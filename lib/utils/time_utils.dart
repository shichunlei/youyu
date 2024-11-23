import 'package:day/day.dart';

class TimeUtils {
  ///转毫秒时间戳
  static int milliTimestampByDateStr(String dateStr) {
    DateTime time = DateTime.parse(dateStr);
    return time.millisecondsSinceEpoch;
  }

  ///时间戳与当前时间差(返回毫秒)
  static int nowTimeDiff(int milliTimestamp) {
    DateTime currentTime = DateTime.now();
    return milliTimestamp - currentTime.millisecondsSinceEpoch;
  }

  ///日时秒分倒计时
  static String countDownTimeBySeconds(int seconds) {
    if (seconds < 0) {
      return '00:00';
    }
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600 % 24;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return "${_formatTime(day)}:${_formatTime(hour)}:${_formatTime(minute)}:${_formatTime(second)}";
    } else if (hour != 0) {
      return "${_formatTime(hour)}:${_formatTime(minute)}:${_formatTime(second)}";
    } else if (minute != 0) {
      return "${_formatTime(minute)}:${_formatTime(second)}";
    } else if (second != 0) {
      return "00:${_formatTime(second)}";
    } else {
      return '00:00';
    }
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String _formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }

  ///时间显示，刚刚，x分钟前
  ///timeStamp 是秒级时间戳
  static String _messageTime(int timeStamp) {
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    int distance = time - timeStamp;
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return customStampStr(
          timestamp: timeStamp, date: 'MM/DD hh:mm', toInt: false);
    } else {
      return customStampStr(
          timestamp: timeStamp, date: 'YY/MM/DD hh:mm', toInt: false);
    }
  }

  ///显示时间 timestamp是秒级时间戳
  static String displayTime(int timestamp) {
    DateTime t = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime n = DateTime.now();
    int differenceDays = n.difference(t).inDays;

    if (differenceDays > 3) {
      return Day.fromDateTime(t).format('MM-DD');
    } else if (differenceDays < 1) {
      int differenceHours = n.difference(t).inHours;
      if (differenceHours < 1) {
        int differenceMinutes = n.difference(t).inMinutes;
        if (differenceMinutes < 1) {
          return "刚刚";
          // return '${n
          //     .difference(t)
          //     .inSeconds}秒钟前';
        } else {
          return '$differenceMinutes 分钟前';
        }
      } else {
        return '$differenceHours 小时前';
      }
    } else {
      return '$differenceDays 天前';
    }
  }

  ///时间戳转时间
  static String customStampStr({
    int? timestamp, // 为空则显示当前时间
    String? date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
    bool toInt = true, // 去除0开头
  }) {
    timestamp ??= (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String yY = dateArr.split('-')[0];
    String mM = dateArr.split('-')[1];
    String dD = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mm = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      mM = (int.parse(mM)).toString();
      dD = (int.parse(dD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (date == null) {
      return timeStr;
    }

    date = date
        .replaceAll('YY', yY)
        .replaceAll('MM', mM)
        .replaceAll('DD', dD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);

    return date;
  }

  ///会话时间
  static String ucTimeAgo(int millTime) {
    //当前日期
    DateTime nowDate = DateTime.now();
    //传入的日期 millTime为毫秒级时间戳
    DateTime conDate = DateTime.fromMillisecondsSinceEpoch(millTime);

    //转换后的时间
    String returnTime = '';

    if (nowDate.year != conDate.year) {
      returnTime = '${conDate.year}年';
    }

    if (nowDate.month != conDate.month) {
      returnTime = '$returnTime${conDate.month}月';
    }

    if (nowDate.day != conDate.day) {
      if (nowDate
              .difference(DateTime(conDate.year, conDate.month, conDate.day))
              .inDays ==
          1) {
        returnTime = '昨日 ';
      } else {
        returnTime = '${conDate.month}月$returnTime${conDate.day}日 ';
      }
    }

    // 凌晨：0时至5时；早晨：5时至8时；上午：8时至11时；中午：11时至13时；下午：13时至16时；傍晚：16时至19时；晚上：19时至24时。

    int conHour = conDate.hour;

    return '$returnTime${conHour.toString().padLeft(2, '0')}:${conDate.minute.toString().padLeft(2, '0')}';
  }

  ///时间戳 -> 月日
  static String dateToMonthDay(int timeDate) {
    int time = timeDate * 1000;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String monthDay =
        '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    return monthDay;
  }

  ///计算剩余时间 -> 月/天
  static String getRemainingTime(int futureUnixTimestamp) {
    DateTime futureDateTime =
        DateTime.fromMillisecondsSinceEpoch(futureUnixTimestamp * 1000);
    DateTime now = DateTime.now();

    // 计算剩余天数
    int remainingDays = futureDateTime.difference(now).inDays;

    if (remainingDays < 30) {
      return '$remainingDays天';
    } else {
      // 计算剩余月数
      int remainingMonths = calculateRemainingMonths(now, futureDateTime);
      return '$remainingMonths月';
    }
  }

  static int calculateRemainingMonths(DateTime start, DateTime end) {
    int yearsDifference = end.year - start.year;
    int monthsDifference = end.month - start.month;

    int totalMonths = yearsDifference * 12 + monthsDifference;

    // 如果结束日期的天数小于开始日期的天数，则减去一个月
    if (end.day < start.day) {
      totalMonths -= 1;
    }

    return totalMonths;
  }
}
