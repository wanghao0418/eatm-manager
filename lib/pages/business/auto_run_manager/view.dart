import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class AutoRunManagerPage extends GetView<AutoRunManagerController> {
  const AutoRunManagerPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("AutoRunManagerPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutoRunManagerController>(
      init: AutoRunManagerController(),
      id: "auto_run_manager",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("auto_run_manager")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
