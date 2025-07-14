import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/review_model.dart';

class BooksService {
  Future<List<BookModel>> fetchUserBorrowedBooks(String userId) async {
    try {
      final borrowSnap =
          await FirebaseFirestore.instance
              .collection('borrows')
              .where('userId', isEqualTo: userId)
              .where('status', whereNotIn: ['returned'])
              .get();

      List<BookModel> books = [];

      for (var doc in borrowSnap.docs) {
        final data = doc.data();
        final borrowId = doc.id;
        final bookId = data['bookId'];

        final bookSnap =
            await FirebaseFirestore.instance
                .collection('books')
                .doc(bookId)
                .get();

        final bookData = bookSnap.data();
        if (bookData != null) {
          books.add(
            BookModel(
              uid: bookId,
              currentStock: bookData['currentStock'] ?? 0,
              color: Color(bookData['color']),
              readers: bookData['readers'],
              bookId: bookData['bookId'] ?? '',
              bookName: bookData['bookName'] ?? '',
              authorName: bookData['authorName'] ?? '',
              description: bookData['description'] ?? '',
              category: bookData['category'] ?? '',
              pages: bookData['pages'] ?? '',
              stocks: bookData['stocks'] ?? '',
              location: bookData['location'] ?? '',
              imageUrls: List<String>.from(bookData['imageUrls'] ?? []),
              borrowId: borrowId,
              borrowDate: (data['borrowDate'] as Timestamp).toDate(),
              returnDate: (data['returnDate'] as Timestamp).toDate(),
              fine: data['fine'] ?? 0,
              status: data['status'] ?? '',
            ),
          );
        }
      }

      return books;
    } catch (e, stack) {
      log('fetchUserBorrowedBooks error: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<List<BookModel>> fetchReturnedBooksByUser(String userId) async {
    try {
      final borrowSnapshot =
          await FirebaseFirestore.instance
              .collection('borrows')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'returned')
              .get();

      List<BookModel> books = [];

      for (var doc in borrowSnapshot.docs) {
        final borrowData = doc.data();
        final borrowId = doc.id;
        final bookId = borrowData['bookId'];

        final bookSnapshot =
            await FirebaseFirestore.instance
                .collection('books')
                .doc(bookId)
                .get();

        final bookData = bookSnapshot.data();

        if (bookData != null) {
          books.add(
            BookModel(
              uid: bookId,
              currentStock: bookData['currentStock'] ?? 0,
              color: Color(bookData['color']),
              readers: bookData['readers'],
              bookId: bookData['bookId'] ?? '',
              bookName: bookData['bookName'] ?? '',
              authorName: bookData['authorName'] ?? '',
              description: bookData['description'] ?? '',
              category: bookData['category'] ?? '',
              pages: bookData['pages'] ?? '',
              stocks: bookData['stocks'] ?? '',
              location: bookData['location'] ?? '',
              imageUrls: List<String>.from(bookData['imageUrls'] ?? []),
              borrowId: borrowId,
              borrowDate: (borrowData['borrowDate'] as Timestamp).toDate(),
              returnDate: (borrowData['returnDate'] as Timestamp).toDate(),
              fine: borrowData['fine'] ?? 0,
              status: borrowData['status'] ?? '',
            ),
          );
        }
      }

      return books;
    } catch (e, stack) {
      log('fetchReturnedBooksByUser error: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<void> addReview({
    required String bookId,
    required Map<String, dynamic> reviewData,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(bookId)
          .collection('reviews')
          .add(reviewData);
    } catch (e, stackTrace) {
      log('addReview error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> fetchAllBooks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();

      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      log('BookService.fetchAllBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> fetchHistoryBooks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where('category', isEqualTo: 'history')
              .get();
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      log('BookService.fetchAllBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
   Future<List<BookModel>> fetchNovelBooks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where('category', isEqualTo: 'novel')
              .get();
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      log('BookService.fetchAllBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<ReviewModel>> fetchReviews(String bookId) async {
    try {
      log(bookId);
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .doc(bookId)
              .collection('reviews')
              .get();
      log("Number of reviews: ${snapshot.docs.length}");
      final reviews =
          snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data())).toList();
      return reviews;
    } catch (e) {
      log('error in loading reviews :$e');
      rethrow;
    }
  }

  Future<ReviewModel?> fetchLatestReview(String bookId) async {
    try{
      final snapshot =
        await FirebaseFirestore.instance
            .collection('books')
            .doc(bookId)
            .collection('reviews')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return ReviewModel.fromMap(snapshot.docs.first.data());
    } else {
      return null;
    }
    }catch(e){
      log('error happended in fetching latest review : $e');
      rethrow;
    }
    
  }
}
