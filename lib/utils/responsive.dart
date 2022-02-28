import 'package:flutter/widgets.dart';

const mobileScreenSize = 425;
const tabletScreenSize = 768;
const desktopScreenSize = 1024;

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletScreenSize;
  }

  static bool isTabletScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletScreenSize &&
        MediaQuery.of(context).size.width < desktopScreenSize;
  }

  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopScreenSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double _width = constraints.maxWidth;
        if (_width >= desktopScreenSize) {
          return desktop ?? mobile;
        } else if (_width >= tabletScreenSize) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
