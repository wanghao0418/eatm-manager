import 'package:eatm_manager/common/utils/http.dart';

class MaintenanceSystemApi {
  // 获取设备列表
  static Future<ResponseApiBody> queryEquipmentList() async {
    return HttpUtil.post('/Eatm/MaintenanceSet_UpQuery', data: {});
  }

  // 查询今日待办
  static Future<ResponseApiBody> queryTodoToday(params) {
    return HttpUtil.post('/Eatm/Maintenance_TodayTodo_Query', data: params);
  }

  // 修改是否异常
  static Future<ResponseApiBody> updateIsAbnormal(params) {
    return HttpUtil.post('/Eatm/Maintenance_TodayTodo_AbnormalSave',
        data: params);
  }

  // 维保处理
  static Future<ResponseApiBody> maintenanceHandle(params) {
    return HttpUtil.post('/Eatm/Maintenance_TodayTodo_Handle', data: params);
  }

  // 修改维保人员
  static Future<ResponseApiBody> updateMaintenancePersonnel(params) {
    return HttpUtil.post('/Eatm/Maintenance_TodayTodo_ModifyName',
        data: params);
  }
}
