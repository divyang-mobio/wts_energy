import 'package:flutter/material.dart';

import '../views/main_screen.dart';
import '../views/safe_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case "/safe":
        return MaterialPageRoute(builder: (context) => const SafeScreen());
      default:
        return MaterialPageRoute(builder: (context) => const MainScreen());
    }
  }
}
