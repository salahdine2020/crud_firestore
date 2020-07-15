import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/ResterantItem_added/customText_widgets.dart';
import 'package:food_delivery/ResterantItem_added/reslist_modale.dart';
import 'package:food_delivery/ResterantItem_added/resturant_screen.dart';
import 'package:food_delivery/ResterantItem_added/store_servises.dart';
import 'package:food_delivery/ResterantItem_added/upload_image.dart';
import 'package:image_picker/image_picker.dart';

class AddResInf extends StatefulWidget {
  @override
  _AddResInfState createState() => _AddResInfState();
}

class _AddResInfState extends State<AddResInf> {
  static String id = 'AddProduct';
  String _name, _location;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  List<RestItems> li = [];
  File _image;
  String _url;

  void pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void uploadImage(context) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://fooddelivery-56b3a.appspot.com');
      StorageReference ref = storage.ref().child(_image.path);
      StorageUploadTask storageUploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      ));
    } catch (ex) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(ex.message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextField(
              hint: 'Enter your name of Resturant',
              onClick: (value) {
                _name = value;
              },
              icon: Icons.person,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              onClick: (value) {
                _location = value;
              },
              hint: 'Enter your Location of Resturant',
              icon: Icons.location_on,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              width: 200,
              //color: Colors.white,
              child: Stack(
                children: <Widget>[
//                CustomTextField(
//                  onClick: (value) {
//                    setState(() {
//                      value = _url;
//                    });
//                  },
//                  onChang: (v) {
//                    setState(() {
//                      v = _url;
//                    });
//                  },
//                  hint: 'Click In pic Image to chose',
//                  //icon: Icons.image,
//                ),

                  Positioned(
                    top: 76,
                    left: 56,
                    child: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        // pick function to images
                        print('Upload Image');
                        pickImage();
                      },
                    ),
                  ),

                  Positioned(
                    top: 76,
                    right: 56,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.cloud_upload),
                        onPressed: () {
                          // pick function to images
                          print('Upload Image');
                          uploadImage(context);
                          print(_url);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 52.0, top: 8),
                    child: Container(
                      //color: Colors.red,
                      height: 70,
                      width: 100,
                      child:  CircleAvatar(
                        backgroundImage: _image == null ? null : FileImage(_image),
                        radius: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                // add the upload image function after
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();
                  _store.addResturant(
                    ResList(
                      pName: _name,
                      pLocation: _location,
                      pImage: _url,
                    ),
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestItems(),
                  ),
                );
              },
              child: Text('Add Resturant'),
            )
          ],
        ),
      ),
    );
  }
}
