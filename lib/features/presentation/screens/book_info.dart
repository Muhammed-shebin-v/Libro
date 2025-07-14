import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/wishlist.dart';
import 'package:libro/features/domain/services/borrow.dart';
import 'package:libro/features/presentation/widgets/book_carousal.dart';
import 'package:libro/features/presentation/widgets/book_details.dart';
import 'package:libro/features/presentation/widgets/book_review.dart';
import 'package:libro/features/presentation/widgets/wish_button.dart';


class BookInfo extends StatelessWidget {
  final BookModel book;
  final String userid;
  const BookInfo({super.key, required this.book, required this.userid});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        shadowColor: AppColors.color60,
        actions: [
          WishlistIconButton(userId: userid, wishlist: WishlistModel(bookId: book.uid, bookName: book.bookName, category: book.category,color: book.color,imgUrl: book.imageUrls.first)),
          IconButton(
            onPressed: () {
              BorrowService().borrowBook(
                userId: userid,
                bookId: book.uid,
                context: context,
              );
            },
            icon: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Gap(20),
              SizedBox(
                height: 980,
                child: Stack(
                  children: [
                    CustomBookDetails(book: book,userId: userid,),
                    BookReview(bookId: book.uid,),
                    BookCarousal(book: book),
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
