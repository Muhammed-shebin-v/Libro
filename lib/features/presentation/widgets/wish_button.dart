import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/wishlist.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_state.dart';

class WishlistIconButton extends StatelessWidget{
  final String userId;
  final WishlistModel wishlist;

  const WishlistIconButton({
    super.key,
    required this.userId,
    required this.wishlist
  });

  @override
  Widget build(BuildContext context) {
    log(wishlist.bookId);
    log(userId);
    return BlocProvider(
      create: (_) => WishlistBloc()..add(CheckWishlistStatus(userId, wishlist.bookId)),
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          bool isWishlisted = false;
          if (state is WishlistStatusChecked) {
            isWishlisted = state.isWishlisted;
          }
          return InkWell(
            child: IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                if (isWishlisted) {
                  log('clicked');
                   context.read<WishlistBloc>().add(RemoveWishlist(userId, wishlist.bookId));
                } else {
                   log('clicked');
                   context.read<WishlistBloc>().add(AddWishlist(userId, wishlist));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
final List<BookModel> dummybooks = [
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: ['https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg'],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: ['https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg'],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: ['https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg'],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: ['https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg'],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
];