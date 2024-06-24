import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_details/image_selection_screen.dart';

class AddImageWidget extends StatelessWidget {
  final String text;
  final String imageUploadType;
  final String barcode;
  const AddImageWidget(
      {super.key,
      required this.text,
      required this.imageUploadType,
      required this.barcode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageSelectionScreen(
                          type: imageUploadType,
                          barcode: barcode,
                        )));
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.brown[200]!),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.brown),
          ),
          icon: Icon(Icons.camera_alt, color: Colors.brown),
          label: Text(text),
        ),
      ),
    );
  }
}
