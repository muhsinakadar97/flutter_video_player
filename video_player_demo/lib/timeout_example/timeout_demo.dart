import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_demo/timeout_example/timeout_controller.dart';

class TimeoutDemo extends StatelessWidget {
   // Initialize the controller
  final TimeoutDemoController controller = Get.put(TimeoutDemoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Disappear Example"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Toggle visibility when the container is tapped
            controller.toggleVisibilityOnTap();
          },
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.blueAccent,
            child: Obx(() {
              // Conditionally display text based on the controller's isVisible value
              return controller.isVisible.value
                  ? Text(
                      'Hello, I will disappear in 3 seconds or on tap!',
                      style: TextStyle(color: Colors.white),
                    )
                  : SizedBox.shrink(); // Empty widget when text is hidden
            }),
          ),
        ),
      ),
    );
  }
}
