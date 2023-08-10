/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-03 11:11:29
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-10 14:16:14
 * @FilePath: /eatm_manager/lib/common/api/warehouse_management/shelf_management_api.dart
 * @Description: 货架管理api
 */
import 'package:eatm_manager/common/utils/http.dart';

class InventoryManagementApi {
  // 是否启用mock
  static bool isMock = false;

  // 获取货架总数
  static Future<ResponseApiBody> getShelfCount(data) async {
    return HttpUtil.get('/Eatm/warehouse/getShelfCount',
        data: data, isMock: isMock);
  }

  // 查询
  static Future<ResponseApiBody> query(data) async {
    return HttpUtil.post('/Eatm/warehouse/storage/query',
        data: data, isMock: isMock);
  }

  // 货位状态修改
  static Future<ResponseApiBody> changeStorageState(data) async {
    return HttpUtil.post('/Eatm/warehouse/changeStorageState',
        data: data, isMock: isMock);
  }
}
