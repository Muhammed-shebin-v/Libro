import 'dart:io';

abstract class UserEvent {}

class LoadUserEvent extends UserEvent {
  final String uid;
  LoadUserEvent(this.uid);
}

class PickImageEvent extends UserEvent {
  final File pickedImage;
  PickImageEvent(this.pickedImage);
}

class UpdateUserEvent extends UserEvent {
  final String uid;
  final String username;
  final String phoneNumber;
  final String place;
  final String? newImageUrl;

  UpdateUserEvent({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.place,
    this.newImageUrl,
  });
}