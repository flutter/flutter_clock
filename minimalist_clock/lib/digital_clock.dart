// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'animated_two_digits.dart';

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

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.parse("1969-07-20 23:45:04Z");
  Timer _timer;
  AnimationController _minuteController;
  AnimationController _hourController;

  String _minute;
  String _previousMinute;
  String _hour;
  String _previousHour;
  String _meridiemLabel;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _minuteController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _hourController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
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

  Future _startMinuteAnimation() async {
    try {
      await _minuteController.forward().orCancel;
    } on TickerCanceled {}
  }

  void _resetMinuteAnimation() {
    _minuteController.reset();
  }

  Future _startHourAnimation() async {
    try {
      await _hourController.forward().orCancel;
    } on TickerCanceled {}
  }

  void _resetHourAnimation() {
    _hourController.reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minuteController?.dispose();

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
      _minute = DateFormat('mm').format(_dateTime);
      _previousMinute =
          DateFormat('mm').format(_dateTime.subtract(new Duration(minutes: 1)));
      _hour = DateFormat('hh').format(_dateTime);
      _previousHour =
          DateFormat('hh').format(_dateTime.subtract(new Duration(hours: 1)));
      _meridiemLabel = _dateTime.hour > 12 ? "PM" : "AM";

      _timer = Timer(
        Duration(seconds: 1),
        _updateTime,
      );
      _resetMinuteAnimation();
      _startMinuteAnimation();
      if (_dateTime.minute == 00) {
        _resetHourAnimation();
        _startHourAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final fontSize = MediaQuery.of(context).size.height * 0.29;

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

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 435,
            child: AnimatedTwoDigits(_hourController, _previousHour, boldStyle,
                MediaQuery.of(context).size.height / 3.45, context),
          ),
          Positioned(
            right: 435,
            child: AnimatedTwoDigits(
                _hourController, _hour, boldStyle, 0.0, context),
          ),
          Positioned(
              left: 220,
              top: MediaQuery.of(context).size.height / 3.45,
              child: Text(
                _meridiemLabel,
                style: thinStyle,
              )),
          Positioned(
            left: 440,
            child: AnimatedTwoDigits(_minuteController, _previousMinute,
                boldStyle, MediaQuery.of(context).size.height / 3.45, context),
          ),
          Positioned(
            left: 440,
            child: AnimatedTwoDigits(
                _minuteController, _minute, boldStyle, 0.0, context),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 1.7,
            top: 0,
            child: Container(
                height: MediaQuery.of(context).size.height / 3.45,
                width: MediaQuery.of(context).size.height / 3.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height / 1.7,
            child: Container(
                height: MediaQuery.of(context).size.height / 3.45,
                width: MediaQuery.of(context).size.height / 3.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
