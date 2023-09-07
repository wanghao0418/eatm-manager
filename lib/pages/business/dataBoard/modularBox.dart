import 'package:flutter/material.dart';

class ModularBox extends StatefulWidget {
  const ModularBox({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  State<ModularBox> createState() => _ModularBoxState();
}

class _ModularBoxState extends State<ModularBox> {
  Widget renderTitleLine() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(8, 37, 183, 0.7),
              Color.fromRGBO(1, 180, 255, 0.7),
              Color.fromRGBO(15, 31, 80, 0.7)
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: <Color>[Color(0xff0E8BFF), Color(0xff01FFFD), Color(0xff01AAFF)],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // border: Border.all(color: Color(0xff0E8BFF), width: 1),
            ),
        child: Column(
          children: [
            renderTitleLine(),
            Expanded(
                child: Container(
              color: Color(0xff101747),
              child: widget.child,
            ))
          ],
        ));
  }
}
