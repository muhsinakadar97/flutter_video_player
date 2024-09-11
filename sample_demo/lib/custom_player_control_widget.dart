import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:sample_demo/video_scrubber_widget.dart';

class CustomPlayerControl extends StatefulWidget {
  const CustomPlayerControl({required this.controller, super.key});

  final BetterPlayerController controller;

  @override
  State<CustomPlayerControl> createState() => _CustomPlayerControlState();
}

class _CustomPlayerControlState extends State<CustomPlayerControl> {
  bool isFullscreen = false;
  bool isMute = false;

  void _onTap() {
    widget.controller.setControlsVisibility(true);
    if (widget.controller.isPlaying() ?? false) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }

  void _controlVisibility() {
    widget.controller.setControlsVisibility(true);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => widget.controller.setControlsVisibility(false));
  }

  String _formatDuration(Duration? duration) {
    if (duration != null) {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _controlVisibility,
      child: StreamBuilder(
        initialData: false,
        stream: widget.controller.controlsVisibilityStream,
        builder: (context, snapshot) {
          return Container(
            color: Colors.grey.withOpacity(0.1),
            child: Stack(
              children: [
                
                ValueListenableBuilder(
                  valueListenable: widget.controller.videoPlayerController!,
                  builder: (context, value, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<double>(
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
                              widget.controller.setSpeed(speed);
                            },
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () {
                              playBackward();
                            }, icon: const Icon(Icons.replay_10, color: Colors.white,)),
                            IconButton(onPressed: () {
                              pausePlay();
                            }, icon: (widget.controller.isPlaying() ?? true) ?  const Icon(Icons.pause, color: Colors.white,) : Icon(Icons.play_arrow, color: Colors.white,)),
                            IconButton(onPressed: () {
                              playForward();
                            }, icon: const Icon(Icons.forward_10, color: Colors.white,))
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 36,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                shape: BoxShape.rectangle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Text(
                                '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: () {
                                  muteUnmute();
                                }, icon: isMute ?  const Icon(Icons.volume_off, color: Colors.white,) : Icon(Icons.volume_up, color: Colors.white,)),
                                IconButton(
                                  onPressed: () async {
                                    widget.controller.toggleFullScreen();
                                  },
                                  icon: Icon(
                                    // Icons.crop_free_rounded,
                                    (widget.controller.isFullScreen ?? true) ?  Icons.fullscreen_exit : Icons.crop_free_rounded, size: 22, color: Colors.white,)),
                                    
                                  
                                
                              ],
                            )
                          ],
                        ),
                        VideoScrubber(
                          controller: widget.controller,
                          playerValue: value,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  void playBackward() {
    final currentPosition = widget.controller.videoPlayerController!.value.position;
                          final newPosition = currentPosition - const Duration(seconds: 10);
                          widget.controller.seekTo(newPosition);
  }

  void playForward() {
    final currentPosition = widget.controller.videoPlayerController!.value.position;
                          final newPosition = currentPosition + const Duration(seconds: 10);
                          widget.controller.seekTo(newPosition);
  }
  
  void pausePlay() {
    if (widget.controller.isPlaying() ?? true) {
                            widget.controller.pause();
                            
                          } else {
                            widget.controller.play();
                          }
  }
  
  void muteUnmute() {
    if (widget.controller.videoPlayerController!.value.volume > 0) {
                            widget.controller.setVolume(0.0);
                            isMute = true;
                          } else {
                            widget.controller.setVolume(1.0);
                            isMute = false;
                          }
  }

}
