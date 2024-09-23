import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:better_player_demo/better_player_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class BetterPlayerPage extends StatelessWidget {
  BetterPlayerPackageController betterPlayerPackageController = Get.put(BetterPlayerPackageController());

  BetterPlayerPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Center(
            child: betterPlayerPackageController.isBuffering.value
                ? InkWell(
                  onTap: () => log("Hello"),
                  child: Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: const Center(
                          child: CircularProgressIndicator(color: Colors.red))),
                )
                : InkWell(
                  onTap: () => log("Hi"),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: BetterPlayer(controller: betterPlayerPackageController.videoController),
                    ),
                ),
          ),
        ),
      )
    );

}




// import 'dart:developer';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:sample_demo/custom_player_control_widget.dart';

// class BetterPlayerPage extends StatefulWidget {
//   const BetterPlayerPage({super.key});

//   @override
//   State<BetterPlayerPage> createState() => _BetterPlayerPageState();
// }

// class _BetterPlayerPageState extends State<BetterPlayerPage> {
//   late BetterPlayerController _videoController;
//   bool _isBuffering = true; // To track buffering/loading state

//   @override
//   void initState() {
//     super.initState();

//     _videoController = BetterPlayerController(
//       BetterPlayerConfiguration(
//         autoDispose: true,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           controlsHideTime: const Duration(seconds: 1),
//           playerTheme: BetterPlayerTheme.custom,
//           customControlsBuilder: (videoController, onPlayerVisibilityChanged) =>
//               CustomPlayerControl(controller: videoController),
//         ),
//         aspectRatio: 16 / 9,
//         looping: true,
//         autoPlay: true,
//       ),
//       betterPlayerDataSource: BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network,
//         'https://drive.google.com/uc?export=view&id=12ir79vBix3Uvon2VIQXaXN00Nsmn7AoT',
//       ),
//     );

//     // Listen to player events to manage buffering state
//     _videoController.addEventsListener((event) {
//       if (event.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
//         setState(() {
//           _isBuffering = true; // Show loading indicator when buffering starts
//         });
//       } else if (event.betterPlayerEventType == BetterPlayerEventType.bufferingEnd ||
//           event.betterPlayerEventType == BetterPlayerEventType.play) {
//         setState(() {
//           _isBuffering = false; // Hide loading indicator when video starts
//         });
//       }
//     });

//     log("Player initialized");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: BetterPlayer(controller: _videoController),
//             ),
//             _isBuffering
//                 ? const CircularProgressIndicator(color: Colors.red)
//                 : const SizedBox(), // Show the indicator while buffering
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
// }



}