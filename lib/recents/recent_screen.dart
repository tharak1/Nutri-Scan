// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart'; // Import your Product model // Import your Recent model
import 'package:flutter_application_1/main_screens/scanned_result_screen.dart';

import 'package:flutter_application_1/recents/recentcard.dart';
import 'package:flutter_application_1/util/storing.dart';
import 'package:openfoodfacts/openfoodfacts.dart'; // Import your storage functions

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  List<Product> scannedProducts = []; // List to hold scanned products

  @override
  void initState() {
    super.initState();
    fetchScannedProducts(); // Fetch scanned products from local storage on screen initialization
  }

  Future<void> fetchScannedProducts() async {
    List<Product> fetchedProducts = await StorageUtils.getScannedProducts();
    print(fetchedProducts);
    setState(() {
      scannedProducts = fetchedProducts;
    });
  }

  void _removeRecent(Product product) async {
    await StorageUtils.removeScannedProduct(
        product); // Remove product from local storage

    setState(() {
      scannedProducts.removeWhere(
          (p) => p.barcode == product.barcode); // Remove from UI list
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Removed from recents.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              scannedProducts.add(product); // Re-add to UI list
            });
            StorageUtils.storeScannedProduct(
                product); // Re-store in local storage
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: Colors.black,
        title: const Text('Recent'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          scannedProducts.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: scannedProducts.length,
                    itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScannedResultScreen(
                                producDetails: scannedProducts[index]),
                          ),
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(scannedProducts[index]),
                        background: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.7),
                          margin: EdgeInsets.symmetric(
                            horizontal: Theme.of(context)
                                    .cardTheme
                                    .margin
                                    ?.horizontal ??
                                4.0,
                          ),
                        ),
                        onDismissed: (direction) {
                          _removeRecent(scannedProducts[index]);
                        },
                        child: RecentCard(
                          // Assuming RecentCard can handle Product dat
                          detailslist: scannedProducts[index],
                        ),
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Text('No scanned products.'),
                ),
        ],
      ),
    );
  }
}
