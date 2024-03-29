/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-04 11:01:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 13:26:36
 * @FilePath: /eatm_manager/lib/common/api/warehouse_management/task_management_api.dart
 * @Description:  任务管理api
 */
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/http.dart';

class TaskManagementApi {
  // 是否启用mock
  static bool get isMock => ConfigStore.instance.openMock ?? false;

  // 查询
  static Future<ResponseApiBody> query(data) async {
    return HttpUtil.post('/Eatm/warehouse/task/query',
        data: data, isMock: isMock);
  }

  // 取消任务
  static Future<ResponseApiBody> cancelTask(data) async {
    return HttpUtil.post('/Eatm/warehouse/cancelTask',
        data: data, isMock: isMock);
  }
}
