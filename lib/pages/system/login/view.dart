/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-26 16:37:19
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 16:39:54
 * @FilePath: /eatm_manager/lib/pages/system/login/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/window_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _LoginViewGetX();
  }
}

class _LoginViewGetX extends GetView<LoginController> {
  const _LoginViewGetX({Key? key}) : super(key: key);

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
            child: const Row(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 20.r),
                          child: InfoLabel(
                            label: '用户名:',
                            labelStyle: TextStyle(
                              fontSize: 20.sp,
                            ),
                            child: TextBox(
                              prefix: Padding(
                                padding: EdgeInsets.only(left: 10.r),
                                child: Icon(
                                  FluentIcons.user_window,
                                  size: 16,
                                  color: GlobalTheme.instance.buttonIconColor,
                                ),
                              ),
                              controller: controller.userNameController,
                              placeholder: '请输入用户名',
                              expands: false,
                              onChanged: (value) {
                                controller.user.userName = value;
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
                            child: PasswordBox(
                              revealMode: PasswordRevealMode.peekAlways,
                              controller: controller.passwordController,
                              leadingIcon: Padding(
                                padding: EdgeInsets.only(left: 10.r),
                                child: Icon(
                                  FluentIcons.lock,
                                  size: 16,
                                  color: GlobalTheme.instance.buttonIconColor,
                                ),
                              ),
                              placeholder: '请输入密码',
                              onChanged: (value) {
                                controller.user.password = value;
                              },
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(right: 20.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              checked: controller.rememberPassword.value,
                              onChanged: (bool? value) {
                                controller.rememberPassword.value = value!;
                                controller.update(["login"]);
                              },
                            ),
                            10.horizontalSpaceRadius,
                            const Text('记住密码').fontSize(14),
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
                  )
                  // Form(
                  //   key: controller.formKey,
                  //   child: ,
                  // )
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
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
