import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login/email_login_signup/email_signup_login.dart';
import 'package:social_login/firebase_analytics.dart';
import 'package:social_login/firebase_service.dart';
import 'package:social_login/google_data.dart';

import 'chat_gpt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // use to initialize firebase in our app.
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final observer = FireBaseService.observer;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [observer],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = FirebaseAuth.instance;

  String? userId = '';

  UserCredential? googleData;

  set setUserId(String id) => userId = id;

  set setGoogleData(UserCredential data) => googleData = data;

  get googleUserId => userId;

// google login.
  Future<void> googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (userId?.isEmpty == true || userId == null) {
        final result = await googleSignIn.signIn();
        if (result == null) {
          return;
        }
        final userData = await result.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: userData.accessToken, idToken: userData.idToken);
        final finalData =
        await FirebaseAuth.instance.signInWithCredential(credential);
        setUserId = result.id.toString();
        setGoogleData = finalData;
        log('provider_id:${finalData.additionalUserInfo?.providerId}');
        log('nameIn additional Info:${finalData.additionalUserInfo?.username}');
        log('authorizationCode additional Info:${finalData.additionalUserInfo
            ?.authorizationCode}');
        log('pic additional Info:${finalData.additionalUserInfo?.profile}');
        log('name :${result.displayName}');
        log('id:${result.id}');
        log('email:${result.email}');
        log('pic :${result.photoUrl}');
      }
      // going to rout.
      // goToGoogleDataPage(result);
      // or we can send data using firebase auth.
      goToGoogleDataPageUsingAuth(googleData!);
    } catch (e) {
      log('error:$e');
    }
  }

  void goToGoogleDataPage(GoogleSignInAccount result) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          GoogleData(
            username: result.displayName,
            image: result.photoUrl,
            logout: logOut,
          ),
    ));
  }

  void goToGoogleDataPageUsingAuth(UserCredential result) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          GoogleData(
            username: result.user?.displayName,
            image: result.user?.photoURL,
            logout: logOut,
          ),
    ));
  }

// this method is use for logout.
  Future<void> logOut() async {
    Navigator.pop(context);
    if (userId?.isNotEmpty == true) {
      setUserId = '';
      googleData = null;
      await GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Social Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: googleLogin,
                child: const ListTile(
                  leading: Icon(
                    Icons.apple,
                    size: 30,
                  ),
                  title: Text(
                    'Google login',
                    style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const ListTile(
                  leading: Icon(
                    Icons.g_mobiledata,
                    size: 30,
                  ),
                  title: Text(
                    'Apple login',
                    style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailSignupLogin(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.email,
                    size: 30,
                  ),
                  title: Text(
                    'Email SignIn',
                    style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatGptFlutter(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                  ),
                  title: Text(
                    'Go To chatGPT',
                    style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirebaseAnalytics(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                  ),
                  title: Text(
                    'Go To FirebaseAnalytics',
                    style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
