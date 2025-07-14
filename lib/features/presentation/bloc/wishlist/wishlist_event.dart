import 'package:libro/features/data/models/wishlist.dart';

abstract class WishlistEvent {}

class AddWishlist extends WishlistEvent {
  final String userId;
  final WishlistModel model;
  AddWishlist(this.userId, this.model);
}

class RemoveWishlist extends WishlistEvent {
  final String userId;
  final String bookId;
  RemoveWishlist(this.userId, this.bookId);
}

class FetchWishlist extends WishlistEvent {
  final String userId;
  FetchWishlist(this.userId);
}

class CheckWishlistStatus extends WishlistEvent {
  final String userId;
  final String bookId;
  CheckWishlistStatus(this.userId, this.bookId);
}