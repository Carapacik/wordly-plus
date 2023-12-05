import 'dart:async';

import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/settings/src/data/datasources/settings_local_datasource.dart';

final class const SettingsRepositoryImpl({required final SettingsLocalDatasource localDatasource})
    implements SettingsRepository {
  @override
  Future<void> save(Settings settings) async {
    await localDatasource.save(settings);
  }

  @override
  Future<Settings> read() => localDatasource.read();
}
