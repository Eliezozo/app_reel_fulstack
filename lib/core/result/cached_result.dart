class CachedResult<T> {
  const CachedResult({required this.data, required this.isFromCache});

  final T data;
  final bool isFromCache;
}
