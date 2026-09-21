import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';

class const ColorPicker({required final Color color, required final ValueChanged<Color> onChanged, super.key})
    extends StatefulWidget {
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState() extends State<ColorPicker> {
  late HSVColor _color = HSVColor.fromColor(widget.color).withAlpha(1);
  late final TextEditingController _hex = TextEditingController(text: _hexValue);
  bool _invalidHex = false;

  String get _hexValue => (_color.toColor().toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color.toARGB32() != _color.toColor().toARGB32()) {
      _color = HSVColor.fromColor(widget.color).withAlpha(1);
      _syncHex();
    }
  }

  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  void _syncHex() {
    _hex.value = TextEditingValue(text: _hexValue, selection: const TextSelection.collapsed(offset: 6));
    _invalidHex = false;
  }

  void _change(HSVColor color, {bool syncHex = true}) {
    setState(() {
      _color = color;
      if (syncHex) {
        _syncHex();
      }
    });
    widget.onChanged(color.toColor());
  }

  void _readHex(String text, {bool submit = false}) {
    final String value = text.trim().replaceFirst(RegExp('^#'), '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(value)) {
      setState(() => _invalidHex = submit);
      return;
    }
    var color = HSVColor.fromColor(Color(0xFF000000 | int.parse(value, radix: 16)));
    // Grayscale has no hue; preserve it so increasing saturation restores the selected hue.
    if (color.saturation == 0) {
      color = color.withHue(_color.hue);
    }
    _invalidHex = false;
    _change(color, syncHex: submit);
  }

  void _pickPalette(Offset position, Size size) => _change(
    _color
        .withSaturation((position.dx / size.width).clamp(0, 1))
        .withValue((1 - position.dy / size.height).clamp(0, 1)),
  );

  KeyEventResult _key(KeyEvent event, {required bool hue}) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    final double dx = key == LogicalKeyboardKey.arrowRight
        ? 1
        : key == LogicalKeyboardKey.arrowLeft
        ? -1
        : 0;
    final double dy = key == LogicalKeyboardKey.arrowUp
        ? 1
        : key == LogicalKeyboardKey.arrowDown
        ? -1
        : 0;
    if (dx == 0 && dy == 0) {
      return KeyEventResult.ignored;
    }
    _change(
      hue
          ? _color.withHue((_color.hue + dx + dy).clamp(0, 360))
          : _color
                .withSaturation((_color.saturation + dx / 100).clamp(0, 1))
                .withValue((_color.value + dy / 100).clamp(0, 1)),
    );
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: 420,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: context.l10n.colorPalette,
              value: '#$_hexValue',
              child: Focus(
                onKeyEvent: (_, event) => _key(event, hue: false),
                child: Builder(
                  builder: (context) => LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxWidth / 1.5);
                      return GestureDetector(
                        key: const ValueKey('color-palette'),
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (event) {
                          Focus.of(context).requestFocus();
                          _pickPalette(event.localPosition, size);
                        },
                        onPanStart: (event) => _pickPalette(event.localPosition, size),
                        onPanUpdate: (event) => _pickPalette(event.localPosition, size),
                        child: SizedBox(
                          height: size.height,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [Colors.white, HSVColor.fromAHSV(1, _color.hue, 1, 1).toColor()],
                              ),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black],
                                ),
                                border: Border.all(
                                  color: Focus.of(context).hasFocus
                                      ? context.theme.colorScheme.primary
                                      : context.theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: (_color.saturation * size.width - 10).clamp(0, size.width - 20),
                                    top: ((1 - _color.value) * size.height - 10).clamp(0, size.height - 20),
                                    child: _ColorMarker(color: _color.toColor(), size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              label: context.l10n.colorHue,
              value: '${_color.hue.round()}°',
              increasedValue: '${(_color.hue + 1).clamp(0, 360).round()}°',
              decreasedValue: '${(_color.hue - 1).clamp(0, 360).round()}°',
              onIncrease: () => _change(_color.withHue((_color.hue + 1).clamp(0, 360))),
              onDecrease: () => _change(_color.withHue((_color.hue - 1).clamp(0, 360))),
              child: Focus(
                onKeyEvent: (_, event) => _key(event, hue: true),
                child: Builder(
                  builder: (context) => LayoutBuilder(
                    builder: (context, constraints) {
                      void pick(Offset position) =>
                          _change(_color.withHue((position.dx / constraints.maxWidth * 360).clamp(0, 360)));
                      return GestureDetector(
                        key: const ValueKey('color-hue'),
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (event) {
                          Focus.of(context).requestFocus();
                          pick(event.localPosition);
                        },
                        onPanStart: (event) => pick(event.localPosition),
                        onPanUpdate: (event) => pick(event.localPosition),
                        child: SizedBox(
                          height: 40,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 12,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF0000),
                                        Color(0xFFFFFF00),
                                        Color(0xFF00FF00),
                                        Color(0xFF00FFFF),
                                        Color(0xFF0000FF),
                                        Color(0xFFFF00FF),
                                        Color(0xFFFF0000),
                                      ],
                                    ),
                                    border: Focus.of(context).hasFocus
                                        ? Border.all(color: context.theme.colorScheme.onSurface)
                                        : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: (_color.hue / 360 * constraints.maxWidth - 9).clamp(0, constraints.maxWidth - 18),
                                child: _ColorMarker(color: HSVColor.fromAHSV(1, _color.hue, 1, 1).toColor(), size: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _hex,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'HEX',
                hintText: 'RRGGBB',
                prefixText: '# ',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _ColorMarker(color: _color.toColor(), size: 24),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                errorText: _invalidHex ? context.l10n.colorHexInvalid : null,
              ),
              onChanged: _readHex,
              onSubmitted: (value) => _readHex(value, submit: true),
              onTapOutside: (_) {
                _readHex(_hex.text, submit: true);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class const _ColorMarker({required final Color color, required final double size}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 2, spreadRadius: 1)],
        ),
      ),
    ),
  );
}
