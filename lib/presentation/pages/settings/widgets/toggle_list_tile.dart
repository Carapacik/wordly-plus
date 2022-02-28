import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

class ToggleListTile extends StatelessWidget {
  const ToggleListTile({
    required this.text,
    required this.value,
    required this.isHighContrast,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool value;
  final bool isHighContrast;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppTypography.m14,
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor:
                isHighContrast ? AppColors.highContrastOrange : AppColors.green,
            inactiveTrackColor: AppColors.grey,
            activeColor: Colors.white,
          ),
        ],
      );
}
