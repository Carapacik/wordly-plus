import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    required this.timeRemaining,
    this.onEnd,
    super.key,
  });

  final Duration timeRemaining;
  final VoidCallback? onEnd;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late int _timeRemaining;

  @override
  void initState() {
    super.initState();
    const oneSecond = Duration(seconds: 1);
    _timeRemaining = widget.timeRemaining.inSeconds;
    _timer = Timer.periodic(
      oneSecond,
      (timer) {
        if (_timeRemaining == 0) {
          setState(() {
            timer.cancel();
            widget.onEnd?.call();
          });
        } else {
          setState(() {
            _timeRemaining--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        durationToStringDate(Duration(seconds: _timeRemaining)),
        style: context.theme.tm.copyWith(color: Colors.white),
      );
}
