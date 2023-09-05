/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-30 10:07:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 13:46:08
 * @FilePath: /eatm_manager/lib/common/utils/hive.dart
 * @Description: hive存储工具类
 */
import 'package:hive_flutter/hive_flutter.dart';

class HiveUtil {
  late Box edmTaskBox;
  late Box edmInfoBox;

  static HiveUtil? _instance;

  static HiveUtil get instance => _sharedInstance();

  HiveUtil._();

  factory HiveUtil() => _sharedInstance();

  static HiveUtil _sharedInstance() {
    _instance ??= HiveUtil._();
    return _instance!;
  }

  // 初始化
  static Future<void> init() async {
    await Hive.initFlutter();
    // instance.edmInfoBox = await Hive.openBox('edmTask');
    // instance.edmInfoBox = await Hive.openBox('edmInfo');
  }
}
