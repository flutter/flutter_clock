import 'package:flutter/material.dart';

class AnimatedTopPositionContainer extends StatelessWidget {
  AnimatedTopPositionContainer(
      this._controller, this._child, topPosition, verticalMovment, context)
      : _movement = Tween<EdgeInsets>(
          begin: EdgeInsets.only(top: topPosition),
          end: EdgeInsets.only(top: topPosition + verticalMovment),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.5, curve: Curves.linear)));

  final Animation<double> _controller;
  final Widget _child;
  final Animation<EdgeInsets> _movement;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Container(
            padding: _movement.value,
            child: _child,
          );
        });
  }
}
