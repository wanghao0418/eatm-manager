import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Text(
        "首页",
      ).fontSize(20.sp)),
    );
  }
}
