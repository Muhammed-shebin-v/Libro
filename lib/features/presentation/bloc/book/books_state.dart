import 'package:libro/features/data/models/book.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Map<String, dynamic>> books;
  final Map<String, dynamic>? selectedBook;

  BookLoaded(this.books, {this.selectedBook});
}

class BookError extends BookState {
  final String message;
  BookError(this.message);
}

class BookUploaded extends BookState {}
class BookSearchInitial extends BookState {}
class BookSearchLoading extends BookState {}
class BookSearchLoaded extends BookState {
  final List<BookModel> results;
  BookSearchLoaded(this.results);
}
class BookSearchError extends BookState {
  final String message;
  BookSearchError(this.message);
}
