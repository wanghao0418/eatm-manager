import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PaperPainter extends CustomPainter {
  //公用变量
  Paint _paint = Paint();
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  //划线需要的变量
  double dStartX = 0.0, dStartY = 0.0, dEndX = 0.0, dEndY = 0.0;

  PaperPainter(this.dStartX, this.dStartY, this.dEndX, this.dEndY) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    foregroundPainter(canvas);
  }

  void foregroundPainter(Canvas canvas) {
    var paint = Paint()..color = const Color(0x80F53010);
    paint.strokeWidth = 1.0;

    canvas.drawLine(
      Offset(dStartX, dStartY),
      Offset(dEndX, dEndY),
      paint,
    );
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate){return false;}
}

class PaperPainterImage extends CustomPainter {
  //公用变量
  Paint _paint = Paint();
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  //动画需要的变量
  final ui.Image _image;
  double dWidth = 68.0,dHeight = 1.0;
  double dLeft = -200.0,dTop = -100.0,dRight = 100.0,dBottom = 1000.0;
  double dOffsetX = 50.0,dOffsetY = 50.0;

  PaperPainterImage(
      this._image, this.dWidth, this.dHeight,this.dLeft,this.dTop,this.dRight,this.dBottom,
      this.dOffsetX,this.dOffsetY) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _drawImage(canvas);
  }

  @override
  bool shouldRepaint(PaperPainterImage oldDelegate)=>
      _image != oldDelegate._image;

  void _drawImage(Canvas canvas) {
    if (_image != null) {
      canvas.drawImageRect(
          _image,
          Rect.fromCenter(
              center: Offset(_image.width * 1.0, _image.height * 1.0),
              width: dWidth,
              height: dHeight),
          Rect.fromLTRB(dLeft, dTop, dRight,dBottom).translate(dOffsetX, dOffsetY),
          _paint);
    }
  }
}