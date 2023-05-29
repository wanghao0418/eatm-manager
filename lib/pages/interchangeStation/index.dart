import 'dart:math';

import 'package:eatm_manager/widgets/colorBorder_content_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

// 货位状态枚举
enum GoodsState {
  Idle(status: 0, label: '空闲', color: Color(0xffebeee3)),
  Wait(status: 1, label: '待加工', color: Color(0xff00ccff)),
  InProcess(status: 2, label: '加工中', color: Color(0xffffa902)),
  Error(status: 3, label: '异常', color: Color(0xffff6300)),
  Complete(status: 4, label: '加工完成', color: Color(0xff00d100));

  final int status;
  final String label;
  final Color color;

  const GoodsState(
      {required this.label, required this.color, required this.status});

  static GoodsState? findByStatus(int status) {
    var index = GoodsState.values
        .indexWhere((GoodsState element) => element.status == status);
    return index >= 0 ? GoodsState.values[index] : null;
  }
}

class InterchangeStationPage extends HookWidget {
  InterchangeStationPage({Key? key}) : super(key: key);
  final GlobalKey _pageKey = GlobalKey();

  Widget useShelvesData() {
    var currentShelfIndex = useState(0);
    var shelfList = useState([]);
    final menuController = FlyoutController();
    var menuOffset = useState(Offset.zero);

    useEffect(() {
      shelfList.value = List.generate(
          10,
          (index) => {
                'shelfName': '货架${index}',
                'shelves': List.generate(
                    50,
                    (index) => {
                          'shelvesName': '货位${index}',
                          'status': Random().nextInt(5)
                        })
              });
    }, []);

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
                  itemCount: shelfList.value.length,
                  itemBuilder: (context, index) {
                    var shelf = shelfList.value[index];
                    return ListTile.selectable(
                      title: Text(shelf['shelfName']),
                      selected: currentShelfIndex.value == index,
                      onSelectionChange: (v) => currentShelfIndex.value = index,
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
                children: (shelfList.value[currentShelfIndex.value]['shelves']
                        as List)
                    .map((e) {
                  var index = shelfList.value[currentShelfIndex.value]
                          ['shelves']
                      .indexOf(e);
                  var good = e;

                  return FlyoutTarget(
                      key: ValueKey("货位$index"),
                      controller: menuController,
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
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        GoodsState.findByStatus(good['status'])!
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
                          var dx = (_pageKey.currentContext!.findRenderObject()
                                  as RenderBox)
                              .localToGlobal(Offset.zero)
                              .dx;
                          var dy = (_pageKey.currentContext!.findRenderObject()
                                  as RenderBox)
                              .localToGlobal(Offset.zero)
                              .dy;
                          menuOffset.value = Offset(
                              details.globalPosition.dx - dx,
                              details.globalPosition.dy - dy);
                          var position = details.globalPosition;
                          menuController.showFlyout(
                              builder: (context) {
                                return MenuFlyout(
                                  elevation: 0,
                                  items: [
                                    MenuFlyoutItem(
                                        text: Text('下料'),
                                        onPressed: () {
                                          print('下料');
                                        }),
                                    // const MenuFlyoutSeparator(),
                                    // MenuFlyoutSubItem(
                                    //     showBehavior: SubItemShowBehavior.press,
                                    //     text: Text('下料'),
                                    //     items: (context) {
                                    //       return [
                                    //         MenuFlyoutItem(
                                    //             text: Text('接驳站1'),
                                    //             onPressed: () {
                                    //               print('接驳站1');
                                    //             }),
                                    //         MenuFlyoutItem(
                                    //             text: Text('接驳站2'),
                                    //             onPressed: () {
                                    //               print('接驳站2');
                                    //             }),
                                    //       ];
                                    //     }),
                                  ],
                                );
                              },
                              position: menuOffset.value);
                        },
                      ));
                }).toList(),
              )),
              // child: CustomScrollView(slivers: [
              //   SliverGrid(
              //       delegate: SliverChildBuilderDelegate(
              //         (context, index) {
              //           var good = shelfList.value[currentShelfIndex.value]
              //               ['shelves'][index];
              //           return FlyoutTarget(
              //               key: ValueKey("货位$index"),
              //               controller: menuController,
              //               child: GestureDetector(
              //                 child: Container(
              //                     padding: EdgeInsets.all(10.r),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(5),
              //                       color: Color(0xff73978e),
              //                     ),
              //                     child: Stack(
              //                       children: [
              //                         Container(
              //                           decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(5),
              //                             color: GoodsState.findByStatus(
              //                                     good['status'])!
              //                                 .color,
              //                           ),
              //                         ),
              //                         Positioned(
              //                           left: 5.r,
              //                           bottom: 5.r,
              //                           child: Text(index.toString())
              //                               .fontSize(16.sp)
              //                               .textColor(Colors.white),
              //                         )
              //                       ],
              //                     )
              //                     // padding: EdgeInsets.all(10.r),
              //                     ),
              //                 onSecondaryTapDown: (details) {
              //                   var position = details.globalPosition;
              //                   menuController.showFlyout(
              //                       builder: (context) {
              //                         return MenuFlyout(
              //                           items: [
              //                             MenuFlyoutItem(
              //                                 text: Text('下料'),
              //                                 onPressed: () {
              //                                   print('下料');
              //                                 }),
              //                             const MenuFlyoutSeparator(),
              //                             MenuFlyoutSubItem(
              //                                 text: Text('下料'),
              //                                 items: (context) {
              //                                   return [
              //                                     MenuFlyoutItem(
              //                                         text: Text('接驳站1'),
              //                                         onPressed: () {
              //                                           print('接驳站1');
              //                                         }),
              //                                     MenuFlyoutItem(
              //                                         text: Text('接驳站2'),
              //                                         onPressed: () {
              //                                           print('接驳站2');
              //                                         }),
              //                                   ];
              //                                 }),
              //                           ],
              //                         );
              //                       },
              //                       position: position);
              //                 },
              //               ));
              //         },
              //         childCount: shelfList
              //             .value[currentShelfIndex.value]['shelves'].length,
              //       ),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 14,
              //           crossAxisSpacing: 10.r,
              //           mainAxisSpacing: 10.r))
              // ]),
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var shelfShelvesInfo = useShelvesData();
    final scrollController = useScrollController();
    return Container(
      key: _pageKey,
      padding: EdgeInsets.all(20.r),
      child: Column(children: [
        Expanded(child: shelfShelvesInfo),
        10.verticalSpacingRadius,
        Expanded(
            child: Row(
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              GoodsState.findByStatus(4)!.color,
                                        ),
                                      ),
                                      // padding: EdgeInsets.all(10.r),
                                    ),
                                    10.verticalSpacingRadius,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Button(
                                            child: Text('绑定物料'),
                                            onPressed: () {}),
                                        5.horizontalSpaceRadius,
                                        FilledButton(
                                            child: Text('上料'), onPressed: () {})
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InfoLabel(
                                          label: '工件编号',
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 40.sp),
                                            child: Text('123'),
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.yellow.darkest),
                                        ),
                                        InfoLabel(
                                          label: '当前工步',
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 40.sp),
                                            child: Text('123'),
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.yellow.darkest),
                                        ),
                                        InfoLabel(
                                          label: '当前工序',
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 40.sp),
                                            child: Text('123'),
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.yellow.darkest),
                                        ),
                                        InfoLabel(
                                          label: '物料信息',
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 40.sp),
                                            child: Text('123'),
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
                                    child: Text('取托盘'), onPressed: () {}),
                                10.verticalSpacingRadius,
                                FilledButton(
                                    child: Text('放托盘'), onPressed: () {})
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
        )),
        // 10.verticalSpacingRadius,
        // Container(
        //   height: 200.r,
        //   child: Row(children: [
        //     Container(
        //         width: 200.r,
        //         child: ColorBorderContentCard(
        //           child: Container(
        //             height: 150.r,
        //           ),
        //           headWidget: Container(
        //             alignment: Alignment.center,
        //             child: Text('操作')
        //                 .fontSize(20.sp)
        //                 .fontWeight(FontWeight.bold)
        //                 .textColor(Colors.white),
        //           ),
        //         )),
        //     10.horizontalSpaceRadius,
        //     Container(
        //         width: 200.r,
        //         child: ColorBorderContentCard(
        //           child: Container(
        //             height: 150.r,
        //           ),
        //           headWidget: Container(
        //             alignment: Alignment.center,
        //             child: Text('机械手操作')
        //                 .fontSize(20.sp)
        //                 .fontWeight(FontWeight.bold)
        //                 .textColor(Colors.white),
        //           ),
        //         )),
        //     10.horizontalSpaceRadius,
        //     Expanded(
        //         child: ColorBorderContentCard(
        //       child: Container(
        //         height: 150.r,
        //       ),
        //       headWidget: Container(
        //         alignment: Alignment.center,
        //         child: Text('机械手任务池')
        //             .fontSize(20.sp)
        //             .fontWeight(FontWeight.bold)
        //             .textColor(Colors.white),
        //       ),
        //     ))
        //   ]),
        // )
      ]),
    );
  }
}
