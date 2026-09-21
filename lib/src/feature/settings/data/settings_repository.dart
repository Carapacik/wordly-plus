import 'package:wordly/src/feature/settings/data/settings_local_datasource.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';

abstract interface class ISettingsRepository() {
  Future<void> save(Settings settings);

  Future<Settings> read();
}

final class const SettingsRepository({required final SettingsLocalDatasource localDatasource})
    implements ISettingsRepository {
  @override
  Future<void> save(Settings settings) => localDatasource.save(settings);

  @override
  Future<Settings> read() => localDatasource.read();
}
