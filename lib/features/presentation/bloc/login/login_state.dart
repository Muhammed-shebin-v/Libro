part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}
class UserNotAvailable extends LoginFailure {
  UserNotAvailable() : super("User Not Found");
}

class OfflineError extends LoginFailure {
  OfflineError() : super("No internet connection. Please try again later.");
}
