abstract class UserBorrowEvent {}

class LoadUserBorrowedBooks extends UserBorrowEvent {
  final String userId;
  LoadUserBorrowedBooks(this.userId);
}
