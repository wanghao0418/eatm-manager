/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-04 11:09:55
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-07 13:40:13
 * @FilePath: /eatm_manager/lib/common/api/warehouse_management/exit_storage_records_api.dart
 * @Description:  出入库记录api
 */
import 'package:eatm_manager/common/utils/http.dart';

class ExitStorageRecordsApi {
  // 是否启用mock
  static bool isMock = true;

  // 查询
  static Future<ResponseApiBody> query(data) async {
    return HttpUtil.post('/Eatm/warehouse/records/query',
        data: data, isMock: isMock);
  }
}
