import 'package:get/get.dart';

class UserStore extends GetxController {
  static UserStore get instance => Get.find();
  // 是否登录
  final _isLogin = false.obs;
  // 令牌 token
  String token = '';

  bool get isLogin => _isLogin.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = '1';
  }

  // 保存 token
  Future<void> setToken(String value) async {
    // await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
    _isLogin.value = true;
  }

  // 注销
  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    // await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    _isLogin.value = false;
    token = '';
  }
}
