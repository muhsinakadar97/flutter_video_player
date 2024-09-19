import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPackageController extends GetxController {
  late VideoPlayerController controller;
  RxBool isPlaying = false.obs;
  RxBool isInitialized = false.obs;
  RxBool isFullscreen = false.obs;
  RxBool isSeeking = false.obs;
  RxBool showIndicator = false.obs;
  RxBool isMuted = false.obs;

  double currentPlaybackSpeed = 1.0;

  late Duration currentPosition; // Track current position
  Timer? progressUpdateTimer;
  RxDouble startValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
     currentPosition = controller.value.position;
    progressUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), updateProgress);
  }



  void initializePlayer() {
    String googleDriveUrl =
        'https://drive.google.com/uc?export=download&id=12ir79vBix3Uvon2VIQXaXN00Nsmn7AoT';

    controller = VideoPlayerController.network(googleDriveUrl)
      ..initialize().then((_) {
        isInitialized.value = true;
        controller.play();
        isPlaying.value = true;
      }).catchError((error) {
        // Handle errors
        log('Error initializing video player: $error');
      });

    controller.addListener(() {
      if (controller.value.isBuffering) {
        showIndicator.value = true; // Show loading indicator
      } else {
        showIndicator.value = false; // Hide loading indicator
      }
    });
  }

  void playPause() {
    if (controller.value.isPlaying) {
      controller.pause();
      isPlaying.value = false;
    } else {
      controller.play();
      isPlaying.value = true;
    }
  }

  void forward10Seconds() async {
    try {
      showIndicator.value = true; // Show indicator
      final currentPosition = controller.value.position;
      final forwardPosition = currentPosition + const Duration(seconds: 10);
      await controller.seekTo(
          forwardPosition < Duration.zero ? Duration.zero : forwardPosition);
      log("controller.value.isBuffering => ${controller.value.isBuffering}");
    } finally {
      showIndicator.value = false; // Hide indicator after seeking
    }
  }

  void rewind10Seconds() async {
    try {
      showIndicator.value = true; // Show indicator
      final currentPosition = controller.value.position;
      final backwardPosition = currentPosition - const Duration(seconds: 10);
      await controller.seekTo(
          backwardPosition < Duration.zero ? Duration.zero : backwardPosition);
      log("controller.value.isBuffering => ${controller.value.isBuffering}");
    } finally {
      showIndicator.value = false; // Hide indicator after seeking
    }
  }

  Future<void> toggleFullscreen() async {
    isFullscreen.value = !isFullscreen.value;

    if (isFullscreen.value) {
      // Enter fullscreen mode and force landscape orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    } else {
      // Exit fullscreen and restore portrait orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  void muteUnmute() {
    double currentVolume = controller.value.volume;
    log("currentVolume => $currentVolume");
    currentVolume > 0 ? isMuted.value = false : isMuted.value = true;
    if (isMuted.value) {
      controller.setVolume(1.0);
    } else {
      controller.setVolume(0);
    }
  }

  void seekToPosition(Duration position) {
    isSeeking.value = true;
    
    controller.seekTo(position).then((_) {
        isSeeking.value = false;
    });
  }


  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void updateProgress(Timer timer) {
      currentPosition = controller.value.position;
  
  }
}




// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerPackageController extends GetxController {
//   late VideoPlayerController controller;
//   RxBool isPlaying = false.obs;
//   RxBool isInitialized = false.obs;
//   RxBool isFullscreen = false.obs;
//   RxBool isSeeking = false.obs;
//   RxBool showIndicator = false.obs;

//   double currentPlaybackSpeed = 1.0;

//   @override
//   void onInit() {
//     super.onInit();
//     initializePlayer();
//   }

//   void initializePlayer() {
//     String googleDriveUrl = 'https://drive.google.com/uc?export=download&id=12ir79vBix3Uvon2VIQXaXN00Nsmn7AoT';

//     controller = VideoPlayerController.network(googleDriveUrl)
//       ..initialize().then((_) {
//         isInitialized.value = true;
//         controller.play();
//         isPlaying.value = true;
//       }).catchError((error) {
//         // Handle errors
//         log('Error initializing video player: $error');
//       });
//   }

//   void playPause() {
//     if (controller.value.isPlaying) {
//       controller.pause();
//       isPlaying.value = false;
//     } else {
//       controller.play();
//       isPlaying.value = true;
//     }
//   }

//   void forward10Seconds() {
//     final currentPosition = controller.value.position;
//     final forwardPosition = currentPosition + const Duration(seconds: 10);
//     controller.seekTo(forwardPosition < Duration.zero ? Duration.zero : forwardPosition);
//     if(controller.value.position != forwardPosition) {
//       showIndicator.value = true;
//     }
   

//   }

//   void rewind10Seconds() async {
//     if (isPlaying.value) {
//       final currentPosition = controller.value.position;
//       final rewindPosition = currentPosition - const Duration(seconds: 10);
//       await controller.seekTo(rewindPosition > Duration.zero ? Duration.zero : rewindPosition);
//       if(controller.value.position != rewindPosition) {
//       showIndicator.value = true;
//     }
//     }
//   }


//   void toggleFullscreen() {
//     log("Toggle Full Screen");
//     // Implement fullscreen functionality here
//   }

//   @override
//   void onClose() {
//     controller.dispose();
//     super.onClose();
//   }
// }
