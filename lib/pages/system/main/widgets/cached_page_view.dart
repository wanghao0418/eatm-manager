/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-07 13:51:29
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-07 15:56:43
 * @FilePath: /eatm_manager/lib/pages/system/main/widgets/cached_page_view.dart
 * @Description: 缓存PageView组件
 */
import 'package:fluent_ui/fluent_ui.dart';

class CachedPageView extends StatefulWidget {
  final List<Widget> children;
  final ValueChanged<int> onPageChanged;
  final int initialPageIndex;
  final ValueChanged<PageController> onPageControllerCreated;

  CachedPageView(
      {required this.children,
      required this.onPageChanged,
      this.initialPageIndex = 0,
      required this.onPageControllerCreated});

  @override
  _CachedPageViewState createState() => _CachedPageViewState();
}

class _CachedPageViewState extends State<CachedPageView>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPageIndex);
    widget.onPageControllerCreated(_pageController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      // 禁止滑动 防止滑动后页面index设置错误
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      children: widget.children,
    );
  }
}
