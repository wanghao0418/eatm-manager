/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-28 17:53:09
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-12 19:10:22
 * @FilePath: /eatm_manager/lib/common/api/tool_management/externalToolMagazine_api.dart
 * @Description: 机外刀库接口
 */
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/http.dart';

class ExternalToolMagazineApi {
  static get isMock => ConfigStore.instance.openMock ?? false;

  // 机外刀库货架信息
  static Future<ResponseApiBody> getMachineOutToolBaseInfo() {
    return HttpUtil.post('/Eatm/MachineOutToolBaseInfo', data: {});
  }

  // 机外刀库数据录入
  static Future<ResponseApiBody> machineOutToolInput(data) {
    return HttpUtil.post('/Eatm/MachineOutToolInput', data: data);
  }

  // 机外刀库查询
  static Future<ResponseApiBody> getMachineOutToolQuery(data) {
    return HttpUtil.post('/Eatm/MachineOutToolQuery',
        data: data, isMock: isMock);
  }

  // 机外刀库删除
  static Future<ResponseApiBody> machineOutToolDelete(data) {
    return HttpUtil.post('/Eatm/MachineOutTool/delete',
        data: data, isMock: isMock);
  }

  // 机外刀库修改
  static Future<ResponseApiBody> machineOutToolUpdate(data) {
    return HttpUtil.post('/Eatm/MachineOutTool/update',
        data: data, isMock: isMock);
  }
}
