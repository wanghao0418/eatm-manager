/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-05 15:08:42
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 15:12:12
 * @FilePath: /eatm_manager/lib/common/api/user_info_api.dart
 * @Description: 用户信息api
 */
import 'package:eatm_manager/common/utils/http.dart';

class UserInfoApi {
  // 查询
  static Future<ResponseApiBody> query(data) {
    return HttpUtil.post('/Eatm/UserInfopage', data: data);
  }

  // 修改
  static Future<ResponseApiBody> update(data) {
    return HttpUtil.post('/Eatm/UserInfoSaveOrUpdate', data: data);
  }

  // 删除
  static Future<ResponseApiBody> delete(data) {
    return HttpUtil.post('/Eatm/DeleteUser', data: data);
  }
}
