/// REST results error.
class RestError {
  final int statusCode;
  final Map<String, dynamic>? locales;
  final String? path;
  final String? requestId;
  final DateTime? timestamp;

  RestError.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'],
        locales = json['locales'] as Map<String, dynamic>?,
        path = json['path'] as String?,
        requestId = json['requestId'] as String?,
        timestamp = json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String);

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'locales': locales,
        'path': path,
        'requestId': requestId,
        'timestamp': timestamp,
      };

  @override
  String toString() =>
      "$statusCode${locales != null ? ' ' + locales!['en'] : ''}; requestId=$requestId, timestamp=$timestamp, path=$path";
}
