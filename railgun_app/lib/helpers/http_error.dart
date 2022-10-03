import 'package:railgun_client_dart/railgun_client_dart.dart';
import '../i18n/strings.g.dart';

class HttpError {
  static String get(RestError e, String locale) {
    // first, finds in locales
    if (e.locales != null) {
      String text = e.locales!.containsKey(locale)
          ? e.locales![locale]!
          : e.locales!['en']!;
      return text;
    }

    // if not, checks in HTTP status codes
    String error = e.statusCode.toString();
    String? text = t['error.e$error'];
    if (text != null) return text;

    // finally, if not, uses error with HTTP status code
    return t.error.unknown(statusCode: e.statusCode);
  }
}
