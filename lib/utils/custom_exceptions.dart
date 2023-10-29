class CustomException implements Exception {
  final dynamic _prefix;
  final dynamic _message;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message]) : super(message, "Error during communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid request: ");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid  input: ");
}
