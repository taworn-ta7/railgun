import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../widgets/back_drop.dart';
import '../services/theme_manager.dart';
import '../services/localization.dart';
import '../services/app_share.dart';
import '../styles.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';

/// SettingsPage class.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

/// _SettingsState internal class.
class _SettingsState extends State<SettingsPage> {
  static final log = Logger('SettingsPage');
  static final appShare = AppShare.instance();

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
    final tr = t.settingsPage;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
      ),
      drawer: const CustomDrawer(),
      body: BackDrop(
        asset: 'assets/backdrops/20-settings.png',
        child: SingleChildScrollView(
          child: Styles.around(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // locale
                Text(
                  tr.locale,
                  style: Styles.titleTextStyle(),
                ),
                Styles.betweenVertical(),
                Row(
                  children: [
                    // English language
                    IconButton(
                      icon: Image.asset('assets/locales/en.png'),
                      tooltip: t.switchLocale.en,
                      onPressed: () => _changeLocale('en'),
                    ),

                    // Thai language
                    IconButton(
                      icon: Image.asset('assets/locales/th.png'),
                      tooltip: t.switchLocale.th,
                      onPressed: () => _changeLocale('th'),
                    ),
                  ],
                ),
                Styles.betweenVerticalBigger(),

                // color theme
                Text(
                  tr.color,
                  style: Styles.titleTextStyle(),
                ),
                Styles.betweenVertical(),
                Row(children: _buildColorButtons(context, 0, 4)),
                Styles.betweenVertical(),
                Row(children: _buildColorButtons(context, 4, 8)),
                Styles.betweenVertical(),
                Row(children: _buildColorButtons(context, 8, 12)),
                Styles.betweenVertical(),
                Row(children: _buildColorButtons(context, 12, 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildColorButtons(
    BuildContext context,
    int start,
    int end,
  ) {
    const text = Text('    ');
    final result = <Widget>[];
    for (var i = start; i < end; i++) {
      final color = ThemeManager.list[i];
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          child: Styles.buttonPadding(text),
          onPressed: () => _changeColorTheme(i),
        ),
      );
      result.add(
        Styles.betweenHorizontal(),
      );
    }
    return result;
  }

  // ----------------------------------------------------------------------

  Future<void> _changeLocale(String locale) async {
    final localization = Localization.instance();
    setState(() {
      localization.change(context, locale);
    });
    appShare.saveLocale(locale);
  }

  Future<void> _changeColorTheme(int index) async {
    final themeManager = ThemeManager.instance();
    setState(() {
      themeManager.change(context, index);
    });
    appShare.saveTheme(index);
  }
}
