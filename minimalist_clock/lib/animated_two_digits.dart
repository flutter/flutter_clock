import 'package:flutter/material.dart';

class AnimatedTwoDigits extends StatelessWidget {
  AnimatedTwoDigits(
      this._controller, this._digits, this._style, topPosition, context)
      : _movement = Tween<EdgeInsets>(
          begin: EdgeInsets.only(top: topPosition),
          end: EdgeInsets.only(top: topPosition + _style.fontSize),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.5, curve: Curves.linear))),
        _opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.5, 0.51, curve: Curves.linear)));

  final String _digits;
  final TextStyle _style;
  final Animation<double> _controller;
  final Animation<EdgeInsets> _movement;
  final Animation<double> _opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Opacity(
            opacity: _opacity.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: _movement.value,
              child: Text(
                _digits,
                style: _style,
              ),
            ),
          );
        });
  }
}
