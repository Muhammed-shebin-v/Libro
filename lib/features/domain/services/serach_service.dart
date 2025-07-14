import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro/features/data/models/book.dart';

class SearchService {
  final _booksRef = FirebaseFirestore.instance.collection('books');

  Future<List<BookModel>> loadBooks() async {
    try {
      final snapshot = await _booksRef.get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();

      return books;
    } catch (e, stackTrace) {
      log('SearchService.loadBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> loadAlphabetical() async {
    try {
      final snapshot = await _booksRef.orderBy('bookName').get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      return books;
    } catch (e, stackTrace) {
      log('SearchService.loadAlphabetic error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> loadAlphabeticDesc() async {
    try {
      final snapshot =
          await _booksRef.orderBy('bookName', descending: true).get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      return books;
    } catch (e) {
      log('$e');
      rethrow;
    }
  }

  Future<List<BookModel>> loadLatestBooks() async {
    try {
      final snapshot = await _booksRef.orderBy('date', descending: true).get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      return books;
    } catch (e, stackTrace) {
      log('SearchService.loadLatestBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> loadOldestBooks() async {
    try {
      final snapshot = await _booksRef.orderBy('date').get();
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      log('SearchService.loadOldestBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<BookModel>> filterBooksByCategory(String category) async {
    try {
      final snapshot =
          await _booksRef.where('category', isEqualTo: category).get();

      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      log(
        'SearchService.filterBooksByCategory error: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final snapshot = await _booksRef.get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();

      final lowerQuery = query.toLowerCase();
      return books.where((book) {
        final bookName = book.bookName.toLowerCase();
        final authorName = book.authorName.toLowerCase();
        return bookName.contains(lowerQuery) || authorName.contains(lowerQuery);
      }).toList();
    } catch (e, stackTrace) {
      log('SearchService.searchBooks error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
