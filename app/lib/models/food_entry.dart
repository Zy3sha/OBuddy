enum ExposureStage { seen, touched, smelled, tasted, eating }

class FoodEntry {
  final String name;
  final ExposureStage stage;
  final bool isSafeFood;
  final List<FoodExposure> exposures;

  const FoodEntry({
    required this.name,
    this.stage = ExposureStage.seen,
    this.isSafeFood = false,
    this.exposures = const [],
  });
}

class FoodExposure {
  final DateTime date;
  final ExposureStage stage;
  final String reaction; // positive, neutral, refused

  const FoodExposure({
    required this.date,
    required this.stage,
    required this.reaction,
  });
}
