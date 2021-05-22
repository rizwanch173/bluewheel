import 'dart:async';
import 'dart:io';
import 'dart:io' as io;

import 'package:bluewhale/ImageSelection.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_recognition/speech_recognition.dart';

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class PreData {
  String pre = "";

  String get preM {
    return pre;
  }

  set preM2(String name) {
    pre += name;
  }
}

// ignore: must_be_immutable
class StartRecording extends StatefulWidget {
  LocalFileSystem localFileSystem;

  String imageFile;
  StartRecording({
    localFileSystem,
    Key key,
    @required this.imageFile,
  }) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _StartRecordingState createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecording> {
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  FlutterAudioRecorder _recorder;
  Recording _current;
  bool isRec = true;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  int s = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    activateSpeechRecognizer();
  }

  // GifController controller1;
  // GifController controller = GifController(vsync: null);
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller1.repeat(min: 0, max: 53, period: Duration(milliseconds: 200));
  //   });
  //
  //   super.initState();
  // }
  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  PreData data = new PreData();

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

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
                    fromChangePic: true,
                  );
                }));
              },
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Tab to change Picture',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ),
                            ),
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
                      onTap: () {},
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_current?.duration.toString().substring(2).split(".")[0]}" +
                                      ' / 05:00',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                                PopupMenuButton<Language>(
                                  onSelected: _selectLangHandler,
                                  itemBuilder: (BuildContext context) =>
                                      _buildLanguagesWidgets,
                                )
                              ],
                            ),
                            isRec
                                ? IconButton(
                                    icon: Image.asset('assets/srec.png'),
                                    iconSize: 100,
                                    onPressed: () {
                                      _start();
                                    },
                                  )
                                : IconButton(
                                    icon: Image.asset('assets/rec.png'),
                                    iconSize: 100,
                                    onPressed: () {
                                      _start();
                                    },
                                  ),
                            isRec
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Click to Record',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/wave.png",
                                        height: 35,
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      _stop();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Recording... Click to Stop',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Montserrat',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        isRec = false;
        _current = recording;
      });
      start();
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
          if (_current.duration.inMinutes == 5) {
            _stop();
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

/////////////////////////////////////////

  void start() => _speech.listen(locale: selectedLang.code).then((result) {
        print('_MyAppState.start => result ${result}');
        data.preM2 = transcription;
      });
  void cancel() {
    _speech.cancel().then((result) => setState(() => _isListening = result));
    data.preM2 = transcription;
  }

  void stop() {
    _speech.stop().then((result) => setState(() => _isListening = result));
    data.preM2 = transcription;
  }

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete() => setState(() {
        // data.preM2 = transcription;
        _isListening = false;
        _pause();
      });
}
