import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.width,
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(primary: AppColors.grey),
        onPressed: onTap,
        child: Container(
          alignment: Alignment.center,
          width: width,
          child: Text(
            text,
            style: AppTypography.r14.copyWith(color: Colors.white),
          ),
        ),
      );
}
