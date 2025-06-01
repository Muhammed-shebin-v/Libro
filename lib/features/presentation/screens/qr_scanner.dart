

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:slide_to_act/slide_to_act.dart';

class QrScanner extends StatelessWidget {
  QrScanner({super.key});
  final GlobalKey<SlideActionState> slideActionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        title: Text("Qr Scanner"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.restart_alt))],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Gap(20),
                CustomContainer(
                  color: AppColors.color30,
                  radius: BorderRadius.circular(20),
                  shadow: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Book(
                                color: AppColors.color30,
                                image: 'lib/assets/images.jpeg',
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'The way of Nameless',
                                  style: AppFonts.heading3,
                                ),
                                Text('Author name', style: AppFonts.body1),
                                Text(
                                  '196 pages • 1000readers • 4.3+rating',
                                  style: AppFonts.body2,
                                ),
                                Text('Fictional', style: AppFonts.body2),
                              ],
                            ),
                          ],
                        ),
                        Gap(30),
                        Text('Add your review', style: AppFonts.heading3),
                        TextFormField(
                          autofocus: true,
                          maxLines: 3,
                          maxLength: 120,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Text here',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        Text('Add your rating', style: AppFonts.heading3),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Rate this Book'),
                              Gap(20),
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SlideWidget(slideKey: slideActionKey, title: 'slide to return',function: fun(),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlideWidget extends StatelessWidget {
  final GlobalKey<SlideActionState> slideKey;
  final String title;
  final function;
  const SlideWidget({super.key, required this.slideKey, required this.title,required this.function});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      height: 80,
      text: title,
      textColor: Colors.black,
      innerColor: Colors.white,
      outerColor: AppColors.color10,
      sliderButtonIcon: const Icon(Icons.arrow_forward, color: Colors.black),
      key: slideKey,
      animationDuration: Duration(milliseconds: 300),
      // onSubmit: () async {
      //   await Future.delayed(
      //     const Duration(seconds: 2),
      //     () => slideKey.currentState!.reset(),
      //   );
      //   // Navigator.pop(context);
      //   function;
      // },
      onSubmit: function,
      elevation: 0,
    );
  }
}
  fun(){
    log('ff');
  }
