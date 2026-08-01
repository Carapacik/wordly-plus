import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class WordsGrid extends StatelessWidget {
  const WordsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: SettingsBuilder(
          builder: (context, settings) => BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              return GridView.builder(
                itemCount: 30,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (_, index) => GridTile(
                  info: state.board.length > index ? state.board[index] : const LetterInfo(letter: ''),
                  position: index,
                  generalSettings: settings.general,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridTile extends StatefulWidget {
  const GridTile({required this.info, required this.position, required this.generalSettings, super.key});

  final LetterInfo info;
  final int position;
  final GeneralSettings generalSettings;

  @override
  State<GridTile> createState() => _GridTileState();
}

class _GridTileState extends State<GridTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    value: 1,
  );
  Timer? _startTimer;
  bool _isRevealing = false;

  @override
  void didUpdateWidget(covariant GridTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info.status == LetterStatus.unknown && widget.info.status != LetterStatus.unknown) {
      _startTimer?.cancel();
      _isRevealing = true;
      _controller.value = 0;
      _startTimer = Timer(Duration(milliseconds: (widget.position % 5) * 65), _controller.forward);
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      final double progress = _isRevealing ? _controller.value : 1;
      return Transform(
        key: ValueKey<String>('submitted-letter-animation-${widget.position}'),
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX((1 - progress) * pi / 2),
        child: child,
      );
    },
    child: AspectRatio(
      key: ValueKey<LetterStatus>(widget.info.status),
      aspectRatio: 1,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
        decoration: BoxDecoration(
          color: widget.info.status.cellColor(context, widget.generalSettings),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FittedBox(
            child: widget.info.letter.isEmpty
                ? const SizedBox.shrink(key: ValueKey('empty'))
                : Text(
                    widget.info.letter.toUpperCase(),
                    key: ValueKey<String>(widget.info.letter),
                    style: TextStyle(
                      color: widget.info.status.textColor(context, widget.generalSettings),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    ),
  );
}
