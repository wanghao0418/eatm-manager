import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../../common/api/user.dart';
import '../../../common/routers/index.dart';
import '../../../common/store/user.dart';
import '../../../common/utils/http.dart';

class LoginController extends GetxController {
  LoginController();
  final formKey = GlobalKey<FormState>();
  final focusNodeUserName = FocusNode();
  final focusNodePassword = FocusNode();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberPassword = false.obs;
  var user = User();

  _initData() {
    update(["login"]);
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    ResponseApiBody response = await UserApi.login(user.toJson());
    if (response.success == true) {
      UserStore userStore = Get.find<UserStore>();
      userStore.setUserInfo(response.data['currentUserInfo']);
      userStore.setToken(response.data['token']);
      Get.offNamed(RouteNames.systemMain);
    }
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
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
