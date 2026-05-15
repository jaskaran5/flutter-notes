import 'package:flutter/material.dart';
import 'package:social_login/email_login_signup/email_signup_login.dart';
import 'package:social_login/firebase_service.dart';
import 'package:social_login/utility.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) =>Navigator.of(context).pop(true),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          title: const Text('Home Page'),
          actions: [
            IconButton(
              onPressed: ()  {
                FireBaseService().logOut(
                  afterSignOut: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailSignupLogin(),
                      )),
                  onError: (error) =>
                      Utility().showDialog(error.toString(), context),
                );
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
