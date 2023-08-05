/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-20 10:03:36
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-04 10:17:13
 * @FilePath: /iniConfig/lib/pages/system/home/widgets/setting_view.dart
 * @Description: 全局设置组件
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/system/main/widgets/navigation_bar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

const List<String> accentColorNames = [
  // 'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

const List<PaneDisplayMode> navigationIndicatorNames = [
  PaneDisplayMode.auto,
  PaneDisplayMode.compact,
  // PaneDisplayMode.minimal,
  PaneDisplayMode.open
];

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Widget _buildColorBlock(AccentColor color, int colorIndex) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          GetStorage('globalTheme').write('accentColorIndex', colorIndex);
          GlobalTheme.instance.accentColor = color;
        },
        style: ButtonStyle(
          padding: ButtonState.all(EdgeInsets.zero),
          backgroundColor: ButtonState.resolveWith((states) {
            if (states.isPressing) {
              return color.light;
            } else if (states.isHovering) {
              return color.lighter;
            }
            return color;
          }),
        ),
        child: Container(
          height: 40,
          width: 40,
          alignment: AlignmentDirectional.center,
          child: GlobalTheme.instance.accentColor == color
              ? Icon(
                  FluentIcons.check_mark,
                  color: color.basedOnLuminance(),
                  size: 22.0,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(children: [
      Text('模式', style: FluentTheme.of(context).typography.subtitle),
      5.verticalSpacingRadius,
      Divider(),
      5.verticalSpacingRadius,
      Container(
        padding: EdgeInsets.symmetric(vertical: 20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '夜晚模式',
              style: FluentTheme.of(context).typography.body,
            ),
            ToggleSwitch(
                checked: GlobalTheme.instance.isDarkMode,
                onChanged: (value) {
                  GlobalTheme.instance.isDarkMode = value;
                }),
          ],
        ),
      ),
      20.verticalSpacingRadius,
      Text('主题色', style: FluentTheme.of(context).typography.subtitle),
      5.verticalSpacingRadius,
      Divider(),
      5.verticalSpacingRadius,
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.r),
        child: Wrap(children: [
          ...List.generate(Colors.accentColors.length, (index) {
            final color = Colors.accentColors[index];
            return Tooltip(
              message: accentColorNames[index],
              child: _buildColorBlock(color, index),
            );
          }),
        ]),
      ),
      20.verticalSpacingRadius,
      Text('导航方式', style: FluentTheme.of(context).typography.subtitle),
      5.verticalSpacingRadius,
      Divider(),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20.r),
          child: Wrap(spacing: 20.r, children: [
            RadioButton(
                checked: GlobalTheme.instance.navigationBarType ==
                    NavigationBarDisplayType.normal,
                onChanged: (value) {
                  GlobalTheme.instance.navigationBarType =
                      NavigationBarDisplayType.normal;
                },
                content: Text(
                  '左侧',
                  style: FluentTheme.of(context).typography.body,
                )),
            RadioButton(
                checked: GlobalTheme.instance.navigationBarType ==
                    NavigationBarDisplayType.drawer,
                onChanged: (value) {
                  GlobalTheme.instance.navigationBarType =
                      NavigationBarDisplayType.drawer;
                },
                content: Text(
                  '抽屉',
                  style: FluentTheme.of(context).typography.body,
                )),
          ])),
    ]);
  }
}
