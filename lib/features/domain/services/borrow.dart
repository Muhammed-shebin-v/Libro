import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libro/features/data/models/borrow_model.dart';

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
      final bookDoc = await _firestore.collection('books').doc(bookId).get();

      if (!userDoc.exists) {
        log("User not found");
        throw Exception("User not found");
      }
      if (!bookDoc.exists) {
        log("User not found");
        throw Exception("User not found");
      }

      final userData = userDoc.data()!;
      final bookData = bookDoc.data();

      final isuserBlocked = isUserBlocked(userData, context);
      final isborrowLimitExceed = isBorrowLimitExceed(userData, context);
      final isbookAlreadyBorrowed = await isBookAlreadyBorrowedBySameUser(
        userId,
        bookId,
        context,
      );
      final isstockOut = isStockOut(bookData, context);
      if (isuserBlocked ||
          isborrowLimitExceed ||
          isbookAlreadyBorrowed ||
          isstockOut) {
        return;
      }

      final borrowId = _firestore.collection('borrows').doc().id;

      final BorrowModel borrowData = BorrowModel(
        userId: userId,
        bookId: bookId,
      );

      WriteBatch batch = _firestore.batch();
      final userBorrowRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('borrows')
          .doc(borrowId);
      batch.set(userBorrowRef, {'borrowId': borrowId});

      final mainBorrowRef = _firestore.collection('borrows').doc(borrowId);
      batch.set(mainBorrowRef, borrowData.toMap());
      final bookBorrowRef = _firestore
          .collection('books')
          .doc(bookId)
          .collection('borrows')
          .doc(borrowId);
      batch.set(bookBorrowRef, {'borrowId': borrowId});

      final newScore = (userData['score'] ?? 0) + 100;
      final newStock = (bookData!['currentStock'] ?? 0) - 1;
      final newReaders = (bookData['readers'] ?? 0) + 1;
      final newLimit = (userData['borrowLimit'] ?? 0) - 1;
      final userRef = _firestore.collection('users').doc(userId);
      final bookRef = _firestore.collection('books').doc(bookId);

      batch.update(userRef, {'borrowLimit': newLimit});
      batch.update(bookRef, {'currentStock': newStock});
      batch.update(bookRef, {'readers': newReaders});
      batch.update(userRef, {'score': newScore});
      await batch.commit();

      Navigator.pop(context);
      log("Batch commit successful");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Book borrowed successfully"),
          backgroundColor: Colors.green,
        ),
      );

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

  bool isUserBlocked(userData, context) {
    final bool isBlocked = userData['isBlock'] ?? false;
    if (isBlocked) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are blocked from borrowing books")),
      );
      log("User is blocked");
      return true;
    }
    return false;
  }

  bool isBorrowLimitExceed(userData, context) {
    if (userData['borrowLimit'] <= 0) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("borrow limit exceed")));
      log("limit out");
      return true;
    }
    return false;
  }

  Future<bool> isBookAlreadyBorrowedBySameUser(userId, bookId, context) async {
    Future<bool> isBookAlreadyBorrowed(String userId, String bookId) async {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('borrows')
              .where('userId', isEqualTo: userId)
              .where('bookId', isEqualTo: bookId)
              .where('status', isEqualTo: 'borrowed')
              .get();

      return querySnapshot.docs.isNotEmpty;
    }

    final bool isborrowed = await isBookAlreadyBorrowed(userId, bookId);
    if (isborrowed) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("book is already borrowed")));
      log("already borrowed");
      return true;
    }
    return false;
  }

  bool isStockOut(bookData, context) {
    if (bookData['currentStock'] <= 0) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("book is not available")));
      log("stock out");
      return true;
    }
    return false;
  }
}
