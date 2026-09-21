import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/logging/app_logger.dart';

class const InitializationFailedApp({
  required final Object error,
  required final StackTrace stackTrace,
  final Future<void> Function()? onRetryInitialization,
  super.key,
}) extends StatefulWidget {
  @override
  State<InitializationFailedApp> createState() => _InitializationFailedAppState();
}

class _InitializationFailedAppState() extends State<InitializationFailedApp> {
  bool _inProgress = false;

  Future<void> _retryInitialization() async {
    if (_inProgress) {
      return;
    }
    setState(() => _inProgress = true);
    try {
      await widget.onRetryInitialization?.call();
    } on Object catch (error, stack) {
      AppLogger.error('Initialization retry failed', error, stack);
    } finally {
      if (mounted) {
        setState(() => _inProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: Localization.localizationDelegates,
    supportedLocales: Localization.supportedLocales,
    locale: Localization.deviceLocale,
    debugShowCheckedModeBanner: false,
    onGenerateTitle: (context) => context.l10n.appTitle,
    home: Builder(
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.initializationFailed,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.initializationFailedDescription, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  if (_inProgress) const CircularProgressIndicator(),
                  if (widget.onRetryInitialization != null)
                    TextButton(onPressed: _inProgress ? null : _retryInitialization, child: Text(context.l10n.retry)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
