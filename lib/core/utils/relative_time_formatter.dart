/// Compact relative time the We36 way: "now", "2h", "1d", "3w", then an
/// absolute short date for older items. Locale-aware buckets via the provided
/// short-unit labels (Constitution XIV).
class RelativeTimeFormatter {
  const RelativeTimeFormatter({RelativeTimeLabels? labels})
    : labels = labels ?? const RelativeTimeLabels.en();

  final RelativeTimeLabels labels;

  String format(DateTime time, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(time);
    if (diff.inSeconds < 60) return labels.now;
    if (diff.inMinutes < 60) return '${diff.inMinutes}${labels.minute}';
    if (diff.inHours < 24) return '${diff.inHours}${labels.hour}';
    if (diff.inDays < 7) return '${diff.inDays}${labels.day}';
    if (diff.inDays < 365) return '${diff.inDays ~/ 7}${labels.week}';
    return '${diff.inDays ~/ 365}${labels.year}';
  }
}

/// Locale-specific single-letter units (kept tiny for the feed/stories voice).
class RelativeTimeLabels {
  const RelativeTimeLabels({
    required this.now,
    required this.minute,
    required this.hour,
    required this.day,
    required this.week,
    required this.year,
  });

  const RelativeTimeLabels.en()
    : now = 'now',
      minute = 'm',
      hour = 'h',
      day = 'd',
      week = 'w',
      year = 'y';

  const RelativeTimeLabels.vi()
    : now = 'vừa xong',
      minute = ' phút',
      hour = ' giờ',
      day = ' ngày',
      week = ' tuần',
      year = ' năm';

  final String now;
  final String minute;
  final String hour;
  final String day;
  final String week;
  final String year;
}
