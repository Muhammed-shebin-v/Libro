import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

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

  // Future<UserCredential?> loginWithGoogle()async{
  //   try{
  //     final googleUser =await GoogleSignIn().signIn();
  //     final gogleAuth = await googleUser?.authentication;
  //     final cred = GoogleAuthProvider.credential(idToken: gogleAuth?.idToken,accessToken: gogleAuth?.accessToken);
  //     return await _auth.signInWithCredential(cred);


      
  //   }catch(e){
  //     log('error:$e');
  //   }
  //   return null;

  // }

  // Future<void> saveUserData(User user, UserModel userModel) async {
  //   try {
  //     await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('uid', user.uid);
  //     await prefs.setString('username', userModel.username!);
  //     await prefs.setString('fullName', userModel.fullName);
  //     await prefs.setString('email', userModel.email);
  //     await prefs.setString('phone', userModel.phoneNumber);
  //     await prefs.setString('address', userModel.address);
  //     await prefs.setString('imgUrl', userModel.imgUrl);
  //     await prefs.setString('createdDate', userModel.createdAt);
  //     await prefs.setBool('isBlock', userModel.isBlock!);
  //     await prefs.setInt('score', userModel.score!);
  //     log('User data saved: ${userModel.toString()}');
  //   } catch (e) {
  //     log('Error saving user data: $e');
  //   }
  // }
Future<void> sendEmailVerificatonLink(){
  try{
    final user = _auth.currentUser;
    if (user != null) {
      return user.sendEmailVerification();
    } else {
      throw Exception("No user is currently signed in.");
    }
  }catch(e){
    log('Error sending email verification link: $e');
    rethrow;
  }
}

Future<void> sendForgetEmailLink({required String email}){
  try{

      return _auth.sendPasswordResetEmail(email:email );
  }catch(e){
    log('error in sending password reset email');
   throw Exception('error in sending reset email $e');
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
