import 'package:eatm_manager/pages/layout/layout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../store/global.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignedInModel>(builder: (context, signedIn, child) {
      return Stack(
        children: [
          // Positioned(
          //     right: 0,
          //     top: 0,
          //     child: Container(
          //       child: Align(
          //         alignment: Alignment.centerRight,
          //         // child: WindowButtons(),
          //       ),
          //     )),
          Container(
            child: Button(
                child: Text('登录'),
                onPressed: () {
                  signedIn.isSignedIn = true;
                  context.go('/');
                }),
          )
        ],
      );
    });
  }
}
