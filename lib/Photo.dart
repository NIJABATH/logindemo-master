 // import 'dart:html';

import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Photo extends StatefulWidget {
  @override
  PhotoState createState() => PhotoState();
}

class PhotoState extends State<Photo> {
   // late File _image;
  // final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showSelectionDialog();
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child:  Image.asset(
                          'assets/images/user.png'), // set a placeholder image when no photo is set
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Please select your profile photo',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method for sending a selected or taken photo to the EditPage
  // Future selectOrTakePhoto(ImageSource imageSource) async {
  //   final pickedFile = await picker.getImage(source: imageSource);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //        // _image = pickedFile as File;
  //       // Navigator.pushNamed(context, HomePage, arguments: _image);
  //     } else
  //       print('No photo was selected or taken');
  //   });
  // }

  /// Selection dialog that prompts the user to select an existing photo or take a new one
  Future showSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
       return SimpleDialog(
          title: Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('From gallery'),
              onPressed: () {
                // selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('Take a photo'),
              onPressed: () {
                // selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
