import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter();

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();
    if (!localDateTime.difference(justNow).isNegative) {
      return "Just Now";
    }
    String roughTimeString = DateFormat('jm').format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return "Yesterday";
    }
    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return weekday;
    }
    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }

  bool isNewUntilYesterday(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime localDateTime = dateTime.toLocal();

    DateTime yesterday = now.subtract(Duration(days: 1));
    if (!localDateTime.difference(yesterday).isNegative) {
      return true;
    }

    return false;
  }
}
