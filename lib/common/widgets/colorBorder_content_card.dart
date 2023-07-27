/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-02 13:48:33
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 09:59:11
 * @FilePath: /eatm_manager/lib/common/widgets/colorBorder_content_card.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/index.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
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
            borderRadius: BorderRadius.circular(5),
            color: GlobalTheme.instance.pageContentBackgroundColor,
            boxShadow: [GlobalTheme.instance.boxShadow]),
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
