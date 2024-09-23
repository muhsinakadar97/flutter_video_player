import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:better_player_demo/video_scrubber_Widget.dart';
import 'package:flutter/material.dart';

class CustomPlayerControl extends StatefulWidget {
  const CustomPlayerControl({required this.controller, super.key});

  final BetterPlayerController controller;

  @override
  State<CustomPlayerControl> createState() => _CustomPlayerControlState();
}

class _CustomPlayerControlState extends State<CustomPlayerControl> {
  bool isFullscreen = false;
  bool isMute = false;
  bool isBuffering = true;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.videoPlayerController!.addListener(_onVideoPlayerStateChange);
  }

  void _onVideoPlayerStateChange() {
    setState(() {
      isBuffering = widget.controller.videoPlayerController!.value.isBuffering;
    });
  }

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
    return LayoutBuilder(
      builder: (context,constraints) {
        log('width : ${constraints.maxWidth}');
        log('height : ${constraints.maxHeight}');

        return InkWell(
          onTap: _controlVisibility,
          child: StreamBuilder(
            initialData: false,
            stream: widget.controller.controlsVisibilityStream,
            builder: (context, snapshot) {
              return Container(
                color: Colors.grey.withOpacity(0.4),
                child: Stack(
                  children: [
                  
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: ValueListenableBuilder(
                          valueListenable: widget.controller.videoPlayerController!,
                          builder: (context, value, child) {
                            return IconButton(
                                onPressed: () async {
                                  widget.controller.toggleFullScreen();
                                },
                                icon: Icon(
                                  // Icons.crop_free_rounded,
                                  (widget.controller.isFullScreen)
                                      ? Icons.fullscreen_exit
                                      : Icons.crop_free_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ));
                      },
                    )),
                    Positioned(
                        bottom: 10,
                        right: 50,
                        child: ValueListenableBuilder(
                            valueListenable: widget.controller.videoPlayerController!,
                            builder: (context, value, child) {
                              return IconButton(onPressed: () {
                                            muteUnmute();
                                          }, icon: isMute ?  const Icon(Icons.volume_off, color: Colors.white, size: 20,) : Icon(Icons.volume_up, color: Colors.white, size: 20,));
                            },
                          )),
                          Positioned(
                        bottom: 15,
                        left: 0,
                        child: ValueListenableBuilder(
                            valueListenable: widget.controller.videoPlayerController!,
                            builder: (context, value, child) {
                              return  Container(
                                        height: 36,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          shape: BoxShape.rectangle,
                                          color: Colors.transparent
                                          // color: Colors.black.withOpacity(0.3),
                                        ),
                                        child: Text(
                                          '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                            },
                          )),
                          Positioned(
                        bottom: 15,
                        left: 0,
                        child: ValueListenableBuilder(
                            valueListenable: widget.controller.videoPlayerController!,
                            builder: (context, value, child) {
                              return  Container(
                                        height: 36,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          shape: BoxShape.rectangle,
                                          color: Colors.transparent
                                          // color: Colors.black.withOpacity(0.3),
                                        ),
                                        child: Text(
                                          '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                            },
                          )),
                        
                          Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(onPressed: () {
                                  playBackward();
                                }, icon: const Icon(Icons.replay_10, color: Colors.white, size: 35,)),
                                ValueListenableBuilder(
                                  valueListenable: widget.controller.videoPlayerController!,
                                  builder: (context, value, child) {
                                    return IconButton(onPressed: () {
                                    pausePlay();
                                  }, 
                                  icon: (widget.controller.isPlaying() ?? true) ?  const Icon(Icons.pause, color: Colors.white,size: 35,) : const Icon(Icons.play_arrow, color: Colors.white, size: 35,));
                                  },
                                  
                                ),
                                IconButton(onPressed: () {
                                  playForward();
                                }, icon: const Icon(Icons.forward_10, color: Colors.white, size: 30,))
                              ],
                            ),),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: PopupMenuButton<double>(
                                iconSize: 35,
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 30,
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
                              ),),

                     Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: ValueListenableBuilder(
                        valueListenable: widget.controller.videoPlayerController!,
                            builder: (context, value, child) {
                              return Container(
                                width: constraints.maxWidth,
                                child: VideoScrubber(
                                  controller: widget.controller,
                                  playerValue: value,
                                ),
                              );
                            }
                      ),)
                         
                             

                            //    Positioned(
                        // bottom: 10,
                        // left: 10,
                        // child: ValueListenableBuilder(
                        //     valueListenable: widget.controller.videoPlayerController!,
                        //     builder: (context, value, child) {
                        //       return   IconButton(onPressed: () {
                        //               pausePlay();
                        //             }, icon: (widget.controller.isPlaying() ?? true) ?  const Icon(Icons.pause, color: Colors.white,size: 20,) : Icon(Icons.play_arrow, color: Colors.white, size: 20,));
                        //     },
                        //   )),
                         
                    // ValueListenableBuilder(
                    //   valueListenable: widget.controller.videoPlayerController!,
                    //   builder: (context, value, child) {
                    //     return Column(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Align(
                    //           alignment: Alignment.topRight,
                              // child: PopupMenuButton<double>(
                              //   iconSize: 35,
                              //   icon: const Icon(
                              //     Icons.more_vert,
                              //     color: Colors.white,
                              //   ),
                              //   itemBuilder: (context) {
                              //     return [0.5, 1.0, 1.5, 2.0].map((speed) {
                              //       return PopupMenuItem<double>(
                              //         value: speed,
                              //         child: Text(
                              //           "${speed}x",
                              //           style: const TextStyle(color: Colors.black),
                              //         ),
                              //       );
                              //     }).toList();
                              //   },
                              //   onSelected: (speed) {
                              //     widget.controller.setSpeed(speed);
                              //   },
                              // ),
                    //         ),
                    //         const SizedBox(height: 5,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     IconButton(onPressed: () {
                            //       playBackward();
                            //     }, icon: const Icon(Icons.replay_10, color: Colors.white, size: 30,)),
                            //     IconButton(onPressed: () {
                            //       pausePlay();
                            //     }, icon: (widget.controller.isPlaying() ?? true) ?  const Icon(Icons.pause, color: Colors.white,size: 30,) : Icon(Icons.play_arrow, color: Colors.white, size: 30,)),
                            //     IconButton(onPressed: () {
                            //       playForward();
                            //     }, icon: const Icon(Icons.forward_10, color: Colors.white, size: 30,))
                            //   ],
                            // ),
                    //         const SizedBox(height: 5,),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
        
                    //             Row(
                    //               children: [
                                    // IconButton(onPressed: () {
                                    //   pausePlay();
                                    // }, icon: (widget.controller.isPlaying() ?? true) ?  const Icon(Icons.pause, color: Colors.white,size: 20,) : Icon(Icons.play_arrow, color: Colors.white, size: 20,)),
                                    //  Container(
                                    //     height: 36,
                                    //     width: 100,
                                    //     alignment: Alignment.center,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(50),
                                    //       shape: BoxShape.rectangle,
                                    //       color: Colors.black.withOpacity(0.5),
                                    //     ),
                                    //     child: Text(
                                    //       '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                    //       style: const TextStyle(color: Colors.white),
                                    //     ),
                                    //   ),
                    //               ],
                    //             ),
        
                    //             Row(
                    //               children: [
                    //                 IconButton(onPressed: () {
                    //                   muteUnmute();
                    //                 }, icon: isMute ?  const Icon(Icons.volume_off, color: Colors.white, size: 20,) : Icon(Icons.volume_up, color: Colors.white, size: 30,)),
                    //                  IconButton(
                    //               onPressed: () async {
                    //                 widget.controller.toggleFullScreen();
                    //               },
                    //               icon: Icon(
                    //                 // Icons.crop_free_rounded,
                    //                 (widget.controller.isFullScreen ?? true) ?  Icons.fullscreen_exit : Icons.crop_free_rounded, size: 20, color: Colors.white,))
                    //               ],
                    //             ),
        
                    //           ],
                    //         ),
                            // VideoScrubber(
                            //   controller: widget.controller,
                            //   playerValue: value,
                            // )
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }

  void playBackward() {
    setState(() {
      isBuffering = true;
    });
    final currentPosition =
        widget.controller.videoPlayerController!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    widget.controller.seekTo(newPosition);
    setState(() {
      isBuffering = false;
    });
  }

  void playForward() {
    final currentPosition =
        widget.controller.videoPlayerController!.value.position;
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
