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
      final bookDoc = await _firestore.collection('books').doc(bookId).get();

      if (!userDoc.exists) {
        log("User not found");
        throw Exception("User not found");
      }

      final userData = userDoc.data()!;
      final bool isBlocked = userData['isBlock'] ?? false;
      final bookData=bookDoc.data();
      // boook = collections(borrows).where(bookid == bookId).&& (usrid ==usreid) ====false
      // subscription = collection(users).(usrid).(borrowlimit)>0===true;


      if (isBlocked) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are blocked from borrowing books")),
        );
        log("User is blocked");
        return;
      }if (bookData!['stocks']<=0) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("book is not available")),
        );
        log("stock out");
        return;
      }
      final borrowDate = DateTime.now();
      final returnDate = borrowDate.add(Duration(days: 10));
      final fine = 0;
      final borrowId = _firestore.collection('borrows').doc().id;
      final borrowData = {
        'userId': userId,
        'bookId': bookId,
        'borrowDate': borrowDate.toIso8601String(),
        'returnDate': returnDate.toIso8601String(),
        'fine': fine,
        
      };

      WriteBatch batch = _firestore.batch();
      final userBorrowRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('borrows')
          .doc(borrowId);
      batch.set(userBorrowRef, {'borrowId': borrowId});

      final mainBorrowRef = _firestore.collection('borrows').doc(borrowId);
      batch.set(mainBorrowRef, borrowData);
      final bookBorrowRef = _firestore
          .collection('books')
          .doc(bookId)
          .collection('borrows')
          .doc(borrowId);
          batch.set(bookBorrowRef, {'borrowId': borrowId});

      final newScore = (userData['score'] ?? 0) + 100;
      final newStock=(bookData['stocks']??0)-1;
      final newReaders=(bookData['readers']??0)+1;
      final userRef = _firestore.collection('users').doc(userId);
      final bookRef = _firestore.collection('books').doc(bookId);
      batch.update(bookRef, {'stocks':newStock});
      batch.update(bookRef, {'readers':newReaders});
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

      // user count =userid.borrowcount -1;
      // book readers= bookid.readers +1'
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
