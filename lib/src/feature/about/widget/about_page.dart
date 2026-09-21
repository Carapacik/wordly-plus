import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/link.dart';
import 'package:wordly/src/feature/app/model/app_links.dart';
import 'package:wordly/src/feature/app/widget/dependencies_context.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/layout/constraint_screen.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';

class const AboutPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: context.l10n.about,
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.l10n.about, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
        ),
        body: ConstraintScreen(
          child: Column(
            children: [
              const Spacer(),
              const Text('Carapacik Space', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const _CreditNameText(text: 'Roman Laptev - Carapacik', url: AppLinks.mySite),
              const Spacer(flex: 10),
              Link(
                uri: Uri.parse(
                  'mailto:${AppLinks.email}?'
                  '${context.l10n.sendMessage}',
                ),
                builder: (context, followLink) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: followLink,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(text: context.l10n.contact),
                          const WidgetSpan(
                            child: SelectableText(
                              AppLinks.email,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                context.dependencies.packageInfo.version,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class const _CreditNameText({required final String text, required final String url}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Link(
    uri: Uri.parse(url),
    builder: (context, followLink) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: followLink,
        behavior: HitTestBehavior.opaque,
        child: Text(text, style: const TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
      ),
    ),
  );
}
