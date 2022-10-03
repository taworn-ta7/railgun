import 'package:test/test.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';

void main() {
  group('client:', () {
    final client = Client.def();

    test('base URL', () {
      expect(client.baseUrl, 'http://127.0.0.1:7777/api/');
    });

    test('about', () async {
      final RestResult rest = await client.call(
        MethodType.get,
        client.url('about'),
      );
      expect(rest.ok, true);
    });
  });
}
