

import 'package:libro/features/data/models/wishlist.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistModel> wishlist;
  WishlistLoaded(this.wishlist);
}

class WishlistStatusChecked extends WishlistState {
  final bool isWishlisted;
  WishlistStatusChecked(this.isWishlisted);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}


