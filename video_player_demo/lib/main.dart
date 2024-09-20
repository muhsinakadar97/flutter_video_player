import 'package:flutter/material.dart';
import 'package:video_player_demo/video_player_package_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const VideoPlayerPackageDemo(),
    );
  }
}

