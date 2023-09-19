import 'dart:math' as Math;
import 'dart:ui' as UI;
import 'package:flutter/material.dart';

class ArcProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double min;
  final double max;
  final double progress;

  ArcProgressBar({
    Key? key,
    this.width = 180,
    this.height = 180,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size(width, height),
        painter: _ArcProgressBarPainter(8, progress, min: min, max: max),
      ));
}

class _ArcProgressBarPainter extends CustomPainter {
  Paint _paint = Paint();

  double _strokeSize = 4;

  double get _margin => _strokeSize / 2;

  num progress = 0;

  double min;

  num max;

  _ArcProgressBarPainter(double strokeSize, this.progress,
      {this.min = 0, this.max = 100}) {
    this._strokeSize = strokeSize;
    if (progress < min) progress = 0;
    if (progress > max) progress = max;
    if (min <= 0) min = 0;
    if (max <= min) max = 100;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double cx = radius;
    double cy = radius;
    _drawProgressArc(canvas, size);
    _drawArcProgressPoint(canvas, cx, cy, radius);
    _drawArcPointLine(canvas, cx, cy, radius);
  }

  void _drawProgressArc(Canvas canvas, Size size) {
    _paint
      ..isAntiAlias = true
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeSize;
    canvas.drawArc(
        Rect.fromLTWH(_margin, _margin, size.width - _strokeSize,
            size.height - _strokeSize),
        _toRadius(120),
        _toRadius(300),
        false,
        _paint);

    _paint
      ..color = Colors.cyan
      ..strokeWidth = _strokeSize - 1;
    canvas.drawArc(
        Rect.fromLTWH(_margin + 1, _margin + 1, size.width - _strokeSize - 2,
            size.height - _strokeSize - 2),
        _toRadius(120),
        progress * _toRadius(300 / (max - min)),
        false,
        _paint);
  }

  void _drawArcProgressPoint(
      Canvas canvas, double cx, double cy, double radius) {
    _paint.strokeWidth = 1;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(120));
    canvas.translate(-cx, -cy);
    for (int i = 0; i <= (max - min); i++) {
      double evaDegree = i * _toRadius(300 / (max - min));
      double b = i % 10 == 0 ? -5 : 0;
      double x = cx + (radius - 20 + b) * Math.cos(evaDegree);
      double y = cy + (radius - 20 + b) * Math.sin(evaDegree);
      double x1 = cx + (radius - 12) * Math.cos(evaDegree);
      double y1 = cx + (radius - 12) * Math.sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(x1, y1), _paint);
    }
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(-120));
    canvas.translate(-cx, -cy);
    // for (double i = min; i <= max; i += 10) {
    //   var pb = UI.ParagraphBuilder(
    //       UI.ParagraphStyle(fontSize: 15, textAlign: TextAlign.start))
    //     ..pushStyle(UI.TextStyle(color: Colors.black))
    //     ..addText(i.toString());
    //   UI.Paragraph p = pb.build()..layout(UI.ParagraphConstraints(width: 30));
    //   double evaDegree = _toRadius(120) + i * _toRadius(300 / (max - min));
    //   double x = cx + (radius - 40) * Math.cos(evaDegree);
    //   double y = cy + (radius - 40) * Math.sin(evaDegree);
    //   canvas.drawParagraph(p, Offset(x - 8, y - 10));
    // }
    canvas.restore();
  }

  void _drawArcPointLine(
      UI.Canvas canvas, double cx, double cy, double radius) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(120));
    canvas.translate(-cx, -cy);
    _paint
      ..color = Colors.amber[800]!
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
    double degree = _toRadius(300 / (max - min)) * progress;
    double x = cx + radius * 3 / 5 * Math.cos(degree);
    double y = cy + radius * 3 / 5 * Math.sin(degree);
    canvas.drawLine(Offset(cx, cy), Offset(x, y), _paint);
    _paint.color = Colors.amber[900]!;
    canvas.drawCircle(Offset(cx, cy), 6, _paint);
    canvas.restore();
  }

  double _toRadius(num degree) => degree * Math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
