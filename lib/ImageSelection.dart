import 'dart:io';

import 'package:bluewhale/StartRecording.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'Home.dart';

class ImageSelection extends StatefulWidget {
  bool fromChangePic;
  ImageSelection({
    Key key,
    @required this.fromChangePic,
  }) : super(key: key);

  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/background.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue.withOpacity(0.8),
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text(
                      'Blue Whale',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, x / 4, 0, 0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/camera.png'),
                                iconSize: 90,
                                onPressed: () {
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/gallery.png'),
                                iconSize: 100,
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _pickImage(ImageSource source, {BuildContext contextx}) async {
    final pickedFile = await _picker.getImage(source: source);
    File croppedFile;
    //crop image by user
    if (pickedFile != null) {
      croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxWidth: 512,
        maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Your Image',
          toolbarColor: Colors.green,
        ),
        compressFormat: ImageCompressFormat.jpg,
      );
    }
    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile;
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return widget.fromChangePic
            ? StartRecording(imageFile: _imageFile.path)
            : Home(imageFile: _imageFile.path);
      }));
    }
  }
}
