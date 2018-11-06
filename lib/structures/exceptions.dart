class ArrayEmptyException extends Exception {
  factory ArrayEmptyException([dynamic message]) => Exception(message);
}

class NotInRangeException extends Exception {
  factory NotInRangeException([dynamic message]) => Exception(message);
}

class InvalidCapacityException extends Exception {
  factory InvalidCapacityException([dynamic message]) => Exception(message);
}