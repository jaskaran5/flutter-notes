import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseService {
  /// initialize firebase auth
  final auth = FirebaseAuth.instance;

  // email signup using auth
  Future<void> signupWithEmail(
      {required String email,
      required String password,
      required Function() onComplete,
      required Function(String error) onError}) async {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value.user != null) {}
    }).onError((error, stackTrace) {
      debugPrint('error email signup:$error');
      onError(error.toString());
    });
  }

  // email log using auth
  Future<void> logInWithEmail(
      {required String email,
      required String password,
      required Function() onComplete,
      required Function(String error) onError}) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password.toString())
        .then((value) {
      if (value.user != null) {
        onComplete();
      }
    }).onError((error, stackTrace) {
      debugPrint('error email login:$error');
      onError(error.toString());
    });
  }

  // check user if already log in then go to already Login  method other wise go to notLoginMethod

  Future<void> checkUserIfAlreadyLogin(
      {required Function() alreadyLogin, required Function() notLogin}) async {
    final user = auth.currentUser;
    if (user != null) {
      alreadyLogin();
    } else {
      notLogin();
    }
  }

  // logOutMethod
  Future<void> logOut(
      {required Function() afterSignOut,
      required Function(String error) onError}) async {
    await auth
        .signOut()
        .then((value) => afterSignOut())
        .onError((error, stackTrace) => onError(error.toString()));
  }

  // method for reset password using phone or email
  void resetPassword(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  /// for analytics
  static FirebaseAnalytics  analytics = FirebaseAnalytics.instance;

 static  FirebaseAnalyticsObserver observer =FirebaseAnalyticsObserver(analytics:analytics );


  // for initialize the analytics.
  void initializeFirebaseAnalytics() async {
    await analytics.setAnalyticsCollectionEnabled(true);
  }

  // for create logEvent to check page visit users.
  void setLogForAnalytics(
      {required String pageName, required int index})  {
    analytics.logEvent(
      name: 'page_trackers',
      parameters: <String, dynamic>{
        'page_name': pageName,
        'page_index': index,
      },
    );
  }
}
