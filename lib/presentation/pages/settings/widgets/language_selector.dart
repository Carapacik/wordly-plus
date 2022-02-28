import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.text,
    required this.value,
    required this.onChanged,
    required this.isHighContrast,
    Key? key,
  }) : super(key: key);

  final String text;
  final String value;
  final bool isHighContrast;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppTypography.m14,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isHighContrast
                  ? AppColors.highContrastOrange
                  : AppColors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                alignment: Alignment.bottomCenter,
                value: value,
                borderRadius: BorderRadius.circular(10),
                items: [
                  DropdownMenuItem(
                    value: 'ru',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          R.svg.russia,
                          width: 30,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'RU',
                          style: AppTypography.m16,
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          R.svg.us,
                          width: 30,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'EN',
                          style: AppTypography.m16,
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      );
}
