// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> showImagePickerOption(BuildContext context) {
  Completer<String?> completer = Completer<String?>();

  showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      String? imagePath = await _pickImageFromGallery(context);
                      completer.complete(imagePath);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      String? imagePath = await _pickImageFromCamera(context);
                      completer.complete(imagePath);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
  return completer.future;
}

// Gallery
Future<String?> _pickImageFromGallery(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return null;

  Navigator.of(context).pop(); // Close the modal sheet
  return pickedFile.path;
}

// Camera
Future<String?> _pickImageFromCamera(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile == null) return null;

  Navigator.of(context).pop();
  return pickedFile.path;
}
