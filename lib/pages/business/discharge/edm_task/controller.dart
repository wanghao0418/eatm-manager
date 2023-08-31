/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-30 10:32:45
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 14:04:48
 * @FilePath: /eatm_manager/lib/pages/business/discharge/edm_task/controller.dart
 * @Description: EDM任务逻辑层
 */
import 'package:eatm_manager/common/api/discharge_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/store/user.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/discharge/edm_task/enum.dart';
import 'package:eatm_manager/pages/business/discharge/edm_task/model.dart';
import 'package:eatm_manager/pages/business/discharge/programming/model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

class EdmTaskController extends GetxController {
  EdmTaskController();

  // 任务信息
  List taskDataList = [];
  late Box edmTaskBox;
  late Box edmInfoBox;

  // 机台任务信息
  List<EdmTaskFixtureData> taskFixtureList = [];

  // 机台编号列表
  List<String> fixtureTypeList = [];

  // 夹具类型集合
  Map<String, Map<String, dynamic>> fixtureTypeMap = {};

  // 任务状态下拉选项
  List<SelectOption> get taskStateOptions => [
        SelectOption(label: '初始状态', value: 'HANBA'),
        SelectOption(label: '加工中', value: 'ZESSI')
      ];

  // 当前任务状态
  String? currentTaskState = 'HANBA';

  // 任务表格
  late PlutoGridStateManager taskManager;
  List<PlutoRow> taskRows = [];

  // 信息表格
  late PlutoGridStateManager infoManager;
  List<PlutoRow> infoRows = [];

  // 当前选中机床名称
  String? currentName;

  // 选中任务行索引
  int? selectedTaskRowIndex;

  _initData() {
    update(["edm_task"]);
  }

  // 本地数据库中读取数据
  void initStoreData() async {
    edmTaskBox = await Hive.openBox('edmTask');
    edmInfoBox = await Hive.openBox('edmInfo');

    taskDataList = edmTaskBox.values.toList();
    fixtureTypeList =
        taskDataList.map((e) => e['fixtureType'] as String).toSet().toList();
    for (var fixture in fixtureTypeList) {
      fixtureTypeMap[fixture] = {'taskId': 0, 'taskState': '初始状态'};
    }
    taskFixtureList = taskDataList.map((e) {
      // var fixture = e['fixtureType'];
      // if (e['TaskState'] != '初始状态') {
      //   fixtureTypeMap[fixture]!['taskState'] = e['TaskState'];
      //   fixtureTypeMap[fixture]!['taskId'] = e['EdmTaskId'];
      // }

      return EdmTaskFixtureData(
          edmTaskId: e['EdmTaskId'],
          taskState: e['TaskState'],
          fixture: e['fixtureType']);
    }).toList();
    updateTaskTableRows();
    _initData();
  }

  // 机床任务选中事件
  onMacTaskSelect(String name) {
    if (currentName == name) {
      currentName = null;
      updateTaskTableRows();
      return;
    }
    currentName = name;
    updateTaskTableRows();
  }

  // 更新任务表格
  updateTaskTableRows() {
    taskRows.clear();
    infoRows.clear();
    selectedTaskRowIndex = null;
    var dataList = taskDataList;
    if (currentName != null) {
      dataList = taskDataList
          .where((data) => data['fixtureType'] == currentName)
          .toList();
    }
    for (var rowData in dataList) {
      var index = dataList.indexOf(rowData);
      var row = PlutoRow(cells: {
        'isChecked': PlutoCell(value: false),
        'index': PlutoCell(value: index + 1),
        'edmTaskId': PlutoCell(value: rowData['EdmTaskId'] ?? ''),
        'taskState': PlutoCell(value: rowData['TaskState'] ?? ''),
        'createTime': PlutoCell(value: rowData['CreateTime'] ?? ''),
        'creator': PlutoCell(value: rowData['CreateAuther'] ?? ''),
        'stateChangeTime': PlutoCell(value: rowData['StateChangeTime'] ?? ''),
        'stateChanger': PlutoCell(value: rowData['StateChangeAuther'] ?? ''),
        'steelMouldSN': PlutoCell(value: rowData['SteelMOULDSN'] ?? ''),
        'data': PlutoCell(value: rowData),
        'fixtureType': PlutoCell(value: rowData['fixtureType'] ?? '')
      });
      taskManager.appendRows([row]);
    }
    _initData();
  }

  // 读取取选中任务信息 更新下方表格
  loadInfoData(int id) {
    List infoData = edmInfoBox.get(id) ?? [];
    infoRows.clear();
    for (var rowData in infoData) {
      var row = PlutoRow(cells: {
        'elecMouldSN': PlutoCell(value: rowData['ElecMOULDSN']),
        'elecPartSN': PlutoCell(value: rowData['ElecPARTSN']),
        'dischargeOrder': PlutoCell(value: rowData['DischargeOrder']),
        'curState': PlutoCell(value: rowData['CurState']),
        'stateChangeAuthor': PlutoCell(value: rowData['StateChangeAuthor']),
        'startTime': PlutoCell(value: rowData['StartTime']),
        'endTime': PlutoCell(value: rowData['EndTime']),
      });
      infoManager.appendRows([row]);
    }

    _initData();
  }

  // 修改任务状态
  void updateTaskState(EdmTaskState state) {
    if (taskManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择任务');
      return;
    }
    PlutoRow row = taskManager.checkedRows.first;
    var data = row.cells['data']!.value;
    int dataIndex = taskDataList
        .indexWhere((element) => element['EdmTaskId'] == data['EdmTaskId']);
    Map taskData = taskDataList[dataIndex];
    taskData['TaskState'] = state.label;
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    taskData['StateChangeTime'] = '${formatter.format(DateTime.now())}';
    taskData['StateChangeAuther'] =
        UserStore.instance.getCurrentUserInfo().nickName;
    data['TaskState'] = state.label;
    data['StateChangeTime'] = '${formatter.format(DateTime.now())}';
    data['stateChangeAuthor'] =
        UserStore.instance.getCurrentUserInfo().nickName;
    row.cells['taskState']!.value = state.label;
    row.cells['stateChangeTime']!.value = '${formatter.format(DateTime.now())}';
    row.cells['stateChanger']!.value =
        UserStore.instance.getCurrentUserInfo().nickName;
    row.cells['data']!.value = data;
    var fixture = data['fixtureType'];
    fixtureTypeMap[fixture]!['taskState'] = state.label;

    // 更新缓存
    edmTaskBox.put(dataIndex, taskData);
    // 发请求更新任务状态
    updateSteelTask(state);
    _initData();
  }

  // 更新任务状态
  void updateSteelTask(EdmTaskState state) {
    // 取出任务列表
    GetStorage taskStorage = GetStorage('edmTask');
    List taskList = taskStorage.read('edmTaskDataList') ?? [];
    List<EdmTaskData> edmTaskList =
        taskList.map((e) => EdmTaskData.fromJson(e)).toList();
    List<int?> taskIds = edmTaskList.map((e) => e.edmTaskId).toSet().toList();
    List<String?> mouldSns =
        edmTaskList.map((e) => e.steelMOULDSN).toSet().toList();
    List<String?> partSns =
        edmTaskList.map((e) => e.steelPARTSN).toSet().toList();

    if (mouldSns.isNotEmpty && partSns.isNotEmpty && taskIds.isNotEmpty) {
      DischargeApi.updateSteelEdmTask({
        "SteelMOULDSN": mouldSns.first,
        "SteelPARTSN": partSns.first,
        "EdmTaskId": taskIds.first,
        "MACHINESN": null,
        "EdmState": state.state
      });
      PopupMessage.showSuccessInfoBar('操作成功');
    }
  }

  // 删除任务
  void onDeleteTask() {
    if (taskManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择任务');
      return;
    }
    updateSteelTask(EdmTaskState.delete);
    // 更新表格
    PlutoRow row = taskManager.checkedRows.first;
    var data = row.cells['data']!.value;
    int dataIndex = taskDataList
        .indexWhere((element) => element['EdmTaskId'] == data['EdmTaskId']);
    taskDataList.removeAt(dataIndex);
    taskManager.removeRows([row]);
    var fixture = data['fixtureType'];
    fixtureTypeMap[fixture]!['taskId'] = 0;
    fixtureTypeMap[fixture]!['taskState'] = '初始状态';

    // 更新缓存
    edmTaskBox.deleteAt(dataIndex);
    infoRows.clear();
    _initData();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    initStoreData();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
