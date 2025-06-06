import 'package:libro/features/data/models/book.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookModel> books;
  final BookModel? selectedBook;

  BookLoaded(this.books, {this.selectedBook});
}

class BookError extends BookState {
  final String message;
  BookError(this.message);
}

class BookUploaded extends BookState {}

