import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Employee Tracker(Glib)',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        selectedDate = pickedDate;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    });
  }

  final CollectionReference _employees =
      FirebaseFirestore.instance.collection('employees');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _roleController.text = documentSnapshot['role'].toString();
      _dateController.text = documentSnapshot['date'].toString();
    }

    await showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _roleController,
                    decoration: const InputDecoration(hintText: 'Role'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextField(
                        controller: _dateController,
                        decoration:
                            const InputDecoration(hintText: 'Date of Joining'),
                        onTap: () => _selectDate(),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new record
                      final String? name = _nameController.text;
                      final String? price = _roleController.text;
                      final String? date = _dateController.text;
                      if (name != null && price != null) {
                        if (action == 'create') {
                          // Persist a new employee to Firestore
                          await _employees
                              .add({"name": name, "role": price, "date": date});
                        }

                        if (action == 'update') {
                          // Update the employee
                          await _employees.doc(documentSnapshot!.id).update(
                              {"name": name, "role": price, "date": date});
                        }

                        // Clear the text fields
                        _nameController.text = '';
                        _roleController.text = '';
                        _dateController.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      }
                    },
                    child: Center( child:Text(action == 'create' ? 'Create' : 'Update')),
                  )
                ],
              ),
            ));
  }

  // Deleting an employee by id
  Future<void> _deleteEmployee(String employeeId) async {
    await _employees.doc(employeeId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an employee')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Tracker(Glib)'),
      ),
      body: StreamBuilder(
        stream: _employees.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['role'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single employee
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single employee
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteEmployee(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new employee
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
