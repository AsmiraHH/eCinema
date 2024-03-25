class PagedResult<T> {
  int? pageCount;
  int? totalCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  List<T> items = [];
}
