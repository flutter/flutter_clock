import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:weather_icons/weather_icons.dart' as icons;

import 'package:digital_clock/blocs/settings.dart' as blocs;

import 'themes/dark.dart' as themes;
import 'themes/light.dart' as themes;

class Weather extends StatelessWidget {
  final blocs.Settings settings;
  const Weather(this.settings);

  @override
  Widget build(BuildContext context) => _buildBackgroundLayout(
      child: _buildLayout(
          context: context,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildWeather(),
              _buildWeatherIcon(),
              _buildTemperature(),
            ],
          )));

  Widget _buildBackgroundLayout({Widget child}) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: child,
        ),
      );

  Widget _buildWeather() => StreamBuilder<String>(
      stream: settings.weather,
      initialData: '',
      builder: (context, snapshot) => Text(
          snapshot.data.isNotEmpty
              // ignore: lines_longer_than_80_chars
              ? '${snapshot.data.substring(0, 1).toUpperCase()}${snapshot.data.substring(1)}'
              : '',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? themes.Light.foreground
                : themes.Dark.foreground,
            fontSize: 16,
          )));

  Widget _buildWeatherIcon() => Transform.translate(
        offset: Offset(0, -5),
        child: StreamBuilder<String>(
            stream: settings.weather,
            initialData: '',
            builder: (context, snapshot) {
              final color = Theme.of(context).brightness == Brightness.light
                  ? themes.Light.foreground
                  : themes.Dark.foreground;

              switch (snapshot.data) {
                case 'cloudy':
                  return Icon(icons.WeatherIcons.cloudy, color: color);
                  break;

                case 'foggy':
                  return Icon(icons.WeatherIcons.fog, color: color);
                  break;

                case 'rainy':
                  return Icon(icons.WeatherIcons.rain, color: color);
                  break;

                case 'snowy':
                  return Icon(icons.WeatherIcons.snow, color: color);
                  break;

                case 'sunny':
                  return Icon(icons.WeatherIcons.day_sunny, color: color);
                  break;

                case 'thunderstorm':
                  return Icon(icons.WeatherIcons.thunderstorm, color: color);
                  break;

                case 'windy':
                  return Icon(icons.WeatherIcons.windy, color: color);
                  break;

                default:
                  return Container();
              }
            }),
      );

  Widget _buildTemperature() => StreamBuilder<String>(
      stream: settings.temperature,
      initialData: '',
      builder: (context, snapshot) => Text(snapshot.data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? themes.Light.foreground
                : themes.Dark.foreground,
            fontSize: 16,
          )));

  Widget _buildLayout({Widget child, BuildContext context}) => Container(
        padding: EdgeInsets.all(6),
        width: 220,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? themes.Light.background
                : themes.Dark.background,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? themes.Light.border
                    : themes.Dark.border)),
        child: child,
      );
}
