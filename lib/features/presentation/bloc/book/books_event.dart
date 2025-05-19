abstract class BookEvent {}

class FetchBooks extends BookEvent {}

class SelectBook extends BookEvent {
  final Map<String, dynamic> book;
  SelectBook(this.book);
}

class PickImagesEvent extends BookEvent {}
class UploadBookEvent extends BookEvent {
  final String title;
  UploadBookEvent(this.title);
}