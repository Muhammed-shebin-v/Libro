import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User Model
class UserModel {
  final String uid;
  final String username;
  final String fullName;
  final String email;
  final String address;
  final String phoneNumber;
  // Add more fields as needed

  UserModel({
    required this.uid,
    required this.username,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}

// Authentication Service
class AuthService1 {
  final _auth = FirebaseAuth.instance;
  
  // Step 1: Create auth account only
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

  // Regular sign in
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

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}

// Database Service for Users
class UserDatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final String? uid;

  UserDatabaseService({this.uid});

  // Collection reference
  CollectionReference get usersCollection => _firestore.collection('users');

  // Get user document reference
  DocumentReference get userDocument => usersCollection.doc(uid);

  // Step 2: Create user profile in Firestore
  Future<bool> createUserProfile({
    required String uid,
    required String username,
    required String email,
    required String fullName,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      // Check if username is taken
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        log('Username already taken');
        return false;
      }
      
      // Create user model
      final userModel = UserModel(
        uid: uid,
        username: username,
        fullName: fullName,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
      );
      
      // Save to Firestore
      await usersCollection.doc(uid).set(userModel.toMap());
      log('User profile created successfully');
      return true;
    } catch (e) {
      log('Error creating user profile: $e');
      return false;
    }
  }

  // Update user data
  Future<void> updateUserData({
    String? username,
    String? fullName,
    String? address,
    String? phoneNumber,
  }) async {
    try {
      Map<String, dynamic> data = {};
      
      // Check username availability if changing
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
      
      // Only add fields that need to be updated
      if (fullName != null) data['fullName'] = fullName;
      if (address != null) data['address'] = address;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
      
      // Add last updated timestamp
      data['lastUpdated'] = FieldValue.serverTimestamp();
      
      await userDocument.update(data);
      log('User data updated successfully');
    } catch (e) {
      log('Error updating user data: $e');
      throw e;
    }
  }

  // Get user data as stream
  Stream<UserModel?> get userData {
    return userDocument.snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    });
  }

  // Get user data as future (one-time read)
  Future<UserModel?> getUserData() async {
    try {
      final doc = await userDocument.get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }

  // Check if a user profile exists in Firestore
  Future<bool> doesUserProfileExist(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      return doc.exists;
    } catch (e) {
      log('Error checking if user profile exists: $e');
      return false;
    }
  }

  // Get user by username (useful for username availability check)
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot = await usersCollection
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      log('Error checking username availability: $e');
      return false;
    }
  }

  // Delete user (both Auth and Firestore data)
  Future<void> deleteUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await userDocument.delete();
        
        // Delete user from Firebase Auth
        await user.delete();
        
        log('User deleted successfully');
      }
    } catch (e) {
      log('Error deleting user: $e');
      throw e;
    }
  }
}