/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 13:56:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 14:40:39
 * @FilePath: /eatm_manager/lib/common/components/line_form_label.dart
 * @Description: 行表单组件说明
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineFormLabel extends StatelessWidget {
  const LineFormLabel(
      {Key? key,
      required this.label,
      required this.child,
      this.isRequired = false,
      this.isExpanded = false})
      : super(key: key);
  final String label;
  final bool? isRequired;
  final Widget child;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
