import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class EcoScoreScreen extends StatelessWidget {
  final EcoscoreData ecoScore;
  const EcoScoreScreen({super.key, required this.ecoScore});

  // Function to determine the color based on the Eco-Score
  Color getEcoScoreColor(String score) {
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

  // Function to determine the warning message based on the Eco-Score
  String getEcoScoreWarning(String score) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eco-Score ${ecoScore.grade!.toUpperCase()} '),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: getEcoScoreColor(ecoScore.grade!.toUpperCase())
                    .withOpacity(0.3),
                child: Row(
                  children: [
                    Icon(Icons.eco_outlined),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eco-Score ${ecoScore.grade!.toUpperCase()}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            getEcoScoreWarning(ecoScore.grade!.toUpperCase()),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The full impact of transportation to your country is currently unknown.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'The Eco-Score is an experimental score that summarizes the environmental impacts of food products. The Eco-Score was initially developed for France and it is being extended to other European countries. The Eco-Score formula is subject to change as it is regularly improved to make it more precise and better suited to each country.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.yellow.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Life cycle analysis',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Average impact of products of the same category: C (Score: 57/100)',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Bonuses and maluses',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.error_outline),
                title: Text('Missing origins of ingredients information'),
                subtitle: Text('Malus:'),
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('Ingredients that threaten species'),
                subtitle: Text('Malus: -10'),
              ),
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text('Missing packaging information for this product'),
                subtitle: Text('Malus: -15'),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                color: getEcoScoreColor(ecoScore.grade!.toUpperCase())
                    .withOpacity(0.3),
                child: Row(
                  children: [
                    Icon(Icons.eco_outlined),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Impact for this product: ${ecoScore.score} (Score: ${ecoScore.score}/100)',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Implement the navigation to the Eco-Score information page
                },
                child: Text(
                  'Learn more about the Eco-Score',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
