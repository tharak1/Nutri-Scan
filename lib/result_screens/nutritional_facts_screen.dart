// import 'package:flutter/material.dart';
// import 'package:openfoodfacts/openfoodfacts.dart';

// class NutrientInfoScreen extends StatelessWidget {
//   final Nutriments nutriments;

//   const NutrientInfoScreen({super.key, required this.nutriments});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Nutrition facts')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Nutritional Facts per 100 g "),
//             Column(
//               children: _buildNutrientRows(),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildNutrientRows() {
//     List<Widget> rows = [];

//     // Add the specific case for Energy as it's computed
//     double? energyKJ = nutriments.getComputedKJ(PerSize.oneHundredGrams);
//     rows.add(_buildNutrientRow('Energy KJ', energyKJ, 'kJ'));

//     double? value =
//         nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
//     rows.add(_buildNutrientRow('Energy Kcal', value, 'kcal'));

//     // Iterate over all Nutrient values
//     for (Nutrient nutrient in Nutrient.values) {
//       if (nutrient != Nutrient.energyKJ && nutrient != Nutrient.energyKCal) {
//         double? value = nutriments.getValue(nutrient, PerSize.oneHundredGrams);
//         if (value != null) {
//           rows.add(_buildNutrientRow(
//               _nutrientName(nutrient), value, _unit(nutrient)));
//         }
//       }
//     }

//     return rows;
//   }

//   String _nutrientName(Nutrient nutrient) {
//     switch (nutrient) {
//       case Nutrient.fat:
//         return 'Fat';
//       case Nutrient.saturatedFat:
//         return 'Saturated fat';
//       case Nutrient.carbohydrates:
//         return 'Carbohydrates';
//       case Nutrient.sugars:
//         return 'Sugars';
//       case Nutrient.fiber:
//         return 'Fiber';
//       case Nutrient.proteins:
//         return 'Proteins';
//       case Nutrient.salt:
//         return 'Salt';
//       default:
//         return nutrient.toString().split('.').last; // Fallback to enum name
//     }
//   }

//   String _unit(Nutrient nutrient) {
//     switch (nutrient) {
//       case Nutrient.energyKJ:
//       case Nutrient.energyKCal:
//         return 'kcal'; // Replace with the appropriate unit
//       case Nutrient.fat:
//       case Nutrient.saturatedFat:
//       case Nutrient.carbohydrates:
//       case Nutrient.sugars:
//       case Nutrient.fiber:
//       case Nutrient.proteins:
//       case Nutrient.salt:
//       default:
//         return 'g'; // Replace with the appropriate unit
//     }
//   }

//   Widget _buildNutrientRow(String name, double? value, String unit) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('$name:', style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(value != null ? '${value.toStringAsFixed(1)} $unit' : 'N/A'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutrientInfoScreen extends StatefulWidget {
  final Nutriments nutriments;

  const NutrientInfoScreen({super.key, required this.nutriments});

  @override
  State<NutrientInfoScreen> createState() => _NutrientInfoScreenState();
}

class _NutrientInfoScreenState extends State<NutrientInfoScreen> {
  bool _per100g = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Facts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(_per100g ? 'Per 100 g' : 'Per serving'),
              value: _per100g,
              onChanged: (value) {
                setState(() {
                  _per100g = value;
                });
              },
            ),
            Expanded(
              child: ListView(
                children: _buildNutrientRows(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNutrientRows() {
    List<Widget> rows = [];
    PerSize perSize = _per100g ? PerSize.oneHundredGrams : PerSize.serving;

    // Add the specific case for Energy as it's computed
    double? energyKJ = widget.nutriments.getComputedKJ(perSize);
    rows.add(_buildNutrientRow('Energy KJ', energyKJ, 'kJ'));

    double? energyKCal =
        widget.nutriments.getValue(Nutrient.energyKCal, perSize);
    rows.add(_buildNutrientRow('Energy Kcal', energyKCal, 'kcal'));

    // Iterate over all Nutrient values
    for (Nutrient nutrient in Nutrient.values) {
      if (nutrient != Nutrient.energyKJ && nutrient != Nutrient.energyKCal) {
        double? value = widget.nutriments.getValue(nutrient, perSize);
        rows.add(
            _buildNutrientRow(_nutrientName(nutrient), value, _unit(nutrient)));
      }
    }

    return rows;
  }

  String _nutrientName(Nutrient nutrient) {
    switch (nutrient) {
      case Nutrient.fat:
        return 'Fat';
      case Nutrient.saturatedFat:
        return 'Saturated fat';
      case Nutrient.carbohydrates:
        return 'Carbohydrates';
      case Nutrient.sugars:
        return 'Sugars';
      case Nutrient.fiber:
        return 'Fiber';
      case Nutrient.proteins:
        return 'Proteins';
      case Nutrient.salt:
        return 'Salt';
      default:
        return nutrient.toString().split('.').last; // Fallback to enum name
    }
  }

  String _unit(Nutrient nutrient) {
    switch (nutrient) {
      case Nutrient.energyKJ:
        return 'kJ';
      case Nutrient.energyKCal:
        return 'kcal';
      case Nutrient.fat:
      case Nutrient.saturatedFat:
      case Nutrient.carbohydrates:
      case Nutrient.sugars:
      case Nutrient.fiber:
      case Nutrient.proteins:
      case Nutrient.salt:
      default:
        return 'g'; // Replace with the appropriate unit
    }
  }

  Widget _buildNutrientRow(String name, double? value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value != null
              ? '${value.toStringAsFixed(1)} $unit'
              : 'Data not present'),
        ],
      ),
    );
  }
}
