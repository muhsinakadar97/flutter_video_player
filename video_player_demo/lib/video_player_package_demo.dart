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
          return LayoutBuilder(builder: (context, constraints) {
            return AspectRatio(
              aspectRatio: orientation == Orientation.portrait
                  ? 16 / 9
                  : constraints.maxWidth / constraints.maxHeight,
              child: GestureDetector(
                onTap: () {
                   log("Toggle visibility when the container is tapped");
                            videoPlayerPackageController.toggleVisibilityOnTap();
                },
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
                            : InkWell(
                                onTap: () {
                                  videoPlayerPackageController.toggleVisibilityOnTap();
                                  // if (videoPlayerPackageController
                                  //     .showOverlay.value) {
                                  //   videoPlayerPackageController.cancelTimer();
                                  // } else {
                                  //   // If overlay is not visible, show it
                                  //   videoPlayerPackageController.toggleOverlay();
                                  // }
                                },
                                // onTap: () => videoPlayerPackageController.showOverlay.value = !videoPlayerPackageController.showOverlay.value,
                                child: AspectRatio(
                                  aspectRatio: videoPlayerPackageController
                                      .controller.value.aspectRatio,
                                  child: VideoPlayer(
                                      videoPlayerPackageController.controller),
                                ),
                              ),
                      ),
                    ),
                    Obx(() => videoPlayerPackageController.showOverlay.value
                        ? GestureDetector(
                           onTap: () {
                            log("Toggle visibility when the container is tapped");
                            videoPlayerPackageController.toggleVisibilityOnTap();
                          },
                          child: videoPlayerPackageController.isVisible.value ? VideoControls(
                              controller: videoPlayerPackageController.controller) : SizedBox.shrink(),
                        )
                        : const SizedBox())
                  ],
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
