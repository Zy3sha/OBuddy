class PathProgress {
  final String pathId;
  final String status; // not_started, active, completed
  final int currentStage;
  final int totalStages;
  final String todayGoal;
  final Map<String, dynamic> data;

  const PathProgress({
    required this.pathId,
    this.status = 'not_started',
    this.currentStage = 0,
    this.totalStages = 5,
    this.todayGoal = '',
    this.data = const {},
  });

  double get progress =>
      totalStages > 0 ? currentStage / totalStages : 0.0;
}
