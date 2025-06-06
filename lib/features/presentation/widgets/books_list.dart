import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/widgets/book.dart';

class BooksList extends StatelessWidget {
  final String title;
  final List books;
  final List images;
  final List authors;
  final List gonores;
  // final List colors;
   const BooksList({super.key,required this.title,required this.books,required this.images,required this.authors,required this.gonores,
  //  required this.colors
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
          itemCount:books.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>QrScanner()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Book(
                    color: Color(0xFFE8E8E8),
                    image: images[index],),
                    Gap(5),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            books[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            authors[index],
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
                              gonores[index],
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
