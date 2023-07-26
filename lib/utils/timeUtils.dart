import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
}
bool isBeforeToday(DateTime until) => until.compareTo(DateTime.now()) < 0;

Color dayColor(DateTime until) {
  var result = until.compareTo(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));
  if (result < 0) return Colors.red;
  if (result == 0) return Colors.orange;
  return Colors.white;
}