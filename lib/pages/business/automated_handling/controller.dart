/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-12 09:20:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 17:21:40
 * @FilePath: /eatm_manager/lib/pages/business/automated_handling/controller.dart
 * @Description: 逻辑层
 */
import 'package:eatm_manager/common/api/automatic_handing_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/automated_handling/models.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AutomatedHandlingController extends GetxController {
  AutomatedHandlingController();
  AGVTaskDataSearch search = AGVTaskDataSearch(
    startTime: DateTime.now()
        .subtract(const Duration(days: 3))
        .toString()
        .substring(0, 10),
    endTime:
        DateTime.now().add(const Duration(days: 3)).toString().substring(0, 10),
  );
  late PlutoGridStateManager stateManager;
  List<PlutoRow> rows = [];
  List<AGVTask> agvTaskDataList = [];
  // 任务类型
  List<SelectOption> taskTypeList = [];

  // 工件类型
  List<SelectOption> workpieceTypeOptionList = [
    SelectOption(label: '电极', value: 0),
    SelectOption(label: '钢件', value: 1)
  ];
  // 特殊工件类型
  List<SelectOption> specialWorkpieceTypeOptionList = [
    SelectOption(label: '注塑', value: 99),
  ];
  // 工件状态
  List<SelectOption> workpieceStatusOptionList = [
    SelectOption(label: '待加工', value: 0),
    SelectOption(label: '加工完成', value: 1),
    SelectOption(label: '异常', value: 2)
  ];
  // 无状态
  List<SelectOption> noneStatusList = [
    SelectOption(label: '无', value: 99),
  ];

  List<SelectOption> get pieceTypeList => search.taskType != null
      ? ([2, 3].contains(search.taskType)
          ? specialWorkpieceTypeOptionList
          : workpieceTypeOptionList)
      : [];

  List<SelectOption> get pieceStatusList => search.taskType != null
      ? ([0, 2, 3].contains(search.taskType)
          ? noneStatusList
          : workpieceStatusOptionList)
      : [];

  _initData() {
    update(["automated_handling"]);
  }

  // 重置表单
  void resetForm() {
    search.clear();
    search.startTime = DateTime.now()
        .subtract(const Duration(days: 3))
        .toString()
        .substring(0, 10);
    search.endTime =
        DateTime.now().add(const Duration(days: 3)).toString().substring(0, 10);
    // search = AGVTaskDataSearch(
    //   startTime: DateTime.now()
    //       .subtract(const Duration(days: 3))
    //       .toString()
    //       .substring(0, 10),
    //   endTime: DateTime.now()
    //       .add(const Duration(days: 3))
    //       .toString()
    //       .substring(0, 10),
    // );
    LogUtil.i('重置');
    LogUtil.i(search.toMap());
    _initData();
  }

  // 获取任务类型
  void getTaskTypeList() async {
    ResponseApiBody res = await AutomaticHandlingApi.getWorkProcessTaskList();
    if (res.success == true) {
      taskTypeList = (res.data as List)
          .map((e) =>
              SelectOption(value: e['TaskType'], label: e['LoadStation']))
          .toList();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询任务
  void query() async {
    var map = search.toMap();
    if (map['WorkPieceType'] == 99) {
      map.remove('WorkPieceType');
    }
    if (map['WorkPieceState'] == 99) {
      map.remove('WorkPieceState');
    }
    ResponseApiBody res =
        await AutomaticHandlingApi.getWorkProcessTaskHistory(map);
    if (res.success == true) {
      agvTaskDataList =
          (res.data as List).map((e) => AGVTask.fromJson(e)).toList();
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 执行
  void run() async {
    bool flag = search.validate();
    if (!flag) {
      PopupMessage.showWarningInfoBar('请确认必选项后提交');
      return;
    }
    var paramsMap = search.toMap();
    paramsMap.remove('startTime');
    paramsMap.remove('endTime');
    // 去掉默认项
    if (paramsMap['WorkPieceType'] == 99) {
      paramsMap.remove('WorkPieceType');
    }
    if (paramsMap['WorkPieceState'] == 99) {
      paramsMap.remove('WorkPieceState');
    }
    ResponseApiBody res =
        await AutomaticHandlingApi.workProcessExecTask(paramsMap);
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('执行成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  void updateRows() {
    rows.clear();
    for (var task in agvTaskDataList) {
      var row = PlutoRow(cells: {
        "id": PlutoCell(value: task.id),
        "taskType": PlutoCell(value: task.taskType),
        "workpieceType": PlutoCell(value: task.workpieceType),
        "recordTime": PlutoCell(value: task.recordTime)
      });
      stateManager.appendRows([row]);
    }
    _initData();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getTaskTypeList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
