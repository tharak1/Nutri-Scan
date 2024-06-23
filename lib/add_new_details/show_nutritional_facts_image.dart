import 'package:flutter/material.dart';

class ShowNutritionalFactsImage extends StatelessWidget {
  final String url;
  const ShowNutritionalFactsImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nutrients info"),
      ),
      body: Center(
        child: SizedBox(
          child: Image.network(url),
        ),
      ),
    );
  }
}
