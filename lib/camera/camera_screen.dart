import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maga/camera/pictureItem.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        ListView.builder(
          itemBuilder: (ctx, index) {
            return PictureItem();
          },
          itemCount: 1,
        ),
        floatingActionButton: new FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: _cameraAction,
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
    
  }

  void _cameraAction() {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return new CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('Open Camera'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Open Gallery'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _getImage(BuildContext context, ImageSource imageSource) async {
    ImagePicker.pickImage(source: imageSource);
  }
}
