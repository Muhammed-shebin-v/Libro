import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/domain/services/return.dart';
import 'package:libro/features/presentation/screens/home_screen.dart';
import 'package:libro/features/presentation/widgets/book_review.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/borrow_details.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/wish_button.dart';

class BookBorrowedInfo extends StatelessWidget {
  final BookModel bookData;
  final UserModel userData;
  BookBorrowedInfo({super.key, required this.bookData,required this.userData});
  ReturnService _returnService=ReturnService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(backgroundColor: AppColors.color60,actions: [
        IconButton(onPressed: (){
          _returnService.returnBookRquest(bookData,context,userData);
        }, icon: Icon(Icons.replay))
      ],),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Gap(20),

              SizedBox(
                height: 980,
                child: Stack(
                  children: [
                    Positioned(
                      top: 200,
                      left: 0,
                      child: CustomContainer(
                        color: AppColors.color30,
                        radius: BorderRadius.only(
                          topRight: Radius.circular(25),
                        ),
                        shadow: 4,
                        height: 850,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          children: [
                           
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    bookData.bookName,
                                    style: AppFonts.body1,
                                  ),
                                  Text(bookData.authorName),
                                  BorrowDetails(bookData: bookData)

                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        itemCount: bookData.imageUrls.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          final selectedImage = bookData.imageUrls[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100.0,
                            ),
                            child: Container(
                              width: 10,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    BookReview(bookId:bookData.uid)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
