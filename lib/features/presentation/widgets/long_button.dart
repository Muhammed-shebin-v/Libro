import 'package:flutter/material.dart';

class CustomLongButton extends StatelessWidget {
  final void Function()? ontap;
  final Widget widget;
  const CustomLongButton({required this.widget,required this.ontap, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: InkWell(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(),
            borderRadius: BorderRadius.circular(30),
          ),
          height: 40,
          width: 250,
          child: Align(
            alignment: Alignment.center,
            child: widget,
          ),
        ),
      ),
    );
  }
}
