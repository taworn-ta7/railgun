import 'dart:math';
import 'package:test/test.dart';
import 'package:logging/logging.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_services.dart' as services;

/// This test is required:
/// - admin@your.diy, password 'admin'
/// - test0@your.diy, password 'test0'.
/// Both members can be create at Postman, then, imports scripts.
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

  group('members', () {
    final client = Client.def();
    final email = 'test0@your.diy';

    test('list', () async {
      final RestResult rest = await services.membersList(
        client,
      );
      expect(rest.ok, true);
      final items = services.toMemberList(rest, log);
      // at least, one test member is created
      expect(items.length, greaterThanOrEqualTo(1));
      final pagination = services.toPagination(rest, log);
      expect(pagination.page, isNotNull);
    });

    test('get', () async {
      final RestResult rest = await services.membersGet(
        client,
        email: email,
      );
      expect(rest.ok, true);
      final item = services.toMember(rest, log);
      expect(item.email, email);
    });

    test('get icon', () async {
      final RestResult rest = await services.membersGetIcon(
        client,
        email: email,
      );
      expect(rest.ok, true);
      final item = rest.res!.bodyBytes;
      expect(item.length, greaterThanOrEqualTo(0));
    });
  });

  // ----------------------------------------------------------------------

  group('members', () {
    test('sign-up', () async {
      final client = Client.def();
      late final String email;
      late final String password;

      // randoms member email
      final randomize = Random();
      email =
          'test${randomize.nextInt(10000).toString().padLeft(4, '0')}@your.diy';
      password = randomize.nextInt(10000).toString().padLeft(4, '0');
      log.finer('email: $email');

      // sign-up
      String code;
      {
        final rest = await services.membersSignUp(
          client,
          email: email,
          password: password,
          confirmPassword: password,
          locale: 'en',
        );
        if (!rest.ok && rest.res!.statusCode == 403) {
          // already created, skip the rest
          log.finer('your random email is already created, skip');
          expect(true, true);
          return;
        }

        expect(rest.ok, true);
        final url = Uri.parse(rest.json!['url']);
        expect(url.queryParameters.containsKey('code'), true);
        code = url.queryParameters['code'].toString();
        log.finer('code: $code');
      }

      // admin sign-in, password must be default 'admin'
      String adminToken;
      {
        final rest = await services.authenSignIn(
          client,
          email: 'admin@your.diy',
          password: 'admin',
        );
        expect(rest.ok, true);
        adminToken = services.toMemberToken(rest);
      }

      // after admin sign-in, call authorize service
      {
        final rest = await services.adminMembersAuthorize(
          client,
          code: code,
          token: adminToken,
        );
        expect(rest.ok, true);
      }

      // try sign-in
      {
        final rest = await services.authenSignIn(
          client,
          email: email,
          password: password,
        );
        expect(rest.ok, true);
      }
    });
  });
}
