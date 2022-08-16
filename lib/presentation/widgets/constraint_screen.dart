import 'package:flutter/material.dart';
import 'package:wordly/utils/utils.dart';

class ConstraintScreen extends StatelessWidget {
  const ConstraintScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxMobileWidth),
            child: child,
          ),
        ),
      );
}
