import 'package:flutter/material.dart';
import 'package:libro/core/themes/fonts.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final BorderRadius radius;
  final double shadow;
  final double? height;
  final double? width;
  final Widget child;

  const CustomContainer({
    super.key,
    required this.color,
    required this.radius,
    required this.shadow,
    this.height,
    this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(),
        borderRadius: radius,
        boxShadow: [BoxShadow(offset: Offset(shadow, shadow.abs()),color: AppColors.grey)],
      ),
      child: child,
    );
  }
}
