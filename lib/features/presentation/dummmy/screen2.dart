import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  String name;
   Screen2({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Center(child: Text('your name is $name'),),
    );
  }
}