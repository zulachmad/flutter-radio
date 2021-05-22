import "package:flutter/material.dart";
import 'package:flutter_radios/launcher/launcher_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Al Mansyuroh",
      theme: new ThemeData(
        fontFamily: "DMSans",
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{},
    );
  }
}
