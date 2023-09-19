/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-14 14:27:49
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2023-09-19 18:18:46
 * @FilePath: /eatm_manager/lib/pages/business/dataBoard/line_body.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/business/dataBoard/machineRunInfo.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

class LineBody extends StatefulWidget {
  const LineBody({Key? key}) : super(key: key);

  @override
  _LineBodyState createState() => _LineBodyState();
}

class _LineBodyState extends State<LineBody> {
  // 初始位置
  Offset position = Offset(20, 20);

  bool isDrag = false;
  GlobalKey _key = GlobalKey();
  GlobalKey imageKey = GlobalKey();

  late double width;
  late double height;

  late double imageWidth;
  late double imageHeight;

  double sizeNum = 80;

  Offset get targetCenter =>
      Offset(position.dx + sizeNum / 2, position.dy + sizeNum / 2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          key: _key,
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/dataBoard/line_body.png',
                fit: BoxFit.fitHeight,
                key: imageKey,
              ),
            ),
            if (!isDrag)
              Positioned(
                  child: CustomPaint(
                painter: ConnectionLinePainter(
                    start: Offset(0.25 * width, 0.3 * height),
                    end: targetCenter), // 自定义的绘制器
                child: const SizedBox.expand(), // 子部件占满整个画布
              )),
            // 测试拖动组件
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Draggable(
                  // 指定拖动的子组件
                  feedback: Opacity(
                    opacity: 0.5,
                    child: MachineRunInfo(
                      width: sizeNum,
                      height: sizeNum,
                      status: MachineStatus.paused,
                      machineName: 'Machine1',
                    ),
                  ),
                  onDragStarted: () {
                    isDrag = true;
                    setState(() {});
                  },
                  // 拖动结束时的处理
                  onDraggableCanceled: (velocity, offset) {
                    // 最大dx dy
                    var maxDx =
                        (_key.currentContext!.findRenderObject() as RenderBox)
                                .size
                                .width -
                            sizeNum;
                    var maxDy =
                        (_key.currentContext!.findRenderObject() as RenderBox)
                                .size
                                .height -
                            sizeNum;
                    // 当前dx dy
                    var currentDx = offset.dx -
                        (context.findRenderObject() as RenderBox)
                            .localToGlobal(Offset.zero)
                            .dx;
                    var currentDy = offset.dy -
                        (context.findRenderObject() as RenderBox)
                            .localToGlobal(Offset.zero)
                            .dy;
                    late double finalDx;
                    late double finalDy;
                    if (currentDx >= 0 && currentDx <= maxDx) {
                      finalDx = currentDx;
                    } else if (currentDx < 0) {
                      finalDx = 0;
                    } else if (currentDx > maxDx) {
                      finalDx = maxDx;
                    }

                    if (currentDy >= 0 && currentDy <= maxDy) {
                      finalDy = currentDy;
                    } else if (currentDy < 0) {
                      finalDy = 0;
                    } else if (currentDy > maxDy) {
                      finalDy = maxDy;
                    }

                    setState(() {
                      isDrag = false;
                      position = Offset(finalDx, finalDy);
                    });
                  },
                  // 指定拖动的子组件
                  child: isDrag
                      ? Container()
                      : MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: MachineRunInfo(
                            width: sizeNum,
                            height: sizeNum,
                            status: MachineStatus.paused,
                            machineName: 'Machine1',
                          ),
                        )),
            ),
          ]),
        );
      },
    );
  }
}

class ConnectionLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  ConnectionLinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    // 画线，这里假设两个点的坐标为 (50, 50) 和 (150, 150)
    Offset startPoint = start;
    Offset endPoint = end;
    canvas.drawCircle(start, 5, paint);
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
