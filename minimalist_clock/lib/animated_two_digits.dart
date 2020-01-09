import 'package:flutter/material.dart';

class AnimatedTwoDigits extends StatelessWidget {
  AnimatedTwoDigits(
      this._controller, this._digits, this._style, topPosition, context)
      : _movement = Tween<EdgeInsets>(
          begin: EdgeInsets.only(top: topPosition),
          end: EdgeInsets.only(top: topPosition + _style.fontSize),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.5, curve: Curves.linear)));

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
            // decoration: BoxDecoration(
            //   color: Colors.white,
            // ),
            padding: _movement.value,
            child: Text(
              _digits,
              style: _style,
            ),
          );
        });
  }
}
