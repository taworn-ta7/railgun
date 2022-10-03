/// UploadImage result from upload services.
class UploadImage {
  final String protocol;
  final String host;
  final String path;
  final String name;
  final String url;

  UploadImage.fromJson(Map<String, dynamic> json)
      : protocol = json['protocol'],
        host = json['host'],
        path = json['path'],
        name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'protocol': protocol,
        'host': host,
        'path': path,
        'name': name,
        'url': url,
      };

  @override
  String toString() => url;
}
