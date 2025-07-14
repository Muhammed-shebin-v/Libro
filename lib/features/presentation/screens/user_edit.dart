import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_bloc.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_event.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_state.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEditScreen extends StatefulWidget {
  final String uid;
  const UserEditScreen({super.key, required this.uid});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  String? imgUrl;
  ImagePicker imagepicker = ImagePicker();
  File? pickedimage;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent(widget.uid));
  }

  Future<void> saveUserToPrefs({required String username}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    log('User saved to prefs: $username');
    log(username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: AppColors.color60,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            _usernameController.text = state.user.username!;
            _phoneController.text = state.user.phoneNumber!;
            _placeController.text = state.user.place!;
            imgUrl = state.user.imgUrl;

            return Padding(
              padding: EdgeInsets.all(2),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomContainer(
                        color: AppColors.color10,
                        radius: BorderRadius.circular(20),
                        shadow: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Gap(20),
                              BlocBuilder<UserBloc, UserState>(
                                builder: (context, state) {
                                  String? imageUrl;

                                  if (state is UserLoaded) {
                                    imageUrl = state.user.imgUrl;
                                  } else if (state is UserImageUploaded) {
                                    imageUrl = state.imageUrl;
                                  }

                                  return GestureDetector(
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                            source: ImageSource.gallery,
                                          );
                                      if (pickedFile != null &&
                                          context.mounted) {
                                        context.read<UserBloc>().add(
                                          PickImageEvent(File(pickedFile.path)),
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          imageUrl != null
                                              ? NetworkImage(imageUrl)
                                              : null,
                                      child:
                                          imageUrl == null
                                              ? const Icon(
                                                Icons.person,
                                                size: 40,
                                              )
                                              : Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ),
                              Text('edit image'),
                              Gap(20),
                              CustomForm(
                                title: 'Username',
                                controller: _usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              CustomForm(
                                title: 'Phone Number',
                                controller: _phoneController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              CustomForm(
                                title: 'Place',
                                controller: _placeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              Gap(20),
                              ElevatedButton(
                                onPressed: () async {
                                  final state = context.read<UserBloc>().state;
                                  if (state is UserLoaded ||
                                      state is UserImageUploaded) {
                                    final imageUrl =
                                        (state is UserLoaded)
                                            ? state.user.imgUrl
                                            : null;

                                    context.read<UserBloc>().add(
                                      UpdateUserEvent(
                                        uid: widget.uid,
                                        username:
                                            _usernameController.text.trim(),
                                        phoneNumber:
                                            _phoneController.text.trim(),
                                        place: _placeController.text.trim(),
                                        newImageUrl: imageUrl,
                                      ),
                                    );
                                    await saveUserToPrefs(
                                      username: _usernameController.text,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context,true);
                                  }
                                },
                                child: const Text("Save Changes"),
                              ),
                              Gap(5),
                              Text(
                                'Enter all info correctly this will lead you to connect to admin',
                                style: TextStyle(fontSize: 11),
                              ),
                              Gap(30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center();
        },
      ),
    );
  }
}
