import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/data/collections/board_data.dart';
import 'package:wordly/domain/board_repository.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(title: R.stringsOf(context).levels),
        body: ConstraintScreen(
          child: FutureBuilder<List<BoardData>>(
            future: GetIt.I<BoardRepository>().getAllData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey),
                  ),
                );
              }
              final data = snapshot.requireData;
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: data.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final levelNumber = index == data.length
                      ? data.isNotEmpty
                          ? data[data.length - 1].levelNumber + 1
                          : 1
                      : data[index].levelNumber;
                  return _GridItem(
                    index: levelNumber,
                    word: index == data.length ? '?' : data[index].secretWord,
                    isComplete: index != data.length && data[index].isComplete,
                    isWin: index == data.length ? null : data[index].isWin,
                  );
                },
              );
            },
          ),
        ),
      );
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.word,
    required this.isWin,
    required this.isComplete,
    required this.index,
  });

  final String word;
  final bool? isWin;
  final bool isComplete;
  final int index;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isWin == null
                ? AppColors.grey
                : isWin!
                    ? AppColors.green
                    : AppColors.red,
          ),
          child: Text(
            isComplete ? '$index\n$word' : '$index\n?',
            textAlign: TextAlign.center,
            style: AppTypography.b30.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
}
