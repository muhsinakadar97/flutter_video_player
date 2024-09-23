import 'dart:async';
import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:better_player_demo/custom_player_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BetterPlayerPackageController extends GetxController {
    late BetterPlayerController videoController;
    RxBool isBuffering = true.obs;
    RxBool showOverlay = true.obs;
    RxBool showIndicator = false.obs;

    late BetterPlayerController _videoController;
    Timer? timer;
    RxBool isVisible = true.obs;

    @override
    void onInit() {
      // TODO: implement onInit
      super.onInit();
      initializePlayer();
      startTimer();
    }




  void initializePlayer() {
       videoController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoDispose: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlsHideTime: const Duration(seconds: 1),
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (videoController, onPlayerVisibilityChanged) => showOverlay.value? 
              CustomPlayerControl(controller: videoController) : SizedBox.shrink(),
        ),
        aspectRatio: 16 / 9,
        looping: true,
        autoPlay: true,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        'https://drive.google.com/uc?export=view&id=12ir79vBix3Uvon2VIQXaXN00Nsmn7AoT',
      ),
    );

    // Listen to player events to manage buffering state
    videoController.addEventsListener((event) {
      log('event.betterPlayerEventType :: ${event.betterPlayerEventType}');
      if (event.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
          isBuffering.value = false; // Show loading indicator when buffering starts
          showIndicator.value = false;
        log('in if ----- HERE ------ $isBuffering');
      } 
      // } else if (event.betterPlayerEventType ==
      //         BetterPlayerEventType.bufferingEnd ||
      //     event.betterPlayerEventType == BetterPlayerEventType.play) {
      else {
          isBuffering.value = false; // Hide loading indicator when video starts
        log('in else ----- HERE ------ $isBuffering');
      }
    });

    log("Player initialized");
    showOverlay.value = true;
  }
  
  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer(Duration(seconds: 5), () {
      isVisible.value = false; // Hide the text after 3 seconds
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}