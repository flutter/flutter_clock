import 'dart:async';

import 'package:flutter_clock_helper/model.dart' as models;

class Settings {
  models.ClockModel clock;

  StreamController<bool> is24HourFormatController;
  Stream<bool> is24HourFormat;
  bool _is24HourFormat;

  StreamController<String> locationController;
  Stream<String> location;
  String _location;

  StreamController<String> temperatureController;
  Stream<String> temperature;
  String _temperature;

  StreamController<String> weatherController;
  Stream<String> weather;
  String _weather;

  StreamController<String> unitsController;
  Stream<String> units;
  String _units;

  Settings({this.clock}) {
    is24HourFormatController = StreamController<bool>();
    is24HourFormat = is24HourFormatController.stream.asBroadcastStream();
    is24HourFormatController.add(clock.is24HourFormat);

    locationController = StreamController<String>();
    location = locationController.stream.asBroadcastStream();
    locationController.add(clock.location);

    temperatureController = StreamController<String>();
    temperature = temperatureController.stream.asBroadcastStream();
    temperatureController.add(clock.temperatureString);

    weatherController = StreamController<String>();
    weather = weatherController.stream.asBroadcastStream();
    weatherController.add(clock.weatherString);

    unitsController = StreamController<String>();
    units = unitsController.stream.asBroadcastStream();
    unitsController.add(clock.unitString);

    clock.addListener(settingsChange);
  }

  void dispose() {
    clock.removeListener(settingsChange);
    is24HourFormatController.close();
  }

  void settingsChange() {
    if (_is24HourFormat != clock.is24HourFormat) {
      _is24HourFormat = clock.is24HourFormat;
      is24HourFormatController.add(_is24HourFormat);
    }

    if (_location != clock.location) {
      _location = clock.location;
      locationController.add(_location);
    }

    if (_temperature != clock.temperatureString) {
      _temperature = clock.temperatureString;
      temperatureController.add(_temperature);
    }

    if (_weather != clock.weatherString) {
      _weather = clock.weatherString;
      weatherController.add(_weather);
    }

    if (_units != clock.unitString) {
      _units = clock.unitString;
      unitsController.add(_units);
    }
  }
}
