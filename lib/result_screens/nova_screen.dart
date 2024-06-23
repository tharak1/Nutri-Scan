import 'package:flutter/material.dart';

class NovaScreen extends StatelessWidget {
  final String novaScore;
  const NovaScreen({super.key, required this.novaScore});

  @override
  Widget build(BuildContext context) {
    String getNovaDescription(String score) {
      switch (score) {
        case '1':
          return '''Group 1: Unprocessed or minimally processed foods

Unprocessed foods are the edible parts of plants, animals, algae and fungi along with water.

This group also includes minimally processed foods, which are unprocessed foods modified through industrial methods such as the removal of unwanted parts, crushing, drying, fractioning, grinding, pasteurization, non-alcoholic fermentation, freezing, and other preservation techniques that maintain the food's integrity and do not introduce salt, sugar, oils, fats, or other culinary ingredients. Additives are absent in this group.

Examples include fresh or frozen fruits and vegetables, grains, legumes, fresh meat, eggs, milk, plain yogurt, and crushed spices.''';
        case '2':
          return '''Group 2: Processed culinary ingredients

Processed culinary ingredients are derived from group 1 foods or else from nature by processes such as pressing, refining, grinding, milling, and drying. It also includes substances mined or extracted from nature. These ingredients are primarily used in seasoning and cooking group 1 foods and preparing dishes from scratch. They are typically free of additives, but some products in this group may include added vitamins or minerals, such as iodized salt.

Examples include oils produced through crushing seeds, nuts, or fruits (such as olive oil), salt, sugar, vinegar, starches, honey, syrups extracted from trees, butter, and other substances used to season and cook.''';
        case '3':
          return '''Group 3: Processed foods

Processed foods are relatively simple food products produced by adding processed culinary ingredients (group 2 substances) such as salt or sugar to unprocessed (group 1) foods.

Processed foods are made or preserved through baking, boiling, canning, bottling, and non-alcoholic fermentation. They often use additives to enhance shelf life, protect the properties of unprocessed food, prevent the spread of microorganisms, or making them more enjoyable.

Examples include cheese, canned vegetables, salted nuts, fruits in syrup, and dried or canned fish. Breads, pastries, cakes, biscuits, snacks, and some meat products fall into this group when they are made predominantly from group 1 foods with the addition of group 2 ingredients.''';
        case '4':
          return '''Group 4: Ultra-processed foods

Industrially manufactured food products made up of several ingredients (formulations) including sugar, oils, fats and salt (generally in combination and in higher amounts than in processed foods) and food substances of no or rare culinary use (such as high-fructose corn syrup, hydrogenated oils, modified starches and protein isolates). Group 1 foods are absent or represent a small proportion of the ingredients in the formulation. Processes enabling the manufacture of ultra-processed foods include industrial techniques such as extrusion, moulding and pre-frying; application of additives including those whose function is to make the final product palatable or hyperpalatable such as flavours, colourants, non-sugar sweeteners and emulsifiers; and sophisticated packaging, usually with synthetic materials. Processes and ingredients here are designed to create highly profitable (low-cost ingredients, long shelf-life, emphatic branding), convenient (ready-to-(h)eat or to drink), tasteful alternatives to all other Nova food groups and to freshly prepared dishes and meals. Ultra-processed foods are operationally distinguishable from processed foods by the presence of food substances of no culinary use (varieties of sugars such as fructose, high-fructose corn syrup, 'fruit juice concentrates', invert sugar, maltodextrin, dextrose and lactose; modified starches; modified oils such as hydrogenated or interesterified oils; and protein sources such as hydrolysed proteins, soya protein isolate, gluten, casein, whey protein and 'mechanically separated meat') or of additives with cosmetic functions (flavours, flavour enhancers, colours, emulsifiers, emulsifying salts, sweeteners, thickeners and anti-foaming, bulking, carbonating, foaming, gelling and glazing agents) in their list of ingredients.''';
        default:
          return 'Invalid Nova Score';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Score : $novaScore"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Text(getNovaDescription(novaScore)),
        ),
      ),
    );
  }
}
