// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flukit/flukit.dart';
import 'container_hand.dart';
import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  Size recordPlayerSize;
  GlobalKey _recordPlayerSizeKey = GlobalKey();

  _getContainerSize() {
    RenderBox _recordPlayerSizeBox =
        _recordPlayerSizeKey.currentContext.findRenderObject();
    recordPlayerSize = _recordPlayerSizeBox.size;
    print('$recordPlayerSize'); ///////////////////
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.

    _updateTime();
    _updateModel();

    WidgetsBinding.instance.addPostFrameCallback((_) => _getContainerSize());
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    _getContainerSize(); //

    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF4285F4),
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        key: _recordPlayerSizeKey,
        color: Colors.transparent,
        child: Stack(
          children: [
            Image(
              image: AssetImage("../images/background_light.png"),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: recordPlayerSize.height * 0.05,
                  horizontal: recordPlayerSize.height * 0.1),
              //開模擬器要先註解
              child: Row(
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: recordPlayerSize.height * 0.8,
                            //開模擬器要先註解
                            child: TurnBox(
                              turns: _now.second * radiansPerTick,
                              speed: 10000,
                              child: Image(
                                image: AssetImage("../images/record_2.png"),
                              ),
                            ),
                          ),
                          Container(
                            width: recordPlayerSize.height * 0.1,
                            //開模擬器要先註解
                          ),
                        ],
                      ),
                      Image.asset(
                        "../images/Tonearm.png",
                        height: recordPlayerSize.height * 0.8,
                        //開模擬器要先註解
                      ),
                      Text('$recordPlayerSize'), ////////////////////
                      Text('\n' +
                          MediaQuery.of(context).size.toString()), ///////////
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          "../images/knob.png",
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "../images/track.png",
                            height: 120,
                          ),
                          Image.asset(
                            "../images/track.png",
                            height: 120,
                          ),
                          Image.asset(
                            "../images/track.png",
                            height: 120,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Example of a hand drawn with [CustomPainter].
            // DrawnHand(
            //   color: customTheme.accentColor,
            //   thickness: 4,
            //   size: 1,
            //   angleRadians: _now.second * radiansPerTick,
            // ),
            // DrawnHand(
            //   color: customTheme.highlightColor,
            //   thickness: 16,
            //   size: 0.9,
            //   angleRadians: _now.minute * radiansPerTick,
            // ),
            // // Example of a hand drawn with [Container].
            // ContainerHand(
            //   color: Colors.transparent,
            //   size: 0.5,
            //   angleRadians: _now.hour * radiansPerHour +
            //       (_now.minute / 60) * radiansPerHour,
            //   child: Transform.translate(
            //     offset: Offset(0.0, -60.0),
            //     child: Container(
            //       width: 32,
            //       height: 150,
            //       decoration: BoxDecoration(
            //         color: customTheme.primaryColor,
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: 0,
            //   bottom: 0,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: weatherInfo,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
