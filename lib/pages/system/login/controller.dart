/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-01 09:33:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 17:48:33
 * @FilePath: /eatm_manager/lib/pages/system/login/controller.dart
 * @Description: 登录逻辑层
 */
import 'package:eatm_manager/common/routers/names.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/api/user.dart';
import '../../../common/store/user.dart';
import '../../../common/utils/http.dart';

class LoginController extends GetxController {
  LoginController();
  UserStore userStore = UserStore.instance;
  // final formKey = GlobalKey<FormState>(debugLabel: 'login');
  // final focusNodeUserName = FocusNode();
  // final focusNodePassword = FocusNode();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberPassword = false.obs;
  var user = User();

  _initData() {
    update(["login"]);
  }

  void login() async {
    if (user.userName.isEmpty || user.password.isEmpty) {
      PopupMessage.showWarningInfoBar('请输入用户名及密码');
      return;
    }
    ResponseApiBody response = await UserApi.login(user.toJson());
    if (response.success == true) {
      userStore.setUserInfo(response.data['currentUserInfo']);
      userStore.setToken(response.data['token']);
      // 更新是否记住账号
      userStore.rememberAccount(
          rememberPassword.value, user.userName, user.password);
      Get.offAndToNamed(RouteNames.systemMain);
    } else {
      PopupMessage.showFailInfoBar(response.message as String);
    }
  }

  init() {
    final GetStorage storage = GetStorage('user');
    var isRemember = storage.read('login_remember');
    if (isRemember == true) {
      var userName = storage.read('login_userName');
      var passWord = storage.read('login_password');
      rememberPassword.value = true;
      userNameController.text = userName;
      user.userName = userName;
      passwordController.text = passWord;
      user.password = passWord;
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() async {
    super.onReady();
    init();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class User {
  String userName = '';
  String password = '';

  User({this.userName = '', this.password = ''});

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
      };
}
