import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_login/email_login_signup/log_in_email.dart';
import 'package:social_login/firebase_service.dart';
import 'package:social_login/home_page.dart';
import 'package:social_login/utility.dart';

class EmailSignupLogin extends StatefulWidget {
  const EmailSignupLogin({super.key});

  @override
  State<EmailSignupLogin> createState() => _EmailSignupLoginState();
}

class _EmailSignupLoginState extends State<EmailSignupLogin> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signupWithEmail() {
    FireBaseService().signupWithEmail(
      email: emailController.text,
      password: passwordController.text,
      onComplete: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      ),
      onError: (error) {
        Utility().showDialog(error.toString(), context);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireBaseService().checkUserIfAlreadyLogin(
      alreadyLogin: () => Timer(
        const Duration(seconds: 1),
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),);
        },
      ), notLogin: () {  },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Email Signup'),
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
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorStyle: const TextStyle(color: Colors.blueAccent),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        }
                        if (value.length < 6) {
                          return 'please enter minimum 6 characters ';
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
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    signupWithEmail();
                  } else {
                    Utility().showDialog(
                        'please enter valid email or password', context);
                  }
                },
                child: const Text('Signup '),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginEmail(),
                    ),
                  );
                },
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                ),
                child: const Text('Log in'),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
