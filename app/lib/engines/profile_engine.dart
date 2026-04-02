import '../models/child_profile.dart';
import '../models/behaviour_incident.dart';
import '../data/temperament_system.dart';

/// Child Profile Engine.
/// Handles temperament quiz scoring, adaptive recalibration,
/// rhythm phase detection, and profile display data.
class ProfileEngine {
  // ────────────────────────────────────────────────────────
  // QUIZ SCORING
  // ────────────────────────────────────────────────────────

  /// Score the temperament quiz from a list of answer score maps.
  /// Each answer is a Map<String, double> mapping temperament id to score.
  static TemperamentProfile scoreQuiz(List<Map<String, double>> answers) {
    final totals = <String, double>{
      'strong-willed': 0,
      'sensitive': 0,
      'cautious': 0,
      'independent': 0,
      'easygoing': 0,
    };

    for (final answer in answers) {
      for (final entry in answer.entries) {
        totals[entry.key] = (totals[entry.key] ?? 0) + entry.value;
      }
    }

    // Normalise to 0–100
    final maxVal = totals.values.reduce((a, b) => a > b ? a : b);
    if (maxVal > 0) {
      for (final key in totals.keys) {
        totals[key] = ((totals[key]! / maxVal) * 100).clamp(0, 100);
      }
    }

    // Map temperament ids to trait keys
    final traitMap = {
      'strong-willed': 'persistence',
      'sensitive': 'sensitivity',
      'cautious': 'caution',
      'independent': 'independence',
      'easygoing': 'adaptability',
    };

    final traits = <String, double>{};
    for (final entry in totals.entries) {
      final traitKey = traitMap[entry.key];
      if (traitKey != null) traits[traitKey] = entry.value;
    }

    // Determine primary + secondary
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primary = sorted.first.key;
    String? secondary;
    if (sorted.length > 1 && sorted[1].value >= sorted.first.value * 0.6) {
      secondary = sorted[1].key;
    }

    return TemperamentProfile(
      primaryType: primary,
      secondaryType: secondary,
      traits: traits,
      lastUpdated: DateTime.now(),
      quizCompletedAt: DateTime.now(),
    );
  }

  // ────────────────────────────────────────────────────────
  // BEHAVIOUR-BASED ANALYSIS (fallback if no quiz)
  // ────────────────────────────────────────────────────────

  /// Analyse behaviour incidents to detect temperament traits.
  static TemperamentProfile? analyseFromBehaviour(
      List<BehaviourIncident> incidents) {
    if (incidents.length < 5) return null;

    final traits = <String, double>{
      'persistence': 0,
      'sensitivity': 0,
      'independence': 0,
      'caution': 0,
      'adaptability': 0,
    };

    for (final incident in incidents) {
      switch (incident.type) {
        case 'tantrum':
        case 'control':
          traits['persistence'] = (traits['persistence'] ?? 0) + 10;
          break;
        case 'clinginess':
        case 'frustration_skill':
          traits['sensitivity'] = (traits['sensitivity'] ?? 0) + 10;
          break;
        case 'refusing':
        case 'not_listening':
          traits['independence'] = (traits['independence'] ?? 0) + 10;
          break;
        case 'transitions':
        case 'bedtime_struggle':
          traits['caution'] = (traits['caution'] ?? 0) + 10;
          break;
      }
    }

    // Check for easygoing: low scores across the board
    final totalConflict = traits.values.reduce((a, b) => a + b);
    if (totalConflict < incidents.length * 3) {
      traits['adaptability'] = 60;
    }

    // Normalise to 0–100
    final maxVal = traits.values.reduce((a, b) => a > b ? a : b);
    if (maxVal > 0) {
      for (final key in traits.keys) {
        traits[key] = ((traits[key]! / maxVal) * 100).clamp(0, 100);
      }
    }

    final typeMap = {
      'persistence': 'strong-willed',
      'sensitivity': 'sensitive',
      'independence': 'independent',
      'caution': 'cautious',
      'adaptability': 'easygoing',
    };

    final sorted = traits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primary = typeMap[sorted.first.key] ?? 'easygoing';
    String? secondary;
    if (sorted.length > 1 && sorted[1].value >= sorted.first.value * 0.6) {
      secondary = typeMap[sorted[1].key];
    }

    return TemperamentProfile(
      primaryType: primary,
      secondaryType: secondary,
      traits: traits,
      lastUpdated: DateTime.now(),
    );
  }

  // ────────────────────────────────────────────────────────
  // RECALIBRATION
  // ────────────────────────────────────────────────────────

  /// Apply recalibration adjustments to an existing profile.
  static TemperamentProfile recalibrate(
    TemperamentProfile current,
    Map<String, double> adjustments,
  ) {
    return current.copyWithAdjustments(adjustments);
  }

  /// Get the next recalibration prompt index (cycles through 8 prompts).
  static int getNextRecalibrationIndex(TemperamentProfile profile) {
    if (profile.lastUpdated == null) return 0;
    final daysSince = DateTime.now().difference(profile.lastUpdated!).inDays;
    // Cycle through prompts every 6 weeks
    return (daysSince ~/ 42) % allRecalibrationPrompts.length;
  }

  // ────────────────────────────────────────────────────────
  // PROFILE DISPLAY DATA
  // ────────────────────────────────────────────────────────

  /// Get the full TemperamentType definition for a type id.
  static TemperamentType? getType(String typeId) {
    try {
      return allTemperamentTypes.firstWhere((t) => t.id == typeId);
    } catch (_) {
      return null;
    }
  }

  /// Get temperament description for the profile screen.
  static String describeTemperament(String type) {
    final t = getType(type);
    if (t != null) return t.description;

    const fallbacks = {
      'routine-loving':
          'Thrives on consistency and predictability. Needs warning before changes.',
      'curious':
          'Endlessly exploring and asking why. Needs safe space to discover.',
    };
    return fallbacks[type] ??
        'Unique and wonderful. We\'re learning their rhythms.';
  }

  /// Get strengths for a temperament type.
  static List<String> getStrengths(String type) {
    final t = getType(type);
    if (t != null) return t.strengths;

    const fallbacks = {
      'routine-loving': ['Organised', 'Reliable', 'Focused'],
      'curious': ['Creative', 'Adventurous', 'Quick learner'],
    };
    return fallbacks[type] ?? ['Growing', 'Learning', 'Discovering'];
  }

  /// Get the strength reframing label.
  static String getStrengthLabel(String type) {
    return getType(type)?.strengthLabel ?? 'Growing every day';
  }

  /// Get the emoji for a temperament type.
  static String getEmoji(String type) {
    return getType(type)?.emoji ?? '🌟';
  }

  /// Get "what works best" list.
  static List<String> getWhatWorks(String type) {
    return getType(type)?.whatWorksBest ?? [];
  }

  /// Get "what to avoid" list.
  static List<String> getWhatToAvoid(String type) {
    return getType(type)?.whatToAvoid ?? [];
  }

  /// Get daily description.
  static String getDailyDescription(String type) {
    return getType(type)?.dailyLooksLike ?? '';
  }

  /// Get the TemperamentModifier for guidance adaptation.
  static TemperamentModifier? getModifier(String type) {
    return temperamentModifiers[type];
  }
}
