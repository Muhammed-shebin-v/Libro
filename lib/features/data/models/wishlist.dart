import 'package:flutter/widgets.dart';

class WishlistModel {
  final String bookId;
  final String bookName;
  final String category;
  final String imgUrl;
  final Color color;

  WishlistModel({
    required this.bookId,
    required this.bookName,
    required this.category,
    required this.color,
    required this.imgUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'category': category,
      'color': color.toARGB32(),
      'imgUrl':imgUrl
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      bookId: map['bookId'],
      bookName: map['bookName'],
      category: map['category'],
      color: Color(map['color']),
      imgUrl: map['imgUrl']
    );
  }
}
