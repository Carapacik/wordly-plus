import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/widget/dependencies_context.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/level/model/level_result.dart';
import 'package:wordly/src/feature/level/widget/level_dialog.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/layout/constraint_screen.dart';
import 'package:wordly/src/ui_kit/layout/not_played.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';

class const LevelPage({required final Locale dictionary, super.key}) extends StatefulWidget {
  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState() extends State<LevelPage> {
  late Future<List<LevelResult>> _getLevelsFuture = context.dependencies.levelRepository.getResults(widget.dictionary);

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
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(context.l10n.dataLoadFailed, textAlign: TextAlign.center),
                      TextButton(
                        onPressed: () => setState(() {
                          _getLevelsFuture = context.dependencies.levelRepository.getResults(widget.dictionary);
                        }),
                        child: Text(context.l10n.retry),
                      ),
                    ],
                  ),
                );
              }
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

class const _LevelItem({required final LevelResult level, required final Locale dictionary}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Settings settings = SettingsScope.of(context, listen: true).settings;
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
                  final String meaning = await context.dependencies.gameRepository.definition(
                    dictionary,
                    level.secretWord!,
                  );
                  if (!context.mounted) {
                    return;
                  }
                  await showLevelDialog(context, word: level.secretWord!, isWin: level.isWin!, meaning: meaning);
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
