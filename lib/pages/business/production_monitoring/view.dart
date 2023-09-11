/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-11 10:05:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-11 16:28:33
 * @FilePath: /eatm_manager/lib/pages/business/production_monitoring/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';

import 'index.dart';

class ProductionMonitoringPage extends StatefulWidget {
  const ProductionMonitoringPage({Key? key}) : super(key: key);

  @override
  State<ProductionMonitoringPage> createState() =>
      _ProductionMonitoringPageState();
}

class _ProductionMonitoringPageState extends State<ProductionMonitoringPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ProductionMonitoringViewGetX();
  }
}

class _ProductionMonitoringViewGetX
    extends GetView<ProductionMonitoringController> {
  const _ProductionMonitoringViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return material.Chip(
      avatar: Text('111'),
      label: Text('Chip'),
      onDeleted: () {},
      deleteIcon: Icon(
        FluentIcons.delete,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductionMonitoringController>(
      init: ProductionMonitoringController(),
      id: "production_monitoring",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
