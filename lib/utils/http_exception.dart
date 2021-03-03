class HttpException implements Exception {
  int statusCode;
  String error;
  String message;

  HttpException({this.statusCode, this.error, this.message});

  @override
  String toString() {
    return 'HttpException{statusCode: $statusCode, error: $error, message: $message}';
  }
}
