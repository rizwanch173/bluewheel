import 'package:bluewhale/StartRecording.dart';
import 'package:flutter/material.dart';

class VoiceSelection extends StatefulWidget {
  String imageFile;
  VoiceSelection({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  @override
  _VoiceSelectionState createState() => _VoiceSelectionState();
}

class _VoiceSelectionState extends State<VoiceSelection> {
  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    print(x);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xFF6ADA42),
            ),
          ),
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF6ADA42),
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
                      padding: EdgeInsets.fromLTRB(0, x / 4.5, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/microphone.png'),
                                iconSize: 100,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return StartRecording(
                                        imageFile: widget.imageFile);
                                  }));
                                },
                              ),
                              Text(
                                'Record',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/audio.png'),
                                iconSize: 100,
                                onPressed: () {},
                              ),
                              Text(
                                'Audio files',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Image.asset(
                            "assets/wave.png",
                            height: 50,
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
}
