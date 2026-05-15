import 'package:flutter/material.dart';

class GoogleData extends StatelessWidget {
  const GoogleData({super.key,  this.username,   this.image, required this.logout});

   final String? username;
   final String? image;
   final Future<void> Function() logout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Google Login Data'),
        actions: [
          TextButton(
            onPressed: () async{
              await logout();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 20, color: Colors.cyanAccent),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: NetworkImage(
                  '$image',
                ),
                height: 200,
                width: 300,
              filterQuality: FilterQuality.high,
                ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '$username',
              style: const TextStyle(fontSize: 30, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
