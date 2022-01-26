
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

import 'HomePage.dart';
// import 'api.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorScreen(),
    );
  }
}

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  // final TextEditingController _userid = TextEditingController();
  // final TextEditingController _password = TextEditingController();
  late double _height, _width;
  String _userid = '',
      _password = '';
  GlobalKey<FormState> _key = GlobalKey();
  bool _showPassword = true,
      _load = false;
  late Future<int> _futureJwt;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('asset/images/connectionerror.JPG'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          // height: _height,
          // width: _width,
          // padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                image(),
                SizedBox(height: 25),
                messageText(),
                SizedBox(height: 25),
                retryButton(),
                SizedBox(height: _height / 20),
                cancelButton(),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }

  Widget image() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 200.0,
      width: 250.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: new Image.asset('asset/images/errorlogo.png'),
    );
  }

  Widget messageText() {
    // return Center(
    //     child:Container(
    //   margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
    //   child: Row(
    //     children: <Widget>[
    //       Text(
    //         "Something went wrong!",
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //           decorationStyle: TextDecorationStyle.wavy,
    //           color:Colors.blueGrey,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // );

    return Center(
      child: Text(
        "Something went wrong!",
        textAlign: TextAlign.center,
        style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  decorationStyle: TextDecorationStyle.wavy,
                  color:Colors.blueGrey,
                ),
      ),
    );
  }

  Widget retryButton() {
    return !_load
        ? RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      onPressed: ()  {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Profile()));

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Profile()), (Route<dynamic> route) => false);
        // else {
        //   setState(() {
        //     _load = true;
        //   });
        //   signIn();
        // }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.lightBlueAccent[200]!, Colors.green],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('Retry', style: TextStyle(fontSize: 15)),
      ),
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget cancelButton() {
    return !_load
        ? RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      onPressed: ()  {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            HomePage()), (Route<dynamic> route) => false);
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.green[300]!, Colors.redAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('Cancel', style: TextStyle(fontSize: 15)),
      ),
    )
    // new RaisedButton(
    // elevation: 0,
    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.circular(30.0)),
    // onPressed: ()  {
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    // HomePage()), (Route<dynamic> route) => false);
    // },
    // textColor: Colors.white,
    // padding: EdgeInsets.all(0.0),
    // child: Container(
    // alignment: Alignment.center,
    // width: _width / 2,
    // decoration: BoxDecoration(
    // borderRadius: BorderRadius.all(Radius.circular(20.0)),
    // gradient: LinearGradient(
    // colors: <Color>[Colors.green[300]!, Colors.blueAccent],
    // ),
    // ),
    // padding: const EdgeInsets.all(12.0),
    // child: Text('Cancel', style: TextStyle(fontSize: 15)),
    // ),
    // )
        : Center(
      child: CircularProgressIndicator(),
    );
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

}

