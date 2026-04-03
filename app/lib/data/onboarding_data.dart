/// Onboarding flow content for OBuddy.
///
/// Two paths:
///   1. Fresh user → name + DOB + (optional) quiz + (optional) partner invite
///   2. OBubba migrant → welcome back + auto-import + quiz (history blends with results)
///
/// Design rules:
///   - Under 60 seconds to first personalised screen
///   - No account gate — use app first, sign in later
///   - Quiz optional but encouraged (gentle nudges until completed)
///   - Partner invite is optional, available anytime

// ─────────────────────────────────────────────────────────────
// Onboarding steps
// ─────────────────────────────────────────────────────────────

enum OnboardingStep {
  welcome,          // Fresh: warm intro. Migrant: "Welcome to OBuddy"
  migrationDetected,// Only for OBubba users — "We found your data"
  childName,        // Enter child's name
  childDob,         // Enter date of birth
  addAnotherChild,  // "Do you have another child aged 1-5?"
  quizIntro,        // "Discover your child's temperament — 90 seconds"
  quiz,             // The 10-question quiz (handled by quiz screen)
  quizResult,       // Show temperament result
  partnerInvite,    // "Invite your co-parent?" (optional)
  allDone,          // "You're all set" — enter app
}

// ─────────────────────────────────────────────────────────────
// Screen copy
// ─────────────────────────────────────────────────────────────

class OnboardingCopy {
  // ── Welcome (fresh) ──
  static const freshTitle = 'Welcome to OBuddy';
  static const freshSubtitle =
      'Calm guidance. Confident parenting.\nFor toddlers aged 1–5.';
  static const freshCta = 'Get started';

  // ── Welcome (migrant) ──
  static const migrantTitle = 'Welcome back';
  static const migrantSubtitle =
      'OBuddy is the next chapter of OBubba —\n'
      'everything you had, plus so much more.';
  static const migrantDetail =
      'We\'ve found your family data and brought it across.\n'
      'Nothing was lost.';
  static const migrantCta = 'Continue';

  // ── Migration detected ──
  static const migrationTitle = 'We found your family';
  static const migrationChildren = 'Children imported:';
  static const migrationPaths = 'Active paths preserved';
  static const migrationIncidents = 'Behaviour history carried over';
  static const migrationCta = 'Looks good — continue';

  // ── Child name ──
  static const childNameTitle = 'What\'s your child\'s name?';
  static const childNameHint = 'First name';
  static const childNameHelper = 'You can add more children later.';

  // ── Child DOB ──
  static const childDobTitle = 'When were they born?';
  static const childDobHelper =
      'We use this to tailor guidance to their exact developmental stage.';

  // ── Add another child ──
  static const addAnotherTitle = 'Any more little ones?';
  static const addAnotherSubtitle =
      'You can add siblings aged 1–5.\nEach child gets their own profile.';
  static const addAnotherCta = 'Add another child';
  static const addAnotherSkip = 'That\'s everyone';

  // ── Quiz intro ──
  static const quizIntroTitle = 'Discover their temperament';
  static const quizIntroSubtitle =
      '10 quick questions about how your child reacts to everyday moments.\n'
      'Takes about 90 seconds.';
  static const quizIntroDetail =
      'This helps us personalise every piece of guidance —\n'
      'boundaries, validation, scripts — all shaped for YOUR child.';
  static const quizIntroCta = 'Start the quiz';
  static const quizIntroSkip = 'I\'ll do this later';

  // ── Quiz intro (migrant) ──
  static const quizIntroMigrantNote =
      'We\'ll blend your answers with what we already know\n'
      'from your behaviour history for the most accurate profile.';

  // ── Quiz result ──
  static const quizResultTitle = 'Meet your child\'s temperament';
  static const quizResultCta = 'Continue';

  // ── Partner invite ──
  static const partnerTitle = 'Invite your co-parent';
  static const partnerSubtitle =
      'Both carers see the same guidance, the same scripts,\n'
      'the same boundaries. Consistency made easy.';
  static const partnerRoles = ['Co-parent', 'Grandparent', 'Nanny', 'Other'];
  static const partnerCta = 'Send invite';
  static const partnerSkip = 'Not right now';

  // ── All done ──
  static const doneTitle = 'You\'re all set';
  static const doneSubtitle =
      'OBuddy is ready. Every piece of guidance is now\n'
      'shaped for your family.';
  static const doneCta = 'Enter OBuddy';
}

// ─────────────────────────────────────────────────────────────
// Onboarding flow builder
// ─────────────────────────────────────────────────────────────

/// Returns the ordered list of onboarding steps.
/// [isMigrant] controls whether the migration screens are included.
List<OnboardingStep> buildOnboardingFlow({required bool isMigrant}) {
  if (isMigrant) {
    return [
      OnboardingStep.welcome,
      OnboardingStep.migrationDetected,
      OnboardingStep.addAnotherChild,
      OnboardingStep.quizIntro,
      // quiz + quizResult are inserted dynamically if user chooses to take it
      OnboardingStep.partnerInvite,
      OnboardingStep.allDone,
    ];
  }
  return [
    OnboardingStep.welcome,
    OnboardingStep.childName,
    OnboardingStep.childDob,
    OnboardingStep.addAnotherChild,
    OnboardingStep.quizIntro,
    // quiz + quizResult are inserted dynamically if user chooses to take it
    OnboardingStep.partnerInvite,
    OnboardingStep.allDone,
  ];
}

// ─────────────────────────────────────────────────────────────
// Migration detection
// ─────────────────────────────────────────────────────────────

/// Checks for existing OBubba data in the shared Firebase project.
/// Returns a migration result with imported children, paths, and incidents.
class MigrationResult {
  final bool hasData;
  final List<MigratedChild> children;
  final int pathCount;
  final int incidentCount;

  const MigrationResult({
    required this.hasData,
    this.children = const [],
    this.pathCount = 0,
    this.incidentCount = 0,
  });

  static const empty = MigrationResult(hasData: false);
}

class MigratedChild {
  final String id;
  final String name;
  final DateTime dob;
  final int incidentCount;

  const MigratedChild({
    required this.id,
    required this.name,
    required this.dob,
    this.incidentCount = 0,
  });
}

// ─────────────────────────────────────────────────────────────
// Quiz nudge messages (shown on Home/Profile until quiz taken)
// ─────────────────────────────────────────────────────────────

const quizNudges = [
  'Take the 90-second temperament quiz to unlock personalised guidance.',
  'Want guidance shaped for YOUR child? Complete the temperament quiz.',
  'Every family is different. The temperament quiz helps us match yours.',
  'Discover your child\'s temperament — it takes less than 2 minutes.',
];
