import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/widget/settings_save_error.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/colors.dart';
import 'package:wordly/src/ui_kit/controls/color_picker.dart';
import 'package:wordly/src/ui_kit/game/letter_tile.dart';
import 'package:wordly/src/ui_kit/layout/constraint_screen.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';

class const ChangeColorPage({
  required final GeneralSettings initialSettings,
  required final Locale dictionary,
  super.key,
}) extends StatefulWidget {
  @override
  State<ChangeColorPage> createState() => _ChangeColorPageState();
}

class _ChangeColorPageState() extends State<ChangeColorPage> {
  late ColorMode _currentColorMode;

  late (Color, Color, Color) _currentOtherColors;

  int? _currentSelectedTileIndex;

  @override
  void initState() {
    super.initState();
    _currentColorMode = widget.initialSettings.colorMode;
    if (_currentColorMode == ColorMode.other) {
      _currentSelectedTileIndex = 0;
    }
    _currentOtherColors = widget.initialSettings.otherColors ?? (AppColors.green, AppColors.yellow, AppColors.grey);
  }

  Future<void> _changeTheme(BuildContext context) async {
    final SettingsScopeState settingsScope = SettingsScope.of(context);
    await settingsScope.update(
      (current) => current.copyWith(
        general: current.general.copyWith(colorMode: _currentColorMode, otherColors: _currentOtherColors),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LetterInfo> word = _wordByDictionary(widget.dictionary);
    return Scaffold(
      backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.colorMode, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
      ),
      body: ConstraintScreen(
        child: ListView(
          children: [
            const SettingsSaveError(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 60),
              child: Center(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: word.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => LetterTile(
                    info: word[index],
                    color: _currentColorByStatus(_currentColorMode, word[index].status),
                    selected: _currentSelectedTileIndex == index,
                    onTap: _currentColorMode == ColorMode.other
                        ? () {
                            if (word[index].status != LetterStatus.unknown) {
                              setState(() => _currentSelectedTileIndex = index);
                            }
                          }
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ColorMode.values.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ListTile(
                title: Text(ColorMode.values[index].localized(context), style: const TextStyle(fontSize: 16)),
                trailing: _currentColorMode == ColorMode.values[index] ? const Icon(Icons.check) : null,
                onTap: () async {
                  setState(() {
                    _currentColorMode = ColorMode.values[index];
                    if (_currentColorMode != ColorMode.other) {
                      _currentSelectedTileIndex = null;
                    } else {
                      _currentSelectedTileIndex ??= 0;
                    }
                  });
                  await _changeTheme(context);
                },
              ),
            ),
            const SizedBox(height: 8),
            if (_currentColorMode == ColorMode.other && _currentSelectedTileIndex != null)
              ColorPicker(
                key: ValueKey(_currentSelectedTileIndex),
                color:
                    _currentColorByStatus(
                      _currentColorMode,
                      _currentSelectedTileIndex == null ? null : word[_currentSelectedTileIndex!].status,
                    ) ??
                    context.theme.colorScheme.surface,
                onChanged: (color) async {
                  final LetterStatus status = word[_currentSelectedTileIndex!].status;
                  setState(() {
                    _currentOtherColors = (
                      status == LetterStatus.correctSpot ? color : _currentOtherColors.$1,
                      status == LetterStatus.wrongSpot ? color : _currentOtherColors.$2,
                      status == LetterStatus.notInWord ? color : _currentOtherColors.$3,
                    );
                  });
                  await _changeTheme(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Color? _currentColorByStatus(ColorMode mode, LetterStatus? status) {
    if (status == null || mode != ColorMode.other) {
      return null;
    }
    final Map<LetterStatus, Color> otherModeColors = {
      LetterStatus.correctSpot: _currentOtherColors.$1,
      LetterStatus.wrongSpot: _currentOtherColors.$2,
      LetterStatus.notInWord: _currentOtherColors.$3,
    };
    return otherModeColors[status];
  }

  List<LetterInfo> _wordByDictionary(Locale dictionary) => switch (dictionary.languageCode) {
    'en' => const [
      LetterInfo(letter: 'p', status: LetterStatus.correctSpot),
      LetterInfo(letter: 'a'),
      LetterInfo(letter: 'u', status: LetterStatus.notInWord),
      LetterInfo(letter: 's', status: LetterStatus.wrongSpot),
      LetterInfo(letter: 'e'),
    ],
    'ru' => const [
      LetterInfo(letter: 'п', status: LetterStatus.correctSpot),
      LetterInfo(letter: 'а'),
      LetterInfo(letter: 'у', status: LetterStatus.notInWord),
      LetterInfo(letter: 'з', status: LetterStatus.wrongSpot),
      LetterInfo(letter: 'а'),
    ],
    _ => [],
  };
}
