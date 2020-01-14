// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'animated_top_position_container.dart';

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

class MinimalistClock extends StatefulWidget {
  const MinimalistClock(this.model);

  final ClockModel model;

  @override
  _MinimalistClockState createState() => _MinimalistClockState();
}

class _MinimalistClockState extends State<MinimalistClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  AnimationController _minuteController;
  AnimationController _hourController;
  AnimationController _meridiemController;
  AnimationController _specialTimeController;
  AnimationController _themeController;

  String _minute;
  String _previousMinute;
  String _hour;
  String _previousHour;
  String _meridiemLabel;
  String _previousMeridiemLabel;
  bool _isSpecialTime;

  @override
  void initState() {
    super.initState();
    _minuteController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _hourController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _meridiemController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _specialTimeController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _themeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    if (_dateTime.hour > 19 || _dateTime.hour < 7) {
      _startThemeAnimation();
    }

    _updateTime();
    _resetHourAnimation();
    _startHourAnimation();
  }

  Future _startMinuteAnimation() async {
    await _minuteController.forward().orCancel;
  }

  void _resetMinuteAnimation() {
    _minuteController.reset();
  }

  Future _startHourAnimation() async {
    await _hourController.forward().orCancel;
  }

  void _resetHourAnimation() {
    _hourController.reset();
  }

  Future _startMeridiemAnimation() async {
    await _meridiemController.forward().orCancel;
  }

  void _resetMeridiemAnimation() {
    _meridiemController.reset();
  }

  Future _startNoonAnimation() async {
    await _specialTimeController.forward().orCancel;
  }

  Future _reverseNoonAnimation() async {
    await _specialTimeController.reverse().orCancel;
  }

  Future _startThemeAnimation() async {
    await _themeController.forward().orCancel;
  }

  Future _reverseThemeAnimation() async {
    await _themeController.reverse().orCancel;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minuteController?.dispose();
    _hourController?.dispose();
    _meridiemController?.dispose();
    _specialTimeController?.dispose();
    _themeController?.dispose();
    super.dispose();
  }

  void updateTimeStateValues() {
    setState(() {
      _minute = DateFormat('mm').format(_dateTime);
      _previousMinute =
          DateFormat('mm').format(_dateTime.subtract(new Duration(minutes: 1)));
      _hour = DateFormat('hh').format(_dateTime);
      _previousHour =
          DateFormat('hh').format(_dateTime.subtract(new Duration(hours: 1)));
      _meridiemLabel = _dateTime.hour >= 12 ? "PM" : "AM";
      _previousMeridiemLabel = _dateTime.hour < 12 ? "PM" : "AM";
    });
  }

  void _updateTime() {
    var previousMinuteValue = _dateTime.minute;
    var previousHourValue = _dateTime.hour;
    var previousMeridiemValue = _meridiemLabel;
    var wasNoon = _isSpecialTime;
    setState(() {
      _dateTime = DateTime.now();
      _isSpecialTime = _dateTime.minute == 0 &&
          (_dateTime.hour == 12 || _dateTime.hour == 0);
      _timer = Timer(
        Duration(seconds: 2),
        _updateTime,
      );
    });

    if (_isSpecialTime) {
      _startNoonAnimation();
      Timer(
        _specialTimeController.duration,
        updateTimeStateValues,
      );
      return;
    }

    if (!_isSpecialTime && wasNoon == true) {
      _reverseNoonAnimation();
      updateTimeStateValues();
      return;
    }

    if (_dateTime.minute == 0 && _dateTime.hour == 19) {
      _startThemeAnimation();
      Timer(
        _themeController.duration * 0.1,
        updateTimeStateValues,
      );
      return;
    }
    if (_dateTime.minute == 0 && _dateTime.hour == 7) {
      _reverseThemeAnimation();
      Timer(
        _themeController.duration * 0.8714,
        updateTimeStateValues,
      );
      return;
    }

    updateTimeStateValues();

    if (_dateTime.minute != previousMinuteValue) {
      _resetMinuteAnimation();
      _startMinuteAnimation();
    }

    if (_dateTime.hour != previousHourValue) {
      _resetHourAnimation();
      _startHourAnimation();
    }

    if (_meridiemLabel != previousMeridiemValue) {
      _resetMeridiemAnimation();
      _startMeridiemAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final specialTimeLabel = _dateTime.minute < 2
        ? _dateTime.hour == 12
            ? 'noon.'
            : _dateTime.hour == 00 ? 'midnight.' : ''
        : '';

    Container mainClock(colors) {
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

      final specialTimeStyle = TextStyle(
        color: colors[_Element.text],
        fontFamily: 'MontSerrat',
        fontSize: fontSize * 0.8,
      );

      final digitDisplayStack = Stack(
        children: <Widget>[
          Positioned(
            right: 435,
            child: AnimatedTopPositionContainer(
                _hourController,
                Text(
                  _previousHour,
                  style: boldStyle,
                ),
                MediaQuery.of(context).size.height / 3.45,
                fontSize,
                context),
          ),
          Positioned(
            right: 435,
            child: AnimatedTopPositionContainer(
                _hourController,
                Text(
                  _hour,
                  style: boldStyle,
                ),
                0.0,
                fontSize,
                context),
          ),
          Positioned(
            left: 220,
            child: AnimatedTopPositionContainer(
                _meridiemController,
                Text(
                  _previousMeridiemLabel,
                  style: thinStyle,
                ),
                MediaQuery.of(context).size.height / 3.45,
                fontSize,
                context),
          ),
          Positioned(
            left: 220,
            child: AnimatedTopPositionContainer(
                _meridiemController,
                Text(
                  _meridiemLabel,
                  style: thinStyle,
                ),
                0.0,
                fontSize,
                context),
          ),
          Positioned(
            left: 440,
            child: AnimatedTopPositionContainer(
                _minuteController,
                Text(
                  _previousMinute,
                  style: boldStyle,
                ),
                MediaQuery.of(context).size.height / 3.45,
                fontSize,
                context),
          ),
          Positioned(
            left: 440,
            child: AnimatedTopPositionContainer(
                _minuteController,
                Text(
                  _minute,
                  style: boldStyle,
                ),
                0.0,
                fontSize,
                context),
          ),
        ],
      );
      return Container(
        color: colors[_Element.background],
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              child: AnimatedTopPositionContainer(
                  _specialTimeController,
                  Text(specialTimeLabel,
                      style: specialTimeStyle, textAlign: TextAlign.center),
                  0.0,
                  fontSize,
                  context),
            ),
            AnimatedTopPositionContainer(_specialTimeController,
                digitDisplayStack, 0.0, fontSize, context),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height / 1.7,
              top: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height / 3.45,
                  width: MediaQuery.of(context).size.height / 3.45,
                  decoration: BoxDecoration(
                    color: colors[_Element.background],
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
                    color: colors[_Element.background],
                  )),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Stack(
        children: <Widget>[
          mainClock(_darkTheme),
          AnimatedTopPositionContainer(_themeController, mainClock(_lightTheme),
              0.0, MediaQuery.of(context).size.width, context),
        ],
      ),
    );
  }
}
