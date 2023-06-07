import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../common/widgets/colorBorder_content_card.dart';
import 'index.dart';

class InterchangeStationPage extends GetView<InterchangeStationController> {
  const InterchangeStationPage({Key? key}) : super(key: key);

  // 货架货位部分
  Widget _buildShelves() {
    return SizedBox(
      child: Row(
        children: [
          ColorBorderContentCard(
              headWidget: Container(
                alignment: Alignment.center,
                width: 300.r,
                child: const Text('货架列表')
                    .fontSize(20.sp)
                    .fontWeight(FontWeight.bold)
                    .textColor(Colors.white),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                width: 300.r,
                child: ListView.builder(
                  itemCount: controller.shelfList.length,
                  itemBuilder: (context, index) {
                    var shelf = controller.shelfList[index];
                    return ListTile.selectable(
                      title: Text(shelf['shelfName']).fontSize(20.sp),
                      selected: controller.currentShelfIndex == index,
                      onSelectionChange: (v) {
                        controller.currentShelfIndex = index;
                        controller.update(['interchangeStation']);
                      },
                    );
                  },
                ),
              )),
          10.horizontalSpaceRadius,
          Expanded(
              child: ColorBorderContentCard(
            headWidget: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  20.horizontalSpaceRadius,
                  const Text('货位')
                      .fontSize(22.sp)
                      .fontWeight(FontWeight.bold)
                      .textColor(Colors.white),
                  20.horizontalSpace,
                  ...GoodsState.values
                      .map((e) => Padding(
                            padding: EdgeInsets.only(right: 10.r, left: 10.r),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30.r,
                                    height: 30.r,
                                    decoration: BoxDecoration(
                                        color: e.color,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                  ),
                                  5.horizontalSpace,
                                  Text(e.label)
                                      .fontSize(16.sp)
                                      .textColor(Colors.white)
                                ]),
                          ))
                      .toList()
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10.r),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Wrap(
                spacing: 10.r,
                runSpacing: 10.r,
                children: (controller.shelfList.isNotEmpty)
                    ? (controller.shelfList[controller.currentShelfIndex]
                            ['shelves'] as List)
                        .map((e) {
                        var index = controller
                            .shelfList[controller.currentShelfIndex]['shelves']
                            .indexOf(e);
                        var good = e;

                        return FlyoutTarget(
                            key: ValueKey("货位$index"),
                            controller: controller.menuController,
                            child: GestureDetector(
                              child: Container(
                                  width: 120.r,
                                  height: 120.r,
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xff73978e),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 100.r,
                                        height: 100.r,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: GoodsState.findByStatus(
                                                  good['status'])!
                                              .color,
                                        ),
                                      ),
                                      Positioned(
                                        left: 5.r,
                                        bottom: 5.r,
                                        child: Text(index.toString())
                                            .fontSize(16.sp)
                                            .textColor(Colors.white),
                                      )
                                    ],
                                  )
                                  // padding: EdgeInsets.all(10.r),
                                  ),
                              onSecondaryTapDown: (details) {
                                var dx = (controller.pageKey.currentContext!
                                        .findRenderObject() as RenderBox)
                                    .localToGlobal(Offset.zero)
                                    .dx;
                                var dy = (controller.pageKey.currentContext!
                                        .findRenderObject() as RenderBox)
                                    .localToGlobal(Offset.zero)
                                    .dy;
                                controller.menuOffset = Offset(
                                    details.globalPosition.dx - dx,
                                    details.globalPosition.dy - dy);
                                var position = details.globalPosition;
                                controller.menuController.showFlyout(
                                    builder: (context) {
                                      return MenuFlyout(
                                        elevation: 0,
                                        items: [
                                          MenuFlyoutItem(
                                              text: Text('下料').fontSize(16.sp),
                                              onPressed: () {
                                                print('下料');
                                              }),
                                        ],
                                      );
                                    },
                                    position: position);
                              },
                            ));
                      }).toList()
                    : [],
              )),
            ),
          ))
        ],
      ),
    );
  }

  // 接驳站部分
  Widget _buildStations() {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemExtent: 300.r,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.only(right: 10.r),
                    child: Column(
                      children: [
                        Expanded(
                            child: ColorBorderContentCard(
                          child: Container(
                            width: 300.r,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120.r,
                                  height: 120.r,
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xff73978e),
                                  ),
                                  child: Container(
                                    width: 100.r,
                                    height: 100.r,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: GoodsState.findByStatus(4)!.color,
                                    ),
                                  ),
                                  // padding: EdgeInsets.all(10.r),
                                ),
                                10.verticalSpacingRadius,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Button(
                                        child: Text('绑定物料').fontSize(16.sp),
                                        onPressed: () {}),
                                    5.horizontalSpaceRadius,
                                    FilledButton(
                                        child: Text('上料').fontSize(16.sp),
                                        onPressed: () {})
                                  ],
                                )
                              ],
                            ),
                          ),
                          headWidget: Container(
                            width: 300.r,
                            alignment: Alignment.center,
                            child: Text('接驳站$index')
                                .fontSize(20.sp)
                                .fontWeight(FontWeight.bold)
                                .textColor(Colors.white),
                          ),
                        )),
                        10.verticalSpacingRadius,
                        Expanded(
                            child: ColorBorderContentCard(
                          child: Container(
                            width: 300.r,
                            padding: EdgeInsets.all(10.r),
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InfoLabel(
                                      label: '工件编号',
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 40.sp),
                                        child: Text('123').fontSize(16.sp),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.yellow.darkest),
                                    ),
                                    InfoLabel(
                                      label: '当前工步',
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 40.sp),
                                        child: Text('123').fontSize(16.sp),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.yellow.darkest),
                                    ),
                                    InfoLabel(
                                      label: '当前工序',
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 40.sp),
                                        child: Text('123').fontSize(16.sp),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.yellow.darkest),
                                    ),
                                    InfoLabel(
                                      label: '物料信息',
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 40.sp),
                                        child: Text('123').fontSize(16.sp),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.yellow.darkest),
                                    ),
                                  ]),
                            ),
                          ),
                          headWidget: Container(
                            width: 300.r,
                            alignment: Alignment.center,
                            child: Text('托盘信息')
                                .fontSize(20.sp)
                                .fontWeight(FontWeight.bold)
                                .textColor(Colors.white),
                          ),
                        ))
                      ],
                    ));
              }),
        ),
        50.horizontalSpaceRadius,
        SizedBox(
          width: 300.r,
          child: Column(
            children: [
              Container(
                  height: 200.r,
                  child: ColorBorderContentCard(
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                                child: Text('取托盘').fontSize(16.sp),
                                onPressed: () {}),
                            10.verticalSpacingRadius,
                            FilledButton(
                                child: Text('放托盘').fontSize(16.sp),
                                onPressed: () {})
                          ]),
                    ),
                    headWidget: Container(
                      alignment: Alignment.center,
                      child: Text('机械手操作')
                          .fontSize(20.sp)
                          .fontWeight(FontWeight.bold)
                          .textColor(Colors.white),
                    ),
                  )),
              10.verticalSpacingRadius,
              Expanded(
                  child: Container(
                width: 300.r,
                child: ColorBorderContentCard(
                  child: Container(),
                  headWidget: Container(
                    alignment: Alignment.center,
                    child: Text('机械手任务池')
                        .fontSize(20.sp)
                        .fontWeight(FontWeight.bold)
                        .textColor(Colors.white),
                  ),
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      key: controller.pageKey,
      padding: EdgeInsets.all(20.r),
      child: Column(children: [
        Expanded(child: _buildShelves()),
        10.verticalSpacingRadius,
        Expanded(child: _buildStations()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterchangeStationController>(
      init: InterchangeStationController(),
      id: "interchangeStation",
      builder: (_) {
        return material.Scaffold(
          body: _buildView(),
        );
      },
    );
  }
}
