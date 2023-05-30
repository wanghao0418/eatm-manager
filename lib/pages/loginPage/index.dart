import 'package:eatm_manager/api/user_api.dart';
import 'package:eatm_manager/common/request.dart';
import 'package:eatm_manager/pages/layout/index.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../store/global.dart';

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

class LoginPage extends HookWidget {
  LoginPage({Key? key}) : super(key: key);
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var user = useState(User());
    var error = useState('');
    var rememberPassword = useState(false);
    TextEditingController userNameController = useTextEditingController();
    TextEditingController passwordController = useTextEditingController();

    return Consumer<SignedInModel>(builder: (context, signedIn, child) {
      _login() async {
        _formKey.currentState!.save();

        if (_formKey.currentState!.validate()) {
          // signedIn.isSignedIn = true;
          ResponseBodyApi res = await UserApi.login(user.value.toJson());
          if (!res.success!) {
            _focusNodePassword.requestFocus();
            return;
          }
          signedIn.isSignedIn = true;
          context.go('/');
        }
      }

      return Stack(
        children: [
          const Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: WindowButtons(),
                ),
              )),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(
                    width: 130.r,
                    height: 40.r,
                    image: AssetImage('assets/images/layout/eman.png'),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 1000.r,
              height: 600.r,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 0),
                    blurRadius: 10.r,
                  ),
                ],
              ),
              child: Row(children: [
                Image.asset(
                  'assets/images/login/login_img.jpg',
                  height: 600.r,
                  fit: BoxFit.fitHeight,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('欢迎使用',
                    //     style: TextStyle(
                    //         fontSize: 36.sp,
                    //         fontWeight: FontWeight.bold,
                    //         // letterSpacing: 5,
                    //         color: Colors.blue)),
                    // 20.verticalSpacingRadius,
                    Text('EMAN 益模',
                        style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.light)),
                    10.verticalSpacingRadius,
                    Text('智能生产管理系统',
                        style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.light)),
                    30.verticalSpacingRadius,
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 20.r),
                              child: InfoLabel(
                                label: '用户名:',
                                labelStyle: TextStyle(
                                  fontSize: 20.sp,
                                ),
                                child: TextFormBox(
                                  // style: TextStyle(
                                  //   fontSize: 16.sp,
                                  // ),
                                  prefix: Padding(
                                    padding: EdgeInsets.only(left: 10.r),
                                    child: Icon(
                                      FluentIcons.user_window,
                                      // size: 16.r,
                                    ),
                                  ),
                                  focusNode: _focusNodeUserName,
                                  controller: userNameController,
                                  placeholder: '请输入用户名',
                                  placeholderStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                  expands: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '请输入用户名';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    user.value.userName = value ?? '';
                                  },
                                  onFieldSubmitted: (value) {
                                    _focusNodePassword.requestFocus();
                                  },
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 20.r),
                              child: InfoLabel(
                                label: '密码:',
                                labelStyle: TextStyle(
                                  fontSize: 20.sp,
                                ),
                                child: PasswordFormBox(
                                  focusNode: _focusNodePassword,
                                  revealMode: PasswordRevealMode.peekAlways,
                                  controller: passwordController,
                                  leadingIcon: Padding(
                                    padding: EdgeInsets.only(left: 10.r),
                                    child: Icon(
                                      FluentIcons.lock,
                                      // size: 16.r,
                                    ),
                                  ),
                                  placeholder: '请输入密码',
                                  placeholderStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '请输入密码';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    user.value.password = value ?? '';
                                  },
                                  onFieldSubmitted: (value) {
                                    _login();
                                  },
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: 20.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  checked: rememberPassword.value,
                                  onChanged: (bool? value) {
                                    rememberPassword.value = value!;
                                  },
                                ),
                                10.horizontalSpaceRadius,
                                const Text('记住密码').fontSize(16.sp),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20.r),
                                  child: FilledButton(
                                    child: Text('登录').fontSize(20.sp),
                                    onPressed: _login,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ]),
            ),
          ),
        ],
      );
    });
  }
}
