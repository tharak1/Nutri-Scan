// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({
    super.key,
    required this.detailslist,
  });
  final Product detailslist;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                detailslist.imageFrontUrl!,
                width: 80, // Specify a width for the image
                height: 80, // Specify a height for the image
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 4,
              ),
              Column(
                children: [
                  Text(
                    detailslist.productName!,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  //const Spacer(),///because of this overflow in card occur.
                  Text(
                    detailslist.brandsTags![0],
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
