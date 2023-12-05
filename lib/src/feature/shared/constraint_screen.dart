import 'package:flutter/material.dart';

const maxMobileWidth = 800.0;

class const ConstraintScreen({required final Widget child, final bool safeAreaBottom = true, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: safeAreaBottom,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxMobileWidth),
        child: child,
      ),
    ),
  );
}
