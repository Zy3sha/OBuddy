import '../models/child_profile.dart';
import '../models/behaviour_incident.dart';

/// Child Profile Engine.
/// Detects temperament patterns and adapts app recommendations.
class ProfileEngine {
  /// Analyse behaviour incidents to detect temperament traits.
  static TemperamentProfile? analyse(List<BehaviourIncident> incidents) {
    if (incidents.length < 5) return null; // Need enough data

    final traits = <String, double>{
      'persistence': 0,
      'sensitivity': 0,
      'independence': 0,
      'caution': 0,
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
          traits['caution'] = (traits['caution'] ?? 0) + 10;
          break;
      }
    }

    // Normalise to 0–100
    final maxVal = traits.values.reduce((a, b) => a > b ? a : b);
    if (maxVal > 0) {
      for (final key in traits.keys) {
        traits[key] = ((traits[key]! / maxVal) * 100).clamp(0, 100);
      }
    }

    // Determine primary type
    final primary = traits.entries.reduce((a, b) => a.value > b.value ? a : b);
    final typeMap = {
      'persistence': 'strong-willed',
      'sensitivity': 'sensitive',
      'independence': 'independent',
      'caution': 'cautious',
    };

    return TemperamentProfile(
      primaryType: typeMap[primary.key] ?? 'curious',
      traits: traits,
    );
  }

  /// Get temperament description for the profile screen.
  static String describeTemperament(String type) {
    const descriptions = {
      'strong-willed': 'Determined and persistent. Needs clear limits with lots of choice.',
      'sensitive': 'Deeply aware of emotions and environment. Needs gentle transitions and extra connection.',
      'independent': 'Wants to do things their own way. Needs autonomy within safe boundaries.',
      'cautious': 'Careful observer who warms up slowly. Needs patience and a predictable rhythm.',
      'routine-loving': 'Thrives on consistency and predictability. Needs warning before changes.',
      'curious': 'Endlessly exploring and asking why. Needs safe space to discover.',
    };
    return descriptions[type] ?? 'Unique and wonderful. We\'re learning their rhythms.';
  }

  /// Get strengths for a temperament type.
  static List<String> getStrengths(String type) {
    const strengths = {
      'strong-willed': ['Determined', 'Confident', 'Knows their own mind'],
      'sensitive': ['Empathetic', 'Deeply caring', 'Observant'],
      'independent': ['Self-motivated', 'Problem-solver', 'Brave'],
      'cautious': ['Thoughtful', 'Careful', 'Attentive to detail'],
      'routine-loving': ['Organised', 'Reliable', 'Focused'],
      'curious': ['Creative', 'Adventurous', 'Quick learner'],
    };
    return strengths[type] ?? ['Growing', 'Learning', 'Discovering'];
  }
}
