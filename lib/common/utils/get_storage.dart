/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-07 16:34:24
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 18:42:44
 * @FilePath: /eatm_manager/lib/common/utils/get_storage.dart
 * @Description: 存取getStorage缓存工具类
 */

import 'package:get_storage/get_storage.dart';

enum StorageInfo {
  // 快捷入口
  fastEntry(storageName: "user", key: 'fastEntryList'),
  // 路由访问历史
  routeHistory(storageName: "user", key: 'historyList');

  final String storageName;
  final String key;
  const StorageInfo({required this.storageName, required this.key});
}

class GetStorageUtil {
  static GetStorage get fastEntryStorage =>
      GetStorage(StorageInfo.fastEntry.storageName);
  static GetStorage get routeHistoryStorage =>
      GetStorage(StorageInfo.routeHistory.storageName);
  static GetStorage get userStorage => GetStorage('user');

  // 读取快捷入口
  static List<String?> getFastEntryList() {
    StorageInfo storage = StorageInfo.fastEntry;
    var data = fastEntryStorage.read(storage.key);
    return data != null ? (data as List).map((e) => e.toString()).toList() : [];
  }

  // 写入快捷入口
  static writeFastEntryList(List<String?> list) {
    StorageInfo storage = StorageInfo.fastEntry;
    fastEntryStorage.write(storage.key, list);
  }

  // 清空快捷入口
  static cleanFastEntryStorage() {
    fastEntryStorage.remove(StorageInfo.fastEntry.key);
  }

  // 读取访问历史
  static List<String?> getVisitHistoryList() {
    var data = routeHistoryStorage.read(StorageInfo.routeHistory.key);
    return data != null ? (data as List).map((e) => e.toString()).toList() : [];
  }

  // 写入访问历史
  static pushVisitHistory(String routeUrl) {
    if (routeUrl == '/home') return;
    List<String?> data = getVisitHistoryList();
    StorageInfo info = StorageInfo.routeHistory;
    if (data == []) {
      routeHistoryStorage.write(info.key, [routeUrl]);
    } else {
      var index = data.indexWhere((url) => url == routeUrl);
      if (index >= 0) {
        data.removeAt(index);
        data.insert(0, routeUrl);
        routeHistoryStorage.write(info.key, data);
      } else {
        data.insert(0, routeUrl);
        routeHistoryStorage.write(info.key, data);
      }
    }
  }

  // 清除访问历史store
  static cleanVisitHistoryStore() {
    routeHistoryStorage.remove(StorageInfo.routeHistory.key);
  }
}
