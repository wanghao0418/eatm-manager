/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 13:44:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 16:06:52
 * @FilePath: /eatm_manager/lib/common/components/filled_icon_button.dart
 * @Description: 填充图标按钮
 */
import 'package:fluent_ui/fluent_ui.dart';

class FilledIconButton extends StatelessWidget {
  const FilledIconButton(
      {Key? key, required this.icon, this.label, required this.onPressed})
      : super(key: key);
  final IconData icon;
  final String? label;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [Icon(icon), Text(label ?? '')]),
      onPressed: onPressed != null ? () => onPressed!() : null,
    );
  }
}
