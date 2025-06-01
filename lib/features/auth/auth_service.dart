import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> createUser(String email, String password) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (e) {
      log('Error in creating user: $e');
      return null;
    }
  }

  //  fetchUserData(String uid) async {
  //   final snapshot = await _firestore.collection('users').doc(uid).get();
  //   if (snapshot.exists) {
  //     final user = UserModel.fromDocument(snapshot);
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('uid', user.uid!);
  //     await prefs.setString('username', user.username!);
  //     await prefs.setString('fullName', user.fullName);
  //     await prefs.setString('email', user.email);
  //     await prefs.setString('phone', user.phoneNumber);
  //     await prefs.setString('address', user.address);
  //     await prefs.setString('imgUrl', user.imgUrl);
  //     await prefs.setString('createdDate', user.createdAt);
  //     await prefs.setBool('isBlock', user.isBlock!);
  //     await prefs.setInt('score', user.score!);
  //     log('User data: ${user.toString()}');
  //   } else {
  //     throw Exception("User data not found.");
  //   }
  // }

  Future<User?> signIn(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (e) {
      log('Error in creating user: $e');
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error in signing out: $e');
    }
  }
}
