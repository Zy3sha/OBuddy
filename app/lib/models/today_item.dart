/// A single item in the Family Brain / Today screen.
enum TodayPeriod { morning, afternoon, evening }

class TodayItem {
  final String id;
  final String title;
  final String? time;
  final TodayPeriod period;
  final String? assignedTo; // "You", partner name, or null
  final bool isCompleted;
  final String? nudge; // smart guidance nudge

  const TodayItem({
    required this.id,
    required this.title,
    required this.period,
    this.time,
    this.assignedTo,
    this.isCompleted = false,
    this.nudge,
  });
}
