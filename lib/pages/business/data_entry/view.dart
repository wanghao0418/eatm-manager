/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-23 14:00:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-23 14:14:39
 * @FilePath: /eatm_manager/lib/pages/business/data_entry/view.dart
 * @Description: 数据录入视图层
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({Key? key}) : super(key: key);

  @override
  State<DataEntryPage> createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _DataEntryViewGetX();
  }
}

class _DataEntryViewGetX extends GetView<DataEntryController> {
  const _DataEntryViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索框
  Widget _buildSearchBar() {
    var formItems = Row(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LineFormLabel(
              label: '显示状态',
              width: 200,
              isExpanded: true,
              child: Container(),
            )
          ],
        )
      ],
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      padding: globalTheme.contentPadding,
      child: Column(children: [formItems, 10.verticalSpace]),
    );
  }

  // 数据表格

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataEntryController>(
      init: DataEntryController(),
      id: "data_entry",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
