import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro/features/data/models/wishlist.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToWishlist(String userId, WishlistModel model) async {
    try{
 await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(model.bookId)
        .set(model.toMap());
    }catch(e){
      log('Error Occured :$e');
    }
   
  }

  Future<void> removeFromWishlist(String userId, String bookId) async {
     try{ await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(bookId)
        .delete();}catch(e){
      log('Error Occured :$e');
    }
   
  }

  Future<List<WishlistModel>> fetchWishlist(String userId) async {
     try{ final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();

    return snapshot.docs
        .map((doc) => WishlistModel.fromMap(doc.data()))
        .toList();}catch(e){
      log('Error Occured :$e');
      rethrow;
    }
   
  }

  Future<bool> isInWishlist(String userId, String bookId) async {
     try{final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(bookId)
        .get();

    return doc.exists;}catch(e){
      log('Error Occured :$e');
      rethrow;
    }
    
  }
}