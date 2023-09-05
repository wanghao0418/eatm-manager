/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-08 10:38:56
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 15:13:08
 * @FilePath: /eatm_manager/lib/common/components/themed_text.dart
 * @Description:  主题文本
 */
import 'package:fluent_ui/fluent_ui.dart';

class ThemedText extends StatefulWidget {
  const ThemedText(this.text,
      {Key? key, this.style, this.textAlign = TextAlign.start})
      : super(key: key);
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  _ThemedTextState createState() => _ThemedTextState();
}

class _ThemedTextState extends State<ThemedText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,
        style: widget.style != null
            ? FluentTheme.of(context).typography.body!.merge(widget.style)
            : FluentTheme.of(context).typography.body,
        textAlign: widget.textAlign);
  }
}
