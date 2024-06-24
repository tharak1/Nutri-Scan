import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/imageselection.dart';
import 'package:flutter_application_1/util/services.dart';

class ImageSelectionScreen extends StatefulWidget {
  final String type;
  final String barcode;
  const ImageSelectionScreen({
    super.key,
    required this.type,
    required this.barcode,
  });

  @override
  State<ImageSelectionScreen> createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  String imagePath = "";
  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: Text('Add ${widget.type.toLowerCase()} Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                String? dummy = await showImagePickerOption(context);
                setState(() {
                  if (dummy != null) {
                    imagePath = dummy;
                  }
                });
              },
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: imagePath != ''
                    ? Image(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/fileadd.jpg',
                        scale: 1.8,
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text('Add Picture of Product\'s ingredients '),
            SizedBox(height: 20),
            // Show loading indicator or button based on isLoading state
            isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Set loading state to true
                      });
                      try {
                        addProductImage(
                            barcode: widget.barcode,
                            imagePath: imagePath,
                            type: widget.type);
                        // Reset imagePath after successful submission if needed
                        setState(() {
                          imagePath = '';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Image uploaded successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to upload image: $e'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } finally {
                        setState(() {
                          isLoading = false; // Set loading state back to false
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
