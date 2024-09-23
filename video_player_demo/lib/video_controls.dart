import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/video_player_package_controller.dart';

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    VideoPlayerPackageController videoPlayerPackageController =
        Get.put(VideoPlayerPackageController());

    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            children: [
              PopupMenuButton<double>(
                iconSize: 30,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (context) {
                  return [0.5, 1.0, 1.5, 2.0].map((speed) {
                    return PopupMenuItem<double>(
                      value: speed,
                      child: Text(
                        "${speed}x",
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList();
                },
                onSelected: (speed) {
                  videoPlayerPackageController.currentPlaybackSpeed = speed;
                  controller.setPlaybackSpeed(
                      videoPlayerPackageController.currentPlaybackSpeed);
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: videoPlayerPackageController.rewind10Seconds,
                        icon: const Icon(
                          Icons.replay_10,
                          color: Colors.white,
                        ),
                        iconSize: 30,
                      ),
                      const SizedBox(width: 40),
                      Obx(
                        () => IconButton(
                          onPressed: videoPlayerPackageController.playPause,
                          icon: Icon(
                            videoPlayerPackageController.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                        ),
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        onPressed:
                            videoPlayerPackageController.forward10Seconds,
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                        ),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
     
        Positioned(
          bottom: 30,
          left: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 20,),
              Container(
                  height: 15,
                  width: 50,
                  color: Colors.transparent,
                  child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, VideoPlayerValue value, child) {
                      //Do Something with the value.
                      return Center(
                        child: Text(
                          "${value.position.inHours.toString().padLeft(2, '0')}:"
                          "${(value.position.inMinutes % 60).toString().padLeft(2, '0')}:"
                          "${(value.position.inSeconds % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  )),
                 
                  
            ],
          ),
        ),
        Positioned(
          right: 5,
          bottom: 30,
          child:  Row(
                    children: [
                        Obx(
                  () => IconButton(
                    onPressed: videoPlayerPackageController.muteUnmute,
                    icon: Icon(
                      videoPlayerPackageController.isMuted.value
                          ? Icons.volume_up
                          : Icons.volume_off,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                  ),
                                  ),
                                  IconButton(
                  onPressed: videoPlayerPackageController.toggleFullscreen,
                  icon: Icon(videoPlayerPackageController.isFullscreen.value? Icons.fullscreen_exit_rounded : Icons.fullscreen, color: Colors.white,),
                  // icon: const Icon(
                  //   Icons.fullscreen,
                  //   color: Colors.white,
                  // ),
                  iconSize: 30,
                                  ),
                    ],
                  )),
       

        Positioned(
          bottom: 0,
          right: 0,left: 0,
         
          child: Container(
            child: Obx(() {
              final duration = controller.value.duration.inMilliseconds;
              final position = controller.value.position.inMilliseconds;
            
              double sliderValue = duration > 0
                  ? (position / duration) // Calculate the progress as a fraction
                  : 0.0;
            
              return Slider(
                value: videoPlayerPackageController.isSeeking.value
                    ? videoPlayerPackageController.startValue.value
                    : sliderValue,
                inactiveColor: Colors.grey,
                activeColor: Colors.red,
                min: 0.0,
                max: 1.0,
                onChanged: (newValue) {
                  videoPlayerPackageController.startValue.value = newValue;
            
                  final newProgress = Duration(
                    milliseconds: (newValue * duration).toInt(),
                  );
                  videoPlayerPackageController.seekToPosition(newProgress);
                },
              );
            }),
          ),
        )

        //    Positioned(
        //       bottom: 15, // Positioned at the bottom of the stack
        //       left: 0,
        //       right: 0,
        //       child: Slider(
        //   value: videoPlayerPackageController.startValue.value,
        //   inactiveColor: Colors.grey,
        //   activeColor: Colors.red,
        //   min: 0.0,
        //   max: 1.0,
        //   onChanged: (newValue) {
        //       videoPlayerPackageController.startValue.value = newValue;

        //     final newProgress = Duration(
        //         milliseconds: (videoPlayerPackageController.startValue.value *
        //                 controller.value.duration!
        //                     .inMilliseconds)
        //             .toInt());
        //     videoPlayerPackageController.seekToPosition(newProgress);
        //   },
        // ),
      ],
    );
  }
}
