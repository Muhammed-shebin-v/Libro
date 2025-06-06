import 'package:flutter/material.dart';
import 'package:libro/features/data/models/book.dart';

class BookCarousal extends StatelessWidget {
  final BookModel book;
  const BookCarousal({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: book.imageUrls.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) {
          final selectedImage = book.imageUrls[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Container(
              width: 10,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(selectedImage, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
