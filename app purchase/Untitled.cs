Future<void> completeAllProduct() async {
    if (Platform.isIOS) {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      printLog("transactions length>> ${transactions.length}");

      for (var transaction in transactions) {
        printLog("transactions>> ${transaction.transactionState}");
        if (transaction.transactionState !=
            SKPaymentTransactionStateWrapper.purchasing) {
          await paymentWrapper.finishTransaction(transaction);
        }
      }
    }
  }
  
   Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async
  {
    
    try {
      printLog("purchaseDetailsList>>${purchaseDetailsList.length}");
      for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
        printLog("status --> ${purchaseDetails.status}");
        printLog("status --> ${purchaseDetails.error?.message}");

        if (purchaseDetails.status == PurchaseStatus.purchased &&
            !purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.pending) {
          await completeAllProduct();
          // await _iap.completePurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          showLoading.value = false;
          if (saveSubs.value == 1) {
            printLog(">>>>>>>>${purchaseDetails.runtimeType}");

            if (Platform.isAndroid) {
              if (purchaseDetails is GooglePlayPurchaseDetails) {
                PurchaseWrapper billingClientPurchase =
                    (purchaseDetails).billingClientPurchase;
                printLog(
                    "billingClientPurchase.originalJson==>${billingClientPurchase.originalJson}");
                saveSubscription(billingClientPurchase.purchaseToken,
                    purchaseDetails.productID);
              }
            } else if (Platform.isIOS) {
              if (purchaseDetails is AppStorePurchaseDetails) {
                final skProduct = (purchaseDetails).skPaymentTransaction;
                saveSubscription(skProduct.transactionIdentifier ?? "",
                    skProduct.payment.productIdentifier);
              }
            }
            saveSubs = (saveSubs.value + 1).obs;
            update();
            await completeAllProduct();
          }
        } else {
          showLoading.value = false;
        }
      }
    } catch (e, t) {
      showLoading.value = false;
      functionLog(msg: e.toString(), fun: "_listenToPurchaseUpdated");
      functionLog(msg: t.toString(), fun: "_listenToPurchaseUpdated");
    }
  }