import 'package:flutter/material.dart';
import 'dart:async';

class DelayedAnimation extends StatefulWidget{
  final Widget child;
  final int delay;
  const DelayedAnimation({required this.delay, required this.child});

  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;
  @override
  void initState(){
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate,);

    _animOffset = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });
  }

  Widget build(BuildContext context)
  {
    return FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _animOffset,
          child: widget.child,
        )
    );
  }
}
