// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

enum _Element {
  background,
  text,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.parse("1969-07-20 00:00:04Z");
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = _dateTime.add(new Duration(minutes: 1));
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.height * 0.29;
    // final fontSize = 120.0;

    final thinStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'MontSerrat',
      fontSize: fontSize,
    );
    final boldStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'MontSerrat',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    debugPrint('height: ${MediaQuery.of(context).size.height}');
    debugPrint('width: ${MediaQuery.of(context).size.width}');

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          Positioned(
              right: 435,
              top: MediaQuery.of(context).size.height / 3.45,
              child: Text(
                hour,
                style: boldStyle,
              )),
          Positioned(
              left: 220,
              top: MediaQuery.of(context).size.height / 3.45,
              child: Text(
                "PM",
                style: thinStyle,
              )),
          Positioned(
              left: 435,
              top: MediaQuery.of(context).size.height / 3.45,
              child: Text(
                minute,
                style: boldStyle,
              )),
        ],
      ),
    );
  }
}
