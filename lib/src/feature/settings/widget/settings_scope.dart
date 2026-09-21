import 'package:flutter/widgets.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/logging/app_logger.dart';
import 'package:wordly/src/utils/mutex_lock.dart';

class const SettingsScope({
  required final ISettingsRepository repository,
  required final Settings initialSettings,
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  static SettingsScopeState of(BuildContext context, {bool listen = false}) {
    final _SettingsInherited? scope = listen
        ? context.dependOnInheritedWidgetOfExactType<_SettingsInherited>()
        : context.getInheritedWidgetOfExactType<_SettingsInherited>();
    assert(scope != null, 'SettingsScope is missing');
    return scope!.state;
  }

  @override
  SettingsScopeState createState() => SettingsScopeState();
}

class SettingsScopeState() extends State<SettingsScope> {
  final _queue = MutexLock();
  late Settings _settings = widget.initialSettings;
  Settings? _failedSettings;
  Object? _error;
  bool _saving = false;
  int _revision = 0;

  Settings get settings => _settings;

  Object? get error => _error;

  bool get isSaving => _saving;

  // Apply queued edits to the last successfully saved settings to avoid lost updates.
  Future<bool> update(Settings Function(Settings) transform) => _queue.runLocked(() async {
    if (!mounted) {
      return false;
    }
    final Settings next = transform(_settings);
    if (next == _settings && _error == null) {
      return true;
    }
    _saving = true;
    _error = null;
    _changed();
    try {
      await widget.repository.save(next);
      _settings = next;
      _failedSettings = null;
      return true;
    } on Object catch (error, stack) {
      _failedSettings = next;
      _error = error;
      AppLogger.error('Settings save failed', error, stack, name: 'Settings');
      return false;
    } finally {
      _saving = false;
      _changed();
    }
  });

  Future<bool> retry() => update((current) => _failedSettings ?? current);

  void _changed() {
    if (mounted) {
      setState(() => _revision++);
    }
  }

  @override
  Widget build(BuildContext context) => _SettingsInherited(state: this, revision: _revision, child: widget.child);
}

class const _SettingsInherited({
  required final SettingsScopeState state,
  required final int revision,
  required super.child,
}) extends InheritedWidget {
  @override
  bool updateShouldNotify(_SettingsInherited oldWidget) => revision != oldWidget.revision;
}
