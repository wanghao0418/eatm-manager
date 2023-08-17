import 'package:eatm_manager/common/routers/names.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../pages/business/work_station/index.dart' deferred as work_station;
import '../../pages/business/auto_running/index.dart' deferred as auto_running;
import '../../pages/business/tool_management/standard_tool_management/index.dart'
    deferred as standard_tool_management;
import '../../pages/business/tool_management/mac_tool_magazine_management/index.dart'
    deferred as mac_tool_magazine_management;
import '../../pages/business/tool_management/tool_magazine_outside_mac/index.dart'
    deferred as tool_magazine_outside_mac;
import '../../pages/business/warehouse_management/inventory_management/index.dart'
    deferred as shelf_management;
import '../../pages/business/warehouse_management/exit_storage_records/index.dart'
    deferred as storage_records;
import '../../pages/business/warehouse_management/task_management/index.dart'
    deferred as task_management;
import '../../pages/business/task_query/index.dart' deferred as task_query;
import '../../pages/business/machine_binding/index.dart'
    deferred as machine_binding;
import '../../pages/business/craft_binding/index.dart'
    deferred as craft_binding;
import '../../pages/business/scheduling/single_machine_operation/index.dart'
    deferred as single_machine_operation;
import '../../pages/business/reporting/index.dart' deferred as reporting;
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
    // 工艺绑定
    MainChildPage(
        url: '/dashboard',
        page: DeferredWidget(
            craft_binding.loadLibrary, () => craft_binding.CraftBindingPage()),
        icon: MyIcons.workmanship),
    // 接驳站管理
    MainChildPage(
        url: '/workStation',
        page: DeferredWidget(
            work_station.loadLibrary, () => work_station.WorkStationPage()),
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
            auto_running.loadLibrary, () => auto_running.AutoRunningPage()),
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
        page: DeferredWidget(single_machine_operation.loadLibrary,
            () => single_machine_operation.SingleMachineOperationPage()),
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
        url: '/AllMachine',
        page: Center(child: Text('多机负荷')),
        icon: MyIcons.loadAnalysis),
    MainChildPage(
        url: '/projectOverview',
        page: Center(child: Text('项目运行统计')),
        icon: MyIcons.operationStatistics),
    MainChildPage(
        url: '/taskQuery',
        page: DeferredWidget(
            task_query.loadLibrary, () => task_query.TaskQueryPage()),
        icon: FluentIcons.search),
    MainChildPage(
        url: '/dataBoard',
        page: Center(child: Text('大屏看板')),
        icon: MyIcons.kanBan),
    MainChildPage(
        url: '/BindMachine',
        page: DeferredWidget(machine_binding.loadLibrary,
            () => machine_binding.MachineBindingPage()),
        icon: MyIcons.machineTool),
    MainChildPage(
        url: '/taskHistoryQuery',
        page: Center(child: Text('历史查询')),
        icon: FluentIcons.history),
    MainChildPage(
        url: '/ChipBindingStl',
        page: Center(child: Text('多钢件绑定')),
        icon: MyIcons.binding),
    //标准刀具管理
    MainChildPage(
        url: '/standardToolManagement',
        page: DeferredWidget(standard_tool_management.loadLibrary,
            () => standard_tool_management.StandardToolManagementPage()),
        icon: MyIcons.tool),
    //机床刀库管理
    MainChildPage(
        url: '/macToolMagazine',
        page: DeferredWidget(mac_tool_magazine_management.loadLibrary,
            () => mac_tool_magazine_management.MacToolMagazineManagementPage()),
        icon: MyIcons.tool),
    //机外刀库
    MainChildPage(
        url: '/toolMagazineOutsideMac',
        page: DeferredWidget(tool_magazine_outside_mac.loadLibrary,
            () => tool_magazine_outside_mac.ToolMagazineOutsideMacPage()),
        icon: MyIcons.tool),
    // 货架管理
    MainChildPage(
        url: '/inventoryManagement',
        page: DeferredWidget(shelf_management.loadLibrary,
            () => shelf_management.InventoryManagementPage()),
        icon: FluentIcons.guid),
    // 入库记录
    MainChildPage(
        url: '/storageRecords',
        page: DeferredWidget(storage_records.loadLibrary,
            () => storage_records.ExitStorageRecordsPage()),
        icon: FluentIcons.open_pane_mirrored),
    // 任务管理
    MainChildPage(
        url: '/taskManagement',
        page: DeferredWidget(task_management.loadLibrary,
            () => task_management.TaskManagementPage()),
        icon: FluentIcons.page_list_solid),
    // 报工
    MainChildPage(
        url: '/reporting',
        page: DeferredWidget(
            reporting.loadLibrary, () => reporting.ReportingPage()),
        icon: FluentIcons.report_add),
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
