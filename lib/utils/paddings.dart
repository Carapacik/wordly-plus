import 'package:flutter/material.dart';
import 'package:wordly/utils/constants.dart';

double horizontalPadding(BuildContext context) =>
    MediaQuery.of(context).size.width > maxMobileWidth
        ? (MediaQuery.of(context).size.width - maxMobileWidth) / 2 + 72
        : 20;

double bottomPadding(BuildContext context) =>
    _screenPhysicalHeight(context).height -
    _safeAreaPadding(context) -
    kToolbarHeight;

Size _screenPhysicalHeight(BuildContext context) =>
    View.of(context).physicalSize / View.of(context).devicePixelRatio;

double _safeAreaPadding(BuildContext context) =>
    (View.of(context).padding.top + View.of(context).padding.bottom) /
    View.of(context).devicePixelRatio;
