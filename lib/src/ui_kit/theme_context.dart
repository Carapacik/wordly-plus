import 'package:material_ui/material_ui.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}
