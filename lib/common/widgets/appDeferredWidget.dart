import 'package:flutter/material.dart';

/// loadLibrary
typedef AppLibraryLoader = Future<dynamic> Function();

/// deferredWidgetBuilder
typedef AppDeferredWidgetBuilder = Widget Function();

/// 延迟加载组件
/// 不在 build 里使用 FutureBuilder 加载，因为 build 执行多少次就会导致 widget 创建多少次
/// 这里在 initState 加载，或者当 AppDeferredWidgetBuilder 改变时重新加载
class AppDeferredWidget extends StatefulWidget {
  const AppDeferredWidget({
    Key? key,
    required this.libraryLoader,
    required this.builder,
    Widget? placeholder,
  })  : placeholder = placeholder ?? const AppDeferredLoading(),
        super(key: key);

  final AppLibraryLoader libraryLoader;
  final AppDeferredWidgetBuilder builder;
  final Widget placeholder;

  static final Map<AppLibraryLoader, Future<dynamic>> _moduleLoaders =
      <AppLibraryLoader, Future<dynamic>>{};
  static final Set<AppLibraryLoader> _loadedModules = <AppLibraryLoader>{};

  /// 预加载
  static Future<dynamic> preload(AppLibraryLoader loader) {
    if (!_moduleLoaders.containsKey(loader)) {
      _moduleLoaders[loader] = loader().then((_) {
        _loadedModules.add(loader);
      });
    }
    return _moduleLoaders[loader]!;
  }

  @override
  State<AppDeferredWidget> createState() => _AppDeferredWidgetState();
}

class _AppDeferredWidgetState extends State<AppDeferredWidget> {
  Widget? _loadedChild;
  AppDeferredWidgetBuilder? _loadedBuilder;

  @override
  void initState() {
    super.initState();
    if (AppDeferredWidget._moduleLoaders.containsKey(widget.libraryLoader)) {
      _onLibraryLoaded();
    } else {
      AppDeferredWidget.preload(widget.libraryLoader).then((_) => _onLibraryLoaded());
    }
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadedBuilder = widget.builder;
      _loadedChild = _loadedBuilder?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedBuilder != widget.builder && _loadedChild != null) {
      _loadedBuilder = widget.builder;
      _loadedChild = _loadedBuilder?.call();
    }
    return _loadedChild ?? widget.placeholder;
  }
}

/// 延迟加载Loading
class AppDeferredLoading extends StatelessWidget {
  const AppDeferredLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('Loading...'),
    );
  }
}
