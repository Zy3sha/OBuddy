import '../models/guidance_response.dart';
import '../data/scenarios.dart';

/// Behaviour Decoder Engine.
/// Takes a behaviour type and returns the full Blended Response Model output.
/// Designed to be usable in under 5 seconds.
class BehaviourEngine {
  /// Get guidance for a specific behaviour type.
  static GuidanceResponse? getGuidance(String behaviourType) {
    return findScenario(behaviourType);
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
}
