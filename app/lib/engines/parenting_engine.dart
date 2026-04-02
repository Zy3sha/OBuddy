import '../models/guidance_response.dart';
import '../data/temperament_system.dart';

/// The Balanced Parenting Engine.
///
/// Generates guidance using the Blended Response Model:
///   1. Calm Boundary — clear, respectful limit
///   2. Emotional Validation — acknowledge the feeling
///   3. Guided Action — practical next step with choice
///
/// This engine adapts output based on child age, temperament, and rhythm phase.
class ParentingEngine {
  /// Formats a full blended response into a concise parent-facing script.
  static String formatScript(GuidanceResponse response) {
    return '${response.calmBoundary} ${response.emotionalValidation} ${response.guidedAction}';
  }

  /// Adapts language complexity for the child's age.
  static String adaptForAge(String script, int ageInYears) {
    if (ageInYears <= 1) {
      final sentences = script.split('. ');
      if (sentences.length > 2) {
        return '${sentences[0]}. ${sentences[1]}.';
      }
      return script;
    }
    if (ageInYears == 2) {
      final sentences = script.split('. ');
      if (sentences.length > 3) {
        return sentences.take(3).join('. ');
      }
    }
    return script;
  }

  /// Deep temperament-aware adaptation of guidance scripts.
  ///
  /// Uses TemperamentModifier rules to reshape boundary, validation,
  /// and action language based on the child's temperament profile.
  static String adaptForTemperament(String script, String? temperament) {
    if (temperament == null) return script;

    final modifier = temperamentModifiers[temperament];
    if (modifier == null) return script;

    // Apply temperament-specific language transformations
    var adapted = script;

    switch (temperament) {
      case 'strong-willed':
        // Firm, choice-based framing — no negotiation
        adapted = adapted
            .replaceAll('I need you to', 'I\'ve decided that')
            .replaceAll('Can you', 'It\'s time to')
            .replaceAll('Please try to', 'You choose:');
        break;

      case 'sensitive':
        // Softer, more empathetic framing with processing time
        adapted = adapted
            .replaceAll('I need you to', 'When you\'re ready,')
            .replaceAll('You must', 'Let\'s try to')
            .replaceAll('Right now', 'In your own time')
            .replaceAll('Stop', 'Let\'s pause');
        break;

      case 'cautious':
        // Predictable, reassurance-heavy framing
        adapted = adapted
            .replaceAll('I need you to', 'Here\'s what happens next:')
            .replaceAll('Try this', 'First we\'ll do this together');
        if (!adapted.contains('right here') && !adapted.contains('I\'m here')) {
          adapted = '$adapted I\'m right here with you.';
        }
        break;

      case 'independent':
        // Autonomy-respecting, trust-based framing
        adapted = adapted
            .replaceAll('I need you to', 'The rule is')
            .replaceAll('Let me help', 'You try first — I\'m here if you need me')
            .replaceAll('I\'ll do it', 'You decide how');
        break;

      case 'easygoing':
        // Actively engaging — don't let them fade into the background
        adapted = adapted
            .replaceAll('That\'s okay', 'How does that feel to you?')
            .replaceAll('You\'re fine', 'I want to know what you think');
        break;
    }

    return adapted;
  }

  /// Generate a complete adapted script for a guidance response.
  ///
  /// Applies the full pipeline: format → age adapt → temperament adapt.
  static String generateScript({
    required GuidanceResponse response,
    required int ageInYears,
    String? temperament,
  }) {
    var script = formatScript(response);
    script = adaptForAge(script, ageInYears);
    script = adaptForTemperament(script, temperament);
    return script;
  }

  /// Get the temperament-specific prefix for guidance opening.
  /// Returns a warm, personalised opening line.
  static String getTemperamentPrefix(String? temperament) {
    final modifier = temperamentModifiers[temperament];
    return modifier?.scriptPrefix ?? '';
  }

  /// Get tone guidance notes for the parent.
  static String getToneGuidance(String? temperament) {
    final modifier = temperamentModifiers[temperament];
    return modifier?.toneNotes ?? 'Calm, warm, and clear.';
  }

  /// Adapt a guidance response for the current rhythm phase.
  /// Adds phase-specific context to the guided action.
  static String adaptForRhythm(String script, String? rhythmPhase) {
    if (rhythmPhase == null) return script;

    switch (rhythmPhase) {
      case 'boundary-testing':
        return '$script Remember: hold the boundary calmly. Repetition is the point right now.';
      case 'independence-surge':
        return '$script Let them try first — even if it takes longer.';
      case 'sensitivity-wave':
        return '$script Go slower than you think you need to. Extra gentleness matters right now.';
      case 'connection-seeking':
        return '$script Connection before correction. Fill their cup first.';
      case 'skill-stretch':
        return '$script Sit with the struggle. Don\'t rush to fix it.';
      case 'cooperation-bloom':
        return '$script Lean into this moment — they want to be helpful. Let them.';
      case 'reset-phase':
        return '$script Ease up today. They\'re processing and consolidating.';
      default:
        return script;
    }
  }

  /// Full pipeline: age + temperament + rhythm adaptation.
  static String generateFullScript({
    required GuidanceResponse response,
    required int ageInYears,
    String? temperament,
    String? rhythmPhase,
  }) {
    var script = formatScript(response);
    script = adaptForAge(script, ageInYears);
    script = adaptForTemperament(script, temperament);
    script = adaptForRhythm(script, rhythmPhase);
    return script;
  }
}
