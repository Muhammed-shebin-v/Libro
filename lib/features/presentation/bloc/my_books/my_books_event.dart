abstract class MyBooksEvent {}

class LoadMyBooks extends MyBooksEvent {
  final String userId;
  LoadMyBooks(this.userId);
}
