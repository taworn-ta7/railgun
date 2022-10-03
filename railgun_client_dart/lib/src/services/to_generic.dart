import 'package:logging/logging.dart';
import '../rest_result.dart';
import '../models/pagination.dart';
import '../models/upload_image.dart';

/// Converts to pagination.
Pagination toPagination(
  RestResult rest, [
  Logger? log,
]) {
  final item = Pagination.fromJson(rest.json!['pagination']);
  if (log != null) log.finer("pagination: $item");
  return item;
}

/// Converts to uploaded image.
UploadImage toUploadImage(
  RestResult rest, [
  Logger? log,
]) {
  final item = UploadImage.fromJson(rest.json!['image']);
  if (log != null) log.finer("uploaded image: $item");
  return item;
}
