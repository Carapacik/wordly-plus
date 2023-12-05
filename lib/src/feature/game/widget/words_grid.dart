import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/game/domain/model/word_error.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class const WordsGrid({super.key}) extends StatefulWidget {
  @override
  State<WordsGrid> createState() => _WordsGridState();
}

class _WordsGridState() extends State<WordsGrid> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _shakeAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: -9), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -9, end: 9), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 9, end: -7), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -7, end: 7), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 7, end: -4), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));
  int? _shakingRow;

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: BlocListener<GameBloc, GameState>(
          listenWhen: (_, current) => current is GameFailure && current.error == WordError.notFound,
          listener: (_, state) {
            setState(() => _shakingRow = state.currentWordIndex);
            _shakeController.forward(from: 0);
          },
          child: SettingsBuilder(
            builder: (context, settings) => BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, _) => GridView.builder(
                    itemCount: 30,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (_, index) => Transform.translate(
                      key: ValueKey<String>('invalid-word-shake-$index'),
                      offset: Offset(index ~/ 5 == _shakingRow ? _shakeAnimation.value : 0, 0),
                      child: GridTile(
                        info: state.board.length > index ? state.board[index] : const LetterInfo(letter: ''),
                        position: index,
                        generalSettings: settings.general,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class const GridTile({
  required final LetterInfo info,
  required final int position,
  required final GeneralSettings generalSettings,
  super.key,
}) extends StatefulWidget {
  @override
  State<GridTile> createState() => _GridTileState();
}

class _GridTileState() extends State<GridTile> with TickerProviderStateMixin {
  late final AnimationController _revealController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    value: 1,
  );
  late final AnimationController _popController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _popAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.12), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1), weight: 1),
  ]).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));
  Timer? _startTimer;
  bool _isRevealing = false;

  @override
  void didUpdateWidget(covariant GridTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info.letter != widget.info.letter && widget.info.letter.isNotEmpty) {
      _popController.forward(from: 0);
    }
    if (oldWidget.info.status == LetterStatus.unknown && widget.info.status != LetterStatus.unknown) {
      _startTimer?.cancel();
      _isRevealing = true;
      _revealController.value = 0;
      _startTimer = Timer(Duration(milliseconds: (widget.position % 5) * 65), _revealController.forward);
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _revealController.dispose();
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    key: ValueKey<String>('entered-letter-animation-${widget.position}'),
    scale: _popAnimation,
    child: AnimatedBuilder(
      animation: _revealController,
      builder: (context, child) {
        final double progress = _isRevealing ? _revealController.value : 1;
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
    ),
  );
}
