import 'dart:developer';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_event.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_state.dart';
class UserBloc extends Bloc<UserEvent, UserState> {
  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );
  UserBloc() : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<PickImageEvent>(_onUploadImage);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.uid)
              .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final user = UserModel.fromDocument(data);
        emit(UserLoaded(user));
      } else {
        emit(UserError('User not found'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final updateData = {
        'userName': event.username,
        'phoneNumber': event.phoneNumber,
        'place': event.place,
      };

      if (event.newImageUrl != null) {
        updateData['imgUrl'] = event.newImageUrl!;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.uid)
          .update(updateData);

      final updatedDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(event.uid)
              .get();
    
      emit(UserLoaded(UserModel.fromDocument(updatedDoc.data()!)));
     
    } catch (e) {
      emit(UserError("Update failed: ${e.toString()}"));
    }
  }

  Future<void> _onUploadImage(
    PickImageEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final cloudinaryUrl = await _uploadToCloudinary(event.pickedImage);
      emit(UserImageUploaded(cloudinaryUrl));
    } catch (e) {
      emit(UserError("Image upload failed: ${e.toString()}"));
    }
  }

  Future<String> _uploadToCloudinary(File imageFile) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      log("Image Uploaded: ${response.secureUrl}");
      return response.secureUrl;
    } catch (e) {
      log('Cloudinary upload error: $e');
      throw Exception("Cloudinary upload error: $e");
    }
  }
}
