/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 17:36:24
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 18:35:39
 * @FilePath: /flutter-mesui/lib/api/tool_management/standard_tool_management_api.dart
 */

import 'package:eatm_manager/common/utils/http.dart';

class StandardToolManagementApi {
  // 查询
  static Future<ResponseApiBody> query(data) {
    return HttpUtil.post('/Eatm/StandardToolManagement/query', data: data);
  }

  // 新增
  static Future<ResponseApiBody> add(data) {
    return HttpUtil.post('/Eatm/StandardToolManagement/add', data: data);
  }

  // 修改
  static Future<ResponseApiBody> update(data) {
    return HttpUtil.post('/Eatm/StandardToolManagement/update', data: data);
  }

  // 删除
  static Future<ResponseApiBody> delete(data) {
    return HttpUtil.post('/Eatm/StandardToolManagement/delete', data: data);
  }
}
