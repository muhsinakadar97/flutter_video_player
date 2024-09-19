import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'video_controls.dart';
import 'video_player_package_controller.dart'; // Adjust the import based on your file structure

class VideoPlayerPackageDemo extends StatelessWidget {
  const VideoPlayerPackageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoPlayerPackageController videoPlayerPackageController =
        Get.put(VideoPlayerPackageController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          log('orientation : ${orientation}');
          return LayoutBuilder(
            builder: (context,constraints) {
              return AspectRatio(
                aspectRatio: orientation == Orientation.portrait
                    ? 16 / 9
                    : constraints.maxWidth / constraints.maxHeight,
                child: Stack(
                  children: [
                    Center(
                      child: Obx(
                        () => !videoPlayerPackageController.isInitialized.value ||
                                videoPlayerPackageController.showIndicator.value
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  color: Colors.black,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white)),
                                ),
                              )
                            : AspectRatio(
                                aspectRatio: videoPlayerPackageController
                                    .controller.value.aspectRatio,
                                child: VideoPlayer(
                                    videoPlayerPackageController.controller),
                              ),
                      ),
                    ),
                    VideoControls(
                        controller: videoPlayerPackageController.controller),
                  ],
                ),
              );
            }
          );
        }),
      ),
    );
  }
}
