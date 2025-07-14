import 'dart:developer';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:libro/features/presentation/widgets/onboarding_heading.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
    

  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
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

  XFile? image;
  String? _uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(30),
            OnboardingHeading(
              title: 'Tell Us More About You',
              subTitle: 'Enter more details to know more about you',
            ),
            Gap(20),
            Center(
              child: InkWell(
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
            Gap(5),
            Center(
              child: Text(
                'upload your profile picture',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Gap(20),
            CustomForm(
              title: 'Phone Number',
              controller: phoneNumberController,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Phone number';
                }
                if (value.length <= 9 || int.tryParse(value) == null) {
                  return 'please enter valid number';
                }
                return null;
              },
            ),
            CustomForm(
              title: 'Place',
              controller: placeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter place';
                }
                if (value.length < 3) {
                  return 'please enter valid place';
                }
                return null;
              },
            ),
            Gap(30),
            CustomLongButton(
              widget: Text('Continue', style: TextStyle(fontSize: 20)),
              ontap: () {
                userhi = UserModel(
                  imgUrl: _uploadedImageUrl,
                  phoneNumber: phoneNumberController.text,
                  place: placeController.text,
                  uid: userhi.uid,
                  username: userhi.username,
                  email: userhi.email,
                );
                context.read<OnboardingBloc>().add(NextPageEvent());
                log('done');
              },
            ),
            Center(
              child: Text(
                'Enter your valid datas',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
