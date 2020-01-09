import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:digital_clock/blocs/settings.dart' as blocs;

import 'themes/dark.dart' as themes;
import 'themes/light.dart' as themes;

class Location extends StatelessWidget {
  final blocs.Settings settings;
  const Location(this.settings);

  @override
  Widget build(BuildContext context) => _buildText();

  Widget _buildText() => StreamBuilder<String>(
      stream: settings.location,
      initialData: '',
      builder: (context, snapshot) => Row(
            children: <Widget>[
              Expanded(
                  child: Text(snapshot.data,
                      style: TextStyle(
                        shadows: [
                          Theme.of(context).brightness == Brightness.light
                              ? themes.Light.shadow
                              : themes.Dark.shadow
                        ],
                        color: Theme.of(context).brightness == Brightness.light
                            ? themes.Light.foreground
                            : themes.Dark.foreground,
                        fontSize: 16,
                        fontFamily: 'Spectral',
                      ))),
            ],
          ));
}
