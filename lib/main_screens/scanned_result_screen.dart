// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/confirm_screen.dart';
import 'package:flutter_application_1/result_screens/environment_impact_screen.dart';
import 'package:flutter_application_1/result_screens/ingredients_screen.dart';
import 'package:flutter_application_1/result_screens/nova_screen.dart';
import 'package:flutter_application_1/result_screens/nutrient_level_screen.dart';
import 'package:flutter_application_1/result_screens/nutritional_facts_screen.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ScannedResultScreen extends StatefulWidget {
  final Product producDetails;
  const ScannedResultScreen({super.key, required this.producDetails});

  @override
  State<ScannedResultScreen> createState() => _ScannedResultScreenState();
}

class _ScannedResultScreenState extends State<ScannedResultScreen> {
  Color _getIconColor(int novaGroup) {
    if (novaGroup == 0 || novaGroup == 1) {
      return Colors.green;
    } else if (novaGroup == 2 || novaGroup == 3) {
      return Colors.yellow;
    } else if (novaGroup == 3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getStatus(int novaGroup) {
    if (novaGroup == 1) {
      return "Unprocessed or minimally processed foods";
    } else if (novaGroup == 2) {
      return "Processed culinary ingredients";
    } else if (novaGroup == 3) {
      return "Processed foods";
    } else {
      return "Ultra-processed foods";
    }
  }

  Color getEcoScoreColor(String? score) {
    switch (score) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getEcoScoreWarning(String? score) {
    switch (score) {
      case 'A':
        return 'No environmental impact';
      case 'B':
        return 'Low environmental impact';
      case 'C':
        return 'Moderate environmental impact';
      case 'D':
        return 'High environmental impact';
      case 'E':
        return 'Very high environmental impact';
      default:
        return 'Unknown environmental impact';
    }
  }

  String getNutritionalWarning(String? score) {
    switch (score) {
      case 'A':
        return 'Good nutritional quality';
      case 'B':
        return 'Fine nutritional quality';
      case 'C':
        return 'Moderate nutritional quality';
      case 'D':
        return 'Poor nutritional quality';
      case 'E':
        return 'Bad nutritional quality';
      default:
        return 'Unknown nutritional quality';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasMissingDetails = widget.producDetails.productName == null ||
        widget.producDetails.productName!.isEmpty ||
        widget.producDetails.imageFrontUrl == null ||
        widget.producDetails.imageFrontUrl!.isEmpty ||
        widget.producDetails.ingredients == null ||
        widget.producDetails.ingredients!.isEmpty ||
        widget.producDetails.nutriments == null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 2.0,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text('Product Details Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Stack(
              children: [
                widget.producDetails.imageFrontUrl != null
                    ? Image.network(
                        widget.producDetails.imageFrontUrl!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 6,
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 6,
                        color: Colors.grey,
                        child: Icon(Icons.image, size: 50, color: Colors.white),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producDetails.productName ?? 'Unknown Product',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.producDetails.quantity ?? 'Unknown Quantity',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.producDetails.brands ?? 'Unknown Brand',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Card(
                    shadowColor: Colors.grey,
                    elevation: 2.0,
                    surfaceTintColor: Colors.grey,
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.grey),
                      title: Text(
                        "Edit",
                        style: TextStyle(
                            color: getEcoScoreColor(
                                widget.producDetails.nutriscore)),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmScreen(
                              barcode: widget.producDetails.barcode!,
                              product: widget.producDetails,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  if (widget.producDetails.nutriscore != null)
                    Card(
                      shadowColor: Colors.grey,
                      elevation: 2.0,
                      surfaceTintColor:
                          getEcoScoreColor(widget.producDetails.nutriscore),
                      child: ListTile(
                        leading: Icon(Icons.info, color: Colors.grey),
                        title: Text(
                          widget.producDetails.nutritionData!
                              ? 'Missing data to compute the Nutri-Score'
                              : 'Nutritional Score : ${widget.producDetails.nutriscore!}',
                          style: TextStyle(
                              color: getEcoScoreColor(
                                  widget.producDetails.nutriscore)),
                        ),
                      ),
                    ),
                  if (widget.producDetails.ecoscoreGrade != null)
                    Card(
                      shadowColor: Colors.grey,
                      elevation: 2.0,
                      surfaceTintColor: getEcoScoreColor(
                          widget.producDetails.ecoscoreGrade!.toUpperCase()),
                      child: ListTile(
                        leading: Icon(Icons.eco),
                        title: Text(
                          "Eco-score : ${widget.producDetails.ecoscoreGrade!.toUpperCase()} ${getEcoScoreWarning(widget.producDetails.ecoscoreGrade!.toUpperCase())}",
                          style: TextStyle(
                              color: getEcoScoreColor(widget
                                  .producDetails.ecoscoreGrade!
                                  .toUpperCase())),
                        ),
                      ),
                    ),
                  if (widget.producDetails.categories != null)
                    Card(
                      shadowColor: Colors.grey,
                      elevation: 2.0,
                      child: ListTile(
                        leading: Icon(Icons.category),
                        title: Text(
                          "Category ${widget.producDetails.categories}",
                        ),
                      ),
                    ),
                  SizedBox(height: 8),
                  if (widget.producDetails.countries != null)
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 12),
                        SizedBox(width: 8),
                        Text(
                            "Country : ${widget.producDetails.countries!.toUpperCase().split(':')[1]}"),
                      ],
                    ),
                  SizedBox(height: 16),
                  Divider(),
                  ListTile(
                    title: Text('Nutrition'),
                  ),
                  if (widget.producDetails.nutrientLevels != null)
                    ListTile(
                      leading: Icon(Icons.bar_chart, color: Colors.grey),
                      title: Text('Nutrient Levels'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NutrientLevelsWidget(
                              nutrientLevels:
                                  widget.producDetails.nutrientLevels!),
                        ),
                      ),
                    ),
                  if (widget.producDetails.nutriments != null)
                    ListTile(
                      leading: Icon(Icons.quiz_sharp, color: Colors.grey),
                      title: Text('Nutrition facts'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NutrientInfoScreen(
                              nutriments: widget.producDetails.nutriments!),
                        ),
                      ),
                    ),
                  ListTile(
                    title: Text('Ingredients'),
                  ),
                  if (widget.producDetails.ingredients != null)
                    ListTile(
                      leading: Icon(Icons.warning, color: Colors.grey),
                      title: Text(
                          "${widget.producDetails.ingredients!.length} ingredients"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IngredientsScreen(
                            ingredientInfo: widget.producDetails.ingredients!,
                            allergens: widget.producDetails.allergens!,
                          ),
                        ),
                      ),
                    ),
                  ListTile(
                    title: Text('Food Processing'),
                  ),
                  if (widget.producDetails.novaGroup != null)
                    ListTile(
                      leading: Icon(Icons.propane_outlined,
                          color:
                              _getIconColor(widget.producDetails.novaGroup!)),
                      title: Text(
                        "Nova Score : ${widget.producDetails.novaGroup} ${_getStatus(widget.producDetails.novaGroup!)}",
                        style: TextStyle(
                            color:
                                _getIconColor(widget.producDetails.novaGroup!)),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NovaScreen(
                              novaScore:
                                  widget.producDetails.novaGroup.toString()),
                        ),
                      ),
                    ),
                  ListTile(
                    title: Text('Additives'),
                  ),
                  if (widget.producDetails.additives != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("Additives"),
                        ),
                        SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              widget.producDetails.additives!.names.length,
                              (index) => ListTile(
                                leading: Icon(Icons.warning_amber,
                                    color: Colors.grey),
                                title: Text(
                                  widget.producDetails.additives!.names[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ListTile(
                    title: Text('Ingredient analysis'),
                  ),
                  if (widget.producDetails.ingredientsAnalysisTags != null)
                    if (widget.producDetails.ingredientsAnalysisTags!
                            .palmOilFreeStatus !=
                        null)
                      ListTile(
                        leading: Icon(
                          Icons.water_drop_outlined,
                          color: widget.producDetails.ingredientsAnalysisTags!
                                      .palmOilFreeStatus !=
                                  null
                              ? Colors.red
                              : null, // Default color
                        ),
                        title: Text(
                          "${widget.producDetails.ingredientsAnalysisTags!.palmOilFreeStatus!.name}",
                          style: TextStyle(
                            color: widget.producDetails.ingredientsAnalysisTags!
                                        .palmOilFreeStatus !=
                                    null
                                ? Colors.red
                                : null, // Default color
                          ),
                        ),
                      ),
                  if (widget.producDetails.ingredientsAnalysisTags != null)
                    if (widget.producDetails.ingredientsAnalysisTags!
                            .veganStatus !=
                        null)
                      ListTile(
                        leading: Icon(
                          Icons.energy_savings_leaf,
                          color: widget.producDetails.ingredientsAnalysisTags!
                                      .veganStatus !=
                                  null
                              ? Colors.red
                              : null, // Default color
                        ),
                        title: Text(
                          "${widget.producDetails.ingredientsAnalysisTags!.veganStatus!.name}",
                          style: TextStyle(
                            color: widget.producDetails.ingredientsAnalysisTags!
                                        .palmOilFreeStatus !=
                                    null
                                ? Colors.red
                                : null, // Default color
                          ),
                        ),
                      ),
                  Divider(),
                  ListTile(
                    title: Text('Environment'),
                  ),
                  if (widget.producDetails.ecoscoreGrade != null)
                    Card(
                      shadowColor: Colors.grey,
                      elevation: 2.0,
                      surfaceTintColor: getEcoScoreColor(
                          widget.producDetails.ecoscoreGrade!.toUpperCase()),
                      child: ListTile(
                        leading: Icon(Icons.eco),
                        title: Text(
                          "Eco-score : ${widget.producDetails.ecoscoreGrade!.toUpperCase()} ${getEcoScoreWarning(widget.producDetails.ecoscoreGrade!.toUpperCase())}",
                          style: TextStyle(
                              color: getEcoScoreColor(widget
                                  .producDetails.ecoscoreGrade!
                                  .toUpperCase())),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EcoScoreScreen(
                                ecoScore: widget.producDetails.ecoscoreData!),
                          ),
                        ),
                      ),
                    ),
                  if (hasMissingDetails)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the screen to add a new product
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmScreen(
                                    barcode: widget.producDetails.barcode!),
                              ),
                            );
                          },
                          child: Text('Add New Product'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
