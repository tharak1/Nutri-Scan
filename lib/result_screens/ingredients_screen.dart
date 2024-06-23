// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class IngredientsScreen extends StatelessWidget {
  final List<Ingredient> ingredientInfo;
  final Allergens allergens;

  const IngredientsScreen(
      {super.key, required this.ingredientInfo, required this.allergens});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredients"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.food_bank, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '${ingredientInfo.length} Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.height /
                    2, // Adjust height as necessary
                child: ListView.builder(
                  itemCount: ingredientInfo.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredientInfo[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ingredient.text ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                          if (ingredient.percent != null) ...[
                            SizedBox(height: 4),
                            Text(
                              '(${ingredient.percent}%)',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${allergens.names.length} Allergens',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.height /
                    2, // Adjust height as necessary
                child: ListView.builder(
                  itemCount: allergens.names.length,
                  itemBuilder: (context, index) {
                    final allergen = allergens.names[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        allergen,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
