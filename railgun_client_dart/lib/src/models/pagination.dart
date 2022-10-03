/// Pagination result from list services.
class Pagination {
  final int page;
  final int offset;
  final int rowsPerPage;
  final int count;
  final int pageIndex;
  final int pageCount;
  final int pageStart;
  final int pageStop;
  final int pageSize;

  Pagination.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        offset = json['offset'],
        rowsPerPage = json['rowsPerPage'],
        count = json['count'],
        pageIndex = json['pageIndex'],
        pageCount = json['pageCount'],
        pageStart = json['pageStart'],
        pageStop = json['pageStop'],
        pageSize = json['pageSize'];

  Map<String, dynamic> toJson() => {
        'page': page,
        'offset': offset,
        'rowsPerPage': rowsPerPage,
        'count': count,
        'pageIndex': pageIndex,
        'pageCount': pageCount,
        'pageStart': pageStart,
        'pageStop': pageStop,
        'pageSize': pageSize,
      };

  @override
  String toString() =>
      "${page + 1}/$pageCount, offset=$offset, rowsPerPage=$rowsPerPage, count=$count";
}
