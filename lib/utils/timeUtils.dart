String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
}
bool isBeforeToday(DateTime until) => until.compareTo(DateTime.now()) < 0;
