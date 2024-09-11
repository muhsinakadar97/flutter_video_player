import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:sample_demo/custom_player_control_widget.dart';

class BetterPlayerPage extends StatefulWidget {
  const BetterPlayerPage({super.key});

  @override
  State<BetterPlayerPage> createState() => _BetterPlayerPageState();
}

class _BetterPlayerPageState extends State<BetterPlayerPage> {
  late BetterPlayerController _videoController;

  @override
  void initState() {
    super.initState();
  
    _videoController = BetterPlayerController(
      BetterPlayerConfiguration(
          autoDispose: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            controlsHideTime: const Duration(seconds: 1),
            playerTheme: BetterPlayerTheme.custom,
            customControlsBuilder: 
                (videoController, onPlayerVisibilityChanged) =>
                    CustomPlayerControl(controller: videoController),
          ),
          aspectRatio: 16 / 9,
          looping: true,
          autoPlay: true),
      betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          'https://drive.google.com/uc?export=view&id=12ir79vBix3Uvon2VIQXaXN00Nsmn7AoT'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _videoController),
        ),
      ),
    );
  }
}
