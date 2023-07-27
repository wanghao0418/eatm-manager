/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 10:21:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 18:46:25
 * @FilePath: /flutter-mesui/lib/pages/tool_management/standard_tool_management/controller.dart
 */
import 'package:eatm_manager/common/api/tool_management/standard_tool_management_api.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'widgets/update_tool_form.dart';

class StandardToolManagementController extends GetxController {
  StandardToolManagementController();
  TextEditingController toolNameController = TextEditingController();
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> rows = [];
  final List<StandardToolData> dataList = [];

  get currentUser => UserStore.instance.getCurrentUserInfo().nickName;

  query() async {
    ResponseApiBody res = await StandardToolManagementApi.query({
      "params": {
        "toolName": toolNameController.text,
      }
    });
    if (res.success == true) {
      dataList.clear();
      dataList.addAll(
          (res.data as List).map((e) => StandardToolData.fromJson(e)).toList());
      updateTableRows();
    }

    // dataList.clear();
    // dataList.addAll(List.generate(
    //     100,
    //     (index) => StandardToolData(
    //           id: index.toString(),
    //           number: (index + 1).toString(),
    //           toolName: '刀具名称$index',
    //           ratedLife: '1000',
    //           createTime: '2021-07-06 10:21:53',
    //           creator: 'admin',
    //           editor: 'admin',
    //           editTime: '2021-07-06 10:21:53',
    //         )));
    // updateTableRows();
  }

  updateTableRows() {
    rows.clear();
    for (var e in dataList) {
      var index = dataList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          "id": PlutoCell(value: e.id),
          'number': PlutoCell(value: index + 1),
          'toolName': PlutoCell(value: e.toolName),
          'ratedLife': PlutoCell(value: e.ratedLife),
          'createTime': PlutoCell(value: e.createTime),
          'creator': PlutoCell(value: e.creator),
          'editor': PlutoCell(value: e.editor),
          'editTime': PlutoCell(value: e.editTime)
        })
      ]);
    }
    _initData();
  }

  updateTool(id, ToolInfo info, BuildContext context) async {
    ResponseApiBody res = await StandardToolManagementApi.update({
      "params": {
        "id": id,
        "toolName": info.toolName,
        "ratedLife": info.ratedLife,
        "editor": currentUser,
      }
    });
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["standard_tool_management"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class StandardToolData {
  String? id;
  String? number;
  String? toolName;
  String? ratedLife;
  String? createTime;
  String? creator;
  String? editor;
  String? editTime;

  StandardToolData(
      {this.id,
      this.number,
      this.toolName,
      this.ratedLife,
      this.createTime,
      this.creator,
      this.editor,
      this.editTime});

  StandardToolData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    toolName = json['toolName'];
    ratedLife = json['ratedLife'];
    createTime = json['createTime'];
    creator = json['creator'];
    editor = json['editor'];
    editTime = json['editTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['toolName'] = this.toolName;
    data['ratedLife'] = this.ratedLife;
    data['createTime'] = this.createTime;
    data['creator'] = this.creator;
    data['editor'] = this.editor;
    data['editTime'] = this.editTime;
    return data;
  }
}
