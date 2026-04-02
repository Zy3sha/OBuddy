/// Core data file for OBuddy's Temperament & Personality System.
/// Covers toddlers aged 1–5 with five temperament types, a 10-question
/// scenario quiz, scoring logic, recalibration micro check-ins, and
/// temperament-aware guidance modifiers.

// ---------------------------------------------------------------------------
// 1. TEMPERAMENT TYPE DEFINITIONS
// ---------------------------------------------------------------------------

class TemperamentType {
  final String id;
  final String label;
  final String emoji;
  final String strengthLabel;
  final String description;
  final List<String> coreTraits;
  final List<String> emotionalTendencies;
  final List<String> behaviourPatterns;
  final List<String> strengths;
  final List<String> challenges;
  final List<String> whatWorksBest;
  final List<String> whatToAvoid;
  final String dailyLooksLike;

  const TemperamentType({
    required this.id,
    required this.label,
    required this.emoji,
    required this.strengthLabel,
    required this.description,
    required this.coreTraits,
    required this.emotionalTendencies,
    required this.behaviourPatterns,
    required this.strengths,
    required this.challenges,
    required this.whatWorksBest,
    required this.whatToAvoid,
    required this.dailyLooksLike,
  });
}

const _strongWilled = TemperamentType(
  id: 'strong-willed',
  label: 'Strong-Willed',
  emoji: '🦁',
  strengthLabel: 'Future leader energy',
  description:
      'A determined child who knows what they want and will persist until '
      'they get it. Their intensity is their superpower — channel it well and '
      'you have a future leader.',
  coreTraits: [
    'High intensity',
    'Persistent',
    'Needs control',
    'Determined',
  ],
  emotionalTendencies: [
    'Big reactions',
    'Frustration when thwarted',
    'Slow to let go of wants',
  ],
  behaviourPatterns: [
    'Pushes back on limits',
    'Negotiates',
    'Insists on doing things their way',
  ],
  strengths: [
    'Determined',
    'Confident',
    'Knows their own mind',
    'Natural leader',
  ],
  challenges: [
    'Power struggles',
    'Difficulty with flexibility',
    'Intensity of reactions',
  ],
  whatWorksBest: [
    'Clear boundaries with limited choices',
    'Consistency',
    'Controlled autonomy',
    '"You decide: A or B"',
  ],
  whatToAvoid: [
    'Open power struggles',
    'Giving in after saying no',
    'Too many open-ended choices',
    'Reasoning mid-meltdown',
  ],
  dailyLooksLike:
      'Expects to be heard. Will push until they find the wall — then feels safe.',
);

const _sensitive = TemperamentType(
  id: 'sensitive',
  label: 'Sensitive',
  emoji: '🌸',
  strengthLabel: 'Deeply tuned-in soul',
  description:
      'A perceptive child who feels the world intensely. Their empathy and '
      'emotional depth are gifts — they just need calm and connection to '
      'thrive.',
  coreTraits: [
    'Emotionally reactive',
    'Easily overwhelmed',
    'Perceptive',
    'Empathetic',
  ],
  emotionalTendencies: [
    'Quick to tears',
    'Absorbs others\' emotions',
    'Overwhelmed by noise/change',
  ],
  behaviourPatterns: [
    'Withdraws when overstimulated',
    'Needs transition time',
    'Deeply affected by tone',
  ],
  strengths: [
    'Empathetic',
    'Deeply caring',
    'Observant',
    'Emotionally intelligent',
  ],
  challenges: [
    'Overwhelm in busy environments',
    'Slow transitions',
    'Heightened emotional reactions',
  ],
  whatWorksBest: [
    'Gentle transitions with warnings',
    'Calm environment',
    'Extra validation',
    'Soft tone',
    'Predictable routine',
  ],
  whatToAvoid: [
    'Abrupt changes',
    'Raised voices',
    'Dismissing feelings',
    '"You\'re fine"',
    'Busy overstimulating environments',
  ],
  dailyLooksLike:
      'Notices everything. Feels everything. Needs calm to feel safe.',
);

const _cautious = TemperamentType(
  id: 'cautious',
  label: 'Cautious',
  emoji: '🦉',
  strengthLabel: 'Thoughtful observer',
  description:
      'A watchful child who takes the world in before engaging. Their '
      'careful nature means they process deeply — given time, they warm up '
      'beautifully.',
  coreTraits: [
    'Slow to warm',
    'Hesitant in new situations',
    'Prefers familiar',
    'Watchful',
  ],
  emotionalTendencies: [
    'Anxiety around novelty',
    'Comfort in predictability',
    'Quiet processing',
  ],
  behaviourPatterns: [
    'Hangs back in groups',
    'Takes time to engage',
    'Prefers watching first',
  ],
  strengths: [
    'Thoughtful',
    'Careful',
    'Detail-oriented',
    'Wise beyond their years',
  ],
  challenges: [
    'Reluctance with new experiences',
    'Social hesitancy',
    'Rigidity with routine changes',
  ],
  whatWorksBest: [
    'Extra warm-up time',
    'No forced participation',
    'Gentle exposure',
    '"I\'ll be right here"',
    'Patience',
  ],
  whatToAvoid: [
    'Pushing into new situations too fast',
    'Comparing to bolder children',
    'Labelling as "shy"',
    'Forcing social interaction',
  ],
  dailyLooksLike:
      'Watches before joining. Processes deeply. Warms up beautifully with time.',
);

const _independent = TemperamentType(
  id: 'independent',
  label: 'Independent',
  emoji: '🚀',
  strengthLabel: 'Self-driven explorer',
  description:
      'A self-motivated child determined to do everything themselves. '
      'Their drive for autonomy is remarkable — they need space to try and '
      'a safety net for when they fall.',
  coreTraits: [
    'Self-motivated',
    'Prefers autonomy',
    'Determined to do it themselves',
  ],
  emotionalTendencies: [
    'Frustration when helped uninvited',
    'Pride in accomplishment',
    'Resistant to being directed',
  ],
  behaviourPatterns: [
    '"I do it myself"',
    'Resists help',
    'Wants to make own decisions',
    'Persistent with tasks',
  ],
  strengths: [
    'Self-motivated',
    'Problem-solver',
    'Brave',
    'Resourceful',
  ],
  challenges: [
    'Frustration when capability doesn\'t match ambition',
    'Resistance to necessary help',
    'Safety concerns',
  ],
  whatWorksBest: [
    'Safe boundaries for exploration',
    '"You try first"',
    'Step-back approach',
    'Celebrate effort not outcome',
  ],
  whatToAvoid: [
    'Doing things for them',
    'Hovering',
    'Removing all challenge',
    'Over-praising results',
  ],
  dailyLooksLike:
      'Wants to conquer the world themselves. Needs space to try — and a safety net when they fall.',
);

const _easygoing = TemperamentType(
  id: 'easygoing',
  label: 'Easygoing',
  emoji: '☀️',
  strengthLabel: 'Calm in the storm',
  description:
      'An adaptable child who goes with the flow. Their calm nature can '
      'mask their needs — make sure they feel seen, heard, and valued.',
  coreTraits: [
    'Adaptable',
    'Flexible',
    'Low reactivity',
    'Goes with the flow',
  ],
  emotionalTendencies: [
    'Even-tempered',
    'Recovers quickly',
    'Rarely escalates',
  ],
  behaviourPatterns: [
    'Cooperates readily',
    'Adapts to changes',
    'Content in most situations',
  ],
  strengths: [
    'Adaptable',
    'Resilient',
    'Easy to be around',
    'Emotionally steady',
  ],
  challenges: [
    'Needs may go unnoticed',
    'May not speak up',
    'Can be overlooked',
    'May suppress feelings',
  ],
  whatWorksBest: [
    'Actively check in on their feelings',
    'Create space for their voice',
    "Don't assume they're always fine",
    'Name their quiet wins',
  ],
  whatToAvoid: [
    'Taking their calmness for granted',
    'Forgetting to ask how they feel',
    'Giving all attention to louder siblings',
    'Assuming no needs',
  ],
  dailyLooksLike:
      'Seems fine — and usually is. But still needs to be seen, heard, and asked.',
);

// ---------------------------------------------------------------------------
// 2. QUIZ QUESTIONS
// ---------------------------------------------------------------------------

class QuizOption {
  final String label;
  final Map<String, double> scores;

  const QuizOption({
    required this.label,
    required this.scores,
  });
}

class TemperamentQuizQuestion {
  final String id;
  final String scenario;
  final List<QuizOption> options;

  const TemperamentQuizQuestion({
    required this.id,
    required this.scenario,
    required this.options,
  });
}

const _quizQuestions = <TemperamentQuizQuestion>[
  // Q1
  TemperamentQuizQuestion(
    id: 'q1',
    scenario: "When your child doesn't get what they want, they usually:",
    options: [
      QuizOption(
        label: 'Push harder, insist, escalate',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Cry or become overwhelmed',
        scores: {'sensitive': 3, 'cautious': 1},
      ),
      QuizOption(
        label: 'Withdraw or go quiet',
        scores: {'cautious': 3, 'sensitive': 1},
      ),
      QuizOption(
        label: 'Shrug it off, move on',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q2
  TemperamentQuizQuestion(
    id: 'q2',
    scenario:
        'In a new environment (playgroup, party), your child:',
    options: [
      QuizOption(
        label: 'Charges right in',
        scores: {'strong-willed': 2, 'independent': 2},
      ),
      QuizOption(
        label: 'Clings to you at first',
        scores: {'sensitive': 2, 'cautious': 2},
      ),
      QuizOption(
        label: 'Watches from the side for a long time',
        scores: {'cautious': 3, 'sensitive': 1},
      ),
      QuizOption(
        label: 'Finds their place after a moment',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q3
  TemperamentQuizQuestion(
    id: 'q3',
    scenario: 'When getting dressed, your child:',
    options: [
      QuizOption(
        label: 'Has strong opinions about what to wear',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Gets upset if routine changes',
        scores: {'sensitive': 2, 'cautious': 2},
      ),
      QuizOption(
        label: "Needs time and doesn't like being rushed",
        scores: {'cautious': 3},
      ),
      QuizOption(
        label: 'Wears whatever, no fuss',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q4
  TemperamentQuizQuestion(
    id: 'q4',
    scenario: 'When another child takes their toy, your child:',
    options: [
      QuizOption(
        label: 'Takes it back or gets loud',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Cries or comes to you',
        scores: {'sensitive': 3},
      ),
      QuizOption(
        label: 'Watches and waits',
        scores: {'cautious': 3, 'easygoing': 1},
      ),
      QuizOption(
        label: 'Finds something else to play with',
        scores: {'easygoing': 3, 'independent': 1},
      ),
    ],
  ),

  // Q5
  TemperamentQuizQuestion(
    id: 'q5',
    scenario: 'At bedtime, your child:',
    options: [
      QuizOption(
        label: 'Negotiates for more time',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Needs lots of comfort and closeness',
        scores: {'sensitive': 3, 'cautious': 1},
      ),
      QuizOption(
        label: "Follows the routine if it's consistent",
        scores: {'cautious': 2, 'easygoing': 2},
      ),
      QuizOption(
        label: 'Falls asleep fairly easily',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q6
  TemperamentQuizQuestion(
    id: 'q6',
    scenario:
        'When trying something new (food, activity), your child:',
    options: [
      QuizOption(
        label: 'Dives in confidently',
        scores: {'independent': 3, 'strong-willed': 1},
      ),
      QuizOption(
        label: 'Needs encouragement and reassurance',
        scores: {'sensitive': 2, 'cautious': 2},
      ),
      QuizOption(
        label: "Refuses until they've watched others first",
        scores: {'cautious': 3},
      ),
      QuizOption(
        label: 'Gives it a go without much fuss',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q7
  TemperamentQuizQuestion(
    id: 'q7',
    scenario: "When you say 'no' to something, your child:",
    options: [
      QuizOption(
        label: 'Pushes back, argues, or has a big reaction',
        scores: {'strong-willed': 3},
      ),
      QuizOption(
        label: 'Gets visibly upset or hurt',
        scores: {'sensitive': 3},
      ),
      QuizOption(
        label: 'Goes quiet and processes',
        scores: {'cautious': 2, 'sensitive': 1, 'easygoing': 1},
      ),
      QuizOption(
        label: 'Accepts it and moves on',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q8
  TemperamentQuizQuestion(
    id: 'q8',
    scenario:
        'When your child is learning a new skill and struggling:',
    options: [
      QuizOption(
        label: 'Gets frustrated but keeps trying',
        scores: {'strong-willed': 2, 'independent': 2},
      ),
      QuizOption(
        label: 'Gets upset and needs comfort',
        scores: {'sensitive': 3},
      ),
      QuizOption(
        label: 'Gives up quickly and avoids trying again',
        scores: {'cautious': 3},
      ),
      QuizOption(
        label: 'Tries casually, not too bothered either way',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q9
  TemperamentQuizQuestion(
    id: 'q9',
    scenario: "Your child's energy level is best described as:",
    options: [
      QuizOption(
        label: 'Intense — always on the go, hard to settle',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Variable — can be very up or very down',
        scores: {'sensitive': 3},
      ),
      QuizOption(
        label: 'Measured — careful and deliberate',
        scores: {'cautious': 3},
      ),
      QuizOption(
        label: 'Steady — calm and consistent',
        scores: {'easygoing': 3},
      ),
    ],
  ),

  // Q10
  TemperamentQuizQuestion(
    id: 'q10',
    scenario: 'When transitioning between activities, your child:',
    options: [
      QuizOption(
        label: 'Resists strongly, wants to finish their way',
        scores: {'strong-willed': 3, 'independent': 1},
      ),
      QuizOption(
        label: 'Gets emotional or clingy',
        scores: {'sensitive': 3, 'cautious': 1},
      ),
      QuizOption(
        label: 'Needs lots of warning and preparation',
        scores: {'cautious': 3},
      ),
      QuizOption(
        label: 'Switches pretty smoothly',
        scores: {'easygoing': 3},
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 3. SCORING LOGIC
// ---------------------------------------------------------------------------

class TemperamentResult {
  final String primaryType;
  final String? secondaryType;
  final Map<String, double> traitScores;

  const TemperamentResult({
    required this.primaryType,
    this.secondaryType,
    required this.traitScores,
  });
}

/// Scores a completed temperament quiz.
///
/// [answers] is a list of 10 maps, one per question, where each map contains
/// the temperament-id → score entries from the selected [QuizOption].
///
/// Returns a [TemperamentResult] with normalised 0–100 trait scores, a
/// primary type, and an optional secondary type (assigned when the second-
/// highest score is ≥ 60 % of the primary score).
TemperamentResult scoreQuiz(List<Map<String, double>> answers) {
  // Maximum possible score per type is 3 points × 10 questions = 30.
  const maxRawScore = 30.0;

  final raw = <String, double>{
    'strong-willed': 0,
    'sensitive': 0,
    'cautious': 0,
    'independent': 0,
    'easygoing': 0,
  };

  for (final answer in answers) {
    for (final entry in answer.entries) {
      raw[entry.key] = (raw[entry.key] ?? 0) + entry.value;
    }
  }

  // Normalise to 0–100.
  final normalised = raw.map(
    (key, value) => MapEntry(key, (value / maxRawScore * 100).clamp(0, 100)),
  );

  // Sort descending by score.
  final sorted = normalised.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final primaryType = sorted.first.key;

  // Secondary type if second-highest is ≥ 60 % of primary.
  String? secondaryType;
  if (sorted.length > 1 && sorted.first.value > 0) {
    final ratio = sorted[1].value / sorted.first.value;
    if (ratio >= 0.6) {
      secondaryType = sorted[1].key;
    }
  }

  return TemperamentResult(
    primaryType: primaryType,
    secondaryType: secondaryType,
    traitScores: normalised,
  );
}

// ---------------------------------------------------------------------------
// 4. RECALIBRATION MICRO CHECK-INS
// ---------------------------------------------------------------------------

class RecalibrationOption {
  final String label;
  final Map<String, double> adjustments;

  const RecalibrationOption({
    required this.label,
    required this.adjustments,
  });
}

class RecalibrationPrompt {
  final String id;
  final String prompt;
  final List<RecalibrationOption> options;

  const RecalibrationPrompt({
    required this.id,
    required this.prompt,
    required this.options,
  });
}

const _recalibrationPrompts = <RecalibrationPrompt>[
  // 1
  RecalibrationPrompt(
    id: 'recal-1',
    prompt:
        "We've noticed more strong reactions lately. Does this feel right?",
    options: [
      RecalibrationOption(
        label: 'Yes, lots of big feelings',
        adjustments: {'sensitive': 5, 'strong-willed': 3},
      ),
      RecalibrationOption(
        label: "Actually, they've been calmer",
        adjustments: {'easygoing': 5, 'sensitive': -3},
      ),
      RecalibrationOption(
        label: 'About the same',
        adjustments: {},
      ),
    ],
  ),

  // 2
  RecalibrationPrompt(
    id: 'recal-2',
    prompt: 'Has your child been more independent recently?',
    options: [
      RecalibrationOption(
        label: 'Yes, wants to do everything themselves',
        adjustments: {'independent': 5, 'strong-willed': 2},
      ),
      RecalibrationOption(
        label: 'No, more clingy than usual',
        adjustments: {'sensitive': 3, 'cautious': 3},
      ),
      RecalibrationOption(
        label: 'About the same',
        adjustments: {},
      ),
    ],
  ),

  // 3
  RecalibrationPrompt(
    id: 'recal-3',
    prompt: 'How is your child with new situations right now?',
    options: [
      RecalibrationOption(
        label: 'More confident — jumping in',
        adjustments: {'independent': 3, 'easygoing': 3, 'cautious': -3},
      ),
      RecalibrationOption(
        label: 'Still cautious — needs warm-up time',
        adjustments: {'cautious': 5},
      ),
      RecalibrationOption(
        label: 'More anxious than before',
        adjustments: {'sensitive': 3, 'cautious': 3},
      ),
    ],
  ),

  // 4
  RecalibrationPrompt(
    id: 'recal-4',
    prompt:
        'How are transitions (leaving the park, stopping play) going?',
    options: [
      RecalibrationOption(
        label: 'Really hard — big protests',
        adjustments: {'strong-willed': 5},
      ),
      RecalibrationOption(
        label: 'Emotional but manageable',
        adjustments: {'sensitive': 3},
      ),
      RecalibrationOption(
        label: 'Getting easier',
        adjustments: {'easygoing': 5, 'cautious': -2},
      ),
    ],
  ),

  // 5
  RecalibrationPrompt(
    id: 'recal-5',
    prompt:
        'Is your child showing more cooperation or more resistance?',
    options: [
      RecalibrationOption(
        label: 'Definitely more resistance',
        adjustments: {'strong-willed': 5, 'independent': 3},
      ),
      RecalibrationOption(
        label: 'More cooperative',
        adjustments: {'easygoing': 5, 'cautious': 2},
      ),
      RecalibrationOption(
        label: 'A real mix of both',
        adjustments: {},
      ),
    ],
  ),

  // 6
  RecalibrationPrompt(
    id: 'recal-6',
    prompt: 'How does your child handle frustration right now?',
    options: [
      RecalibrationOption(
        label: 'Big reactions — meltdowns',
        adjustments: {'strong-willed': 3, 'sensitive': 3},
      ),
      RecalibrationOption(
        label: 'Gets upset but recovers',
        adjustments: {'sensitive': 2, 'easygoing': 2},
      ),
      RecalibrationOption(
        label: 'Handles it fairly well',
        adjustments: {'easygoing': 5},
      ),
    ],
  ),

  // 7
  RecalibrationPrompt(
    id: 'recal-7',
    prompt: 'Is your child seeking more control over decisions?',
    options: [
      RecalibrationOption(
        label: 'Yes — everything is a negotiation',
        adjustments: {'strong-willed': 5, 'independent': 3},
      ),
      RecalibrationOption(
        label: 'Not really',
        adjustments: {'easygoing': 3},
      ),
      RecalibrationOption(
        label: 'They seem overwhelmed by choices',
        adjustments: {'sensitive': 3, 'cautious': 3},
      ),
    ],
  ),

  // 8
  RecalibrationPrompt(
    id: 'recal-8',
    prompt: 'How is your child around other children recently?',
    options: [
      RecalibrationOption(
        label: 'Confident and social',
        adjustments: {'independent': 3, 'easygoing': 3},
      ),
      RecalibrationOption(
        label: 'Hangs back, prefers to watch',
        adjustments: {'cautious': 5},
      ),
      RecalibrationOption(
        label: 'Gets overwhelmed in groups',
        adjustments: {'sensitive': 5, 'cautious': 2},
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 5. TEMPERAMENT-AWARE GUIDANCE MODIFIERS
// ---------------------------------------------------------------------------

class TemperamentModifier {
  final String boundaryStyle;
  final String validationStyle;
  final String actionStyle;
  final String toneNotes;
  final String scriptPrefix;

  const TemperamentModifier({
    required this.boundaryStyle,
    required this.validationStyle,
    required this.actionStyle,
    required this.toneNotes,
    required this.scriptPrefix,
  });
}

const _temperamentModifiers = <String, TemperamentModifier>{
  'strong-willed': TemperamentModifier(
    boundaryStyle:
        "Firm, clear, no negotiation. State once. 'I've decided.'",
    validationStyle:
        "Brief. Acknowledge their will. 'You really wanted that.'",
    actionStyle:
        "Two structured choices. No open-ended. 'A or B — you pick.'",
    toneNotes: 'Confident and calm. They respect strength.',
    scriptPrefix: 'I can see you feel strongly about this.',
  ),
  'sensitive': TemperamentModifier(
    boundaryStyle:
        "Gentle but firm. 'This is what needs to happen, and I'm here with you.'",
    validationStyle:
        "Extended. Name the feeling precisely. 'That felt really unfair to you.'",
    actionStyle:
        "Soft transition. 'When you're ready...' Allow processing time.",
    toneNotes: 'Warm, soft, unhurried. They need to feel safe.',
    scriptPrefix: 'I can see this is hard for you right now.',
  ),
  'cautious': TemperamentModifier(
    boundaryStyle:
        "Predictable and consistent. 'This is what we always do.'",
    validationStyle:
        "Reassurance-focused. 'It's okay to feel unsure. I'm right here.'",
    actionStyle:
        "Step-by-step preview. 'First we'll do X, then Y.' No surprises.",
    toneNotes:
        "Patient, warm, predictable. They need to know what's coming.",
    scriptPrefix:
        "I know this feels different. Let's go through it together.",
  ),
  'independent': TemperamentModifier(
    boundaryStyle:
        "Respect their autonomy within the limit. 'The rule is X. You decide how.'",
    validationStyle:
        "Acknowledge their capability. 'I know you can handle this.'",
    actionStyle:
        "Give them agency. 'You try first. I'm here if you need me.'",
    toneNotes: 'Respectful, peer-like. They need to feel trusted.',
    scriptPrefix: 'I trust you to figure this out.',
  ),
  'easygoing': TemperamentModifier(
    boundaryStyle:
        "Don't skip it because they seem fine. 'This matters, even though you're calm.'",
    validationStyle:
        "Actively draw out feelings. 'How did that make you feel?'",
    actionStyle:
        "Check they're truly okay, not just compliant. 'What do you think?'",
    toneNotes: 'Engaging, present. Make sure they feel seen.',
    scriptPrefix: 'I want to hear what you think about this.',
  ),
};

// ---------------------------------------------------------------------------
// 6. CONSTANTS — public API
// ---------------------------------------------------------------------------

/// All five temperament types.
const List<TemperamentType> allTemperamentTypes = [
  _strongWilled,
  _sensitive,
  _cautious,
  _independent,
  _easygoing,
];

/// All ten scenario-based quiz questions.
const List<TemperamentQuizQuestion> allQuizQuestions = _quizQuestions;

/// All eight recalibration micro check-in prompts.
const List<RecalibrationPrompt> allRecalibrationPrompts =
    _recalibrationPrompts;

/// Temperament-aware guidance modifiers keyed by temperament id.
const Map<String, TemperamentModifier> temperamentModifiers =
    _temperamentModifiers;
