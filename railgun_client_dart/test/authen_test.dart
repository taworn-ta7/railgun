import 'package:test/test.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_services.dart' as services;

/// This test is required:
/// - test0@your.diy, password 'test0'.
/// This member can be create at Postman, then, imports scripts.
void main() {
  final log = Logger('TEST');
  Logger.root.level = Level.ALL;
  if (true) {
    Logger.root.onRecord.listen(
      // ignore: avoid_print
      (record) => print(
        "${record.time} ${record.level.name.padRight(7)} ${record.loggerName.padRight(12)} ${record.message}",
      ),
    );
  }

  group('authen', () {
    final client = Client.def();
    final email = 'test0@your.diy';
    final password = 'test0';

    setUpAll(() async {
      // sign-in pre-created member
      final rest = await services.authenSignIn(
        client,
        email: email,
        password: password,
      );
      expect(rest.ok, true);
      client.token = services.toMemberToken(rest);
    });

    tearDownAll(() async {
      // sign-out
      final rest = await services.authenSignOut(
        client,
      );
      expect(rest.ok, true);
    });

    // ----------------------------------------------------------------------

    test('change icon', () async {
      final fileName = path.join('test', 'assets', 'boss.png');
      final RestResult rest = await services.profileUploadIcon(
        client,
        file: await http.MultipartFile.fromPath(
          'image',
          fileName,
          contentType: MediaType('image', 'png'),
        ),
      );
      expect(rest.ok, true);
      final item = services.toUploadImage(rest, log);
      expect(item.url, isNotNull);
    });

    test('change name', () async {
      final RestResult rest = await services.profileChangeName(
        client,
        name: "TEST",
      );
      expect(rest.ok, true);
      final item = services.toMember(rest, log);
      expect(item.name == "TEST", true);
    });

    test('settings', () async {
      final RestResult rest = await services.settingsChange(
        client,
        locale: 'th',
      );
      expect(rest.ok, true);
      final item = services.toMember(rest, log);
      expect(item.locale == 'th', true);
    });
  });

  // ----------------------------------------------------------------------

  group('authen', () {
    final client = Client.def();
    final email = 'test0@your.diy';
    final password = 'test0';

    setUpAll(() async {
      // sign-in pre-created member
      final rest = await services.authenSignIn(
        client,
        email: email,
        password: password,
      );
      expect(rest.ok, true);
      client.token = services.toMemberToken(rest);
    });

    tearDownAll(() async {
      // no sign-out since it already sign-out in test change password
    });

    // ----------------------------------------------------------------------

    test('change password', () async {
      final RestResult rest = await services.profileChangePassword(
        client,
        currentPassword: password,
        newPassword: password,
        confirmPassword: password,
      );
      expect(rest.ok, true);
    });
  });
}
