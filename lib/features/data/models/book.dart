import 'package:flutter/widgets.dart';

class BookModel {
  final String uid;
  final String bookName;
  final String bookId;
  final String authorName;
  final String description;
  final String category;
  final int pages;
  final int stocks;
  final String location;
  final Color color;
  final int readers;
  final List<String> imageUrls;
  final DateTime? borrowDate;
  final DateTime? returnDate;
  final int? fine;
  final String? status;
  final int currentStock;








  

  BookModel({
    required this.bookName,
    required this.bookId,
    required this.authorName,
    required this.description,
    required this.category,
    required this.pages,
    required this.stocks,
    required this.location,
    required this.imageUrls,
    required this.uid, 
    required this.currentStock,
    required this.color,
    required this.readers,
    this.borrowDate,
    this.returnDate,
    this.fine,
    this.status
  });


  factory BookModel.fromMap(Map<String, dynamic> data) {
    return BookModel(
      uid: data['uid']??'',
      bookName: data['bookName'] ?? '',
      bookId: data['bookId'] ?? '',
      authorName: data['authorName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      pages: data['pages'] ?? 0,
      stocks: data['stocks'] ?? 0,
      location: data['location'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      currentStock: data['currentStock']??0,
      color: Color(data['color']),
       readers: data['readers']??0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookname': bookName,
      'bookId': bookId,
      'authorName': authorName,
      'description': description,
      'category': category,
      'pages': pages,
      'stocks': stocks,
      'location': location,
      'imageUrls': imageUrls,
    };
  }
}