import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import './i18n/strings.g.dart';
import './services/localization.dart';
import './services/theme_manager.dart';
import './pages.dart';
import './pages/begin.dart';
import './pages/dashboard.dart';
import './pages/members.dart';
import './pages/settings.dart';

/// App class.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();

  static void refresh(BuildContext context) async =>
      context.findAncestorStateOfType<_AppState>()?.refresh();
}

/// _AppState internal class.
class _AppState extends State<App> {
  static final log = Logger('App');

  @override
  void initState() {
    super.initState();
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.instance();
    final localization = Localization.instance();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: localization.list,
      locale: localization.current,
      theme: ThemeData(
        primarySwatch: themeManager.current,
      ),
      onGenerateRoute: (settings) {
        const transition = PageTransitionType.bottomToTop;
        var path = settings.name ?? '';
        switch (path) {
          case Pages.dashboard:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const DashboardPage(),
            );

          case Pages.members:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const MembersPage(),
            );

          case Pages.settings:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const SettingsPage(),
            );

          case '/':
          case '':
            return PageTransition(
              type: transition,
              settings: settings,
              child: const BeginPage(),
            );
        }
        return null;
      },
      initialRoute: '/',
      title: t.app,
      debugShowCheckedModeBanner: false,
    );
  }

  // ----------------------------------------------------------------------

  void refresh() => setState(() {});
}
