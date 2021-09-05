import 'package:deskable/screens/management/create_room_screen.dart';
import 'package:deskable/screens/screens.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SignInScreen.routeName:
        return SignInScreen.route();
      case HomeScreen.routeName:
        final args = settings.arguments as bool?;
        return HomeScreen.route(args ?? false);
      case SettingsScreen.routeName:
        return SettingsScreen.route();
      case AccountEditScreen.routeName:
        return AccountEditScreen.route();
      case AccountCreateScreen.routeName:
        return AccountCreateScreen.route();
      case IntroScreen.routeName:
        return IntroScreen.route();
      case ManagementScreen.routeName:
        return ManagementScreen.route();
      case CropImageScreen.routeName:
        final args = settings.arguments as CropScreenArguments;
        return CropImageScreen.route(args);
      case CreateCompanyScreen.routeName:
        return CreateCompanyScreen.route();
      case CreateRoomScreen.routeName:
        return CreateRoomScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
