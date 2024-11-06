extension ListExtensions on List {
  int limitLenght(int limit) {
    if (limit > length) {
      return length;
    }
    return limit;
  }
}
