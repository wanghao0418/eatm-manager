/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-13 16:20:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 16:20:56
 * @FilePath: /eatm_manager/lib/common/api/automatic_handing_api.dart
 * @Description: 自动化搬运api
 */
import 'package:eatm_manager/common/utils/http.dart';

class AutomaticHandlingApi {
  static Future<ResponseApiBody> getWorkProcessTaskList() {
    return HttpUtil.post('/Eatm/WorkProcessTask', data: {});
  }

  static Future<ResponseApiBody> workProcessExecTask(data) {
    return HttpUtil.post('/Eatm/WorkProcessExecTask', data: data);
  }

  static Future<ResponseApiBody> getWorkProcessTaskHistory(data) {
    return HttpUtil.post('/Eatm/WorkProcessTaskHistory', data: data);
  }
}
