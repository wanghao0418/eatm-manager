/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-11 09:26:10
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-11 16:47:57
 * @FilePath: /eatm_manager/lib/common/components/hover_float.dart
 * @Description: 鼠标悬停悬浮组件
 */
import 'package:fluent_ui/fluent_ui.dart';

class HoverEffectWidget extends StatefulWidget {
  final Widget child;

  HoverEffectWidget({required this.child});

  @override
  _HoverEffectWidgetState createState() => _HoverEffectWidgetState();
}

class _HoverEffectWidgetState extends State<HoverEffectWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _mouseEnter(true),
      onExit: (_) => _mouseEnter(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        // transform: _isHovered
        //     ? Matrix4.translationValues(0, -3, -3)
        //     : Matrix4.identity(),
        child: Stack(children: [
          Container(
              decoration: _isHovered
                  ? const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 3.5), //阴影x轴偏移量
                          blurRadius: 3, //阴影模糊程度
                          spreadRadius: 0 //阴影扩散程度
                          )
                    ])
                  : const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 2.5), //阴影x轴偏移量
                          blurRadius: 2, //阴影模糊程度
                          spreadRadius: 0 //阴影扩散程度
                          )
                    ]),
              child: widget.child),
          if (_isHovered)
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white.withOpacity(0.2),
                ))
        ]),
      ),
    );
  }

  void _mouseEnter(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
