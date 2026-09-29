sealed class AldiwanException implements Exception {
  const AldiwanException(this.message, {this.statusCode, this.requestId});

  final String message;
  final int? statusCode;
  final String? requestId;

  @override
  String toString() => '$runtimeType: $message';
}

final class AldiwanHttpException extends AldiwanException {
  const AldiwanHttpException(super.message,
      {super.statusCode, super.requestId});
}

final class AldiwanRateLimitException extends AldiwanException {
  const AldiwanRateLimitException(super.message,
      {this.retryAfter, super.requestId})
      : super(statusCode: 429);

  final Duration? retryAfter;
}

final class AldiwanTimeoutException extends AldiwanException {
  const AldiwanTimeoutException(super.message);
}

final class AldiwanNetworkException extends AldiwanException {
  const AldiwanNetworkException(super.message);
}

final class AldiwanFormatException extends AldiwanException {
  const AldiwanFormatException(super.message);
}
