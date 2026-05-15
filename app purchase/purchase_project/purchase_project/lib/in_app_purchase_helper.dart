import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHelper {
  // Private constructor
  InAppPurchaseHelper._privateConstructor();

  // Singleton instance
  static final InAppPurchaseHelper _instance = InAppPurchaseHelper._privateConstructor();

  // Factory constructor to return the singleton instance
  factory InAppPurchaseHelper() {
    return _instance;
  }

  // List to store product details
  List<ProductDetails> productDetailsList = [];

  // Instance of InAppPurchase
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // Method to get product details
  Future<void> getProductDetails() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();


    print('isAvailable:$isAvailable');
    // Set of product IDs to query
    var ids = [
      "sil",
      "gol",
      "dia",
      "silveryear",
      "goldyearly",
    ];
    if (isAvailable) {

    // Query product details
    final response = await _inAppPurchase.queryProductDetails(ids.toSet());

    // Check if the query was successful

      if (response.notFoundIDs.isNotEmpty) {
        print('Error: Some product IDs were not found: ${response.notFoundIDs}');
        return;
      }

      if (response.error != null) {
        print('Error: ${response.error!.message}');
        return;
      }


    productDetailsList = response.productDetails;
    print('Product Details: $productDetailsList');
    }
  }

  void listenToPurchaseUpdates() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    }, onDone: () {
      // Handle stream completion if necessary
    }, onError: (error) {
      // Handle error
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending purchase
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Verify purchase and deliver product
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle purchase error
      }

      if (purchaseDetails.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Implement receipt verification here
    bool isValid = await _verifyReceipt(purchaseDetails);
    if (isValid) {
      // Deliver the product
    } else {
      // Handle invalid purchase
    }
  }

  Future<bool> _verifyReceipt(PurchaseDetails purchaseDetails) async {
    // Implement platform-specific receipt verification
    return purchaseDetails.purchaseID!=null;
  }


}
