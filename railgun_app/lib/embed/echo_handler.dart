import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../logger.dart';

class EchoEmbed {
  static final log = Logger('EchoEmbed');

  Router setup() => Router()..post('/echo/<message>', echo);

  // ----------------------------------------------------------------------

  Response echo(Request request) {
    final message = request.params['message'];
    debugLog.d("echo request: $message");
    log.finer("echo request: $message");
    return Response.ok("$message\n");
  }
}
