/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 09:39:58
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 14:04:29
 * @FilePath: /eatm_manager/lib/pages/business/home/widgets/visit_history.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:async';

import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/get_storage.dart';
import 'package:eatm_manager/common/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VisitHistory extends StatefulWidget {
  const VisitHistory({Key? key}) : super(key: key);

  @override
  State<VisitHistory> createState() => _VisitHistoryState();
}

class _VisitHistoryState extends State<VisitHistory> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  final GetStorage _storage = GetStorageUtil.routeHistoryStorage;
  Function? _listen;

  Widget _renderHistoryItem(MenuItem data) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: ThemedText(
            data.url ?? '',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
                color: globalTheme.isDarkMode
                    ? Color.fromARGB(255, 59, 58, 58)
                    : Color(0xfff1f1f1),
                border: Border.all(color: Color(0xffebebeb)),
                borderRadius: BorderRadius.circular(2)),
            child: ThemedText(
              data.name ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          )
        ]),
      ),
      onTap: () {
        RouterUtils.jumpToChildPage(data.url!);
      },
    );
  }

  @override
  void initState() {
    _listen = _storage.listen(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // _historySubscription.cancel();
    _listen?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var historyUrlList = GetStorageUtil.getVisitHistoryList();
    var menus = RouterUtils.jumpableMenuItems;
    var historyList = historyUrlList
        .map((url) => menus.firstWhereOrNull((menu) => menu.url == url))
        .where((element) => element != null);
    return ListView(
      children: historyList.map((e) => _renderHistoryItem(e!)).toList(),
    );
  }
}
