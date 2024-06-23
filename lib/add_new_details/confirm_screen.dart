import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/add_new_item.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ConfirmScreen extends StatefulWidget {
  final String barcode;
  final Product? product;
  const ConfirmScreen({super.key, required this.barcode, this.product});

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController quantityCategoryController =
      TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if optional parameters are passed and not null
    if (widget.product != null) {
      if (widget.product!.productName != null) {
        nameController.text = widget.product!.productName!;
      }
      if (widget.product!.brands != null) {
        brandController.text = widget.product!.brands!;
      }
      if (widget.product!.quantity != null) {
        // Assuming quantity is in the format "123 g", strip the " g"
        quantityController.text =
            widget.product!.quantity!.replaceAll(RegExp(r' g$'), '');
      }
      if (widget.product!.categories != null) {
        quantityCategoryController.text = widget.product!.categories!;
      }
    }
  }

  Future<void> addNewProduct({
    required String name,
    required String barcode,
    required String brand,
    required String quantity,
    required String quantityCategory,
  }) async {
    setState(() {
      isLoading = true;
    });

    // Define the product to be added.
    Product myProduct = Product(
      barcode: barcode,
      productName: name,
      brands: brand,
      quantity: "$quantity g",
      categories: quantityCategory,
    );

    // A registered user login for https://world.openfoodfacts.org/ is required
    User myUser = User(userId: 'tharak2', password: '#Since2004');

    try {
      // Query the OpenFoodFacts API
      Status result = await OpenFoodAPIClient.saveProduct(myUser, myProduct);

      if (result.status == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewProductPage(barcode: barcode),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product could not be added: ${result.error}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Product"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Add Information for Barcode ${widget.barcode}"),
                    SizedBox(height: 20),
                    Text(
                        "Please make sure that front photo, ingredients photo, nutritional information, and recycle information photos are all taken and cropped."),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Enter the Product Name",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: brandController,
                      decoration: InputDecoration(
                        labelText: "Enter the Brand Name",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: "Enter the Quantity in g",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: quantityCategoryController,
                      decoration: InputDecoration(
                        labelText: "Enter the Category",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewProduct(
            name: nameController.text.trim(),
            barcode: widget.barcode,
            brand: brandController.text.trim(),
            quantity: quantityController.text.trim(),
            quantityCategory: quantityCategoryController.text.trim(),
          );
        },
        child: Text("Continue"),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    nameController.dispose();
    brandController.dispose();
    quantityController.dispose();
    quantityCategoryController.dispose();
    super.dispose();
  }
}
