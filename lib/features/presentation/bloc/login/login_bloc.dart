import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc(this._authService) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      User? user = await _authService.signIn(event.email, event.password);
      if (user != null) {
        // await _authService.fetchUserData(user.uid);
        await getUserData();
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Invalid credentials"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(UserNotAvailable());
      } else if (e.code == 'network-request-failed') {
        emit(OfflineError());
      } else {
        emit(LoginFailure("Login failed: ${e.message}"));
      }
    } catch (e) {
      emit(LoginFailure('this is the error$e'));
    }
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        UserModel user = UserModel.fromDocument(
          doc.data() as Map<String, dynamic>,
        );
        log(user.uid!);
        log(user.username!);
        await saveUserToPrefs(
          uid: user.uid!,
          username: user.username!,
          imgUrl: user.imgUrl!,
        );

        // Now you can use `user.name`, `user.email`, etc.
      }
    }
  }

  Future<void> saveUserToPrefs({
    required String uid,
    required String username,
    required String imgUrl,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('username', username);
    await prefs.setString('imgUrl', imgUrl);
    log('User saved to prefs: $uid');
    log(username);
  }
}
