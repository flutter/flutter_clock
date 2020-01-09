import 'dart:async';

import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

class Time extends ChangeNotifier {
  Timer timer;

  DateTime dateTime;

  String formattedDateTime;

  bool is24HourFormat;

  Time()
      : dateTime = DateTime.now(),
        is24HourFormat = true,
        hour = TimeParts(),
        minute = TimeParts(),
        second = TimeParts() {
    timer = Timer.periodic(
        Duration(seconds: 1) - Duration(milliseconds: dateTime.millisecond),
        (timer) {
      dateTime = DateTime.now();

      formattedDateTime =
          DateFormat(is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss').format(dateTime);

      updateTimeParts(formattedDateTime);
      notifyListeners();
    });
  }

  Time.fromDateTime({this.formattedDateTime}) {
    updateTimeParts(formattedDateTime == null
        ? DateFormat(is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss')
            .format(DateTime.now())
        : formattedDateTime);
  }

  TimeParts hour;
  TimeParts minute;
  TimeParts second;

  void updateTimeParts(String formattedDateTime) {
    final parts = formattedDateTime.split(':');

    final hourParts = parts[0].split('');
    hour = TimeParts(
        firstPart: hourParts.length == 1 ? 0 : hourParts.first,
        lastPart: hourParts.last);

    final minuteParts = parts[1].split('');
    minute = TimeParts(
        firstPart: minuteParts.length == 1 ? 0 : minuteParts.first,
        lastPart: minuteParts.last);

    final secondParts = parts[2].split('');
    second = TimeParts(
        firstPart: secondParts.length == 1 ? 0 : secondParts.first,
        lastPart: secondParts.last);
  }

  TimeCompare compare(Time time) {
    final comparedHour = TimeCompareParts(
        firstPart: time != null && time.hour.firstPart == hour.firstPart
            ? true
            : false,
        lastPart:
            time != null && time.hour.lastPart == hour.lastPart ? true : false);

    final comparedMinute = TimeCompareParts(
        firstPart: time != null && time.minute.firstPart == minute.firstPart
            ? true
            : false,
        lastPart: time != null && time.minute.lastPart == minute.lastPart
            ? true
            : false);

    final comparedSecond = TimeCompareParts(
        firstPart: time != null && time.second.firstPart == second.firstPart
            ? true
            : false,
        lastPart: time != null && time.second.lastPart == second.lastPart
            ? true
            : false);

    return TimeCompare(
        hour: comparedHour, minute: comparedMinute, second: comparedSecond);
  }
}

class TimeParts {
  String firstPart;
  String lastPart;

  TimeParts({this.firstPart, this.lastPart});
}

class TimeCompare {
  TimeCompareParts hour;
  TimeCompareParts minute;
  TimeCompareParts second;

  TimeCompare({this.hour, this.minute, this.second});
}

class TimeCompareParts {
  bool firstPart;
  bool lastPart;

  TimeCompareParts({this.firstPart, this.lastPart});
}
