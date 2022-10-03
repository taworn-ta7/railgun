import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import './i18n/strings.g.dart';
import './services/localization.dart';
import './embed.dart';
import './app.dart';

/// Main program.
void main() async {
  // initializes loggings
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    // ignore: avoid_print
    (record) => print(
      "${record.time} ${record.level.name.padRight(7)} ${record.loggerName.padRight(12).characters.take(12)} ${record.message}",
    ),
  );

  // initializes localization
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  LocaleSettings.setLocaleRaw(Localization.instance().current.languageCode);

  if (!kIsWeb) {
    // setup embedding
    await Embed.setup();
  }

  // run app
  runApp(TranslationProvider(child: const App()));
}
