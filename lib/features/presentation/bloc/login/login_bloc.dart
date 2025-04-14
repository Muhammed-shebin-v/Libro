import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libro/features/auth/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc(this._authService) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      User? user =
          await _authService.signIn(event.email, event.password);
      if (user != null) {
        emit(LoginSuccess(user));

      } else {
        emit(LoginFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
