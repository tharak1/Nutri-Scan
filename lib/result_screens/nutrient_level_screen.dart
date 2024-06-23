// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutrientLevelsWidget extends StatelessWidget {
  final NutrientLevels nutrientLevels;

  const NutrientLevelsWidget({super.key, required this.nutrientLevels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrient Levels'),
      ),
      body: ListView(
        children: nutrientLevels.levels.entries.map((entry) {
          String nutrient = entry.key;
          NutrientLevel level = entry.value;

          Color color;
          switch (level) {
            case NutrientLevel.LOW:
              color = Colors.green;
              break;
            case NutrientLevel.MODERATE:
              color = Colors.yellow;
              break;
            case NutrientLevel.HIGH:
              color = Colors.red;
              break;
            default:
              color = Colors.grey;
          }

          return ListTile(
            leading: CircleAvatar(
              radius: 10,
              backgroundColor: color,
            ),
            title: Text('${nutrient.replaceAll('-', ' ').capitalize()}'),
            trailing: Text(level.name),
          );
        }).toList(),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
