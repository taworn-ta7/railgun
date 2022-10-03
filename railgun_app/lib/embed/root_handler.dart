import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RootEmbed {
  static final log = Logger('RootEmbed');

  static Router setup() => Router()..get('/', root);

  // ----------------------------------------------------------------------

  static Response root(Request req) {
    return Response.ok("Hello, world :)");
  }
}
