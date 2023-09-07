/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-05 14:35:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 17:23:12
 * @FilePath: /eatm_manager/lib/pages/business/user_management/controller.dart
 * @Description: 用户管理逻辑层
 */
import 'package:eatm_manager/common/api/user_info_api.dart';
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

class UserManagementController extends GetxController {
  UserManagementController();
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  List<UserInfo> userInfoList = [];
  TextEditingController userNameController = TextEditingController();

  int? selectedRowIndex;

  _initData() {
    update(["user_management"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // 查询
  void query() async {
    var res = await UserInfoApi.query({
      'page': {'current': 1, 'pages': 1, 'size': 10},
      'params': {"userName": userNameController.text}
    });
    if (res.success!) {
      userInfoList = (res.data['records'] as List)
          .map((e) => UserInfo.fromMap(e))
          .toList();
      updateRows();
    }
  }

  // 更新表格
  updateRows() {
    rows.clear();
    for (var user in userInfoList) {
      var index = userInfoList.indexOf(user);
      var row = PlutoRow(cells: {
        'index': PlutoCell(value: index),
        'id': PlutoCell(value: user.id),
        'userName': PlutoCell(value: user.userName),
        'userId': PlutoCell(value: user.userId),
        'password': PlutoCell(value: user.nickName),
        'createTime': PlutoCell(value: user.createTime),
        'updateTime': PlutoCell(value: user.updateTime),
        'data': PlutoCell(value: user),
      });
      stateManager.appendRows([row]);
    }
    _initData();
  }

  // 更新
  void updateUser(UserInfo info) async {
    var time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    if (info.createTime == null) {
      info.createTime = time;
      info.updateTime = time;
    } else {
      info.updateTime = time;
    }
    var res = await UserInfoApi.update(info.toMap());
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void deleteUser(List<UserInfo> userList) async {
    List<String?> names = userList.map((e) => e.userName).toList();
    var res = await UserInfoApi.delete(names);
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

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
