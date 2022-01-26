import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularIndicator extends StatefulWidget {

  CircularIndicatorWidget createState() => CircularIndicatorWidget();

}

class CircularIndicatorWidget extends State {

  bool visible = true ;

  loadProgress(){

    if(visible == true){
      setState(() {
        visible = false;
      });
    }
    else{
      setState(() {
        visible = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(top: 50, bottom: 30),
                      child: CircularProgressIndicator()
                  )
              ),

              // RaisedButton(
              //   onPressed: loadProgress,
              //   color: Colors.pink,
              //   textColor: Colors.white,
              //   padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              //   child: Text('Click Here To Show Hide Circular Progress Indicator'),
              // ),

            ],
          ),
        ));
  }

  void showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Updating..'),
      ),
    );
  }



}