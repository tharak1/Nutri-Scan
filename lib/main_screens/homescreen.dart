// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/confirm_screen.dart';
import 'package:flutter_application_1/main_screens/scanned_result_screen.dart';
import 'package:flutter_application_1/util/services.dart';
import 'package:flutter_application_1/util/storing.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String _scannedResult = '';
  String status = '';

  @override
  Widget build(BuildContext context) {
    Future<void> startScanner() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      );

      if (result != null && result is String) {
        setState(() {
          _scannedResult = 'loading';
          status = 'loading';
        });

        try {
          final Product? product = await getProduct(barcode: result);

          if (product != null) {
            StorageUtils.storeScannedProduct(product);
            setState(() {
              _scannedResult = result;
              status = "Product Found";
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ScannedResultScreen(producDetails: product),
              ),
            );
          } else {
            setState(() {
              status = "No Product";
              _scannedResult = result;
            });
          }
        } catch (e) {
          setState(() {
            if (result == '-1') {
              status = "Do again";
              _scannedResult = result;
            } else {
              setState(() {
                status = "No Product";
                _scannedResult = result;
              });
            }
          });
        }
      }
    }

    Widget buildLoading() {
      return const CircularProgressIndicator();
    }

    Widget buildNoProduct() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Product not found !!",
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmScreen(barcode: _scannedResult),
                ),
              );
            },
            child: const Text('Add Product'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                status = "cancel";
                _scannedResult = "";
              });
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    }

    Widget _buildScanAgain() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Something went wrong, scan again !!",
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: startScanner,
            child: const Text('Scan again'),
          ),
        ],
      );
    }

    Widget _buildInitial() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Scan Something To Know Interesting things",
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: startScanner,
            child: const Text('Open Scanner'),
          ),
        ],
      );
    }

    Widget _buildContent() {
      switch (status) {
        case 'loading':
          return buildLoading();
        case 'No Product':
          return buildNoProduct();
        case 'Error':
          return buildNoProduct(); // Display the "Add Product" screen in case of an error
        default:
          return _buildInitial();
      }
    }

    return Scaffold(
      body: Center(
        child: _buildContent(),
      ),
    );
  }
}
