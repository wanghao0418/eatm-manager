import 'package:eatm_manager/common/routers/names.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../pages/business/ceshi/ceshi.dart';
import '../../pages/business/work_station/index.dart' deferred as workStation;
import '../../pages/business/auto_running/index.dart' deferred as autoRunning;
import '../../pages/business/warehouse_management/shelf_management/index.dart'
    deferred as shelfManagement;
import '../../pages/index.dart';
import '../middlewares/index.dart';
import '../style/icons.dart';
import '../widgets/deferred_widget.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.systemLogin,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteNames.systemMain,
      page: () => const MainPage(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
  ];
}

class MainChildPage {
  String? url;
  IconData? icon;
  Widget? page;

  MainChildPage({this.url, this.page, this.icon});

  MainChildPage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    icon = json['icon'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['page'] = page;
    data['icon'] = icon;
    return data;
  }
}

class MainChildPages {
  static List<MainChildPage> list = [
    MainChildPage(url: '/dashboard', page: Ceshi(), icon: MyIcons.workmanship),
    MainChildPage(
        url: '/workStation',
        page: DeferredWidget(
            workStation.loadLibrary, () => workStation.WorkStationPage()),
        icon: MyIcons.kanBan),
    MainChildPage(
        url: '/userInfoList',
        page: Center(child: Text('用户管理')),
        icon: MyIcons.userManage),
    MainChildPage(
        url: '/menuList',
        page: Center(child: Text('菜单管理')),
        icon: MyIcons.menuManage),
    MainChildPage(
        url: '/productCard',
        page: Center(child: Text('生产监控')),
        icon: MyIcons.productionMonitoring),
    MainChildPage(
        url: '/discharge',
        page: Center(child: Text('程式编程')),
        icon: MyIcons.programming),
    MainChildPage(
        url: '/EDMTask',
        page: Center(child: Text('EDM任务')),
        icon: MyIcons.task),
    MainChildPage(
        url: '/gantchart',
        page: Center(child: Text('计划甘特图')),
        icon: MyIcons.ganttChart),
    MainChildPage(
        url: '/AutoRunView',
        page: DeferredWidget(
            autoRunning.loadLibrary, () => autoRunning.AutoRunningPage()),
        icon: MyIcons.runManage),
    MainChildPage(
        url: '/MachineManagement',
        page: Center(child: Text('机床管理')),
        icon: MyIcons.machineTool),
    MainChildPage(
        url: '/ToolWarehousing',
        page: Center(child: Text('刀具出入库')),
        icon: MyIcons.tool),
    MainChildPage(
        url: '/ReceiptIssueRecord',
        page: Center(child: Text('出入库记录')),
        icon: MyIcons.record),
    MainChildPage(
        url: '/EquipmentMagazine',
        page: Center(child: Text('设备刀库')),
        icon: MyIcons.tool),
    MainChildPage(
        url: '/OtherEquipment',
        page: Center(child: Text('其他设备')),
        icon: MyIcons.equipment),
    MainChildPage(
        url: '/Workpiece',
        page: Center(child: Text('工件')),
        icon: MyIcons.spareParts),
    MainChildPage(
        url: '/Equipment',
        page: Center(child: Text('设备')),
        icon: MyIcons.equipment),
    MainChildPage(
        url: '/LogQuery',
        page: Center(child: Text('日志查询')),
        icon: MyIcons.logQuery),
    MainChildPage(
        url: '/robotView',
        page: Center(child: Text('机器人')),
        icon: MyIcons.robot),
    MainChildPage(
        url: '/ChipBinding',
        page: Center(child: Text('多电极绑定')),
        icon: MyIcons.binding),
    MainChildPage(
        url: '/EquipmentStatus',
        page: Center(child: Text('设备状态')),
        icon: MyIcons.equipmentManage),
    MainChildPage(
        url: '/MachineKanBan',
        page: Center(child: Text('单机负荷')),
        icon: MyIcons.loadControl),
    MainChildPage(
        url: '/DataEntry',
        page: Center(child: Text('数据录入')),
        icon: MyIcons.dataEntry),
    MainChildPage(
        url: '/AutomaticHandling',
        page: Center(child: Text('自动化搬运')),
        icon: MyIcons.carry),
    MainChildPage(
        url: '/EquipmentOperationStatistics',
        page: Center(child: Text('设备运行统计')),
        icon: MyIcons.operationStatistics),
    MainChildPage(
        url: '/TodoToday',
        page: Center(child: Text('今日待办')),
        icon: MyIcons.todo),
    MainChildPage(
        url: '/TaskCreation',
        page: Center(child: Text('任务创建')),
        icon: MyIcons.taskPlan),
    MainChildPage(
        url: '/MaintenanceManagement',
        page: Center(child: Text('维保设置')),
        icon: MyIcons.maintenance),
    MainChildPage(
        url: '/ExternalToolMagazine',
        page: Center(child: Text('机外刀库')),
        icon: MyIcons.tool),
    MainChildPage(
        url: '/AllMachine',
        page: Center(child: Text('多机负荷')),
        icon: MyIcons.loadAnalysis),
    MainChildPage(
        url: '/projectOverview',
        page: Center(child: Text('项目运行统计')),
        icon: MyIcons.operationStatistics),
    MainChildPage(
        url: '/taskQuery',
        page: Center(child: Text('任务查询')),
        icon: FluentIcons.search),
    MainChildPage(
        url: '/dataBoard',
        page: Center(child: Text('大屏看板')),
        icon: MyIcons.kanBan),
    MainChildPage(
        url: '/BindMachine',
        page: Center(child: Text('机床选择')),
        icon: MyIcons.machineTool),
    MainChildPage(
        url: '/taskHistoryQuery',
        page: Center(child: Text('历史查询')),
        icon: FluentIcons.history),
    MainChildPage(
        url: '/ChipBindingStl',
        page: Center(child: Text('多钢件绑定')),
        icon: MyIcons.binding),
    MainChildPage(
        url: '/shelfManagement',
        page: DeferredWidget(shelfManagement.loadLibrary,
            () => shelfManagement.ShelfManagementPage()),
        icon: FluentIcons.guid),
  ];

  static Widget getPage(String url) {
    var page = list.firstWhereOrNull((element) => element.url == url);
    return page?.page ?? Container();
  }

  static IconData getIcon(String url) {
    var page = list.firstWhereOrNull((element) => element.url == url);
    return page?.icon ?? FluentIcons.home;
  }
}
