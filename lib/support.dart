import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasons_HR/progressdialog/progress_dialog.dart';
import 'package:pasons_HR/service.dart';
import 'globals.dart' as globals;

class Support extends StatefulWidget {
  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return FutureBuilder<dynamic>(
        builder: (context, AsyncSnapshot<dynamic> _data) {
      if (globals.showLoading == false && globals.show == true) {
        return Scaffold(
            //alignment: Alignment.bottomCenter,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                // if (data != null && globals.saveFlag == true) {
                // pd.show(max: 100, msg: 'Saving...');
                // }
                // var status = await saveProfile(data);
                // if (status) {
                // pd.close();
                // Get.snackbar('Saved', '');
                // ProgressDialog(context: null);
                // }
              },
              isExtended: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: Icon(Icons.add_circle_rounded),
              label: Text('New'),
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Support'),
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
                child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10.0),
                    height: 120,
                    width: 400,
                    child: Card(
                        elevation: 6,
                        // child:Align(
                        //   alignment: Alignment.topLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 15, 1, 1),
                                  child: Text('Total : ' + '0'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 6, 1, 1),
                                  child: Text('Completed : ' + '0'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 6, 1, 1),
                                    child: Text(
                                      'Pending : ' + '0',
                                    )),
                              ),
                            ]))),
                Row(children: [
                  Container(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 1, 1, 1),
                        child: Text(
                          'Department : ',
                        )),
                  ),
                  Container(
                    alignment: Alignment.topRight,

                    // padding: EdgeInsets.all(1.0),
                    height: 30,
                    width: 108,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        // labelText: '  Dpt',
                        // hintText: 'All',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 10.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      // decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.all(0.0)
                      // ),
                      // value: _department.toString(),
                      items: ['IT', 'Accounts', 'HR', 'Finance']
                          .map((String unit) => DropdownMenuItem<String>(
                              value: unit, child: Text(unit)))
                          .toList(),
                      onChanged: (val) {
                        // _onUpdate(label, val.toString());
                      },
                      // onChanged: (value) => setState(() {
                      //  // _widthUnit = value;
                      // })),
                    ),
                  ),
                ]),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                    height: 50,
                    width: 400,
                    child: Card(
                        elevation: 6,
                        // child:Align(
                        //   alignment: Alignment.topLeft,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 15, 1, 1),
                                  child: Text('Total : ' + '0'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 6, 1, 1),
                                  child: Text('Completed : ' + '0'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 6, 1, 1),
                                    child: Text(
                                      'Pending : ' + '0',
                                    )),
                              ),
                            ])))
              ],

              // child: Card(
              //   color: Colors.white,
              //   clipBehavior: Clip.antiAlias,
              //   child: Column(
              //     children: [
              //       Container(
              //         child: Container(
              //           alignment: Alignment.topRight,
              //           decoration: new BoxDecoration(color: Colors.blueAccent),
              //           child: ListTile(
              //             title: Text('test'),
              //             subtitle: Text(
              //               'test2',
              //               style: TextStyle(color: Colors.black.withOpacity(0.6)),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child: Text(
              //           'text3',
              //           style: TextStyle(color: Colors.black.withOpacity(1.0)),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            )));
      } else {
        return CircularIndicator();
      }
    });
  }
}
