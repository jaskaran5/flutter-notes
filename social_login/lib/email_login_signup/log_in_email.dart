import 'package:flutter/material.dart';
import 'package:social_login/firebase_service.dart';

import '../home_page.dart';
import '../utility.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void logInWithEmail() {
    FireBaseService().logInWithEmail(
      email: emailController.text,
      password: passwordController.text,
      onComplete: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      ),
      onError: (error) => Utility().showDialog(error.toString(), context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Enter Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorStyle: const TextStyle(color: Colors.blueAccent),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Enter password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorStyle: const TextStyle(color: Colors.blueAccent),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    logInWithEmail();
                  }
                },
                child: const Text('Log in '),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot password ?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
