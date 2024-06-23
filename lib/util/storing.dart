// // storage_utils.dart

// // ignore_for_file: prefer_conditional_assignment

// import 'dart:convert';
// import 'package:openfoodfacts/openfoodfacts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StorageUtils {
//   static Future<void> storeScannedProduct(Product product) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

//     if (scannedProductsJson == null) {
//       scannedProductsJson = [];
//     }

//     if (!StorageUtils.checkIfProductExistsSync(
//         product.barcode!, scannedProductsJson)) {
//       String productJson = jsonEncode(product.toJson());
//       scannedProductsJson.add(productJson);

//       // Store updated list in SharedPreferences
//       await prefs.setStringList('scanned_products', scannedProductsJson);
//     }

//     // Serialize Product object to JSON and add to list
//   }

//   static Future<List<Product>> getScannedProducts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

//     if (scannedProductsJson == null) {
//       return [];
//     }

//     // Deserialize each JSON string to Product object
//     List<Product> scannedProducts = scannedProductsJson
//         .map((json) => Product.fromJson(jsonDecode(json)))
//         .toList();

//     return scannedProducts;
//   }

//   static Future<void> removeScannedProduct(Product product) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

//     if (scannedProductsJson == null) {
//       return;
//     }

//     // Find and remove the JSON string matching the product to remove
//     scannedProductsJson.removeWhere((json) {
//       Product storedProduct = Product.fromJson(jsonDecode(json));
//       return storedProduct.barcode == product.barcode;
//     });

//     // Update SharedPreferences with the modified list
//     await prefs.setStringList('scanned_products', scannedProductsJson);
//   }

//   static bool checkIfProductExistsSync(
//       String barcode, List<String>? scannedProductsJson) {
//     if (scannedProductsJson == null) {
//       return false;
//     }

//     // Deserialize each JSON string to Product object and check barcode
//     for (String productJson in scannedProductsJson) {
//       Product product = Product.fromJson(jsonDecode(productJson));
//       if (product.barcode == barcode) {
//         return true;
//       }
//     }

//     return false;
//   }

//   static Future<bool> checkIfProductExists(String barcode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? scannedProductsJson = prefs.getStringList('scanned_products');
//     return checkIfProductExistsSync(barcode, scannedProductsJson);
//   }
// }

import 'dart:convert';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static Future<void> storeScannedProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

    if (scannedProductsJson == null) {
      scannedProductsJson = [];
    }

    bool productExists = false;

    for (int i = 0; i < scannedProductsJson.length; i++) {
      Product storedProduct =
          Product.fromJson(jsonDecode(scannedProductsJson[i]));
      if (storedProduct.barcode == product.barcode) {
        // Replace existing product
        scannedProductsJson[i] = jsonEncode(product.toJson());
        productExists = true;
        break;
      }
    }

    if (!productExists) {
      // Add new product if it doesn't exist
      String productJson = jsonEncode(product.toJson());
      scannedProductsJson.add(productJson);
    }

    // Store updated list in SharedPreferences
    await prefs.setStringList('scanned_products', scannedProductsJson);
  }

  static Future<List<Product>> getScannedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

    if (scannedProductsJson == null) {
      return [];
    }

    // Deserialize each JSON string to Product object
    List<Product> scannedProducts = scannedProductsJson
        .map((json) => Product.fromJson(jsonDecode(json)))
        .toList();

    return scannedProducts;
  }

  static Future<void> removeScannedProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scannedProductsJson = prefs.getStringList('scanned_products');

    if (scannedProductsJson == null) {
      return;
    }

    // Find and remove the JSON string matching the product to remove
    scannedProductsJson.removeWhere((json) {
      Product storedProduct = Product.fromJson(jsonDecode(json));
      return storedProduct.barcode == product.barcode;
    });

    // Update SharedPreferences with the modified list
    await prefs.setStringList('scanned_products', scannedProductsJson);
  }

  static bool checkIfProductExistsSync(
      String barcode, List<String>? scannedProductsJson) {
    if (scannedProductsJson == null) {
      return false;
    }

    // Deserialize each JSON string to Product object and check barcode
    for (String productJson in scannedProductsJson) {
      Product product = Product.fromJson(jsonDecode(productJson));
      if (product.barcode == barcode) {
        return true;
      }
    }

    return false;
  }

  static Future<bool> checkIfProductExists(String barcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scannedProductsJson = prefs.getStringList('scanned_products');
    return checkIfProductExistsSync(barcode, scannedProductsJson);
  }
}
