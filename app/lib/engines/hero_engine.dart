import '../models/child_profile.dart';
import '../models/path_progress.dart';

/// Generates the Daily Hero Card content.
///
/// The hero card is the first thing parents see. It must be:
///   - calm, intelligent, reassuring
///   - personalised to the child
///   - actionable (one simple thing to do)
class HeroEngine {
  /// Generate hero card content based on child profile and active paths.
  static HeroCardData generate({
    required ChildProfile child,
    required List<PathProgress> activePaths,
  }) {
    final focus = _pickFocus(activePaths);
    final observation = _pickObservation(child, activePaths);
    final challenge = _pickChallenge(child);
    final action = _pickAction(focus);

    return HeroCardData(
      focusIntro: 'Today ${child.name} is learning',
      focusHighlight: focus,
      observation: observation,
      challenge: challenge,
      action: action,
    );
  }

  static String _pickFocus(List<PathProgress> paths) {
    // Prioritise the most active path
    if (paths.isEmpty) return 'patience';

    final active = paths.where((p) => p.status == 'active').toList();
    if (active.isEmpty) return 'new things';

    // Map path to learning focus
    final focusMap = {
      'potty': 'body awareness',
      'food': 'food confidence',
      'feelings': 'patience',
      'skills': 'independence',
      'routine': 'rhythm',
    };

    return focusMap[active.first.pathId] ?? 'new things';
  }

  static String _pickObservation(ChildProfile child, List<PathProgress> paths) {
    // Generate a positive observation
    if (paths.any((p) => p.pathId == 'feelings' && p.currentStage > 0)) {
      return 'He paused briefly before reacting — that\'s growth.';
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
    // Gentle heads-up about what might be tricky
    final ageMonths = child.ageInMonths;
    if (ageMonths < 24) {
      return 'Separation may feel harder today.';
    }
    if (ageMonths < 36) {
      return 'Transitions may feel a little harder today.';
    }
    return 'Big feelings may surface after a busy day.';
  }

  static String _pickAction(String focus) {
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
