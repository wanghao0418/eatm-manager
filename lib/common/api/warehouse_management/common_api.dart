/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-04 10:58:05
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 15:57:27
 * @FilePath: /eatm_manager/lib/common/api/warehouse_management/common_api.dart
 * @Description: 仓库管理公共api
 */
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/http.dart';

class WarehouseCommonApi {
  // 是否启用mock
  static bool get isMock => ConfigStore.instance.openMock ?? false;

  // 出库
  static Future<ResponseApiBody> outWarehouse(data) async {
    return HttpUtil.post('/Eatm/warehouse/OutWarehouse',
        data: data, isMock: isMock);
  }

  // 入库
  static Future<ResponseApiBody> warehouse(data) async {
    return HttpUtil.post('/Eatm/warehouse/Warehousing',
        data: data, isMock: isMock);
  }
}
