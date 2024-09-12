import 'package:flutter/material.dart';
import 'package:sample_demo/better_player/better_player_page.dart';
import 'package:sample_demo/video_player/video_player_page.dart';

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
      home: VideoPlayerPage(),
    );
  }
}

