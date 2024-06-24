import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/add_image_button.dart';
import 'package:flutter_application_1/add_new_details/nutrition_and_ingredients_screen.dart';

class NewProductPage extends StatelessWidget {
  final String barcode;
  const NewProductPage({super.key, required this.barcode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please take the following photos and the Open Food Facts engine can work out the rest!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            AddImageWidget(
              text: "Front Packaging",
              imageUploadType: "FRONT",
              barcode: barcode,
            ),
            AddImageWidget(
              text: "Ingredients",
              imageUploadType: "INGREDIENTS",
              barcode: barcode,
            ),
            AddImageWidget(
              text: "Nutritional Facts",
              imageUploadType: "NUTRITION",
              barcode: barcode,
            ),
            AddImageWidget(
              text: "Recycling",
              imageUploadType: "PACKAGING",
              barcode: barcode,
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NutrientsAndIngredientsScreen(
                        barcode: barcode,
                      )));
        },
        child: Text('Next'),
      ),
    );
  }
}
