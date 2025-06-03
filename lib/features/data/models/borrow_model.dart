import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowModel {
  final String userId;
  final String bookId;
  final DateTime? borrowedDate;
  final DateTime? returnDate;
  final int? fine;
  final String? status;
  BorrowModel({
    required this.userId,
    required this.bookId,
     this.borrowedDate,
     this.returnDate,
     this.fine,
     this.status,
  });

  factory BorrowModel.fromMap(Map<String, dynamic> borrow) {
    return BorrowModel(
      userId: borrow['userId'] ?? '',
      bookId: borrow['bookId'] ?? '',
      borrowedDate: (borrow['borrowedDate'] as Timestamp).toDate(),
      returnDate: (borrow['returnDate'] as Timestamp).toDate(),
      fine: borrow['fine'] ?? 0,
      status: borrow['status'] ?? 0,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'borrowDate': DateTime.now(),
      'returnDate': DateTime.now().add(Duration(days: 10)),
      'fine': 0,
      'status': 'borrowed',
    };
  }
}
