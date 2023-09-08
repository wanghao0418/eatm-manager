/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 13:56:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 14:23:43
 * @FilePath: /eatm_manager/lib/common/components/line_form_label.dart
 * @Description: 行表单组件说明
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

class LineFormLabel extends StatelessWidget {
  const LineFormLabel(
      {Key? key,
      required this.label,
      required this.child,
      this.isRequired = false,
      this.isExpanded = false,
      this.width,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.textStyle})
      : super(key: key);
  final String label;
  final bool? isRequired;
  final Widget child;
  final bool? isExpanded;
  final double? width;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return width != null
        ? SizedBox(
            width: width,
            child: Row(
                mainAxisAlignment: mainAxisAlignment!,
                crossAxisAlignment: crossAxisAlignment!,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: RichText(
                        text: TextSpan(
                      text: isRequired == true ? '*' : '',
                      style: TextStyle(color: Colors.red),
                      children: [
                        TextSpan(
                            text: '$label:',
                            style: textStyle ??
                                FluentTheme.of(context).typography.body),
                      ],
                    )),
                  ),
                  10.horizontalSpace,
                  isExpanded == true ? Expanded(child: child) : child
                ]),
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment!,
            crossAxisAlignment: crossAxisAlignment!,
            children: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: RichText(
                      text: TextSpan(
                    text: isRequired == true ? '*' : '',
                    style: TextStyle(color: Colors.red),
                    children: [
                      TextSpan(
                          text: '$label:',
                          style: FluentTheme.of(context).typography.body),
                    ],
                  )),
                ),
                10.horizontalSpace,
                isExpanded == true ? Expanded(child: child) : child
              ]);
  }
}
