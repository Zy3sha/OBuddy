import '../models/guidance_response.dart';
import '../data/scenarios.dart';
import '../data/temperament_system.dart';

/// Behaviour Decoder Engine.
/// Takes a behaviour type and returns the full Blended Response Model output.
/// Adapts guidance based on temperament and anticipates emerging behaviours.
/// Designed to be usable in under 5 seconds.
class BehaviourEngine {
  /// Get guidance for a specific behaviour type.
  static GuidanceResponse? getGuidance(String behaviourType) {
    return findScenario(behaviourType);
  }

  /// Get temperament-adapted guidance.
  /// Returns guidance with temperament-specific modifications to the script.
  static AdaptedGuidance? getAdaptedGuidance(
    String behaviourType,
    String? temperament,
  ) {
    final response = findScenario(behaviourType);
    if (response == null) return null;

    final modifier = temperament != null
        ? temperamentModifiers[temperament]
        : null;

    return AdaptedGuidance(
      response: response,
      temperamentPrefix: modifier?.scriptPrefix,
      toneGuidance: modifier?.toneNotes,
      boundaryStyle: modifier?.boundaryStyle,
      validationStyle: modifier?.validationStyle,
      actionStyle: modifier?.actionStyle,
    );
  }

  /// Get all available behaviour categories for the Quick Help screen.
  static List<Map<String, String>> getCategories() {
    return quickHelpCategories
        .map((c) => {
              'type': c['type'] as String,
              'icon': c['icon'] as String,
              'label': c['label'] as String,
            })
        .toList();
  }

  /// Get prioritised categories based on temperament and rhythm phase.
  /// Returns categories sorted by relevance to the child's current state.
  static List<Map<String, String>> getPrioritisedCategories({
    String? temperament,
    String? rhythmPhase,
  }) {
    final categories = getCategories();
    if (temperament == null && rhythmPhase == null) return categories;

    // Define relevance weights
    final weights = <String, int>{};
    for (final cat in categories) {
      weights[cat['type']!] = 0;
    }

    // Temperament-based prioritisation
    if (temperament != null) {
      switch (temperament) {
        case 'strong-willed':
          _boost(weights, ['tantrum', 'refusing', 'not_listening'], 3);
          break;
        case 'sensitive':
          _boost(weights, ['bedtime_struggle', 'tantrum', 'refusing_dinner'], 3);
          break;
        case 'cautious':
          _boost(weights, ['bedtime_struggle', 'potty_refusal'], 3);
          break;
        case 'independent':
          _boost(weights, ['refusing', 'not_listening', 'tantrum'], 3);
          break;
        case 'easygoing':
          // No strong priority — show default order
          break;
      }
    }

    // Rhythm phase prioritisation
    if (rhythmPhase != null) {
      switch (rhythmPhase) {
        case 'boundary-testing':
          _boost(weights, ['tantrum', 'refusing', 'not_listening', 'hitting'], 5);
          break;
        case 'independence-surge':
          _boost(weights, ['refusing', 'not_listening'], 5);
          break;
        case 'sensitivity-wave':
          _boost(weights, ['tantrum', 'bedtime_struggle', 'refusing_dinner'], 5);
          break;
        case 'connection-seeking':
          _boost(weights, ['bedtime_struggle'], 5);
          break;
        case 'skill-stretch':
          _boost(weights, ['tantrum', 'refusing'], 3);
          break;
      }
    }

    // Sort by weight descending
    categories.sort((a, b) =>
        (weights[b['type']] ?? 0).compareTo(weights[a['type']] ?? 0));

    return categories;
  }

  static void _boost(Map<String, int> weights, List<String> types, int amount) {
    for (final type in types) {
      weights[type] = (weights[type] ?? 0) + amount;
    }
  }

  /// Get the most common behaviour from a list of incidents.
  static String? getMostCommonBehaviour(List<String> recentTypes) {
    if (recentTypes.isEmpty) return null;
    final counts = <String, int>{};
    for (final type in recentTypes) {
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Detect patterns in recent behaviour incidents.
  static String? detectPattern(List<String> recentTypes) {
    if (recentTypes.length < 3) return null;
    final last3 = recentTypes.take(3).toSet();
    if (last3.length == 1) {
      return 'This has happened a few times recently. That\'s normal — it often means they\'re working through something.';
    }
    return null;
  }

  /// Detect pattern with temperament context.
  static String? detectPatternWithContext(
    List<String> recentTypes,
    String? temperament,
  ) {
    final basePattern = detectPattern(recentTypes);
    if (basePattern == null) return null;

    if (temperament == null) return basePattern;

    switch (temperament) {
      case 'strong-willed':
        return '$basePattern For a strong-willed child, repetition is how they verify the boundary is real.';
      case 'sensitive':
        return '$basePattern For a sensitive child, repeated patterns often signal they\'re feeling overwhelmed.';
      case 'cautious':
        return '$basePattern For a cautious child, this may mean they\'re processing a change in routine.';
      case 'independent':
        return '$basePattern For an independent child, this is usually a push for more autonomy.';
      case 'easygoing':
        return '$basePattern If your easygoing child is showing a pattern, pay extra attention — they don\'t usually flag things loudly.';
      default:
        return basePattern;
    }
  }
}

/// Guidance adapted for a specific temperament.
class AdaptedGuidance {
  final GuidanceResponse response;
  final String? temperamentPrefix;
  final String? toneGuidance;
  final String? boundaryStyle;
  final String? validationStyle;
  final String? actionStyle;

  const AdaptedGuidance({
    required this.response,
    this.temperamentPrefix,
    this.toneGuidance,
    this.boundaryStyle,
    this.validationStyle,
    this.actionStyle,
  });

  bool get hasTemperamentAdaptation => temperamentPrefix != null;
}
