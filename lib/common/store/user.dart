/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-31 17:45:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-25 11:29:03
 * @FilePath: /eatm_manager/lib/common/store/user.dart
 * @Description:  用户信息
 */
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
    print('初始化');
    // token = await StorageService.to.getString(STORAGE_USER_TOKEN_KEY) ?? '';
    token = _storage.read('token') ?? '';
    _isLogin.value = token.isNotEmpty;
  }

  // 保存用户信息
  Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    // await StorageService.to.setMap(STORAGE_USER_INFO_KEY, userInfo);
    _storage.write('userInfo', userInfo);
  }

  // 保存 token
  Future<void> setToken(String value) async {
    // await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
    _storage.write('token', value);
    _isLogin.value = true;
  }

  // 注销
  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    // await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    _isLogin.value = false;
    _storage.remove('token');
    token = '';
  }
}
