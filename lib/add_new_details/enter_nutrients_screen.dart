// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutrientApp extends StatelessWidget {
  final String barcode;
  const NutrientApp({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Nutrients'),
      ),
      body: NutrientForm(
        barcode: barcode,
      ),
    );
  }
}

class NutrientForm extends StatefulWidget {
  final String barcode;
  const NutrientForm({super.key, required this.barcode});

  @override
  State<NutrientForm> createState() => _NutrientFormState();
}

class _NutrientFormState extends State<NutrientForm> {
  final Map<Nutrient, TextEditingController> _controllers = {
    Nutrient.energyKJ: TextEditingController(),
    Nutrient.energyKCal: TextEditingController(),
    Nutrient.fat: TextEditingController(),
    Nutrient.saturatedFat: TextEditingController(),
    Nutrient.carbohydrates: TextEditingController(),
    Nutrient.sugars: TextEditingController(),
    Nutrient.fiber: TextEditingController(),
    Nutrient.salt: TextEditingController(),
    Nutrient.cholesterol: TextEditingController(),
    Nutrient.proteins: TextEditingController(),
  };

  final Map<Nutrient, String> _units = {
    Nutrient.energyKJ: 'kJ',
    Nutrient.energyKCal: 'kcal',
    Nutrient.fat: 'g',
    Nutrient.saturatedFat: 'g',
    Nutrient.carbohydrates: 'g',
    Nutrient.sugars: 'g',
    Nutrient.fiber: 'g',
    Nutrient.salt: 'g',
    Nutrient.cholesterol: 'g',
    Nutrient.proteins: 'g',
  };

  bool _per100g = true;
  final TextEditingController _servingSizeController = TextEditingController();

  void _toggleUnit(Nutrient nutrient) {
    setState(() {
      if (nutrient != Nutrient.energyKJ && nutrient != Nutrient.energyKCal) {
        if (_units[nutrient] == 'g') {
          _units[nutrient] = 'mg';
        } else {
          _units[nutrient] = 'g';
        }
      }
    });
  }

  Future<void> _submit() async {
    final nutriments = Nutriments.empty();

    _controllers.forEach((nutrient, controller) {
      final value = double.tryParse(controller.text);
      if (value != null) {
        nutriments.setValue(
          nutrient,
          _per100g ? PerSize.oneHundredGrams : PerSize.serving,
          _units[nutrient] == 'mg' ? value / 1000 : value,
        );
      }
    });

    final barcode = widget.barcode;

    try {
      await addNutrientsToProduct(
        entered_val: nutriments,
        barcode: barcode,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _servingSizeController,
            decoration: InputDecoration(
              labelText: 'Serving size',
            ),
            keyboardType: TextInputType.number,
          ),
          SwitchListTile(
            title: Text(_per100g ? 'per 100g' : 'per serving'),
            value: _per100g,
            onChanged: (value) {
              setState(() {
                _per100g = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                final nutrient = _controllers.keys.elementAt(index);
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controllers[nutrient],
                        decoration: InputDecoration(
                          labelText: '${nutrient.offTag} (${_units[nutrient]})',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () => _toggleUnit(nutrient),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

Future<void> addNutrientsToProduct({
  required Nutriments entered_val,
  required String barcode,
}) async {
  User myUser = User(userId: 'tharak2', password: '#Since2004');
  Product myProduct = Product(
    barcode: barcode,
    nutriments: entered_val,
  );

  Status result = await OpenFoodAPIClient.saveProduct(myUser, myProduct);

  if (result.status == 1) {
    debugPrint('Product added successfully');
  } else {
    throw Exception('Failed to add product: ${result.error}');
  }
}
