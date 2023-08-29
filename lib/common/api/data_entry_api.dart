/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-24 09:44:05
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-24 14:16:21
 * @FilePath: /eatm_manager/lib/common/api/data_entry_api.dart
 * @Description:  数据录入接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class DataEntryApi {
  // 是否开启mock
  static bool isMock = true;

  // 查询作业单列表
  static Future<ResponseApiBody> getHomeworkSheetList(data) {
    return HttpUtil.post('/Eatm/getHomeworkSheetList',
        data: data, isMock: isMock);
  }

  // 数据导入
  static Future<ResponseApiBody> dataImport(data) {
    return HttpUtil.post('/Eatm/DataImport', data: data, isMock: isMock);
  }

  // 删除 解绑
  static Future<ResponseApiBody> delete(data) {
    return HttpUtil.post('/Eatm/DataInputDelete', data: data, isMock: isMock);
  }

  // 芯片绑定
  static Future<ResponseApiBody> barCodeBind(data) {
    return HttpUtil.post('/Eatm/WorkProcessInPut', data: data, isMock: isMock);
  }
}