import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wordle/app.dart';
import 'package:wordle/bloc/app/bloc_observer.dart';
import 'package:wordle/bloc/settings/settings_cubit.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/settings_data.dart';
import 'package:wordle/data/repositories/settings_repository.dart';
import 'package:wordle/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await platformSpecificFirebase();
  return BlocOverrides.runZoned(
    () async {
      final dictionary = DictionaryData.getInstance();
      await dictionary.getDictionaryLanguage();
      dictionary.createSecretWord();
      await dictionary.getBoard();
      await getStatistic();
      final settingsData = await SettingsRepository.getInstance().getItem();
      runApp(
        BlocProvider<SettingsCubit>(
          create: (_) =>
              SettingsCubit(item: settingsData ?? const SettingsData()),
          child: const App(),
        ),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}
