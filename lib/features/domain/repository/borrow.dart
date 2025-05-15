import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BorrowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> borrowBook({
    required String userId,
    required String bookId,
    required BuildContext context,
  }) async {
    try {
      showLoadingDialogBorrow(context);
      log('Borrowing book with ID: $bookId for user with ID: $userId');
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        log("User not found");
        throw Exception("User not found");
      }

      final userData = userDoc.data()!;
      final bool isBlocked = userData['isBlock'] ?? false;

      if (isBlocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are blocked from borrowing books")),
        );
        log("User is blocked");
        return;
      }
      final borrowDate = DateTime.now();
      final returnDate = borrowDate.add(Duration(days: 10));
      final fine = 0;
      final borrowId = _firestore.collection('borrows').doc().id;
      log("Borrow ID: $borrowId");
      final borrowData = {
        'userId': userId,
        'bookId': bookId,
        'borrowDate': borrowDate,
        'returnDate': returnDate,
        'fine': fine,
      };

      WriteBatch batch = _firestore.batch();
      log("Batch created");
      final userBorrowRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('borrows')
          .doc(borrowId);
      batch.set(userBorrowRef, {'borrowId': borrowId});

      log("User borrow reference: $userBorrowRef");
      final mainBorrowRef = _firestore.collection('borrows').doc(borrowId);
      batch.set(mainBorrowRef, borrowData);
      final bookBorrowRef = _firestore
          .collection('books')
          .doc(bookId)
          .collection('borrows')
          .doc(borrowId);
      batch.set(bookBorrowRef, {'borrowId': borrowId});
      log("Main borrow reference: $mainBorrowRef");
      final newScore = (userData['score'] ?? 0) + 100;
      final userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {'score': newScore});
      await batch.commit();
      Navigator.pop(context);
      log("Batch commit successful");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
        content: Text("Book borrowed successfully"),
        backgroundColor: Colors.green,
        ));
      log("Book borrowed successfully");
    } catch (e) {
      debugPrint("Error borrowing book: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to borrow book")));
    }
  }

  void showLoadingDialogBorrow(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }
}
