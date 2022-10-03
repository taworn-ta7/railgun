import 'dart:typed_data';
import 'package:logging/logging.dart';
import './rest_result.dart';
import './client.dart';
import './models/member.dart';
import './services/authen.dart';
import './services/profile.dart';
import './services/settings.dart';
import './services/to_members.dart';

/// Provides authentication, store member and related fields.
class Authen {
  static final log = Logger('Authen');

  /// Constructor.
  Authen();

  // ----------------------------------------------------------------------

  /// Is signed-in?
  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;

  /// Current member.
  Member? _member;
  Member? get member => _member;

  /// Current token.
  String? _token;
  String? get token => _token;

  /// Current icon.
  Uint8List? _icon;
  Uint8List? get icon => _icon;

  /// Current settings.
  Map<String, dynamic> settings = {};

  /// Sign-in function.
  Future<RestResult> signIn(
    Client client, {
    required String email,
    required String password,
  }) async {
    // calls sign-in
    final rest = await authenSignIn(
      client,
      email: email,
      password: password,
      outputJsonLog: true,
    );
    if (!rest.ok) return rest;
    _member = toMember(rest, log);
    _token = toMemberToken(rest, log);

    {
      // calls get icon
      final rest = await profileViewIcon(
        client,
        token: token,
      );
      if (!rest.ok) {
        _icon = null;
      } else {
        _icon = rest.res!.bodyBytes;
      }
    }

    {
      // calls get settings
      final rest = await settingsGetAll(
        client,
        token: token,
      );
      if (!rest.ok) {
        settings = {};
      } else {
        settings = rest.json!['settings'];
      }
    }

    _isSignIn = true;
    return rest;
  }

  /// Sign-out function.
  Future<RestResult> signOut(Client client) async {
    // calls sign-out
    final rest = await authenSignOut(
      client,
    );

    _isSignIn = false;
    _member = null;
    _token = null;
    _icon = null;
    settings = {};
    return rest;
  }

  // ----------------------------------------------------------------------

  /// Updates member.
  void updateMember(Member value) {
    if (!isSignIn) throw AssertionError("NOT isSignIn!");
    _member = value;
  }

  /// Updates icon.
  void updateIcon(Uint8List? icon) {
    if (!isSignIn) throw AssertionError("NOT isSignIn!");
    _icon = icon;
  }

  // ----------------------------------------------------------------------

  /// Gets settings.
  String get(String key, String defaultValue) {
    if (settings.containsKey(key)) {
      return settings[key];
    }
    return defaultValue;
  }

  /// Gets settings as integer.
  int getInt(String key, int defaultValue) {
    if (settings.containsKey(key)) {
      final value = settings[key];
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Gets settings as floating-point.
  double getFloat(String key, double defaultValue) {
    if (settings.containsKey(key)) {
      final value = settings[key];
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }
}
