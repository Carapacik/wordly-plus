import 'package:flutter/material.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/resources/resources.dart';

class TileItem extends StatelessWidget {
  const TileItem({required this.info, super.key});

  final LetterInfo info;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: info.letterStatus.itemColor(context),
            border: info.letterStatus == LetterStatus.unknown
                ? Border.all(
                    width: 3,
                    color: context.dynamicColor(
                      light: AppColors.lightGrey,
                      dark: AppColors.darkGrey,
                    ),
                  )
                : null,
          ),
          child: Text(
            info.letter.toUpperCase(),
            style: context.theme.tlb.copyWith(
              color: info.letterStatus != LetterStatus.unknown
                  ? Colors.white
                  : null,
            ),
          ),
        ),
      );
}
