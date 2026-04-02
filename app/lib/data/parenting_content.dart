/// ══════════════════════════════════════════════════════════════
/// OBuddy Parenting Framework
/// ══════════════════════════════════════════════════════════════
///
/// CORE PHILOSOPHY
/// Clear limit + warm connection + practical next step.
///
/// Silently blends:
///   Japanese-inspired: respect, consistency, patience, responsibility,
///     routine, calm discipline, modelling, natural consequences
///   Western-inspired: emotional validation, confidence, independence,
///     resilience, warmth, self-expression, autonomy within limits
///
/// THE BLENDED RESPONSE MODEL (Non-negotiable)
/// Every guidance output follows:
///   1. Calm Boundary   — clear, respectful limit (firm, not harsh)
///   2. Emotional Validation — acknowledge the feeling (warm, empathetic)
///   3. Guided Action   — practical next step with choice (constructive)

// ── Core Principles ──

const corePrinciples = [
  CorePrinciple(
    title: 'Clear limits without harshness',
    description: 'Set boundaries with a calm, confident voice. No threats, no shouting. Limits are an act of care.',
  ),
  CorePrinciple(
    title: 'Warmth without overexplaining',
    description: 'Connect with empathy, then move on. Long lectures lose a toddler in seconds.',
  ),
  CorePrinciple(
    title: 'Consistency without rigidity',
    description: 'Follow through on important boundaries. Flex on the small stuff. Know the difference.',
  ),
  CorePrinciple(
    title: 'Confidence through capability',
    description: 'Let them struggle a little. Help less. They grow confident by doing, not by being told they\'re great.',
  ),
  CorePrinciple(
    title: 'Respect is taught through modelling',
    description: 'They learn respect by being treated respectfully. Say please. Apologise. Show them how.',
  ),
  CorePrinciple(
    title: 'Feelings are allowed; hurtful behaviour is not',
    description: 'You can be angry. You cannot hit. Both statements are true and important.',
  ),
  CorePrinciple(
    title: 'Independence grows through supported practice',
    description: 'Let them try. Stand close. Help only when needed. Celebrate effort, not perfection.',
  ),
  CorePrinciple(
    title: 'Progress is quiet growth, not performance',
    description: 'No streaks, no pressure. Every small step forward matters. Growth is not a competition.',
  ),
];

// ── Tone of Voice Rules ──

const toneRules = ToneRules(
  doUse: [
    'Calm — speak as if you have all the time in the world',
    'Intelligent — respect the parent\'s intelligence',
    'Warm — like a friend who gets it',
    'Firm — clear when needed, never wobbly',
    'Non-judgmental — no "you should" energy',
    'Concise — 2–3 lines max per point',
    'Supportive — "You\'re doing this. We\'re here."',
  ],
  doNotUse: [
    'Shame — "Why would you do that?"',
    'Threats — "If you don\'t stop..."',
    'Sarcasm — never, not even subtle',
    'Wordy explanations — keep it scannable',
    'Unrealistic positivity — "Everything is wonderful!"',
    'Performative gentleness with no boundary — soft but spineless',
  ],
);

// ── Age Adaptation Notes ──

const ageAdaptation = {
  1: 'Mostly action-based. Minimal verbal. Heavy on redirection and physical guidance. Short sentences.',
  2: 'Simple 3–5 word scripts. Choices between 2 options. Name basic feelings: happy, sad, angry.',
  3: 'Short sentences. Name more feelings. Simple reasoning: "because your body needs rest."',
  4: 'Collaborative problem-solving. Natural consequences. "What do you think will happen if...?"',
  5: 'Empathy prompts. More responsibility. "How do you think they felt?" Greater independence.',
};

// ── OBuddy Parenting Manifesto ──

const manifesto = '''
We hold the line with calm, not force.
We name the feeling before we fix the problem.
We give choices, not ultimatums.
We model what we want to see.
We build confidence through capability, not praise.
We trust that small steps lead to big growth.
We are the calm in their chaos.
We are enough.
''';

// ── Supporting classes ──

class CorePrinciple {
  final String title;
  final String description;
  const CorePrinciple({required this.title, required this.description});
}

class ToneRules {
  final List<String> doUse;
  final List<String> doNotUse;
  const ToneRules({required this.doUse, required this.doNotUse});
}
