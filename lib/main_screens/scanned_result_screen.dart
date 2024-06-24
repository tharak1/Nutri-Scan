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
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.producDetails.imageFrontUrl != null
                  ? Image.network(
                      widget.producDetails.imageFrontUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
              SizedBox(height: 16),
              Text(
                widget.producDetails.productName ?? 'Unknown Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.producDetails.quantity ?? 'Unknown Quantity',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                widget.producDetails.brands ?? 'Unknown Brand',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 16),
              _buildCard(
                context,
                title: 'Edit',
                icon: Icons.edit,
                color: Colors.blue,
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
              if (widget.producDetails.nutriscore != null)
                _buildCard(
                  context,
                  title:
                      'Nutritional Score: ${widget.producDetails.nutriscore!.toUpperCase()}',
                  subtitle: getNutritionalWarning(
                      widget.producDetails.nutriscore!.toUpperCase()),
                  icon: Icons.info,
                  color: getEcoScoreColor(
                      widget.producDetails.nutriscore!.toUpperCase()),
                ),
              if (widget.producDetails.ecoscoreGrade != null)
                _buildCard(
                  context,
                  title:
                      'Eco-score: ${widget.producDetails.ecoscoreGrade!.toUpperCase()}',
                  subtitle: getEcoScoreWarning(
                      widget.producDetails.ecoscoreGrade!.toUpperCase()),
                  icon: Icons.eco,
                  color: getEcoScoreColor(
                      widget.producDetails.ecoscoreGrade!.toUpperCase()),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EcoScoreScreen(
                          ecoScore: widget.producDetails.ecoscoreData!),
                    ),
                  ),
                ),
              if (widget.producDetails.categories != null)
                _buildCard(
                  context,
                  title: 'Category',
                  subtitle: widget.producDetails.categories!,
                  icon: Icons.category,
                  color: Colors.orange,
                ),
              if (widget.producDetails.countries != null)
                _buildRow(
                  icon: Icons.location_on,
                  text:
                      'Country: ${widget.producDetails.countries!.toUpperCase().split(':')[1]}',
                ),
              Divider(),
              _buildSectionTitle('Nutrition'),
              if (widget.producDetails.nutrientLevels != null)
                _buildListTile(
                  context,
                  title: 'Nutrient Levels',
                  icon: Icons.bar_chart,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NutrientLevelsWidget(
                          nutrientLevels: widget.producDetails.nutrientLevels!),
                    ),
                  ),
                ),
              if (widget.producDetails.nutriments != null)
                _buildListTile(
                  context,
                  title: 'Nutrition facts',
                  icon: Icons.quiz_sharp,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NutrientInfoScreen(
                          nutriments: widget.producDetails.nutriments!),
                    ),
                  ),
                ),
              Divider(),
              _buildSectionTitle('Ingredients'),
              if (widget.producDetails.ingredients != null)
                _buildListTile(
                  context,
                  title:
                      '${widget.producDetails.ingredients!.length} ingredients',
                  icon: Icons.warning,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => IngredientsScreen(
                        ingredientInfo: widget.producDetails.ingredients!,
                        allergens: widget.producDetails.allergens!,
                      ),
                    ),
                  ),
                ),
              Divider(),
              _buildSectionTitle('Food Processing'),
              if (widget.producDetails.novaGroup != null)
                _buildCard(
                  context,
                  title: 'Nova Score: ${widget.producDetails.novaGroup}',
                  subtitle: _getStatus(widget.producDetails.novaGroup!),
                  icon: Icons.propane_outlined,
                  color: _getIconColor(widget.producDetails.novaGroup!),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NovaScreen(
                          novaScore: widget.producDetails.novaGroup.toString()),
                    ),
                  ),
                ),
              Divider(),
              _buildSectionTitle('Additives'),
              if (widget.producDetails.additives != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.producDetails.additives!.names.length,
                    (index) => ListTile(
                      leading: Icon(Icons.warning_amber, color: Colors.grey),
                      title: Text(
                        widget.producDetails.additives!.names[index],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              Divider(),
              _buildSectionTitle('Ingredient analysis'),
              if (widget.producDetails.ingredientsAnalysisTags != null)
                if (widget.producDetails.ingredientsAnalysisTags!
                        .palmOilFreeStatus !=
                    null)
                  _buildCard(
                    context,
                    title: widget.producDetails.ingredientsAnalysisTags!
                        .palmOilFreeStatus!.name,
                    icon: Icons.water_drop_outlined,
                    color: Colors.red,
                  ),
              if (widget.producDetails.ingredientsAnalysisTags != null)
                if (widget.producDetails.ingredientsAnalysisTags!.veganStatus !=
                    null)
                  _buildCard(
                    context,
                    title: widget.producDetails.ingredientsAnalysisTags!
                        .veganStatus!.name,
                    icon: Icons.energy_savings_leaf,
                    color: Colors.red,
                  ),
              Divider(),
              _buildSectionTitle('Environment'),
              if (widget.producDetails.ecoscoreGrade != null)
                _buildCard(
                  context,
                  title:
                      'Eco-score: ${widget.producDetails.ecoscoreGrade!.toUpperCase()}',
                  subtitle: getEcoScoreWarning(
                      widget.producDetails.ecoscoreGrade!.toUpperCase()),
                  icon: Icons.eco,
                  color: getEcoScoreColor(
                      widget.producDetails.ecoscoreGrade!.toUpperCase()),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EcoScoreScreen(
                          ecoScore: widget.producDetails.ecoscoreData!),
                    ),
                  ),
                ),
              if (hasMissingDetails)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      String? subtitle,
      required IconData icon,
      required Color color,
      VoidCallback? onTap}) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: color),
              )
            : null,
        trailing: onTap != null ? Icon(Icons.arrow_forward_ios) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title, required IconData icon, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: onTap != null ? Icon(Icons.arrow_forward_ios) : null,
      onTap: onTap,
    );
  }

  Widget _buildRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.red, size: 12),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
