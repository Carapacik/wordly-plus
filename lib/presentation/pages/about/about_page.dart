import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';
import 'package:wordly/presentation/pages/about/models/credit_people.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const email = 'carapacik@gmail.com';

  static const rofl = [
    CreditPeople('Carapacik', 'https://github.com/Carapacik')
  ];

  static const gameDesign = [
    CreditPeople('Carapacik', 'https://github.com/Carapacik'),
    CreditPeople('Sancene', 'https://github.com/Sancene'),
  ];

  static const visualDesign = [
    CreditPeople('Carapacik', 'https://github.com/Carapacik'),
    CreditPeople('Mary Wilson', 'https://www.behance.net/bugagam'),
  ];

  static const dictionary = [
    CreditPeople('Carapacik', 'https://github.com/Carapacik'),
    CreditPeople('Alex Dekhant', 'https://github.com/Dekhant'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: R.stringsOf(context).about,
        ),
        body: ConstraintScreen(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _CreditCategory(
                  title: R.stringsOf(context).created_by,
                  peoples: rofl,
                ),
                _CreditCategory(
                  title: R.stringsOf(context).game_design,
                  peoples: gameDesign,
                ),
                _CreditCategory(
                  title: R.stringsOf(context).visual_design,
                  peoples: visualDesign,
                ),
                _CreditCategory(
                  title: R.stringsOf(context).dictionary,
                  peoples: dictionary,
                ),
                _CreditCategory(
                  title: R.stringsOf(context).scenario,
                  peoples: rofl,
                ),
                const Spacer(),
                Link(
                  uri: Uri.parse(
                    'mailto:$email?'
                    '${R.stringsOf(context).message_new_word}',
                  ),
                  builder: (context, followLink) => MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: kIsWeb
                          ? () => Clipboard.setData(
                                const ClipboardData(text: email),
                              )
                          : followLink,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: R.stringsOf(context).contact,
                              style: AppTypography.m16.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            WidgetSpan(
                              child: SelectableText(
                                email,
                                style: AppTypography.m18.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
}

class _CreditCategory extends StatelessWidget {
  const _CreditCategory({
    required this.title,
    required this.peoples,
  });

  final String title;
  final List<CreditPeople> peoples;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.b25,
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) => Center(
              child: _CreditNameText(
                text: peoples[index].name,
                url: peoples[index].url,
              ),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemCount: peoples.length,
          ),
          const SizedBox(height: 8),
        ],
      );
}

class _CreditNameText extends StatelessWidget {
  const _CreditNameText({
    required this.text,
    required this.url,
  });

  final String text;
  final String url;

  @override
  Widget build(BuildContext context) => Link(
        uri: Uri.parse(url),
        builder: (context, followLink) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: followLink,
            behavior: HitTestBehavior.opaque,
            child: Text(
              text,
              style: AppTypography.m18
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ),
      );
}
