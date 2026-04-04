import 'package:intl/intl.dart';

String formatTime(String rawTime) {
  final dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(rawTime);
  return DateFormat('h:mm a').format(dateTime);
}
