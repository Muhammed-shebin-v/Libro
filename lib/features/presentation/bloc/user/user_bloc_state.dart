import 'package:libro/features/data/models/user_model.dart';

abstract class UserState {}

class UserImageUploaded extends UserState {
  final String imageUrl;
  UserImageUploaded(this.imageUrl);
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}