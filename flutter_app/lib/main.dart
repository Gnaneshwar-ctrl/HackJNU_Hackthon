import 'package:flutter/material.dart';
import 'package:flutter_app/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainTumor Dector',
      home: MySplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
