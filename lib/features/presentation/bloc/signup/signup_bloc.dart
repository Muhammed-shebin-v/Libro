import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import 'package:libro/features/auth/auth_service.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService;

  SignupBloc(this._authService) : super(SignupInitial()) {
    on<SignupUser>(_onSignupUser);
  }

  Future<void> _onSignupUser(SignupUser event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      User? user = await _authService.createUser(event.email, event.password);
      if (user != null) {
        log("User created: $user");
        emit(SignupSuccess());
      } else {
        emit(SignupFailure("Signup failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      emit(UserAlreadyExists());
    } else if (e.code == 'network-request-failed') {
      emit(OfflineError());
    } else {
      emit(SignupFailure("Signup failed: ${e.message}"));
    }
  } catch (e) {
    log("Error in creating user: $e");
    emit(SignupFailure("An unexpected error occurred: ${e.toString()}"));
  }
}
}

