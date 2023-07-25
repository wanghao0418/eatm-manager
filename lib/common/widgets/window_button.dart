/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-31 18:16:23
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-25 09:21:33
 * @FilePath: /eatm_manager/lib/common/widgets/window_button.dart
 * @Description: 窗口按钮
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 34,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
