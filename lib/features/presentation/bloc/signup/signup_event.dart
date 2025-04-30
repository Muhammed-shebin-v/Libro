import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupUser extends SignupEvent {
  final String username;
  final String email;
  final String password;

  SignupUser(this.username, this.email, this.password);

  @override
  List<Object> get props => [username, email, password];
}


