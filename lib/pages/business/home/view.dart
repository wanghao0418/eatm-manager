/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 10:37:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 10:45:08
 * @FilePath: /eatm_manager/lib/pages/business/home/view.dart
 * @Description: 首页视图层
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/router.dart';
import 'package:eatm_manager/pages/business/home/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _HomeViewGetX();
  }
}

class _HomeViewGetX extends GetView<HomeController> {
  const _HomeViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 用户信息
  Widget _buildUserInfo() {
    UserInfo user = UserStore.instance.getCurrentUserInfo();

    // 头像
    Widget avatar = Container(
      width: 50.r,
      height: 50.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/user/default_avatar.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );

    // 昵称
    Widget nickName = ThemedText(
      '${user.nickName}，${controller.isMorning ? '上午' : '下午'}好！',
      style: TextStyle(fontSize: 20.sp, color: const Color(0xff666666)),
    );
    var now = DateTime.now();
    var dateStr = DateFormat('yyyy/MM/dd').format(now);

    // 日期
    Widget date = ThemedText(
      dateStr,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xff999999)),
    );

    String weekdayName = DateFormat('EEEE', 'zh_CN').format(now);

    // 星期
    Widget weekday = ThemedText(
      weekdayName,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xff999999)),
    );

    return Container(
      padding: globalTheme.contentPadding,
      child: Row(
        children: [
          Expanded(
              child: Wrap(
            spacing: 10.r,
            runSpacing: 10.r,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [avatar, nickName, date, weekday],
          ))
        ],
      ),
    );
  }

  // 线体状态
  Widget _buildLineBodyStatus() {
    return Container(
      decoration: globalTheme.contentDecoration,
      height: 200.h,
      child: TitleCard(
        title: '线体概况',
        headPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 5.r),
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        titleRight: Row(
          children: [
            ThemedText(
              '平均稼动率 ${controller.averageUtilizationRate}%',
              style: TextStyle(fontSize: 14),
            ),
            5.r.horizontalSpace,
            IconButton(
                icon: Icon(
                  FluentIcons.go_to_dashboard,
                  size: 16,
                  color: globalTheme.buttonIconColor,
                ),
                onPressed: () => RouterUtils.jumpToChildPage('/dataBoard'))
          ],
        ),
        containChild: Container(
          padding: globalTheme.contentPadding,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: controller.macRunDataList.map((e) {
                var status = MachineState.getStatus(e.machineState ?? -1);
                bool isLast = e == controller.macRunDataList.last;
                return Container(
                  width: 200.r,
                  margin: isLast ? null : EdgeInsets.only(right: 10.r),
                  child: TitleCard(
                      cardBackgroundColor: globalTheme.isDarkMode
                          ? Color(0xff181818)
                          : Color.fromARGB(188, 236, 236, 247),
                      headBorderColor: Colors.transparent,
                      headPadding:
                          EdgeInsets.symmetric(horizontal: 5.r, vertical: 5.r),
                      title: e.machineSn ?? '',
                      titleRight: Card(
                          padding: EdgeInsets.all(5.r),
                          backgroundColor: status?.color ?? Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                status!.icon,
                                size: 18.r,
                              ),
                              10.horizontalSpaceRadius,
                              Text(status.label)
                                  .fontSize(14.sp)
                                  .fontWeight(FontWeight.bold),
                            ],
                          )),
                      containChild: Padding(
                        padding: globalTheme.contentPadding,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxHeight,
                              child: Stack(children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ProgressRing(
                                    strokeWidth: 6.r,
                                    value: double.tryParse(
                                        e.utilizationRate ?? '0'),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ThemedText(
                                      '${e.utilizationRate ?? '0'}%',
                                      style: TextStyle(fontSize: 14.r),
                                    ),
                                  ),
                                )
                              ]),
                            );
                          },
                        ),
                      )),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // 今日任务数
  Widget _buildTodayTaskNum() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '今日任务',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(),
      ),
    );
  }

  // 累计任务数
  Widget _buildGrandTaskTotal() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '累计任务',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(),
      ),
    );
  }

  // 加工任务
  Widget _buildProcessTask() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '任务看板',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(),
      ),
    );
  }

  // 消息中心
  Widget _buildMessageCenter() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '消息中心',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(),
      ),
    );
  }

  // 快捷入口
  Widget _buildQuickEntry() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '快捷入口',
        headPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        titleRight: IconButton(
          icon: Icon(
            FluentIcons.settings,
            size: 16,
            color: globalTheme.buttonIconColor,
          ),
          onPressed: () {},
        ),
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(),
      ),
    );
  }

  // 最近访问
  Widget _buildRecentVisit() {
    return Container(
        decoration: globalTheme.contentDecoration,
        child: TitleCard(
          title: '最近访问',
          headPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          titleRight: IconButton(
            icon: Icon(
              FluentIcons.delete,
              size: 16,
              color: globalTheme.buttonIconColor,
            ),
            onPressed: () {
              PopupMessage.showConfirmDialog(
                  title: '确认', message: '确定清除所有访问记录么？', onConfirm: () {});
            },
          ),
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: Container(),
        ));
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildUserInfo(),
          globalTheme.contentDistance.verticalSpace,
          _buildLineBodyStatus(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(child: _buildTodayTaskNum()),
                      globalTheme.contentDistance.horizontalSpace,
                      Expanded(child: _buildGrandTaskTotal()),
                      globalTheme.contentDistance.horizontalSpace,
                      Expanded(child: _buildMessageCenter())
                    ],
                  )),
                  globalTheme.contentDistance.verticalSpace,
                  Expanded(flex: 2, child: _buildProcessTask()),
                ],
              )),
              globalTheme.contentDistance.horizontalSpace,
              SizedBox(
                width: 400.0.r,
                child: Column(children: [
                  SizedBox(
                    height: 300.0.r,
                    child: _buildQuickEntry(),
                  ),
                  globalTheme.contentDistance.verticalSpace,
                  Expanded(child: _buildRecentVisit())
                ]),
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
