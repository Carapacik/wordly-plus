import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

class HaveNotPlayed extends StatelessWidget {
  const HaveNotPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          context.r.not_played,
          style: context.theme.tl,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
