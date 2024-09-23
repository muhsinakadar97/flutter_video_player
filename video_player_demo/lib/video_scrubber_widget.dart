import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScrubber extends StatefulWidget {
  const VideoScrubber(
      {required this.playerValue, required this.controller, super.key});
  final VideoPlayerValue playerValue;
  final VideoPlayerController controller;

  @override
  VideoScrubberState createState() => VideoScrubberState();
}

class VideoScrubberState extends State<VideoScrubber> {
  double _value = 0.0;
  bool _isSeeking = false; // To track if seeking is ongoing

  @override
  void didUpdateWidget(covariant VideoScrubber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSeeking) {
      // Update slider value only if not seeking
      int position = widget.playerValue.position.inSeconds;
      int duration = widget.playerValue.duration.inSeconds;
      setState(() {
        _value = duration > 0 ? position / duration : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: CustomThumbShape(),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: _value,
        inactiveColor: Colors.grey,
        activeColor: Colors.red,
        min: 0.0,
        max: 1.0,
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
          });
          final newProgress = Duration(
              milliseconds: (_value *
                      widget.controller.value.duration
                          .inMilliseconds)
                  .toInt());
          _seekToPosition(newProgress);
        },
      ),
    );
  }

  void _seekToPosition(Duration position) {
    setState(() {
      _isSeeking = true;
    });
    widget.controller.seekTo(position).then((_) {
      // Reset isSeeking after seeking is completed
      setState(() {
        _isSeeking = false;
      });
    });
  }

  // Forward Button Press Logic
  void seekForward() {
    final currentPosition =
        widget.controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _seekToPosition(newPosition);
  }

  // Backward Button Press Logic
  void seekBackward() {
    final currentPosition =
        widget.controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _seekToPosition(newPosition);
  }
}

class CustomThumbShape extends SliderComponentShape {
  final double thumbRadius = 6.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, fillPaint);
  }
}
