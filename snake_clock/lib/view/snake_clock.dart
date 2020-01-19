import 'package:snake_clock/view/constants.dart';
import 'package:snake_clock/view/pixel_manager.dart';
import 'package:snake_clock/view/pixel_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

class SnakeClock extends StatefulWidget {
  final ClockModel clockModel;

  const SnakeClock(ClockModel model, {Key key, this.clockModel})
      : super(key: key);

  @override
  _SnakeClockState createState() => _SnakeClockState();
}

class _SnakeClockState extends State<SnakeClock> with TickerProviderStateMixin {
  final pixelManager = PixelManager();
  AnimationController controller;

  num minute;
  num second;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    minute = DateTime.now().minute;
    second = DateTime.now().second;

    pixelManager.createInitialTime(widget.clockModel);

    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.repeat(reverse: true);

    controller.addListener(() {
      final dateTime = DateTime.now();
      if(second != dateTime.second){
        second = dateTime.second;
        pixelManager.secondUpdated(second);
      }
      if (minute != dateTime.minute) {
        minute = dateTime.minute;
        pixelManager.minuteUpdated(widget.clockModel);
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    pixelManager.updateTimeDisplayed(widget.clockModel);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return ClipRect(
        child: Container(
            color: brightness == Brightness.dark ? Colors.black : Colors.white,
            child: AnimatedBuilder(
                animation: controller,
                builder: (_, _a) => Opacity(
                    opacity: 0.5 + controller.value * 0.5,
                    child: CustomPaint(
                        painter: PixelPainter(
                            pixelManager.createFrame(DateTime.now()),
                            brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            pixelWidth,
                            pixelHeight),
                        child: Container())))));
  }
}
