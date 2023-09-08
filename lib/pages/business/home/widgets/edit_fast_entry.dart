/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-07 16:56:19
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 18:03:39
 * @FilePath: /eatm_manager/lib/pages/business/home/widgets/editFastEntryDialog_content.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/get_storage.dart';
import 'package:eatm_manager/pages/system/main/controller.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditFastEntry extends StatefulWidget {
  EditFastEntry({Key? key}) : super(key: key);

  @override
  State<EditFastEntry> createState() => EditFastEntryState();
}

class EditFastEntryState extends State<EditFastEntry> {
  // 已选集合
  List<String?> _selectedList = [];
  List<MenuItem> _menuList = [];
  GlobalTheme get globalTheme => GlobalTheme.instance;

  void save() {
    GetStorageUtil.writeFastEntryList(_selectedList);
    // eventBus.fire(ChangeFastEntryEvent(_selectedList));
  }

  void clean() {
    setState(() {
      _selectedList.clear();
    });
  }

  bool _isEntrySelected(String? entryUrl) {
    // return _selectedList.indexWhere((element) => element!.id == entry!.id) >= 0;
    return _selectedList.contains(entryUrl);
  }

  void _select(MenuItem? entry) {
    setState(() {
      if (_isEntrySelected(entry!.url)) {
        _selectedList.remove(entry.url);
      } else {
        _selectedList.add(entry.url);
      }
    });
  }

  Widget _renderEntryItem(MenuItem? data) {
    return Container(
        height: 20,
        child: fluent_ui.ToggleButton(
          checked: _isEntrySelected(data!.url),
          onChanged: (value) {
            _select(data);
          },
          // onPressed: () {
          //   _select(data);
          // },
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.all(globalTheme.isDarkMode
          //       ? (_isEntrySelected(data!.url)
          //           ? Colors.blue.shade200
          //           : Color.fromARGB(255, 59, 58, 58))
          //       : (_isEntrySelected(data!.url)
          //           ? Colors.blue.shade200
          //           : Color.fromARGB(255, 238, 238, 242))),
          // ),
          child: Text(
            data.name ?? '',
            style: TextStyle(
                color: globalTheme.isDarkMode
                    ? (_isEntrySelected(data.url) ? Colors.white : Colors.white)
                    : (_isEntrySelected(data.url)
                        ? Colors.white
                        : Colors.black87)),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedList = GetStorageUtil.getFastEntryList();
    MainController mainController = Get.find<MainController>();
    _menuList = mainController.jumpableMenuList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> entryButtonList = _menuList.map<Widget>((MenuItem? menuInfo) {
      return _renderEntryItem(menuInfo);
    }).toList();
    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 5,
        children: entryButtonList,
      ),
    );
  }
}
