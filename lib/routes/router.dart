import 'package:go_router/go_router.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import '../pages/layout/layout.dart';
import '../widgets/deferred_widget.dart';
import '../pages/homePage/homePage.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Layout(
          child: child,
          shellContext: _shellNavigatorKey.currentContext,
          state: state,
        );
      },
      routes: [
        /// Home
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
);
