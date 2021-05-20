import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);
  var image =
      'https://static.vecteezy.com/system/resources/thumbnails/002/125/900/small/dark-blue-ramadan-geometric-motif-in-arabesque-door-shape-background-with-golden-color-frame-vector.jpg';
  var title = "Title";
  var artist = "Artist";
  var text;
  static const streamUrl = "https://a1.siar.us:8100/radio.mp3";
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  bool isPlaying = false;
  @override
  void initState() {
    fetchData();
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

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

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }

  Widget _btn() {
    return CircleAvatar(
      backgroundColor: Colors.blueAccent,
      radius: 50,
      child: IconButton(
          padding: new EdgeInsets.all(0),
          icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          color: Colors.black87,
          onPressed: () {
            setState(() {
              try {
                if (isPlaying) {
                  isPlaying = false;
                  advancedPlayer.pause();
                } else if (!isPlaying) {
                  isPlaying = true;
                  // If the video is paused, play it.
                  audioCache.play('audio/sesi1.mp3');
                } else {
                  isPlaying = false;
                }
              } catch (e) {}
            });
          }),
    );
  }

  fetchData() async {
    final String _url = "https://a1.siar.us/api/nowplaying/salafytual";
    _setHeaders() => {
          "Content-type": "application/json",
          "Accept": "application/json",
        };
    try {
      Dio dio = new Dio(BaseOptions(
        validateStatus: (_) => true,
      ));
      Response response = await dio.get(_url);

      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {
          artist = body['now_playing']['song']['artist'];
          title = body['now_playing']['song']['title'];
          text = body['now_playing']['song']['text'];
        });
      } else {
        print(response.statusCode);
        // throw Exception('Failed to load jobs from API');
      }
    } on DioError catch (e) {
      print(e.response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music player screen',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          backgroundColor: blueColor,
          body: Column(
            children: <Widget>[
              Container(
                height: 500.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(image), fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [blueColor.withOpacity(0.4), blueColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 52.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50.0)),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Radio Al-Manshuroh Tual',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Text('Radio anti Terorisme',
                                      style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.6))),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50.0)),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            artist,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14.0),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 42.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Siaran Ulang / Siaran Langsung',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text('Pendengan : 100',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)))
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: IconButton(
                        iconSize: 50,
                        padding: new EdgeInsets.all(0),
                        icon: isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        color: Colors.black87,
                        onPressed: () {
                          setState(() {
                            try {
                              if (isPlaying) {
                                isPlaying = false;
                                FlutterRadio.playOrPause(url: streamUrl);
                              } else if (!isPlaying) {
                                isPlaying = true;
                                // If the video is paused, play it.
                                FlutterRadio.playOrPause(url: streamUrl);
                              } else {
                                isPlaying = false;
                              }
                            } catch (e) {}
                          });
                        }),
                  )
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.airplanemode_on,
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _keluar();
                    },
                  ),
                ],
              ),
              SizedBox(height: 58.0),
            ],
          ),
        ));
  }

  _keluar() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("Yakin keluar?"),
            title: Text("Keluar ?"),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text("Ya"),
                onPressed: () async {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
              ElevatedButton(
                child: Text("Tidak"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
