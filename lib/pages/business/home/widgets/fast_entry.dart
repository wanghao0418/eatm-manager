/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-07 16:25:42
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 17:59:14
 * @FilePath: /eatm_manager/lib/pages/business/home/widgets/fastEntry.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/get_storage.dart';
import 'package:eatm_manager/common/utils/router.dart';
import 'package:eatm_manager/pages/system/main/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FastEntry extends StatefulWidget {
  const FastEntry({Key? key}) : super(key: key);

  @override
  State<FastEntry> createState() => _FastEntryState();
}

class _FastEntryState extends State<FastEntry> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  final GetStorage _storage = GetStorage(StorageInfo.fastEntry.storageName);
  Function? _listen;
  final MainController _mainController = Get.find<MainController>();

  Widget _renderEntryItem(MenuItem data) {
    return Container(
        height: 20,
        child: TextButton(
          onPressed: () {
            RouterUtils.jumpToChildPage(data.url!);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(globalTheme.isDarkMode
                ? Color.fromARGB(255, 59, 58, 58)
                : Color.fromARGB(255, 238, 238, 242)),
          ),
          child: Text(
            data.name ?? '',
            style: TextStyle(
                fontSize: 16.r,
                color: globalTheme.isDarkMode ? Colors.white : Colors.black87),
          ),
        ));
  }

  @override
  void initState() {
    // 添加监听
    // _fashEntrySubscription = eventBus.on<ChangeFastEntryEvent>().listen((event) {
    //   // print(event.page);
    //   setState(() {});
    // });
    _listen = _storage.listen(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // _fashEntrySubscription.cancel();
    _listen?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var entryList = GetStorageUtil.getFastEntryList();
    var entries = _mainController.jumpableMenuList
        .where((e) => entryList.contains(e.url));
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 5,
        children: entries.map((e) => _renderEntryItem(e)).toList(),
      ),
    );
  }
}
