class ChildProfile {
  final String id;
  final String name;
  final DateTime dob;
  final String? photoUrl;
  final TemperamentProfile? temperament;
  final RhythmState? rhythm;

  const ChildProfile({
    required this.id,
    required this.name,
    required this.dob,
    this.photoUrl,
    this.temperament,
    this.rhythm,
  });

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - dob.year) * 12 + now.month - dob.month;
  }

  int get ageInYears => ageInMonths ~/ 12;

  String get ageLabel {
    final months = ageInMonths;
    if (months < 24) return '$months months';
    final years = months ~/ 12;
    final remaining = months % 12;
    if (remaining == 0) return '$years years';
    return '$years yr ${remaining}m';
  }

  /// Age band for rhythm system: "1-2", "2-3", "3-4", "4-5"
  String get ageBand {
    final years = ageInYears;
    if (years < 2) return '1-2';
    if (years < 3) return '2-3';
    if (years < 4) return '3-4';
    return '4-5';
  }

  ChildProfile copyWith({
    String? id,
    String? name,
    DateTime? dob,
    String? photoUrl,
    TemperamentProfile? temperament,
    RhythmState? rhythm,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      photoUrl: photoUrl ?? this.photoUrl,
      temperament: temperament ?? this.temperament,
      rhythm: rhythm ?? this.rhythm,
    );
  }
}

/// Enhanced temperament profile with primary/secondary types and blended scores.
class TemperamentProfile {
  final String primaryType;
  final String? secondaryType;
  final Map<String, double> traits;
  final DateTime? lastUpdated;
  final DateTime? quizCompletedAt;

  const TemperamentProfile({
    required this.primaryType,
    this.secondaryType,
    required this.traits,
    this.lastUpdated,
    this.quizCompletedAt,
  });

  /// Whether recalibration is due (every 6 weeks).
  bool get recalibrationDue {
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated!).inDays >= 42;
  }

  /// Get normalised score for a trait (0-100).
  double traitScore(String trait) => traits[trait] ?? 0;

  /// Returns true if the profile is a blend (secondary present).
  bool get isBlended => secondaryType != null;

  TemperamentProfile copyWithAdjustments(Map<String, double> adjustments) {
    final updated = Map<String, double>.from(traits);
    for (final entry in adjustments.entries) {
      updated[entry.key] = (updated[entry.key] ?? 0) + entry.value;
      updated[entry.key] = updated[entry.key]!.clamp(0, 100);
    }

    // Recalculate primary/secondary
    final sorted = updated.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final typeMap = {
      'persistence': 'strong-willed',
      'sensitivity': 'sensitive',
      'caution': 'cautious',
      'independence': 'independent',
      'adaptability': 'easygoing',
    };

    final newPrimary = typeMap[sorted.first.key] ?? primaryType;
    String? newSecondary;
    if (sorted.length > 1 && sorted[1].value >= sorted.first.value * 0.6) {
      newSecondary = typeMap[sorted[1].key];
    }

    return TemperamentProfile(
      primaryType: newPrimary,
      secondaryType: newSecondary,
      traits: updated,
      lastUpdated: DateTime.now(),
      quizCompletedAt: quizCompletedAt,
    );
  }

  static const types = [
    'strong-willed',
    'sensitive',
    'cautious',
    'independent',
    'easygoing',
  ];
}

/// Current developmental rhythm state.
class RhythmState {
  final String currentPhase;
  final String? secondaryPhase;
  final String confidence;
  final String explanation;
  final DateTime detectedAt;

  const RhythmState({
    required this.currentPhase,
    this.secondaryPhase,
    required this.confidence,
    required this.explanation,
    required this.detectedAt,
  });
}
