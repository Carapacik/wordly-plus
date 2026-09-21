import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization_context.dart';

class const HaveNotPlayed({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Text(
          context.l10n.notPlayed,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
