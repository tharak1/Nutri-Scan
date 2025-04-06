import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_screens/navbar.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'Food Doctor',
  );
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ), 
      home: Navbar(),
    ),
  );
}
