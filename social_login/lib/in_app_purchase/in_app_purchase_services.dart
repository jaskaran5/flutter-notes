/* 1. for this we need to add package called in_app_purchase.
 2. make instance of this app_purchase
 3. create   streamSubscriptions object.
 4. create list of productDetails */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AppPurchaseServices {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  late StreamSubscription<dynamic> streamSubscription;

  List<ProductDetails> productDetails = [];

  void initializeInAppPurchase(BuildContext context) {
    Stream purchaseUpdate = _inAppPurchase.purchaseStream;
    streamSubscription = purchaseUpdate.listen((purchaseDetailList) {
      listenProduct(purchaseDetailList, context);
    },
        onDone: () => streamSubscription.cancel(),
        onError: (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'error:${error.toString()}',
                style: const TextStyle(fontSize: 30),
              ),
              backgroundColor: Colors.redAccent,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            )));
  }

  void listenProduct(
      List<PurchaseDetails> purchaseDetailList, BuildContext context) async {
    for (var purchaseDetail in purchaseDetailList) {
      if (purchaseDetail.status == PurchaseStatus.pending) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Pending',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.lightGreen,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      } else if (purchaseDetail.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Error',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.redAccent,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      } else if (purchaseDetail.status == PurchaseStatus.purchased) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'SuccessFully Purchased',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.green,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
    }
  }
}
