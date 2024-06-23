import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/services.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class EnterIngredientsScreen extends StatefulWidget {
  final String barcode;

  const EnterIngredientsScreen({Key? key, required this.barcode})
      : super(key: key);

  @override
  State<EnterIngredientsScreen> createState() => _EnterIngredientsScreenState();
}

class _EnterIngredientsScreenState extends State<EnterIngredientsScreen> {
  Product? product;
  bool loading = true;
  bool dataLoading = false;
  bool saving = false; // New state variable
  TextEditingController ingredientsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      Product? fetchedProduct = await getProduct(barcode: widget.barcode);
      setState(() {
        product = fetchedProduct;
        loading = false;
      });
    } catch (e) {
      // Handle error as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 2),
        ),
      );
      debugPrint('Error loading product data: $e');
    }
  }

  Future<void> addIngredients() async {
    setState(() {
      saving = true; // Start saving process
    });
    try {
      addIngredientsToProduct(
        ingredients: ingredientsController.text.trim(),
        barcode: widget.barcode,
      );
      // Clear loading state after successful save
      setState(() {
        saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ingredients added successfully "),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle error as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 2),
        ),
      );
      debugPrint('Error adding ingredients: $e');
      setState(() {
        saving = false; // Clear loading state on error too
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredients"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  if (product != null && product!.imageIngredientsUrl != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(product!.imageIngredientsUrl!),
                    ),
                  ElevatedButton(
                    onPressed: dataLoading
                        ? null
                        : () async {
                            setState(() {
                              dataLoading = true;
                            });
                            try {
                              String? ingredients = await extractIngredient(
                                  barcode: widget.barcode);
                              debugPrint(
                                  ingredients ?? 'Ingredients not found');
                              setState(() {
                                ingredientsController.text = ingredients ?? '';
                                dataLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              debugPrint('Error extracting ingredients: $e');
                              setState(() {
                                dataLoading = false;
                              });
                            }
                          },
                    child: dataLoading
                        ? Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Text("Extract Ingredients"),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: ingredientsController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Type ingredients',
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: saving ? null : addIngredients, // Disable button when saving
        child: saving ? CircularProgressIndicator() : Text("Save"),
      ),
    );
  }
}
