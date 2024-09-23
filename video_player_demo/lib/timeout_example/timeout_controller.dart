import 'dart:async';

import 'package:get/get.dart';

class TimeoutDemoController extends GetxController {
  // Observable boolean to track visibility
  var isVisible = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start the 3-second timer when initialized
    startTimer();
  }

  // Method to start or restart the timer for hiding text after 3 seconds
  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(Duration(seconds: 3), () {
      isVisible.value = false; // Hide the text after 3 seconds
    });
  }

  // Method to handle taps (toggle visibility and restart the timer)
  void toggleVisibilityOnTap() {
    if (isVisible.value) {
      isVisible.value = false; // Hide text if it's visible
    } else {
      isVisible.value = true;  // Show text if it's hidden
      startTimer();            // Restart the 3-second timer
    }
  }

  @override
  void onClose() {
    // Dispose of the timer when the controller is closed
    _timer?.cancel();
    super.onClose();
  }
}