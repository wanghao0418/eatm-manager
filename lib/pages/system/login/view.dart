import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../common/widgets/window_button.dart';
import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Stack(
      children: [
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
        if (!kIsWeb)
          Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                height: 50.r,
                child: WindowButtons(),
              )),
        Positioned(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10.r, right: 10.r),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  width: 130,
                  height: 40,
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
            constraints: BoxConstraints(minWidth: 500, minHeight: 300),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: GlobalTheme.instance.isDarkMode
                  ? FluentTheme.of(context).acrylicBackgroundColor
                  : Colors.white,
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
              Container(
                height: 600.r,
                constraints: BoxConstraints(minHeight: 300),
                child: Image.asset(
                  'assets/images/login/login_img.jpg',
                  fit: BoxFit.fitHeight,
                ),
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
                    key: controller.formKey,
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
                                // style: TextStyle(fontSize: 16.sp),
                                prefix: Padding(
                                  padding: EdgeInsets.only(left: 10.r),
                                  child: Icon(
                                    FluentIcons.user_window,
                                    size: 20.sp,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                ),
                                focusNode: controller.focusNodeUserName,
                                controller: controller.userNameController,
                                placeholder: '请输入用户名',
                                // placeholderStyle: TextStyle(
                                //   fontSize: 16.sp,
                                // ),
                                expands: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入用户名';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  controller.user.userName = value ?? '';
                                },
                                onFieldSubmitted: (value) {
                                  controller.focusNodePassword.requestFocus();
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
                                focusNode: controller.focusNodePassword,
                                revealMode: PasswordRevealMode.peekAlways,
                                controller: controller.passwordController,
                                leadingIcon: Padding(
                                  padding: EdgeInsets.only(left: 10.r),
                                  child: Icon(
                                    FluentIcons.lock,
                                    size: 20.sp,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                ),
                                placeholder: '请输入密码',
                                // placeholderStyle: TextStyle(fontSize: 16.sp),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  controller.user.password = value ?? '';
                                },
                                onFieldSubmitted: (value) {
                                  controller.login();
                                },
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 20.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                checked: controller.rememberPassword.value,
                                onChanged: (bool? value) {
                                  controller.rememberPassword.value = value!;
                                  controller.update(["login"]);
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
                                  onPressed: controller.login,
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
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return material.Scaffold(
          body: _buildView(context),
        );
      },
    );
  }
}
