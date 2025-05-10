// lib/core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}