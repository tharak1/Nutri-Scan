import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/services.dart';

class NutritionFactsScreen extends StatefulWidget {
  final String barcode;
  const NutritionFactsScreen({super.key, required this.barcode});
  @override
  State<NutritionFactsScreen> createState() => _NutritionFactsScreenState();
}

class _NutritionFactsScreenState extends State<NutritionFactsScreen> {
  final Map<String, TextEditingController> controllers = {
    'energyKJ': TextEditingController(),
    'energyKcal': TextEditingController(),
    'fat': TextEditingController(),
    'saturatedFat': TextEditingController(),
    'carbohydrates': TextEditingController(),
    'sugars': TextEditingController(),
    'fiber': TextEditingController(),
    'proteins': TextEditingController(),
    'salt': TextEditingController(),
  };

  String servingSize = 'per 100g';

  void saveData() {
    final Map<String, String> parameterMap = {};
    controllers.forEach((key, controller) {
      String formattedKey = key;
      if (servingSize == 'per serving') {
        formattedKey = '${key}_serving';
      }
      parameterMap['nutriment_$formattedKey'] = controller.text;
      addNutrientsToProduct(
          parameterMap: parameterMap, barcode: widget.barcode);
    });

    // Remove '_per100g' and '_serving' suffixes from keys if present
    final Map<String, String> cleanedParameterMap = {};
    parameterMap.forEach((key, value) {
      PerSize.values.forEach((option) {
        final int pos = key.indexOf('_${option.offTag}');
        if (pos != -1) {
          key = key.substring(0, pos);
        }
      });
      cleanedParameterMap[key] = value;
    });

    // Upload cleanedParameterMap to the server
    print(cleanedParameterMap);
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Facts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Unknown product name, Unknown brand'),
            SwitchListTile(
              title: Text('Nutrition facts are not specified on the product'),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Nutrition facts photo'),
              leading: Icon(Icons.camera_alt),
              onTap: () {},
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Serving size'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('per 100g'),
                Switch(
                  value: servingSize == 'per 100g',
                  onChanged: (value) {
                    setState(() {
                      servingSize = value ? 'per 100g' : 'per serving';
                    });
                  },
                ),
                Text('per serving'),
              ],
            ),
            ...controllers.keys.map((key) {
              return TextField(
                controller: controllers[key],
                decoration: InputDecoration(
                  labelText: _formatLabel(key),
                  suffixText: key == 'energyKJ'
                      ? 'kJ'
                      : key == 'energyKcal'
                          ? 'kcal'
                          : 'g',
                ),
                keyboardType: TextInputType.number,
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLabel(String key) {
    switch (key) {
      case 'energyKJ':
        return 'Energy (kJ)';
      case 'energyKcal':
        return 'Energy (kcal)';
      case 'fat':
        return 'Fat';
      case 'saturatedFat':
        return 'Saturated fat';
      case 'carbohydrates':
        return 'Carbohydrates';
      case 'sugars':
        return 'Sugars';
      case 'fiber':
        return 'Fiber';
      case 'proteins':
        return 'Proteins';
      case 'salt':
        return 'Salt';
      default:
        return '';
    }
  }
}

enum PerSize {
  per100g('per 100g'),
  perServing('per serving');

  final String offTag;

  const PerSize(this.offTag);
}
