import 'package:eatm_manager/common/index.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorBorderContentCard extends StatefulWidget {
  const ColorBorderContentCard(
      {Key? key, required this.child, this.color, required this.headWidget})
      : super(key: key);
  final Widget child;
  final Color? color;
  final Widget headWidget;

  @override
  _ColorBorderContentCardState createState() => _ColorBorderContentCardState();
}

class _ColorBorderContentCardState extends State<ColorBorderContentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: widget.color ?? AppTheme().color, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
            child: Column(children: [
          Container(
            padding: EdgeInsets.all(5.h),
            color: widget.color ?? AppTheme().color,
            child: widget.headWidget,
          ),
          Expanded(child: widget.child)
        ])));
  }
}
