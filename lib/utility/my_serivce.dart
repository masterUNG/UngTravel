import 'package:intl/intl.dart';

class MyService {
  String myNumberFormat(double distance) {
    var myFormat = NumberFormat('#.##', 'en_US');
    return myFormat.format(distance);
  }

  String showClock(int sec) {
    Duration duration = Duration(seconds: sec);
    String hour(int n) => n.toString().padLeft(2, "0");
    String minus = hour(duration.inMinutes.remainder(60));
    String second = hour(duration.inSeconds.remainder(60));

    String showTimeString = '${hour(duration.inHours)}:$minus:$second';

    return showTimeString;
  }

  MyService();
}
