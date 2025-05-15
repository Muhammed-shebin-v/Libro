import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/screens/subscription.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  final String uid;
  final String email;
  final String username;

  const DetailsScreen({
    super.key,
    required this.uid,
    required this.email,
    required this.username,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _firestore = FirebaseFirestore.instance;

  final _fullNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  final _placeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
    String? _uploadedImageUrl;
  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );
  XFile? image;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _placeController.dispose();
    super.dispose();
  }
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = pickedFile;
    });
    if (pickedFile != null) {
      await _uploadToCloudinary(File(pickedFile.path));
    }
  }

  Future<void> _uploadToCloudinary(File imageFile) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      _uploadedImageUrl = response.secureUrl;
      log("Image Uploaded: $_uploadedImageUrl");
    } catch (e) {
      log('Cloudinary upload error: $e');
    }
  }

  bool _isLoading = false;
  
  Future<void> saveUserToPrefs(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userModel.uid);
    await prefs.setString('username', userModel.username);
    await prefs.setString('email', userModel.email);
    await prefs.setString('fullName', userModel.fullName);
    await prefs.setString('address', userModel.address);
    await prefs.setString('phoneNumber', userModel.phoneNumber);
    await prefs.setString('imgUrl', userModel.imgUrl);
    await prefs.setString('createdAt', userModel.createdAt.toIso8601String());
    await prefs.setBool('isBlock', userModel.isBlock??false);
    await prefs.setInt('score', userModel.score??0);
    log('User saved to prefs: ${userModel.toString()}');
  }

  Future<void> _saveUserDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userModel = UserModel(
          uid: widget.uid,
          username: widget.username,
          fullName: _fullNameController.text.trim(),
          email: widget.email,
          address: _placeController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          imgUrl: _uploadedImageUrl!,
          createdAt: DateTime.now()
        );

        await _firestore.collection('users').doc(widget.uid).set(userModel.toMap());
        await saveUserToPrefs(userModel);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration complete!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Subscription()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving details: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.uid);
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(30),
                        Text(
                          'Tell Us More About You',
                          style: AppFonts.heading1,
                        ),
                        Text('Enter more details to know more about you'),
                        Gap(80),

                        Center(
                          child:  InkWell(
                        onTap: () => _pickImage(),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              _uploadedImageUrl != null
                                  ? Image.network(_uploadedImageUrl!)
                                  : Icon(Icons.image),
                        ),
                      ),
                        ),
                           
                        Gap(80),
                        CustomForm(
                          title: 'Full Name',
                          hint: 'enter Full Name',
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 2) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                        CustomForm(
                          title: 'Phone Number',
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Phone number';
                            }
                            if (value.length < 9) {
                              return 'please enter valid number';
                            }
                            return null;
                          },
                          hint: 'enter phone number',
                        ),
                        CustomForm(
                          title: 'Place',
                          controller: _placeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter place';
                            }
                            if (value.length < 3) {
                              return 'please enter valid place';
                            }
                            return null;
                          },
                          hint: 'enter place',
                        ),
                        Gap(50),
                        CustomLongButton(
                          title: 'Next',
                          ontap: () {
                            _saveUserDetails();
                            log('done');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
