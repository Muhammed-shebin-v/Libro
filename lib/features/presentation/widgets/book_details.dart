import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class CustomBookDetails extends StatelessWidget {
  final BookModel book;
  const CustomBookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150,
      left: 0,
      child: CustomContainer(
        color: AppColors.color30,
        radius: BorderRadius.only(topRight: Radius.circular(25)),
        shadow: 4,
        height: 850,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark,
                    color: const Color.fromARGB(255, 255, 136, 0),
                    size: 35,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(book.bookName, style: AppFonts.body1),
                  Text(book.authorName),
                  CustomContainer(
                    color: AppColors.color60,
                    radius: BorderRadius.circular(25),
                    shadow: 3,
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('4.6 *'),
                        VerticalDivider(color: Colors.black),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  book.currentStock > 0
                                      ? 'available'
                                      : 'notAvailable',
                                ),

                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      7,
                                      255,
                                      36,
                                    ),
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ],
                            ),
                            Text('${book.pages} • ${book.category}'),
                          ],
                        ),
                        VerticalDivider(color: Colors.black),
                        Text(
                          '${book.readers} readers',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Gap(20),
                  Text(
                    book.description,
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [Icon(Icons.location_pin), Text(book.location)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
