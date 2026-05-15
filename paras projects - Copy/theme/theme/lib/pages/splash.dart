import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            height: 100,
            color: Colors.amber,
          ),
          const Center(
            child: Text(
              "Spash Screen",
              style: TextStyle(color: Colors.amberAccent),
            ),
          ),
          Text(
            "Add Diet",
            style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w500, color: Colors.amberAccent),
          ),
          Text(
            "Enter the name of ",
            style: textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
