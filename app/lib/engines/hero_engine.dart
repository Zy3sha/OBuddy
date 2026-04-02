import '../models/child_profile.dart';
import '../models/path_progress.dart';
import '../data/temperament_system.dart';

/// Generates the Daily Hero Card content.
///
/// The hero card is the first thing parents see. It must be:
///   - calm, intelligent, reassuring
///   - personalised to temperament and rhythm phase
///   - actionable (one simple thing to do)
class HeroEngine {
  /// Generate hero card content based on child profile, paths, and rhythm.
  static HeroCardData generate({
    required ChildProfile child,
    required List<PathProgress> activePaths,
  }) {
    final focus = _pickFocus(activePaths);
    final observation = _pickObservation(child, activePaths);
    final challenge = _pickChallenge(child);
    final action = _pickAction(focus, child);

    return HeroCardData(
      focusIntro: 'Today ${child.name} is learning',
      focusHighlight: focus,
      observation: observation,
      challenge: challenge,
      action: action,
    );
  }

  static String _pickFocus(List<PathProgress> paths) {
    if (paths.isEmpty) return 'patience';

    final active = paths.where((p) => p.status == 'active').toList();
    if (active.isEmpty) return 'new things';

    final focusMap = {
      'potty': 'body awareness',
      'food': 'food confidence',
      'feelings': 'patience',
      'skills': 'independence',
      'routine': 'rhythm',
    };

    return focusMap[active.first.pathId] ?? 'new things';
  }

  static String _pickObservation(
      ChildProfile child, List<PathProgress> paths) {
    final temperament = child.temperament?.primaryType;
    final rhythm = child.rhythm?.currentPhase;

    // Rhythm-aware observations
    if (rhythm != null) {
      switch (rhythm) {
        case 'boundary-testing':
          return '${child.name} is pushing limits right now — that\'s them checking the walls are still there. They are.';
        case 'independence-surge':
          return '${child.name} wants to do it all themselves. That determination is a strength.';
        case 'sensitivity-wave':
          return '${child.name}\'s feelings are running close to the surface. Extra gentleness goes a long way today.';
        case 'connection-seeking':
          return '${child.name} needs closeness right now. That\'s their way of refuelling.';
        case 'skill-stretch':
          return '${child.name} is reaching for new skills. The frustration means they\'re learning.';
        case 'cooperation-bloom':
          return '${child.name} is showing a real desire to help and be part of things.';
        case 'reset-phase':
          return '${child.name} seems calmer. Their brain is consolidating everything they\'ve learned.';
      }
    }

    // Temperament-aware observations
    if (temperament != null) {
      switch (temperament) {
        case 'strong-willed':
          return '${child.name} knows what they want. That persistence will serve them well.';
        case 'sensitive':
          return '${child.name} is tuning into the world deeply today.';
        case 'cautious':
          return '${child.name} is watching carefully before joining in — wise.';
        case 'independent':
          return '${child.name} is showing real self-motivation today.';
        case 'easygoing':
          return '${child.name} is rolling with the day — but check in on how they really feel.';
      }
    }

    // Fallback to path-based observations
    if (paths.any((p) => p.pathId == 'feelings' && p.currentStage > 0)) {
      return '${child.name} paused briefly before reacting — that\'s growth.';
    }
    if (paths.any((p) => p.pathId == 'food' && p.currentStage > 0)) {
      return '${child.name} looked at a new food today — curiosity is building.';
    }
    if (paths.any((p) => p.pathId == 'potty' && p.currentStage > 0)) {
      return '${child.name} sat on the potty without fuss — trust is growing.';
    }
    return '${child.name} is showing more awareness of the world around them.';
  }

  static String _pickChallenge(ChildProfile child) {
    final rhythm = child.rhythm?.currentPhase;
    final temperament = child.temperament?.primaryType;

    // Rhythm-phase challenges
    if (rhythm != null) {
      switch (rhythm) {
        case 'boundary-testing':
          return 'You may hear a lot of "no" today. That\'s the phase talking.';
        case 'independence-surge':
          return 'Things may take longer than usual. That\'s okay — they\'re practising.';
        case 'sensitivity-wave':
          return 'Small things may trigger big feelings today.';
        case 'connection-seeking':
          return 'Separations may be harder right now.';
        case 'skill-stretch':
          return 'Frustration may spike when tasks feel just out of reach.';
        case 'cooperation-bloom':
          return 'They may want to help with everything — even things that aren\'t helpful.';
        case 'reset-phase':
          return 'You might see some regression. That\'s consolidation, not backsliding.';
      }
    }

    // Temperament-based challenges
    if (temperament == 'strong-willed') {
      return 'Power moments may come in waves. Hold steady.';
    }
    if (temperament == 'sensitive') {
      return 'Emotional reactions may be bigger than the trigger.';
    }

    // Age-based fallback
    final ageMonths = child.ageInMonths;
    if (ageMonths < 24) return 'Separation may feel harder today.';
    if (ageMonths < 36) return 'Transitions may feel a little harder today.';
    return 'Big feelings may surface after a busy day.';
  }

  static String _pickAction(String focus, ChildProfile child) {
    final temperament = child.temperament?.primaryType;
    final rhythm = child.rhythm?.currentPhase;

    // Rhythm-specific actions
    if (rhythm != null) {
      switch (rhythm) {
        case 'boundary-testing':
          return 'State your limit once, calmly. Then hold.';
        case 'independence-surge':
          return 'Ask: "Do you want to try that yourself first?"';
        case 'sensitivity-wave':
          return 'Lower the volume on the day. Less stimulation, more calm.';
        case 'connection-seeking':
          return '10 minutes of undivided attention before anything else.';
        case 'skill-stretch':
          return 'Sit beside them. Don\'t fix. Just be there.';
        case 'cooperation-bloom':
          return 'Give them one real job today. "Can you carry this for me?"';
        case 'reset-phase':
          return 'Take the pressure off. A quiet day is a productive day.';
      }
    }

    // Temperament-specific actions
    if (temperament == 'strong-willed') {
      return 'Offer two choices before the next transition.';
    }
    if (temperament == 'sensitive') {
      return 'Give a 5-minute warning before the next change.';
    }
    if (temperament == 'cautious') {
      return 'Preview the day: "First we\'ll do X, then Y."';
    }
    if (temperament == 'independent') {
      return 'Let them lead one activity today.';
    }
    if (temperament == 'easygoing') {
      return 'Ask them: "What do you want to do?" — make sure they get a voice.';
    }

    // Focus-based fallback
    final actionMap = {
      'patience': 'Pause 3 seconds before stepping in.',
      'body awareness': 'Ask: "Do you want to try the potty after breakfast?"',
      'food confidence': 'Place one new food on the plate — no pressure.',
      'independence': 'Let them try one thing by themselves today.',
      'rhythm': 'Name each step of the routine out loud.',
      'new things': 'Notice one thing they did well and name it.',
    };
    return actionMap[focus] ?? 'Take a breath. You\'re doing great.';
  }
}

class HeroCardData {
  final String focusIntro;
  final String focusHighlight;
  final String observation;
  final String challenge;
  final String action;

  const HeroCardData({
    required this.focusIntro,
    required this.focusHighlight,
    required this.observation,
    required this.challenge,
    required this.action,
  });
}
