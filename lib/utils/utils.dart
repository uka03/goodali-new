import 'package:html/parser.dart';
import 'package:intl/intl.dart';

String removeHtmlTags(String htmlString, {String? placeholder}) {
  // Parse HTML string to get the text content
  var document = parse(htmlString);
  String text = parse(document.body!.text).documentElement!.text;

  // Remove extra whitespace characters
  text = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (text.isNotEmpty == true) {
    return text;
  } else {
    return placeholder ?? "";
  }
}

String formatDate(String? createdAt, {String? newPattern}) {
  DateTime dateTime = DateTime.now();
  if (createdAt?.isNotEmpty == true) {
    dateTime = DateTime.tryParse(createdAt ?? "") ?? DateTime.now();
  }
  return DateFormat(newPattern ?? 'yyyy.MM.dd').format(dateTime.toLocal());
}

String formatCurrency(int number) {
  final formattedNumber = NumberFormat('#,##0').format(number);
  return "$formattedNumber₮";
}

String formatDuration(int? number) {
  String durationText = "";
  if (number != null) {
    final duration = Duration(seconds: number);

    // Цаг болон минутыг салгаж авна
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      durationText = "$hours цаг $minutes мин";
    } else {
      durationText = "$minutes мин";
    }
  }
  return durationText;
}

String formatNumber(int number) {
  final formattedNumber = NumberFormat('#,##0').format(number);
  return formattedNumber;
}
