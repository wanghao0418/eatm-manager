import 'package:eatm_manager/common/utils/http.dart';

class ExternalToolMagazineApi {
  // 机外刀库货架信息
  static Future<ResponseApiBody> getMachineOutToolBaseInfo(data) {
    return HttpUtil.post('/Eatm/MachineOutToolBaseInfo', data: data);
  }

  // 机外刀库数据录入
  static Future<ResponseApiBody> machineOutToolInput(data) {
    return HttpUtil.post('/Eatm/MachineOutToolInput', data: data);
  }

  // 机外刀库查询
  static Future<ResponseApiBody> getMachineOutToolQuery(data) {
    return HttpUtil.post('/Eatm/MachineOutToolQuery', data: data);
  }
}
