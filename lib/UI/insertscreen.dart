import 'package:flutter/material.dart';
import 'package:startup_namer/main.dart';
import 'package:startup_namer/repository/employee.dart';
import 'package:startup_namer/services/dbservice.dart';

class InsertScreen extends StatefulWidget {
  InsertScreen({Key? key, this.employee}) : super(key: key);
  Employee? employee;

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

String? name, doj, role;
int? age;
TextEditingController namecontroller = new TextEditingController();
TextEditingController rolecontroller = new TextEditingController();
TextEditingController dojcontroller = new TextEditingController();

class _InsertScreenState extends State<InsertScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.employee != null) {
      namecontroller.text = widget.employee!.name;
      rolecontroller.text = widget.employee!.role;
      dojcontroller.text = widget.employee!.doj;
    } else {
      namecontroller.clear();
      rolecontroller.clear();
      dojcontroller.clear();
    }
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(15)),
              TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Employee Name',
                ),
                onChanged: (String? value) {
                  name = value;
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              TextField(
                controller: rolecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Employee Role',
                ),
                onChanged: (String? value) {
                  role = value;
                },
              ),
              const Padding(padding: EdgeInsets.all(15)),
              TextField(
                controller: dojcontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Date of Joining',
                ),
                onChanged: (String? value) {
                  doj = value;
                },
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton(
                  child: Text("Add"),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff293895),
                      padding: EdgeInsets.fromLTRB(26, 20, 26, 20)),
                  onPressed: () async {
                    try {
                      if (widget.employee == null) {
                        Employee employee =
                            new Employee(name: name!, role: role!, doj: doj!);
                        await DBService().insert(employee.toMap());
                      } else {
                        Employee employee = Employee(
                            name: name!,
                            role: role!,
                            doj: doj!,
                            id: widget.employee!.id);
                        await DBService().update(employee);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: "Test")),
                      );
                    } catch (exception) {
                      print(exception);
                    }
                  })
            ],
          ),
        ));
  }
}
