import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'progressdialog/progress_dialog.dart';

//import 'animation/FadeAnimation.dart';
import 'api.dart';
import 'globals.dart' as globals;
import 'service.dart';

class Profile extends StatelessWidget {
  int _id = int.parse(globals.userID);
  String _name = "";
  int _age = 0;
  String _email = "";
  String _department = "";
  var data;
  var token;
  var tt = globals.loaded = false;

  List<Map<String, dynamic>> _values = [
    {'id': 'id', 'value': globals.userID}
  ];

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return FutureBuilder<dynamic>(
        future: init(globals.userID, context),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          if (globals.showLoading == false && globals.show == true) {
            return Scaffold(
              //alignment: Alignment.bottomCenter,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  if (data != null && globals.saveFlag == true) {
                    pd.show(max: 100, msg: 'Saving...');
                  }
                  var status = await saveProfile(data);
                  if (status) {
                    pd.close();
                    Get.snackbar('Saved', '');
                    ProgressDialog(context: null);
                  }
                },
                isExtended: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Icon(Icons.supervised_user_circle),
                label: Text('Save'),
              ),

              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('Profile'),
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 255,
                    // MediaQuery.of(context).size.height - 150
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            // FadeAnimation(0.2, makeInput(label: "Name", field: _name,),),
                            //FadeAnimation(0.3, makeInput(label: "Age", field: _age,)),
                            //FadeAnimation(0.4, makeInput(label: "Email", field: _email,)),
                            //FadeAnimation(0.5, makeInput(label: "Department", field: _department,)),

                            makeInput(
                              label: "Name",
                              field: _name,
                            ),
                            makeInput(
                              label: "Age",
                              field: _age,
                            ),
                            makeInput(
                              label: "Email",
                              field: _email,
                            ),
                            makeInput(
                              label: "Department",
                              field: _department,
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
              ),
            );
          } else {
            return CircularIndicator();
          }
        });
  }

  Widget makeInput({label, field, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 350.0,
            height: 46,
            child: label != "Department"
                ? Material(
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 10,
                    child: TextFormField(
                      keyboardType: label == "Age"
                          ? TextInputType.number
                          : TextInputType.text,
                      //label == "tt" ? keyboardType: TextInputType.number,
                      onChanged: (val) {
                        _onUpdate(label, val);
                      },
                      initialValue: field != 0 ? field.toString() : null,
                      inputFormatters: label == "Age"
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : [
                              FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                            ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: label,
                        hintText: '',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ))
                : Material(
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 10,
                    child: DropdownButtonFormField(
                      //initialValue:field != 0 ?field.toString():null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: label,
                        hintText: '',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      // decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.all(0.0)
                      // ),
                      value: _department.toString(),
                      items: ['IT', 'Accounts', 'HR', 'Finance']
                          .map((String unit) => DropdownMenuItem<String>(
                              value: unit, child: Text(unit)))
                          .toList(),
                      onChanged: (val) {
                        _onUpdate(label, val.toString());
                      },
                      // onChanged: (value) => setState(() {
                      //  // _widthUnit = value;
                      // })),
                    ))
            ),
        SizedBox(
          height: 10,
          width: 5,
        ),
      ],
    );
    // }
    //   );
  }

  _onUpdate(String key, String val) {
    globals.saveFlag = true;
    var foundkey = "1";
    for (var map in _values) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundkey = key;
          break;
        }
      }
    }
    if ("1" != foundkey) {
      _values.removeWhere((map) {
        return map['id'] == foundkey;
      });
    }

    if ("Name" == key) {
      _name = val;
    } else if ("Age" == key) {
      _age = int.parse(val);
    } else if ("Email" == key) {
      _email = val;
    } else if ("Department" == key) {
      _department = val;
    }

    //Map<String, dynamic> json = {'id': _id, 'value': val};
    Map<String, dynamic> json = {
      "Id": _id,
      "Name": _name,
      "Age": _age,
      "Email": _email,
      "Department": _department
    };
    //_values.add(json);
    data = jsonEncode(json);
    //return data;
  }
  //
  // _saveToken(String key, String val) {
  //
  //   Map<String, dynamic> json = {
  //     "Id": _id,
  //     "token": _name,
  //   };
  //   //_values.add(json);
  //   token = jsonEncode(json);
  //
  // }


  init(userID, context) async {
    var connectivityResult = await getUserDetails(userID);

    _id = connectivityResult.id;
    _name = connectivityResult.name;
    _age = connectivityResult.age;
    _email = connectivityResult.email;
    _department = connectivityResult.department;
    globals.showLoading = false;
  }
}

class Profile2 {
  int id = 0;
  String name = "NULL";
  int age = 0;
  String email = "NULL";
  String department = "NULL";

  Profile2(
      {required this.id,
      required this.name,
      required this.age,
      required this.email,
      required this.department});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'email': email,
        'department': department
      };

  fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
    department = json['department'];
  }
}
