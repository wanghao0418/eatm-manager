import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'paperPainter.dart';
import 'dart:ui' as ui;

class AnimatedSpriteImage extends StatefulWidget {
  final Size spriteSize;
  final int startIndex;
  final int endIndex;
  final int playTimes;
  final Duration duration;
  final Axis axis;
  final ui.Image image;
  final double dImageLeft, dImageTop, dImageRight, dImageBottom;

  const AnimatedSpriteImage({
    Key? key,
    required this.image,
    required this.spriteSize,
    required this.duration,
    this.axis = Axis.horizontal,
    this.startIndex = 0,
    this.endIndex = 0,
    this.playTimes = 0, //0 = loop
    required this.dImageLeft,
    required this.dImageTop,
    required this.dImageRight,
    required this.dImageBottom,
  }) : super(key: key);

  @override
  _AnimatedSpriteImageState createState() => _AnimatedSpriteImageState();
}

class _AnimatedSpriteImageState extends State<AnimatedSpriteImage> {
  int currentIndex = 0;
  int currentTimes = 0;

  Stream<int> counter() {
    return Stream.periodic(widget.duration, (timer) {
      if (currentTimes <= widget.playTimes) {
        if (currentIndex >= widget.endIndex) {
          if (widget.playTimes != 0) currentTimes++;
          if (currentTimes < widget.playTimes || widget.playTimes == 0) {
            currentIndex = widget.startIndex;
          } else {
            currentIndex = widget.endIndex;
          }
        } else {
          currentIndex++;
        }
      }
      return currentIndex;
    });
  }

  @override
  void initState() {
    currentIndex = widget.startIndex;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream: counter(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Positioned(
                  left: widget.axis == Axis.horizontal
                      ? widget.spriteSize.width * currentIndex
                      : 0,
                  top: widget.axis == Axis.vertical
                      ? widget.spriteSize.height * currentIndex
                      : 0,
                  // child: SizedBox(width:500,height: 500,child:Image.asset(widget.strImage,fit:BoxFit.scaleDown,width: 100,height: 100)),
                  child: CustomPaint(
                    painter: PaperPainterImage(
                        widget.image,
                        68.0,
                        1.0,
                        widget.dImageLeft,
                        widget.dImageTop,
                        widget.dImageRight,
                        widget.dImageBottom,
                        0,
                        0), //-100,-100,10,210
                  ));
            }),
      ],
    );
  }
}
