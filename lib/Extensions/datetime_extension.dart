extension DateTimeResponseExtension on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}