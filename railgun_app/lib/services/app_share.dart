import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:railgun_app/services/theme_manager.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/wait_box.dart';
import './theme_manager.dart';
import './localization.dart';
import './service_runner.dart';
import '../constants.dart';

/// Application shared service singleton class.
class AppShare {
  static AppShare? _instance;

  static AppShare instance() {
    _instance ??= AppShare();
    return _instance!;
  }

  // ----------------------------------------------------------------------

  static final log = Logger('AppShare');

  /// Constructor.
  AppShare();

  // ----------------------------------------------------------------------

  /// Railgun client.
  final Client client = Client(baseUrl: Constants.baseUrl);

  /// Authentication.
  final Authen authen = Authen();

  // ----------------------------------------------------------------------

  /// Sign-in over-all function.
  Future<bool> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    // sign-in to service
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await authen.signIn(client, email: email, password: password);
      },
    );
    if (rest == null || !rest.ok) return false;
    client.token = authen.token;

    // sign-in flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('member.signin', true);

    // member settings
    // ignore: use_build_context_synchronously
    Localization.instance().change(context, authen.member!.locale);
    // ignore: use_build_context_synchronously
    ThemeManager.instance().change(context, authen.getInt('app-theme', 0));

    log.info("sign-in to system, welcome :)");
    return true;
  }

  /// Sign-out over-all function.
  Future<void> signOut(
    BuildContext context,
  ) async {
    // sign-out from service
    await WaitBox.show(
      context,
      () async {
        return await authen.signOut(client);
      },
    );
    client.token = null;

    // sign-in flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('member.signin');

    // moves out to first page
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
    // ignore: use_build_context_synchronously
    ThemeManager.instance().change(context, 0);

    log.info("sign-out from system gracefully :)");
  }

  // ----------------------------------------------------------------------

  /// Saves locale settings.
  Future<void> saveLocale(String locale) async {
    final RestResult rest = await services.settingsChange(
      client,
      locale: locale,
    );
    if (!rest.ok) return;
    final item = services.toMember(rest);
    authen.updateMember(item);
  }

  /// Saves theme settings.
  Future<void> saveTheme(int index) async {
    final value = index.toString();
    final RestResult rest = await services.settingsSet(
      client,
      key: 'app-theme',
      value: value,
    );
    if (!rest.ok) return;
    authen.settings['app-theme'] = value;
  }
}
