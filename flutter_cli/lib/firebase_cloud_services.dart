import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static var firebaseFirestore = FirebaseFirestore.instance.collection('User');

  // add data

  static Future<void> addData(value) async {
    await firebaseFirestore
        .doc('counter')
        .set({'counter': value})
        .then((value) {
          print('added');
          return const SnackBar(content: Text('success'));
        })
        .onError(
            (error, stackTrace) {
              print('failed:$error');

              return const SnackBar(content: Text('failed'));
            });
  }


}
