import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wordly/src/feature/settings/data/settings_codec.dart';
import 'package:wordly/src/feature/settings/data/settings_local_datasource.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('legacy settings default to normal mode and copyWith retains hard mode', () {
    final Settings settings = const SettingsCodec().decode({'dictionary': 'en'});
    expect(settings.hardMode, isFalse);
    final Settings hard = settings.copyWith(hardMode: true);
    expect(hard, isNot(settings));
    expect(hard.copyWith().hardMode, isTrue);
    expect(const SettingsCodec().decode(const SettingsCodec().encode(hard)).hardMode, isTrue);
  });

  test('hard mode survives recreating the settings repository', () async {
    final SharedPreferencesAsyncPlatform? previous = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = previous);
    final repository = SettingsRepository(
      localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: SharedPreferencesAsync()),
    );
    await repository.save((await repository.read()).copyWith(hardMode: true));
    final restored = SettingsRepository(
      localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: SharedPreferencesAsync()),
    );
    expect((await restored.read()).hardMode, isTrue);
  });
}
