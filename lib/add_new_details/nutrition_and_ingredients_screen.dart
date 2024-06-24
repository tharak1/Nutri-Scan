import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/enter_ingredients_screen.dart';
import 'package:flutter_application_1/add_new_details/enter_nutrients_screen.dart';

class NutrientsAndIngredientsScreen extends StatelessWidget {
  final String barcode;
  const NutrientsAndIngredientsScreen({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("more data"),
      ),
      body: Column(
        children: [
          Card(
            shadowColor: Colors.grey,
            elevation: 2.0,
            surfaceTintColor: Colors.amber,
            child: ListTile(
              leading: Icon(Icons.eco),
              title: Text(
                "Enter Ingedients",
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        EnterIngredientsScreen(barcode: barcode)),
              ),
            ),
          ),
          Card(
            shadowColor: Colors.grey,
            elevation: 2.0,
            surfaceTintColor: Colors.green,
            child: ListTile(
              leading: Icon(Icons.eco),
              title: Text(
                "Enter Nutrition",
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NutrientApp(barcode: barcode),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Done"),
      ),
    );
  }
}
