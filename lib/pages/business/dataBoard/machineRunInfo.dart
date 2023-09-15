/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-11 09:58:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-15 14:51:47
 * @FilePath: /mesui/lib/pages/dataBoard/machineRunInfo.dart
 * @Description: 机台运行信息
 */
import 'dart:math';

import 'package:flutter/material.dart';

class MachineRunInfo extends StatefulWidget {
  final double width;
  final double height;
  final int? rotateAngle;
  final String machineName;
  final MachineStatus status;
  const MachineRunInfo(
      {super.key,
      required this.width,
      required this.height,
      this.rotateAngle,
      required this.status,
      required this.machineName});

  @override
  State<MachineRunInfo> createState() => _MachineRunInfoState();
}

class _MachineRunInfoState extends State<MachineRunInfo> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: widget.rotateAngle != null ? widget.rotateAngle! * pi / 180 : 0,
        child: Container(
          width: widget.width,
          height: widget.height,
          // decoration: BoxDecoration(
          //   border: Border(
          //     left: BorderSide(
          //       color: Color.fromARGB(201, 33, 149, 243),
          //       width: 2,
          //     ),
          //     bottom: BorderSide(
          //       color: Color.fromARGB(201, 33, 149, 243),
          //       width: 2,
          //     ),
          //   ),
          // ),
          child: Stack(
            children: [
              // Positioned(
              //     top: 0,
              //     left: 0,
              //     child: Container(
              //       width: 10,
              //       height: 10,
              //       transform: Matrix4.translationValues(-6, -10, 0.0),
              //       decoration: BoxDecoration(
              //         color: Color.fromARGB(201, 33, 149, 243),
              //       ),
              //     )),
              LayoutBuilder(builder: (context, constraints) {
                // return Transform.translate(
                //   offset: Offset(
                //       constraints.maxWidth / 2, constraints.maxHeight * 0.6),
                //   child: Transform.rotate(
                //       angle: widget.rotateAngle != null
                //           ? (360 - widget.rotateAngle!) * pi / 180
                //           : 0,
                //       child: Container(
                //           width: constraints.maxWidth,
                //           height: constraints.maxHeight,
                //           decoration: BoxDecoration(
                //             color: widget.status.color,
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.5),
                //                 spreadRadius: 1,
                //                 blurRadius: 1,
                //                 offset:
                //                     Offset(0, 1), // changes position of shadow
                //               ),
                //             ],
                //             borderRadius: BorderRadius.circular(6),
                //           ),
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 widget.status.label,
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.bold),
                //               ),
                //               SizedBox(
                //                 height: 5,
                //               ),
                //               Text(
                //                 widget.machineName,
                //                 style: TextStyle(
                //                     color: Color(0xff333333),
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ))),
                // );

                return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: widget.status.color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.status.label,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.machineName,
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ));
              })
            ],
          ),
        ));
  }
}

// 状态枚举
enum MachineStatus {
  running(status: 1, label: '运行中', color: Colors.green),
  idle(status: 2, label: '空闲', color: Colors.grey),
  error(status: 3, label: '异常', color: Colors.red),
  paused(status: 4, label: '暂停', color: Colors.yellow);

  final int status;
  final String label;
  final Color color;

  const MachineStatus(
      {required this.status, required this.label, required this.color});

  static MachineStatus? findByStatus(int status) {
    var index = MachineStatus.values
        .indexWhere((MachineStatus element) => element.status == status);
    return index >= 0 ? MachineStatus.values[index] : null;
  }
}
