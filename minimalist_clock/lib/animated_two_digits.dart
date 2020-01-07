import 'package:flutter/material.dart';

class AnimatedTwoDigits extends StatelessWidget {
  AnimatedTwoDigits(this._controller, this._digits, this._style, context)
      : _movement = Tween<EdgeInsets>(
          begin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.45),
          end: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3.45 + _style.fontSize),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));

  final String _digits;
  final TextStyle _style;
  final Animation<double> _controller;
  final Animation<EdgeInsets> _movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Container(
            padding: _movement.value,
            child: Text(
              _digits,
              style: _style,
            ),
          );
        });
  }
}
