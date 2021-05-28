class ServerException implements Exception {
  final message;

  ServerException([this.message]);

  @override
  String toString() {
    return "ServerError ${message ?? ""}";
  }
}

class ServerTooManyRequestsException implements ServerException {
  final message;

  ServerTooManyRequestsException([this.message]);

  @override
  String toString() {
    return "ServerTooManyRequestsException ${message ?? ""}";
  }
}
