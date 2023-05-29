import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ColorBorderContentCard extends HookWidget {
  const ColorBorderContentCard(
      {Key? key, required this.child, this.color, required this.headWidget})
      : super(key: key);
  final Widget child;
  final Color? color;
  final Widget headWidget;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: color ?? appTheme.color, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
            child: Column(children: [
          Container(
            padding: EdgeInsets.all(5.h),
            color: color ?? appTheme.color,
            child: headWidget,
          ),
          Expanded(child: child)
        ])));
  }
}
