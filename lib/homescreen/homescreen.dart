import 'package:flutter/services.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);
  var title = "Loading";
  var artist = "Loading";
  var text;
  bool isLive;
  bool isLoading = true;
  var listeners;
  static const streamUrl = "https://a1.siar.us:8100/radio.mp3";
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

  _launchInBrowser() async {
    var url = 'https://t.me/flutter_id';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }

  fetchData() async {
    final String _url = "https://a1.siar.us/api/nowplaying/salafytual";
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
          isLive = body['live']['is_live'];
          listeners = body['listeners']['total'].toString();
          isLoading = false;
        });
      } else {
        isLoading = false;
        print(response.statusCode);
        // throw Exception('Failed to load jobs from API');
      }
    } on DioError catch (e) {
      isLoading = false;
      print(e.response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage("assets/bg.jpeg"),
              fit: BoxFit.cover,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: <Widget>[
                  Container(
                    height: 500.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                          image: new AssetImage("assets/bg.jpeg"),
                          fit: BoxFit.cover,
                        ))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 52.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Radio Al-Manshuroh Tual',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Text('Radio Islam Kota Tual',
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.6))),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Center(
                                child: new Image.asset(
                                  "assets/logo.png",
                                  height: 250.0,
                                  width: 250.0,
                                ),
                              ),
                              Spacer(),
                              Text(title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                              SizedBox(
                                height: 10.0,
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
                        isLive == true
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 5,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 5,
                              ),
                        isLive == true
                            ? Padding(
                                padding: EdgeInsets.only(right: 270),
                                child: Text('Live',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)))
                            : Padding(
                                padding: EdgeInsets.only(right: 240),
                                child: Text('Rekaman',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))),
                        Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text('Pendengar : $listeners',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white))),
                      ],
                    ),
                  ),
                  SizedBox(height: 70.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      isLoading == false
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: IconButton(
                                  iconSize: 35,
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
                                          FlutterRadio.playOrPause(
                                              url: streamUrl);
                                        } else if (!isPlaying) {
                                          isPlaying = true;
                                          // If the video is paused, play it.
                                          FlutterRadio.playOrPause(
                                              url: streamUrl);
                                        } else {
                                          isPlaying = false;
                                        }
                                      } catch (e) {}
                                    });
                                  }),
                            )
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                  SizedBox(height: 90.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _launchInBrowser();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.airplanemode_active,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _launchInBrowser();
                        },
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
            )));
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
