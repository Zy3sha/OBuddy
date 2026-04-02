import '../models/guidance_response.dart';

/// The Balanced Parenting Engine.
///
/// Generates guidance using the Blended Response Model:
///   1. Calm Boundary — clear, respectful limit
///   2. Emotional Validation — acknowledge the feeling
///   3. Guided Action — practical next step with choice
///
/// This engine adapts output based on child age and temperament.
class ParentingEngine {
  /// Formats a full blended response into a concise parent-facing script.
  /// Combines boundary + validation + action into 1–3 natural sentences.
  static String formatScript(GuidanceResponse response) {
    return '${response.calmBoundary} ${response.emotionalValidation} ${response.guidedAction}';
  }

  /// Adapts language complexity for the child's age.
  static String adaptForAge(String script, int ageInYears) {
    if (ageInYears <= 1) {
      // Simplify to very short phrases
      final sentences = script.split('. ');
      if (sentences.length > 2) {
        return '${sentences[0]}. ${sentences[1]}.';
      }
      return script;
    }
    if (ageInYears == 2) {
      // Keep it to 2–3 short sentences
      final sentences = script.split('. ');
      if (sentences.length > 3) {
        return sentences.take(3).join('. ');
      }
    }
    // Ages 3–5: full script is appropriate
    return script;
  }

  /// Adapts tone based on temperament type.
  static String adaptForTemperament(String script, String? temperament) {
    if (temperament == null) return script;

    switch (temperament) {
      case 'sensitive':
        // Softer, more empathetic framing
        return script
            .replaceAll('I need you to', 'When you\'re ready,')
            .replaceAll('You must', 'Let\'s try to');
      case 'strong-willed':
        // More choice-based framing
        return script;
      case 'cautious':
        // More reassurance
        return '$script I\'m right here with you.';
      default:
        return script;
    }
  }
}
