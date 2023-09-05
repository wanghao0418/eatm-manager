/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 10:02:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-04 14:30:15
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/controller.dart
 * @Description: 多电极绑定视图层
 */
import 'dart:convert';

import 'package:eatm_manager/common/api/work_process_binding_api.dart';
import 'package:eatm_manager/common/models/workProcess.dart';
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/electrode_binding/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ElectrodeBindingController extends GetxController {
  ElectrodeBindingController();

  // 当前选中索引
  int? currentIndex;

  // WebSocket
  WebSocketUtility? webSocketUtility;
  List<ChipBindData> allChipBindData = [];
  List<ChipBindData> chipBindDataList = [];
  TextEditingController barcodeController = TextEditingController();

  // 夹具信息
  final Map<String, ChipBindData?> chipBindDataMap = {
    "G55": null,
    "G56": null,
    "G57": null,
    "G58": null
  };

  get currentClipKey => chipBindDataMap.keys.toList()[currentIndex!];

  set bindData(val) => chipBindDataMap[currentClipKey] = val;

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.chipBindingWebsocketUrl;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {
          LogUtil.t('WebSocket连接成功');
        },
        onMessage: (data) {
          LogUtil.t('WebSocket接收到消息：$data');
          var json = jsonDecode(data);
          // var schedulingData = MacSchedulingData.fromJson(json);
          // machineSchedulingInfoList = schedulingData.deviceResources ?? [];
          _initData();
        },
        onError: (e) {
          LogUtil.f('WebSocket连接发生错误：$e');
          if (e.toString().contains('Connection refused') ||
              e.toString().contains('connection failed')) {
            readLocalData();
          }
        },
        onClose: () {
          LogUtil.f('WebSocket连接关闭：');
        });
    webSocketUtility!.connect();
  }

  // 读取本地数据
  void readLocalData() async {
    var str =
        await rootBundle.loadString('assets/json/test_chip_binding_json.json');
    var json = jsonDecode(str);
    allChipBindData = (json['chipBindStl'] as List)
        .map((e) => ChipBindData.fromMap(e))
        .toList();
    chipBindDataList = allChipBindData;
    _initData();
  }

  // 初始化夹位
  void initClipMap() {
    chipBindDataMap.forEach((key, val) {
      chipBindDataMap[key] = null;
    });
  }

  // 查询
  void query() async {
    WorkProcessSearch search = WorkProcessSearch(
        barcode: barcodeController.text,
        querySource: 0,
        isSelect: true,
        workpiecetype: 2);
    PopupMessage.showLoading();
    var res = await WorkProcessBindingApi.query({"paramse": search.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      allChipBindData = (res.data as List)
          .map((e) => WorkProcessData.fromJson(e))
          .map((e) => ChipBindData(
              nAction: 0,
              nCurLocationId: 0,
              nFasciaId: 0,
              strChipFascia: e.barCode,
              strElectrodeNo: e.sn,
              strSpecifications: e.spec,
              strTextureMaterial: e.workpieceType,
              strPresetHeight: '',
              strFixture: '',
              strX: e.offsetX?.toString() ?? '',
              strY: e.offsetY?.toString() ?? '',
              strZ: e.offsetZ?.toString() ?? '',
              strChipClampId: e.barCode,
              nIsOk: 1))
          .toList();
      chipBindDataList = allChipBindData;
      clearData();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 清除数据
  void clearData() {
    allChipBindData.clear();
    chipBindDataList.clear();
    initClipMap();
    _initData();
  }

  // 解除绑定
  void unbind() async {
    if (barcodeController.text.isEmpty) {
      PopupMessage.showWarningInfoBar('芯片号不能为空');
      return;
    } else if (allChipBindData.isEmpty) {
      PopupMessage.showWarningInfoBar('产品芯片号需要查询到最少一个对应数据');
      return;
    } else {
      // 发送消息
      var message = chipBindDataList
          .map((e) => {
                "strBarcode": e.strChipFascia,
                "strElectrodeNo": e.strElectrodeNo
              })
          .toList()
          .toString();

      var send = {
        'module': "ADD_DATA",
        'message1': '1002',
        'message2': message
      };
      LogUtil.t(send);
      webSocketUtility?.sendMessage(send.toString());
    }
  }

  // 一键绑定
  void bind() {
    if (allChipBindData.isEmpty) {
      PopupMessage.showWarningInfoBar('产品芯片号需要查询到最少一个对应数据');
      return;
    } else if (chipBindDataMap.values.length < allChipBindData.length &&
        chipBindDataMap.values.where((element) => element != null).length <
            chipBindDataMap.length) {
      PopupMessage.showWarningInfoBar('绑定的数据小于需要绑定的数据,请操作完成界面坐标系的选择');
      return;
    } else {
      var bindList =
          chipBindDataMap.entries.where((element) => element.value != null);
      if (bindList.isEmpty) {
        return;
      }
      // 发送消息
      var message = bindList
          .map((e) => {
                "strBarcode": e.value!.strChipFascia,
                "strElectrodeNo": e.value!.strElectrodeNo,
                "strStlCoordinateSystem": e.key
              })
          .toList()
          .toString();

      var send = {
        'module': "ADD_DATA",
        'message1': '1003',
        'message2': message
      };
      LogUtil.t(send);
      webSocketUtility?.sendMessage(send.toString());
    }
  }

  // 显示绑定
  void showBind() {
    if (barcodeController.text.isEmpty) {
      PopupMessage.showWarningInfoBar("芯片号不能为空!");
      return;
    }
    if (allChipBindData.isEmpty) {
      PopupMessage.showWarningInfoBar("产品芯片号需要查询到最少一个对应数据!");
      return;
    }

    var message = allChipBindData
        .map((e) =>
            {"strBarcode": e.strChipFascia, "strElectrodeNo": e.strElectrodeNo})
        .join(',');
    var send = {'module': "ADD_DATA", 'message1': '1001', 'message2': message};
    LogUtil.t(send);
    webSocketUtility?.sendMessage(send.toString());
  }

  _initData() {
    update(["electrode_binding"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    initWebSocket();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
