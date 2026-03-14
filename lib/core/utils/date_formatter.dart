class DateFormatter {
  DateFormatter._();

  static String format(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day-$month-${date.year}';
    } catch (_) {
      return 'Unknown';
    }
  }
}
