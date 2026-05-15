import 'package:flutter/material.dart';
import '../../../feature/auth/presentation/views/splash_view.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print('Current Screen: ${settings.name}');
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorRoute());

    }
  }
}

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('No Such screen found in route generator'),
      ),
    );
  }
}
