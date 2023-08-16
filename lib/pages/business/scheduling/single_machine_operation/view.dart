/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 10:59:00
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-16 14:37:37
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/view.dart
 * @Description:  单机负荷视图层
 */
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/widgets/time_now.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class SingleMachineOperationPage extends StatefulWidget {
  const SingleMachineOperationPage({Key? key}) : super(key: key);

  @override
  State<SingleMachineOperationPage> createState() =>
      _SingleMachineOperationPageState();
}

class _SingleMachineOperationPageState extends State<SingleMachineOperationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SingleMachineOperationViewGetX();
  }
}

class _SingleMachineOperationViewGetX
    extends GetView<SingleMachineOperationController> {
  const _SingleMachineOperationViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 机床信息
  Widget _buildMacInfo() {
    return Expanded(
        flex: 9,
        child: TitleCard(
            title: "机床信息",
            cardBackgroundColor: const Color(0xffd9ecff),
            headBorderColor: Colors.white,
            headTextColor: globalTheme.buttonIconColor,
            titleRight: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: Color(0xfffef0f0),
              ),
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
              child: Text(
                '', // _nCount == 0 ? '' : currentMachine!.curStatus.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            containChild: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '',
                                    // _nCount == 0
                                    //     ? ''
                                    //     : currentMachine!.deviceName.toString(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff333333)),
                                  ),
                                  const TimeNow()
                                ],
                              )),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    '今日在线时长',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff606266),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    // _nCount == 0
                                    //     ? ''
                                    //     : currentMachine!.todayOnlineTimes
                                    //         .toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff606266),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              )),
                          Container(
                              child: Column(
                            children: [
                              const Text(
                                '累计运行时长',
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff606266),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '',
                                // _nCount == 0
                                //     ? ''
                                //     : currentMachine!.allRunTimes.toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff606266),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          )),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    '设备系统类型',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff606266),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    // _nCount == 0
                                    //     ? ''
                                    //     : currentMachine!.systemType.toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff606266),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              )),
                          SizedBox(
                              child: Column(
                            children: [
                              const Text(
                                '设备工艺限制',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff606266),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '',
                                // _nCount == 0
                                //     ? ''
                                //     : currentMachine!.chuckCraftLimit
                                //         .toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff606266),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          )),
                        ],
                      ))
                ],
              ),
            )));
  }

  // 主视图
  Widget _buildView() {
    return Container(
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: globalTheme.contentDecoration,
              child: Row(
                children: [_buildMacInfo()],
              ),
            ),
            globalTheme.contentDistance.verticalSpace,
            Expanded(
                child: Row(
              children: [
                Container(
                  width: 200,
                  decoration: globalTheme.contentDecoration,
                ),
                globalTheme.contentDistance.horizontalSpace,
                Expanded(
                    child: Container(
                  decoration: globalTheme.contentDecoration,
                )),
              ],
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleMachineOperationController>(
      init: SingleMachineOperationController(),
      id: "single_machine_operation",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
