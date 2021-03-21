import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';

typedef void OnError(Exception exception);

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  static const streamUrl = "https://a1.siar.us:8100/radio.mp3";

  bool isPlaying;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  String localFilePath;

  Widget _tab(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
      minWidth: 48.0,
      child: Container(
        width: 150,
        height: 45,
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Text(txt),
            color: Colors.blueGrey,
            textColor: Colors.white,
            onPressed: onPressed),
      ),
    );
  }

  Widget LocalAudio() {
    return _tab([
      Text(
        "Judul Audio",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 78.0,
          child: Image.asset('assets/volume.png'),
        ),
      ),
      _btn('Putar', () => FlutterRadio.playOrPause(url: streamUrl)),
      _btn('Jeda', () => FlutterRadio.playOrPause(url: streamUrl)),
      _btn('Berhenti', () => FlutterRadio.playOrPause(url: streamUrl)),
      SizedBox(
        height: 30,
      ),
      ButtonTheme(
        minWidth: 48.0,
        child: Container(
          width: 250,
          height: 45,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Text("Selanjutnya"),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1.0,
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          title: Text("Sesi 2".toUpperCase(),
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 17,
              )),
        ),
        body: TabBarView(
          children: [LocalAudio()],
        ),
      ),
    );
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }
}
