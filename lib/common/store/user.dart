/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-31 17:45:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 18:34:27
 * @FilePath: /eatm_manager/lib/common/store/user.dart
 * @Description:  用户信息
 */
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:eatm_manager/common/routers/names.dart';
import 'package:eatm_manager/common/utils/get_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserStore extends GetxController {
  static UserStore get instance => Get.find();
  final GetStorage _storage = GetStorage('user');
  // 是否登录
  final _isLogin = true.obs;
  // 令牌 token
  String token = '';

  bool get isLogin => _isLogin.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // 初始化
  Future<void> init() async {
    token = _storage.read('token') ?? '';
    _isLogin.value = token.isNotEmpty;
  }

  // 保存用户信息
  Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    _storage.write('userInfo', userInfo);
  }

  UserInfo getCurrentUserInfo() {
    var userInfo = _storage.read('userInfo');
    return userInfo == null ? UserInfo() : UserInfo.fromMap(userInfo);
  }

  // 保存 token
  Future<void> setToken(String value) async {
    token = value;
    _storage.write('token', value);
    _isLogin.value = true;
  }

  // 注销
  Future<void> onLogout() async {
    _isLogin.value = false;
    _storage.remove('token');
    GetStorageUtil.cleanFastEntryStorage();
    token = '';
    Get.offAndToNamed(RouteNames.systemLogin);
  }

  // 保存用户名密码
  Future<void> rememberAccount(
      bool isRemember, String userName, String password) async {
    _storage.write('login_remember', isRemember);
    _storage.write('login_userName', userName);
    _storage.write('login_password', password);
  }
}
