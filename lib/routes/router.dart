import 'package:eatm_manager/pages/loginPage/loginPage.dart';
import 'package:go_router/go_router.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:provider/provider.dart';
import '../pages/layout/layout.dart';
import '../store/global.dart';
import '../widgets/deferred_widget.dart';
import '../pages/homePage/homePage.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
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
          redirect: (context, state) {
            var signedIn = Provider.of<SignedInModel>(context, listen: false);
            if (signedIn.isSignedIn == false) {
              return '/login';
            } else {
              return null;
            }
          },
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
);
