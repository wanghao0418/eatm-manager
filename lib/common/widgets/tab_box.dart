import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class TabBox extends StatefulWidget {
  const TabBox(
      {Key? key,
      required this.tabList,
      this.header,
      this.footer,
      this.onCurrentChange})
      : super(key: key);
  final List<Tab> tabList;
  final Widget? header;
  final Widget? footer;
  final void Function(int)? onCurrentChange;

  @override
  _TabBoxState createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  RxInt currentTabIndex = (-1).obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.tabList.isNotEmpty) {
      setState(() {
        currentTabIndex.value = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(
          resources: globalTheme.isDarkMode
              ? ResourceDictionary.dark(
                  solidBackgroundFillColorTertiary: globalTheme.accentColor)
              : ResourceDictionary.light(
                  solidBackgroundFillColorTertiary: globalTheme.accentColor)),
      child: Column(
        children: [
          SizedBox(
            height: 38.5,
            child: TabView(
                tabWidthBehavior: TabWidthBehavior.sizeToContent,
                closeButtonVisibility: CloseButtonVisibilityMode.never,
                currentIndex: currentTabIndex.value,
                onChanged: (value) {
                  setState(() {
                    currentTabIndex.value = value;
                    if (widget.onCurrentChange != null) {
                      widget.onCurrentChange!(value);
                    }
                  });
                },
                header: widget.header,
                footer: widget.footer,
                tabs: widget.tabList.map(
                  (e) {
                    int index = widget.tabList.indexOf(e);
                    bool isActive = currentTabIndex.value == index;
                    return Tab(
                        icon: null,
                        text: ThemedText(
                          (e.text as Text).data ?? '',
                          style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : null,
                              decorationColor: Colors.white,
                              color: isActive ? Colors.white : null),
                        ),
                        body: Container());
                  },
                ).toList()),
          ),
          Expanded(
              child: IndexedStack(
            index: currentTabIndex.value,
            children: widget.tabList
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(10.r),
                    child: e.body,
                  ).border(all: 1, color: globalTheme.accentColor),
                )
                .toList(),
          ))
        ],
      ),
    );
  }
}
