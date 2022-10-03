import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import './embed/root_handler.dart';
import './embed/echo_handler.dart';

/// Embedded class.
class Embed {
  static final log = Logger('Embed');

  static late final int port;
  static late final String host;

  // ----------------------------------------------------------------------

  static Future<void> setup() async {
    final adder =
        Cascade().add(RootEmbed.setup()).add(EchoEmbed().setup()).handler;
    final handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(adder);

    final ip = InternetAddress.anyIPv4;
    const port = 8080;
    final server = await serve(handler, ip, port);
    log.info("embed server listening on port ${server.port}");

    Embed.port = server.port;
    Embed.host = 'http://127.0.0.1:$port';
  }

  static Uri url(String relativePath) =>
      Uri.parse('${Embed.host}/$relativePath');
}
