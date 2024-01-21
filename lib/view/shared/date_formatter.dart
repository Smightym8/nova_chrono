import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateWithTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
  }

  static String formatDateWithoutTime(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date.toLocal());
  }
}
