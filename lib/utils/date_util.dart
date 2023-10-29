import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateUtil {
  //2019-12-03 10:45:07
  static final _displayFormatDateTimeFormat = DateFormat('dd/MM/yyyy hh:mm a');
  static final _displayFormatDateTimeFormatDashed =
      DateFormat('yyyy-MM-dd hh:mm:ss');
  static final _displayFormatDateFormat = DateFormat('dd/MM/yyyy');
  static final _monthFullDateFormat = DateFormat('dd MMMM yyyy');
  static final _shortMonthDateFormat = DateFormat("dd'th' MMM yyyy");
  static final _videoDateFormat = DateFormat('MMM dd, yyyy, hh:mm a');
  static final _bookmarkDateFormat = DateFormat('MMM dd, yyyy');
  static final _timeFormatDateFormat = DateFormat('hh:mm a');

  static final _dateMonthDateFormator = DateFormat('dd MMM');
  static final _weekDayFormator = DateFormat('EEEE');

  static final _serverFormatDate = DateFormat('yyyy-MM-dd');
  static final _serverFormatDateTimeFormat =
      DateFormat('''yyyy-MM-dd HH:mm:ss''');
  static final _dateForChats = DateFormat('dd-MM-yyyy');

  static String getDateMonthFormatTime(DateTime dateTime) {
    return _dateMonthDateFormator.format(dateTime);
  }

  static String getChatDisplayDate(DateTime dateTime) {
    return _dateForChats.format(dateTime);
  }

  static String getWeekDayFromDate(DateTime dateTime) {
    return _weekDayFormator.format(dateTime);
  }

  static String getDisplayFormatDateTime(DateTime dateTime) {
    return _displayFormatDateTimeFormat.format(dateTime);
  }

  static String getDisplayFormatDateTimeDashed(DateTime dateTime) {
    return _displayFormatDateTimeFormatDashed.format(dateTime);
  }

  static String getDisplayFormatTime(DateTime dateTime) {
    return _timeFormatDateFormat.format(dateTime);
  }

  static String? getDisplayFormatDate(DateTime dateTime) {
    return _displayFormatDateFormat.format(dateTime);
  }

  static String getServerFormatDateString(DateTime dateTime) {
    return _serverFormatDate.format(dateTime);
  }

  static DateTime parseServerFormatDateTime(String date) {
    return _serverFormatDate.parse(date);
  }

  static DateTime? parseServerFormatFullDateTime(String date) {
    try {
      return _serverFormatDateTimeFormat.parse(date);
    } catch (ex) {
      return null;
    }
  }

  static String getMonthFullNameDateFormat(DateTime dateTime) {
    return _monthFullDateFormat.format(dateTime);
  }

  static String getVideoDateFormat(DateTime dateTime) {
    return _videoDateFormat.format(dateTime.toLocal());
  }

  static String getBookmarkDateFormat(DateTime dateTime) {
    return _bookmarkDateFormat.format(dateTime);
  }

  static DateTime parseBookmarkDateFormat(String date) {
    return _bookmarkDateFormat.parse(date);
  }

  static DateTime parseVideoDateFormat(String date) {
    return _videoDateFormat.parse(date);
  }

  static String formatTimeText(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  static String timeAgo(DateTime dateTime) {
    Duration differenceDuration = DateTime.now().difference(dateTime);

//    return getDisplayFormatDateTime(dateTime);
    int timeDifference = differenceDuration.inHours;

    if (timeDifference < 24) {
      if (timeDifference <= 0) {
        return '${differenceDuration.inMinutes} min ago';
        // return '${differenceDuration.inMinutes} मिनिटे अगोदर';
      }
      return '$timeDifference hrs ago';
      // return '$timeDifference तास अगोदर';
    } else if (timeDifference > 24) {
      int day = timeDifference ~/ 24;
      int hrs = timeDifference % 24;

      return '$day days $hrs hrs ago';
      // return '$day दिवस $hrs तास अगोदर';
    }

    return getDisplayFormatDateTime(dateTime);
  }

  static String timeAgo2(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  static String timeAgo3(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'en_short');
  }

  static String getCurrentTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String getShortMonthYearDate(DateTime dateTime) {
    return _shortMonthDateFormat.format(dateTime);
  }
}
