import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/levels/levels_bloc.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) => Title(
        color: AppColors.dark,
        title: context.r.levels,
        child: Scaffold(
          appBar: CustomAppBar(title: context.r.levels),
          body: ConstraintScreen(
            child: BlocBuilder<LevelsBloc, LevelsState>(
              builder: (context, state) => state.map(
                initial: (_) =>
                    const Center(child: CircularProgressIndicator()),
                levelsLoaded: (s) {
                  final levels = s.levels;
                  if (levels.isEmpty) {
                    return const HaveNotPlayed();
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: levels.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) => _GridItem(
                      index: index + 1,
                      word: levels[index].word,
                      meaning: levels[index].meaning,
                      isWin: levels[index].isWin,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.word,
    required this.meaning,
    required this.isWin,
    required this.index,
  });

  final String word;
  final String meaning;
  final bool? isWin;
  final int index;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(8),
          color: isWin == null
              ? context.dynamicColor(
                  light: AppColors.greyLight,
                  dark: AppColors.greyDark,
                )
              : isWin!
                  ? context.dynamicColor(
                      light: AppColors.greenLight,
                      dark: AppColors.greenDark,
                    )
                  : context.dynamicColor(
                      light: AppColors.redLight,
                      dark: AppColors.redDark,
                    ),
          child: InkWell(
            onTap: () {
              if (isWin != null) {
                showMeaningDialog(
                  context,
                  meaning: meaning,
                  isWin: isWin!,
                  word: word,
                );
              }
            },
            child: Center(
              child: Text(
                '$index\n$word',
                textAlign: TextAlign.center,
                style: context.theme.tl.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
