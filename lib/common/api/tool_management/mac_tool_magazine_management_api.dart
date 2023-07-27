/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-10 11:32:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 18:35:53
 * @FilePath: /flutter-mesui/lib/api/tool_management/mac_tool_magazine_management_api.dart
 */

import 'package:eatm_manager/common/utils/http.dart';

class MacToolMagazineManagementApi {
  // 查询
  static Future<ResponseApiBody> query(data) {
    return HttpUtil.post('/Eatm/MacToolMagazineManagement/query', data: data);
  }

  // 新增
  static Future<ResponseApiBody> add(data) {
    return HttpUtil.post('/Eatm/MacToolMagazineManagement/add', data: data);
  }

  // 修改
  static Future<ResponseApiBody> update(data) {
    return HttpUtil.post('/Eatm/MacToolMagazineManagement/update', data: data);
  }

  // 删除
  static Future<ResponseApiBody> delete(data) {
    return HttpUtil.post('/Eatm/MacToolMagazineManagement/delete', data: data);
  }

  // 获取机床列表
  static Future<ResponseApiBody> getMachineList(data) {
    return HttpUtil.post('/Eatm/MacToolMagazineManagement/getMacList',
        data: data);
  }
}
