import 'dart:async';

import 'package:material_ui/material_ui.dart';

class const CountdownTimer({
  required final Duration timeRemaining,
  final VoidCallback? onEnd,
  final Color color = Colors.white,
  super.key,
}) extends StatefulWidget {
  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState() extends State<CountdownTimer> {
  Timer? _timer;
  late int _timeRemaining;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    const oneSecond = Duration(seconds: 1);
    _deadline = DateTime.now().add(widget.timeRemaining);
    _timeRemaining = (widget.timeRemaining.inMilliseconds / 1000).ceil().clamp(0, 86400);
    _timer = Timer.periodic(oneSecond, (timer) {
      final int remaining = (_deadline.difference(DateTime.now()).inMilliseconds / 1000).ceil().clamp(0, 86400);
      setState(() => _timeRemaining = remaining);
      if (remaining == 0) {
        timer.cancel();
        widget.onEnd?.call();
      }
    });
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
    style: TextStyle(color: widget.color, fontSize: 16, fontWeight: FontWeight.w500),
  );
}

String durationToStringDate(Duration duration) {
  final String twoDigitMinutes = _twoDigits(duration.inMinutes.remainder(60));
  final String twoDigitSeconds = _twoDigits(duration.inSeconds.remainder(60));
  final String twoDigitHours = _twoDigits(duration.inHours);
  return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');
