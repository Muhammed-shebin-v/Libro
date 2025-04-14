import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/screens/subscription.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:lottie/lottie.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _placeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30),
                Text('Tell Us More About You', style: AppFonts.heading1),
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
                    if (value == null || value.isEmpty || value.length < 2) {
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Subscription()),
                      );
                    }
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
