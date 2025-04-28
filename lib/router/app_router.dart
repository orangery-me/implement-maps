import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/auth/views/login_view.dart';
import 'package:flutter_template/presentation/core/views/root_view.dart';
import 'package:flutter_template/presentation/location_search/location_search.dart';
import 'package:flutter_template/presentation/maps/maps.dart';
import 'package:flutter_template/presentation/splash/splash.dart';

import 'package:flutter_template/presentation/location_list/location_list.dart';

abstract final class AppRouter {
  static const String splash = '/';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Root
  static const String root = '/root';

  //Maps
  static const String maps = '/maps';
  static const String locationList = '/locationList';
  static const String locationSearch = '/locationSearch';

  // static final router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: login,
  //       pageBuilder: (_, __) {
  //         return const MaterialPage(
  //           child: LoginPage(),
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: register,
  //       pageBuilder: (_, __) {
  //         return const MaterialPage(
  //           child: RegisterView(),
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: root,
  //       pageBuilder: (_, __) {
  //         return const MaterialPage(
  //           child: RootPage(),
  //         );
  //       },
  //     )
  //   ],
  //   initialLocation: login,
  // );

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) {
            return const SplashPage();
          },
        );
      case login:
        return MaterialPageRoute(
          builder: (_) {
            return const LoginPage();
          },
        );
      case root:
        return MaterialPageRoute(
          builder: (_) {
            return const RootPage();
          },
        );
      case maps:
        return MapsRoute.route();
      case locationList:
        return LocationListRoute.route();
      case locationSearch:
        return LocationSearchRoute.route();
      default:
        return null;
    }
  }
}
