import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/screens/bottom_navigation.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/screens/subscription.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:lottie/lottie.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _saveUserDetails() async {
    log('fdf');
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        log('true');
      });

      try {
        final userModel = UserModel(
          uid: widget.uid,
          username: widget.username,
          fullName: _fullNameController.text.trim(),
          email: widget.email,
          address: _placeController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
        );

        await _firestore
            .collection('users')
            .doc(widget.uid)
            .set(userModel.toMap());

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
                        Gap(40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Icon(Icons.image, size: 45),
                              ),
                            ),
                            Align(
                              child: Lottie.asset(
                                'lib/assets/Animation - 1742030119292.json',
                                height: 250,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
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
