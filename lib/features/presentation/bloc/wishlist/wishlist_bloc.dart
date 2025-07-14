

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/wishlist.dart';
import 'package:libro/features/domain/services/wishlist.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_state.dart';




class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistService _service = WishlistService();

  WishlistBloc() : super(WishlistInitial()) {
    on<AddWishlist>(_onAddWishlist);
    on<RemoveWishlist>(_onRemoveWishlist);
    on<FetchWishlist>(_onFetchWishlist);
    on<CheckWishlistStatus>(_onCheckStatus);
  }

  Future<void> _onAddWishlist(AddWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _service.addToWishlist(event.userId, event.model);
      log('added to wishlist');
      emit(WishlistStatusChecked(true));
    } catch (e) {
      log(e.toString());
      emit(WishlistError('Failed to add to wishlist'));
    }
  }

  Future<void> _onRemoveWishlist(RemoveWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _service.removeFromWishlist(event.userId, event.bookId);
      log('removed from wishlist');
      emit(WishlistStatusChecked(false));
    } catch (e) {
      emit(WishlistError('Failed to remove from wishlist'));
    }
  }

  Future<void> _onFetchWishlist(FetchWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final list = await _service.fetchWishlist(event.userId);
      emit(WishlistLoaded(list));
    } catch (e) {
      log('error ocured :$e');
      emit(WishlistError('Failed to fetch wishlist'));
      
    }
  }

  Future<void> _onCheckStatus(CheckWishlistStatus event, Emitter<WishlistState> emit) async {
    try {
      final exists = await _service.isInWishlist(event.userId, event.bookId);
      log('checked on wishlist');
      emit(WishlistStatusChecked(exists));
    } catch (e) {
      emit(WishlistError('Failed to check wishlist status'));
    }
  }
}