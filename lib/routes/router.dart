import 'package:eatm_manager/pages/interchangeStation/index.dart';
import 'package:eatm_manager/pages/loginPage/index.dart';
import 'package:go_router/go_router.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:provider/provider.dart';
import '../pages/layout/index.dart';
import '../store/global.dart';
import '../widgets/deferred_widget.dart';
import '../pages/homePage/index.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final openTabs = <Tab>[];
int currentTabIndex = 0;

// class MyNavObserver extends NavigatorObserver {
//   void log(value) => debugPrint('MyNavObserver:$value');
//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     log('didPush: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => log(
//       'didPop: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');
//   @override
//   void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => log(
//       'didRemove: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');
//   @override
//   void didWordStr({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => log(
//       'didWordStr: new= ${newRoute?.toString()}, old= ${oldRoute?.toString()}');
//   @override
//   void didStartUserGesture(
//     Route<dynamic> route,
//     Route<dynamic>? previousRoute,
//   ) =>
//       log('didStartUserGesture: ${route.toString()}, '
//           'previousRoute= ${previousRoute?.toString()}');
//   @override
//   void didStopUserGesture() => log('didStopUserGesture');
// }

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
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
        GoRoute(
          path: '/interchangeStation',
          name: 'interchangeStation',
          redirect: (context, state) {
            var signedIn = Provider.of<SignedInModel>(context, listen: false);
            if (signedIn.isSignedIn == false) {
              return '/login';
            } else {
              return null;
            }
          },
          builder: (context, state) => InterchangeStationPage(),
        ),
      ],
    ),
  ],
);
