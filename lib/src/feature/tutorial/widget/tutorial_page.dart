import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';
import 'package:wordly/src/feature/shared/letter_tile.dart';

class const TutorialPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsContainer settingsScope = SettingsScope.of(context, listen: true);
    final Settings settings = settingsScope.settingsService.current;
    final Locale locale = settings.general.locale;
    final List<LetterInfo> wordWithCorrectSpot = _wordWithCorrectSpot(locale);
    final List<LetterInfo> wordWithWrongSpot = _wordWithWrongSpot(locale);
    final List<LetterInfo> wordNotSpot = _wordNotSpot(locale);
    return Title(
      color: Colors.black,
      title: context.l10n.tutorial,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.tutorial, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ConstraintScreen(
          safeAreaBottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 16),
              children: [
                Text(context.l10n.tutorialTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '\u2022'),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      TextSpan(text: context.l10n.tutorialDescription1),
                    ],
                  ),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '\u2022'),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      TextSpan(text: context.l10n.tutorialDescription2),
                    ],
                  ),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.secondary),
                const SizedBox(height: 16),
                Text(context.l10n.examples, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350, maxHeight: 60),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: wordWithCorrectSpot.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => LetterTile(info: wordWithCorrectSpot[index]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.tutorialWordCorrectSpot,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350, maxHeight: 60),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: wordWithWrongSpot.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => LetterTile(info: wordWithWrongSpot[index]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.tutorialWordWrongSpot,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350, maxHeight: 60),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: wordNotSpot.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => LetterTile(info: wordNotSpot[index]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.tutorialNotInWordSpot,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.secondary),
                const SizedBox(height: 16),
                Text(
                  context.l10n.newWordAvailableEachDay.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<LetterInfo> _wordWithCorrectSpot(Locale locale) {
    switch (locale) {
      case const Locale('ru'):
        return const [
          LetterInfo(letter: 'п', status: LetterStatus.correctSpot),
          LetterInfo(letter: 'а'),
          LetterInfo(letter: 'у'),
          LetterInfo(letter: 'з'),
          LetterInfo(letter: 'а'),
        ];
    }
    return const [
      LetterInfo(letter: 'p', status: LetterStatus.correctSpot),
      LetterInfo(letter: 'a'),
      LetterInfo(letter: 'u'),
      LetterInfo(letter: 's'),
      LetterInfo(letter: 'e'),
    ];
  }

  List<LetterInfo> _wordWithWrongSpot(Locale locale) {
    switch (locale) {
      case const Locale('ru'):
        return const [
          LetterInfo(letter: 'ф'),
          LetterInfo(letter: 'и'),
          LetterInfo(letter: 'ш', status: LetterStatus.wrongSpot),
          LetterInfo(letter: 'к'),
          LetterInfo(letter: 'а'),
        ];
    }
    return const [
      LetterInfo(letter: 'c'),
      LetterInfo(letter: 'r'),
      LetterInfo(letter: 'a', status: LetterStatus.wrongSpot),
      LetterInfo(letter: 'n'),
      LetterInfo(letter: 'e'),
    ];
  }

  List<LetterInfo> _wordNotSpot(Locale locale) {
    switch (locale) {
      case const Locale('ru'):
        return const [
          LetterInfo(letter: 'л'),
          LetterInfo(letter: 'е'),
          LetterInfo(letter: 'й'),
          LetterInfo(letter: 'к'),
          LetterInfo(letter: 'а', status: LetterStatus.notInWord),
        ];
    }
    return const [
      LetterInfo(letter: 's'),
      LetterInfo(letter: 'p'),
      LetterInfo(letter: 'o'),
      LetterInfo(letter: 'r'),
      LetterInfo(letter: 'e', status: LetterStatus.notInWord),
    ];
  }
}
