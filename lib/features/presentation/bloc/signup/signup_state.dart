import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);

  @override
  List<Object> get props => [error];
}
class UserAlreadyExists extends SignupFailure {
  UserAlreadyExists() : super("User already exists.");
}

class OfflineError extends SignupFailure {
  OfflineError() : super("No internet connection. Please try again later.");
}


