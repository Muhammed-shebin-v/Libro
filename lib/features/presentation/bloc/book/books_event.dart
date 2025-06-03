import 'package:libro/features/data/models/book.dart';

abstract class BookEvent {}

class FetchBooks extends BookEvent {}

class SelectBook extends BookEvent {
  final BookModel book;
  SelectBook(this.book);
}

class PickImagesEvent extends BookEvent {}
class UploadBookEvent extends BookEvent {
  final String title;
  UploadBookEvent(this.title);
}






