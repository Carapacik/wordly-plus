import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/level/domain/model/level_result.dart';
import 'package:wordly/src/feature/level/widget/level_dialog.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/shared/not_played.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({required this.dictionary, super.key});

  final Locale dictionary;

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late final Future<List<LevelResult>> _getLevelsFuture = context.dependencies.levelRepository.getResults(
    widget.dictionary,
  );

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: context.l10n.levels,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.levels, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ConstraintScreen(
          child: FutureBuilder(
            future: _getLevelsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.requireData.isEmpty) {
                return const HaveNotPlayed();
              }
              final List<LevelResult> levels = snapshot.requireData;
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: levels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => _LevelItem(level: levels[index], dictionary: widget.dictionary),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  const _LevelItem({required this.level, required this.dictionary});

  final LevelResult level;
  final Locale dictionary;

  @override
  Widget build(BuildContext context) {
    final Settings settings = SettingsScope.of(context, listen: true).settingsService.current;
    final LetterStatus status = level.isUnavailable
        ? LetterStatus.unknown
        : level.isWin!
        ? LetterStatus.correctSpot
        : LetterStatus.notInWord;
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(8),
        color: status.cellColor(context, settings.general),
        child: InkWell(
          onTap: level.isUnavailable
              ? null
              : () async {
                  await showLevelDialog(
                    context,
                    word: level.secretWord!,
                    isWin: level.isWin!,
                    meaning: context.dependencies.gameRepository.currentDictionary(dictionary)[level.secretWord] ?? '',
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  level.isUnavailable
                      ? '${level.levelNumber}\n${context.l10n.resultUnavailable}'
                      : '${level.levelNumber}\n${level.secretWord!.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: status.textColor(context, settings.general), fontSize: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
