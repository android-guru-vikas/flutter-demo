import 'package:flutter/material.dart';
import 'package:startup_namer/UI/insertscreen.dart';
import 'package:startup_namer/repository/employee.dart';
import 'package:startup_namer/services/dbservice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    DBService().initDB();
    DBService().createTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: FutureBuilder<List<Employee>>(
                future: DBService().getemployee(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Employee>> snapshot) {
                  List<Widget> children;
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Employee employee = snapshot.data![index];
                          return Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Card(
                                      child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Name"),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              Text("Role"),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              Text("DOJ"),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              ElevatedButton(
                                                  child: Text("Delete"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color(0xff293895),
                                                  ),
                                                  onPressed: () {
                                                    DBService().deleteEmployee(
                                                        snapshot
                                                            .data![index].id!);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MyHomePage(
                                                                  title:
                                                                      "Test")),
                                                    );
                                                  }),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data![index].name),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              Text(snapshot.data![index].role),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              Text(snapshot.data![index].doj),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                              ElevatedButton(
                                                  child: Text("Edit"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color(0xff293895),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InsertScreen(
                                                                employee: snapshot
                                                                        .data![
                                                                    index],
                                                              )),
                                                    );
                                                  }),
                                              const Padding(
                                                  padding: EdgeInsets.all(15)),
                                            ],
                                          ),
                                        ]),
                                  )))
                            ],
                          );
                        });
                  } else {
                    return const Center(child: Text("No Data found"));
                  }
                }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InsertScreen()),
              );
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
