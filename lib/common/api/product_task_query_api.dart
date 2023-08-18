/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-08 13:50:17
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 10:28:22
 * @FilePath: /eatm_manager/lib/common/api/product_task_query_api.dart
 * @Description: 生产任务查询接口
 */
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/utils/http.dart';

class ProductTaskQueryApi {
  // 是否启用mock
  static bool isMock = false;

  // 查询
  static Future<ResponseApiBody> query(data) async {
    return HttpUtil.post('/Eatm/ProductionSchedulingQuery',
        data: data, isMock: isMock);
  }

  // 开关门
  static Future<ResponseApiBody> openOrCloseDoor(data) async {
    var mesPort = ConfigStore.instance.mesPort;
    var baseUrl = HttpUtil.baseUrl;
    baseUrl = baseUrl!.replaceAll(RegExp(r':\d+'), ':$mesPort');
    return HttpUtil.post('$baseUrl/Eatm/TransportDoorOpenClose', data: data);
  }

  // 修改生产任务出入库状态
  static Future<ResponseApiBody> updateProductTaskState(data) async {
    return HttpUtil.post('/Eatm/productTaskStateUpdate',
        data: data, isMock: isMock);
  }

  // 获取出入库状态选项列表
  static Future<ResponseApiBody> getInOutStateList(data) async {
    return HttpUtil.post('/Eatm/getProductTaskList',
        data: data, isMock: isMock);
  }
}
