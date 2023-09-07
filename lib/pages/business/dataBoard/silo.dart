/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-03-28 14:27:46
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-06 16:20:29
 * @FilePath: /mesui/lib/pages/dataBoard/silo.dart
 * @Description: 料仓组件
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Silo extends StatefulWidget {
  @override
  _SiloState createState() => _SiloState();
}

class _SiloState extends State<Silo> {
  List<String> _tabs = [
    '货架 1',
    '货架 2',
    '货架 3',
    '货架 4',
    '货架 5',
    '货架 6',
    '货架 7',
    '货架 8'
  ];
  int _selectedTabIndex = 0;
  List<List<String>> _items = [
    [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
      'Item 6',
      'Item 7',
      'Item 8'
    ],
    [
      'Item 9',
      'Item 10',
      'Item 11',
      'Item 12',
      'Item 13',
      'Item 14',
      'Item 15',
      'Item 16'
    ],
    [
      'Item 17',
      'Item 18',
      'Item 19',
      'Item 20',
      'Item 21',
      'Item 22',
      'Item 23',
      'Item 24'
    ],
  ];
  final _controller = ScrollController();
  final _tabController = ScrollController();
  late Timer _timer;
  final int _SPEED = 20;

  void _scrollToSelectedIndex() {
    final itemWidth = 130.0;

    final center = _tabController.position.viewportDimension / 2;
    // Log.i(_tabController.position.viewportDimension);

    final scrollOffset = (itemWidth * _selectedTabIndex) -
        (_tabController.position.viewportDimension / 2) +
        (itemWidth / 2);
    // Log.i(scrollOffset);

    final canScroll =
        scrollOffset < _tabController.position.viewportDimension / 2 &&
            scrollOffset > 0;
    if (!canScroll) {
      if (scrollOffset < _tabController.position.viewportDimension / 2) {
        _tabController.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else if (scrollOffset > 0) {
        _tabController.animateTo(_tabController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      return;
    }
    _tabController.animateTo(scrollOffset,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Log.i(_controller.offset);
      // Log.i(_controller.position.maxScrollExtent);
      // Log.i(_controller.position.viewportDimension);
      // Log.i(_controller.position.pixels);
      _controller.animateTo(_controller.offset + _SPEED,
          duration: Duration(milliseconds: 1000), curve: Curves.linear);
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent / 2) {
        _controller.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _tabController,
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                  _scrollToSelectedIndex();
                },
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints(minWidth: 120),
                  margin: EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_selectedTabIndex == index
                          ? 'assets/images/dataBoard/tab_active.png'
                          : 'assets/images/dataBoard/tab.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: _selectedTabIndex == index
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
            child: Row(children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: 50,
              itemBuilder: (context, index) {
                // 计算当前行的起始索引和结束索引
                int startIndex = index * 8;
                int endIndex = (index + 1) * 8;

                // 如果结束索引超过了总数据量，则使用总数据量作为结束索引
                // if (endIndex > 50) {
                //   endIndex = 50;
                // }

                // 创建一行
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/dataBoard/silo_row.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(endIndex - startIndex, (i) {
                      // 计算当前元素的索引
                      int elementIndex = startIndex + i;
                      int status = Random().nextInt(5) + 1;

                      // 创建一个元素
                      return Expanded(
                        child: elementIndex < 50
                            ? Container(
                                child: Stack(children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        ArtifactStatus.findByStatus(status)!
                                            .imageSrc,
                                        width: 80,
                                        height: 40,
                                      ),
                                      Text(
                                        (elementIndex + 1).toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Image.asset(
                                        'assets/images/dataBoard/silo_cell.png',
                                        width: 80,
                                        height: 30,
                                      ))
                                ]),
                              )
                            : Container(),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          Container(
              width: 110,
              padding: EdgeInsets.only(left: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: ArtifactStatus.values
                        .map((e) => Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Image(
                                    image: AssetImage(e.imageSrc),
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    e.label,
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ))
                        .toList()),
              )),
        ])),
      ],
    );
  }
}

// 状态枚举
enum ArtifactStatus {
  processing(
      status: 1,
      label: '待加工',
      imageSrc: 'assets/images/artifact/steel_status1.png'),
  inProgress(
      status: 2,
      label: '加工中',
      imageSrc: 'assets/images/artifact/steel_status2.png'),
  finished(
      status: 3,
      label: '加工完成',
      imageSrc: 'assets/images/artifact/steel_status3.png'),
  idle(
      status: 4,
      label: '空闲',
      imageSrc: 'assets/images/artifact/steel_status4.png'),
  error(
      status: 5,
      label: '异常',
      imageSrc: 'assets/images/artifact/steel_status5.png');

  final int status;
  final String label;
  final String imageSrc;

  const ArtifactStatus(
      {required this.status, required this.label, required this.imageSrc});

  static ArtifactStatus? findByStatus(int status) {
    var index = ArtifactStatus.values
        .indexWhere((ArtifactStatus element) => element.status == status);
    return index >= 0 ? ArtifactStatus.values[index] : null;
  }
}
