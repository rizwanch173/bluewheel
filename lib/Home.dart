import 'dart:io';

import 'package:bluewhale/ImageSelection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'VoiceSelection.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  String imageFile;
  Home({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ImageSelection(
                    fromChangePic: false,
                  );
                }));
              },
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: widget.imageFile == null
                        ? Image.asset(
                            "assets/background.jpg",
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.imageFile),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue.withOpacity(0.7),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Blue Whale',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '1/ Select a Picture',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                            ),
                            Text(""),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    color: Color(0xFF6ADA42),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return VoiceSelection(
                            imageFile: widget.imageFile,
                          );
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '2/ Record Voice',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                            ),
                            Image.asset(
                              "assets/wave.png",
                              height: 50,
                            ),
                            Text(""),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '3/ Create',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
