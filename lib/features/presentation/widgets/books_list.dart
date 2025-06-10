import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/widgets/book.dart';

class BooksList extends StatelessWidget {
  final String title;
final List<BookModel> books;
  const BooksList({
    super.key,
    required this.title,
required this.books
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.heading3),
        Gap(10),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final BookModel book=books[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QrScanner()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Book(color: Color(0xFFE8E8E8), image: book.imageUrls[0]),
                      Gap(5),
                      SizedBox(
                        width: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                             book.bookName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                             book.authorName,
                              style: AppFonts.body2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              height: 18,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                               book.category,
                                textAlign: TextAlign.center,
                                style: AppFonts.body2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
