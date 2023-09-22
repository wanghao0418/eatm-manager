import 'package:eatm_manager/common/utils/http.dart';

class MaintenanceSystemApi {
  // 获取设备列表
  static Future<ResponseApiBody> queryEquipmentList(params) async {
    return HttpUtil.post('/Eatm/MaintenanceSet_UpQuery', data: params);
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

  // 查询维保任务
  static Future<ResponseApiBody> queryMaintenanceTask(params) {
    return HttpUtil.post('/Eatm/Maintenance_TaskCreate_Query', data: params);
  }

  // 查询维保项目
  static Future<ResponseApiBody> queryMaintenanceItem() {
    return HttpUtil.post('/Eatm/MaintenanceSet_DownQuery',
        data: {"params": {}});
  }

  // 创建维保任务
  static Future<ResponseApiBody> addMaintenanceTask(params) {
    return HttpUtil.post('/Eatm/Maintenance_TaskCreate_Add', data: params);
  }

  // 删除维保任务
  static Future<ResponseApiBody> deleteMaintenanceTask(params) {
    return HttpUtil.post('/Eatm/Maintenance_TaskCreate_Delete', data: params);
  }

  // 新增设备
  static Future<ResponseApiBody> addEquipment(params) {
    return HttpUtil.post('/Eatm/MaintenanceSet_UpSave', data: params);
  }

  // 删除设备
  static Future<ResponseApiBody> deleteEquipment(params) {
    return HttpUtil.post('/Eatm/MaintenanceSet_UpDelete', data: params);
  }

  // 删除维保项目
  static Future<ResponseApiBody> deleteMaintenanceItem(params) {
    return HttpUtil.post('/Eatm/MaintenanceSet_DownDelete', data: params);
  }

  // 添加(修改)维保项目
  static Future<ResponseApiBody> updateMaintenanceItem(params) {
    return HttpUtil.post('/Eatm/MaintenanceSet_DownAddItem', data: params);
  }

  // 查询历史任务
  static Future<ResponseApiBody> queryTaskHistory(params) {
    return HttpUtil.post('/Eatm/Maintenance_HistoryQuery', data: params);
  }
}
