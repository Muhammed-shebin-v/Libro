import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro/features/data/models/book.dart';


class UserModel {
  final String? uid;
  final String? username;
  final String? email;
  final String? place;
  final String? phoneNumber;
  final String?imgUrl;
  final DateTime? createdAt;
  final bool? isBlock;
  final int? score;
  final String? subscriptionType;
  final int? borrowLimit;
  final DateTime? subscriptionDate;
  


  UserModel({
     this.uid,
     this.username,
     this.email,
     this.place,
     this.phoneNumber,
     this.imgUrl,
     this.createdAt,
    this.isBlock,
    this.score,
    this.borrowLimit,
    this.subscriptionDate,
    this.subscriptionType

  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': username,
      'email': email,
      'place': place,
      'phoneNumber': phoneNumber,
      'imgUrl':imgUrl,
      'createdAt': DateTime.now(),
      'isBlock':false,
      'score':0,
      'subType':subscriptionType,
      'borrowLimit':3,
      'subDate':DateTime.now(),
    };
  }

  factory UserModel.fromDocument( Map<String,dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      username: data['userName'] ?? '',
      email: data['email'] ?? '',
      place: data['place'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      imgUrl: data['imgUrl']??'',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isBlock: data['isBlock'] ?? false,
      score: data['score'] ?? 0,
      subscriptionType: data['subTyple']??'',
      borrowLimit: data['borrowLimit']??3,
      subscriptionDate:  (data['subDate'] as Timestamp).toDate(),


    );
  }
}

class AuthService1 {
  final _auth = FirebaseAuth.instance;

  Future<User?> createAuthUser(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      log('Error creating auth user: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      log('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}

class UserDatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final String? uid;

  UserDatabaseService({this.uid});

  CollectionReference get usersCollection => _firestore.collection('users');

  DocumentReference get userDocument => usersCollection.doc(uid);

  // Future<bool> createUserProfile({
  //    String uid,
  //    String username,
  //    String email,
  //    String fullName,
  //    String address,
  //    String phoneNumber,
  //    String imgurl
  // }) async {
  //   try {
  //     final isAvailable = await isUsernameAvailable(username);
  //     if (!isAvailable) {
  //       log('Username already taken');
  //       return false;
  //     }

  //     final userModel = UserModel(
  //       uid: uid,
  //       username: username,
  //       fullName: fullName,
  //       email: email,
  //       address: address,
  //       phoneNumber: phoneNumber,
  //       imgUrl: imgurl,);

  //     await usersCollection.doc(uid).set(userModel.toMap());
  //     log('User profile created successfully');
  //     return true;
  //   } catch (e) {
  //     log('Error creating user profile: $e');
  //     return false;
  //   }
  // }

  Future<void> updateUserData({
    String? username,
    String? fullName,
    String? address,
    String? phoneNumber,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (username != null) {
        final currentData = await userDocument.get();
        final currentUsername = currentData['username'];

        if (username != currentUsername) {
          final isAvailable = await isUsernameAvailable(username);
          if (!isAvailable) {
            throw Exception('Username already taken');
          }
        }

        data['username'] = username;
      }

      if (fullName != null) data['fullName'] = fullName;
      if (address != null) data['address'] = address;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;

      data['lastUpdated'] = FieldValue.serverTimestamp();

      await userDocument.update(data);
      log('User data updated successfully');
    } catch (e) {
      log('Error updating user data: $e');
      rethrow;
    }
  }

  Stream<UserModel?> get userData {
    return userDocument.snapshots().map((doc) {
      if (doc.exists) {
       return UserModel.fromDocument(doc.data() as Map<String, dynamic>);

      }
      return null;
    });
  }

  Future<UserModel?> getUserData() async {
    try {
      final doc = await userDocument.get();
      if (doc.exists) {
     return UserModel.fromDocument(doc.data() as Map<String, dynamic>);

      }
      return null;
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }

  Future<bool> doesUserProfileExist(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      log('Error checking if user profile exists: $e');
      return false;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot =
          await usersCollection
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      log('Error checking username availability: $e');
      return false;
    }
  }

  Future<void> deleteUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await userDocument.delete();

        await user.delete();

        log('User deleted successfully');
      }
    } catch (e) {
      log('Error deleting user: $e');
      rethrow;
    }
  }
}
