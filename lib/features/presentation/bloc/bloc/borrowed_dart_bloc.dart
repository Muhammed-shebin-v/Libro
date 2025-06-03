// Events
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/book.dart';

abstract class UserBorrowEvent {}

class LoadUserBorrowedBooks extends UserBorrowEvent {
  final String userId;
  LoadUserBorrowedBooks(this.userId);
}

// States
abstract class UserBorrowState {}

class UserBorrowInitial extends UserBorrowState {}

class UserBorrowLoading extends UserBorrowState {}

class UserBorrowLoaded extends UserBorrowState {
  final List<BookModel> books;
  UserBorrowLoaded(this.books);
}

class UserBorrowError extends UserBorrowState {
  final String message;
  UserBorrowError(this.message);
}

class UserBorrowBloc extends Bloc<UserBorrowEvent, UserBorrowState> {
  UserBorrowBloc() : super(UserBorrowInitial()) {
    on<LoadUserBorrowedBooks>((event, emit) async {
      emit(UserBorrowLoading());

      try {
        final borrowSnap =
            await FirebaseFirestore.instance
                .collection('borrows')
                .where('userId', isEqualTo: event.userId)
                .get();

        List<BookModel> books = [];

        for (var doc in borrowSnap.docs) {
          final data = doc.data();
          final uid = data['bookId'];
          final bookSnap =
              await FirebaseFirestore.instance
                  .collection('books')
                  .doc(uid)
                  .get();
          final bookData = bookSnap.data();

          if (bookData != null) {
            books.add(
              BookModel(
                uid: uid,
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
                borrowDate: (data['borrowDate'] as Timestamp).toDate(),
                returnDate: (data['returnDate'] as Timestamp).toDate(),
                fine: data['fine'] ?? 0,
              ),
            );
          }
        }

        emit(UserBorrowLoaded(books));
      } catch (e) {
        emit(UserBorrowError('Failed to load borrowed books: $e'));
      }
    });
  }
}
