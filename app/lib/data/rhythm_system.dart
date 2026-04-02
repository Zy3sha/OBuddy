/// OBuddy Rhythm System — pattern-based developmental phase detection.
///
/// NOT age-based. NOT deterministic. These are behavioural pattern
/// interpretations grounded in temperament research, attachment theory,
/// and developmental psychology.

// ---------------------------------------------------------------------------
// CLASS DEFINITIONS
// ---------------------------------------------------------------------------

class RhythmPhase {
  final String id;
  final String label;
  final String emoji;
  final String whatHappening;
  final List<String> whatParentsNotice;
  final String whatChildLearning;
  final List<String> whatToSay;
  final List<String> whatToDo;
  final List<String> whatToAvoid;
  final String scientificBasis;
  final List<String> relevantTraits;
  final List<String> signals;

  const RhythmPhase({
    required this.id,
    required this.label,
    required this.emoji,
    required this.whatHappening,
    required this.whatParentsNotice,
    required this.whatChildLearning,
    required this.whatToSay,
    required this.whatToDo,
    required this.whatToAvoid,
    required this.scientificBasis,
    required this.relevantTraits,
    required this.signals,
  });
}

class AgePresentation {
  final String ageRange;
  final List<String> behaviours;
  final List<String> emotionalPatterns;
  final String guidanceStyle;
  final String scriptComplexity;

  const AgePresentation({
    required this.ageRange,
    required this.behaviours,
    required this.emotionalPatterns,
    required this.guidanceStyle,
    required this.scriptComplexity,
  });
}

class RhythmPhaseWithAge {
  final RhythmPhase phase;
  final Map<String, AgePresentation> agePresentations;

  const RhythmPhaseWithAge({
    required this.phase,
    required this.agePresentations,
  });
}

class BehaviourAnticipation {
  final String headsUp;
  final String why;
  final String whatToSay;
  final String whatToDo;
  final List<String> relevantTemperaments;
  final List<String> relevantPhases;
  final int ageMinMonths;
  final int ageMaxMonths;

  const BehaviourAnticipation({
    required this.headsUp,
    required this.why,
    required this.whatToSay,
    required this.whatToDo,
    required this.relevantTemperaments,
    required this.relevantPhases,
    required this.ageMinMonths,
    required this.ageMaxMonths,
  });
}

class RhythmDetectionResult {
  final String primaryPhase;
  final String? secondaryPhase;
  final String confidence;
  final String explanation;

  const RhythmDetectionResult({
    required this.primaryPhase,
    this.secondaryPhase,
    required this.confidence,
    required this.explanation,
  });
}

// ---------------------------------------------------------------------------
// PHASE DEFINITIONS
// ---------------------------------------------------------------------------

const _boundaryTesting = RhythmPhase(
  id: 'boundary-testing',
  label: 'Boundary Testing',
  emoji: '🧱',
  whatHappening:
      'Your child is mapping the edges of their world. Every "no" and '
      'pushback is them checking: "Is this wall still here? Am I safe?"',
  whatParentsNotice: [
    'Increased defiance',
    'Saying no to everything',
    'Testing rules they know',
    'Pushing limits repeatedly',
    'Protests at transitions',
  ],
  whatChildLearning:
      'Where the limits are — and that those limits are reliable',
  whatToSay: [
    'I won\'t let you do that. The rule hasn\'t changed.',
    'You\'re allowed to be upset about it.',
    'I know you wish you could. The answer is still no.',
  ],
  whatToDo: [
    'Hold the boundary calmly — every time',
    'Acknowledge their frustration without caving',
    'Offer two acceptable choices within the limit',
  ],
  whatToAvoid: [
    'Giving in after they escalate',
    'Explaining endlessly',
    'Taking it personally — this is developmental, not disrespect',
  ],
  scientificBasis:
      'Between 18 months and 4 years, children develop a sense of self as '
      'separate from their caregivers. Testing boundaries is how they verify '
      'that the world is predictable and safe. Consistent limits actually '
      'reduce anxiety.',
  relevantTraits: ['persistence', 'independence'],
  signals: ['tantrum', 'refusing', 'control', 'not_listening'],
);

const _independenceSurge = RhythmPhase(
  id: 'independence-surge',
  label: 'Independence Surge',
  emoji: '🚀',
  whatHappening:
      'Your child is driven to do things themselves. This is their autonomy '
      'system firing — it feels urgent to them, even when the task is beyond '
      'their ability.',
  whatParentsNotice: [
    '"I do it myself!"',
    'Frustration when helped',
    'Resisting assistance',
    'Wanting control over choices',
    'Attempting tasks beyond ability',
  ],
  whatChildLearning:
      'That they are capable — and that trying matters more than succeeding',
  whatToSay: [
    'You want to do it yourself. I get that.',
    'You try first. I\'m here if you need me.',
    'That was hard and you kept going.',
  ],
  whatToDo: [
    'Step back and let them struggle a little',
    'Offer the minimum help needed',
    'Celebrate effort, not outcome',
  ],
  whatToAvoid: [
    'Doing it for them because it\'s faster',
    'Saying "you can\'t do that"',
    'Over-praising results instead of effort',
  ],
  scientificBasis:
      'Autonomy development peaks between 18-36 months but continues through '
      'age 5. The drive for independence is linked to the development of '
      'self-efficacy — a child\'s belief that their actions matter.',
  relevantTraits: ['independence', 'persistence'],
  signals: ['refusing', 'control', 'frustration_skill'],
);

const _sensitivityWave = RhythmPhase(
  id: 'sensitivity-wave',
  label: 'Sensitivity Wave',
  emoji: '🌊',
  whatHappening:
      'Your child\'s emotional antenna is turned up high right now. They\'re '
      'absorbing more than usual — sounds, feelings, changes. Everything '
      'feels bigger.',
  whatParentsNotice: [
    'More tears than usual',
    'Overwhelm in busy places',
    'Clinginess',
    'Heightened startle response',
    'Emotional reactions to small things',
  ],
  whatChildLearning:
      'To recognise and manage big feelings — the foundation of emotional '
      'intelligence',
  whatToSay: [
    'That felt really big. I\'m here.',
    'You don\'t have to be brave right now.',
    'Let\'s find somewhere quieter together.',
  ],
  whatToDo: [
    'Reduce stimulation where possible',
    'Allow extra transition time',
    'Provide a calm, predictable environment',
    'Increase physical comfort and connection',
  ],
  whatToAvoid: [
    'Dismissing with "you\'re fine"',
    'Forcing them into overwhelming situations',
    'Comparing them to calmer children',
  ],
  scientificBasis:
      'Emotional sensitivity is linked to high negative emotionality in '
      'temperament research. During periods of rapid development, stress, or '
      'environmental change, children\'s emotional regulation systems can '
      'become temporarily overwhelmed.',
  relevantTraits: ['sensitivity', 'caution'],
  signals: ['clinginess', 'tantrum', 'bedtime_struggle', 'transitions'],
);

const _connectionSeeking = RhythmPhase(
  id: 'connection-seeking',
  label: 'Connection Phase',
  emoji: '🤗',
  whatHappening:
      'Your child\'s attachment system is activated. They need closeness, '
      'reassurance, and to know you\'re still there. This is their way of '
      'refuelling.',
  whatParentsNotice: [
    'Extra clinginess',
    'Wanting to be held',
    'Following you around',
    'Difficulty with separation',
    'Regression in independence',
  ],
  whatChildLearning:
      'That their safe base is reliable — so they can eventually venture '
      'out again',
  whatToSay: [
    'I\'m right here. I\'m not going anywhere.',
    'You want to be close. I love that.',
    'I\'ll always come back.',
  ],
  whatToDo: [
    'Fill their connection cup before expecting independence',
    'Keep goodbyes brief and confident',
    'Create predictable reunion rituals',
  ],
  whatToAvoid: [
    'Sneaking away',
    'Pushing independence when they need closeness',
    'Shaming clinginess',
  ],
  scientificBasis:
      'Attachment theory shows that children cycle between proximity-seeking '
      'and exploration. Connection-seeking phases often precede developmental '
      'leaps — the child is building their secure base before launching into '
      'new territory.',
  relevantTraits: ['sensitivity', 'caution'],
  signals: ['clinginess', 'bedtime_struggle'],
);

const _skillStretch = RhythmPhase(
  id: 'skill-stretch',
  label: 'Skill Stretch',
  emoji: '🌱',
  whatHappening:
      'Your child is pushing the edge of what they can do. They can see '
      'where they want to get — but their body or brain can\'t quite get '
      'there yet. The gap is frustrating.',
  whatParentsNotice: [
    'Increased frustration with tasks',
    'Trying and failing repeatedly',
    'Emotional outbursts during activities',
    'Perfectionism emerging',
  ],
  whatChildLearning:
      'Persistence, problem-solving, and that failure is part of learning',
  whatToSay: [
    'This is tricky. You\'re working hard.',
    'I can see you\'re frustrated. That makes sense.',
    'You don\'t have to get it right. You just have to try.',
  ],
  whatToDo: [
    'Sit with the frustration — don\'t rush to fix',
    'Offer one small help, not the solution',
    'Name the effort: "You kept trying even when it was hard"',
  ],
  whatToAvoid: [
    'Doing it for them',
    'Saying "it\'s easy"',
    'Dismissing the difficulty',
  ],
  scientificBasis:
      'The zone of proximal development (Vygotsky) describes the space '
      'between what a child can do alone and what they can do with support. '
      'Frustration in this zone is a sign of active learning.',
  relevantTraits: ['persistence', 'independence'],
  signals: ['frustration_skill', 'tantrum', 'refusing'],
);

const _cooperationBloom = RhythmPhase(
  id: 'cooperation-bloom',
  label: 'Cooperation Bloom',
  emoji: '🌻',
  whatHappening:
      'Your child is discovering the pleasure of doing things together. '
      'They want to help, share, and be part of the team. This is social '
      'learning in action.',
  whatParentsNotice: [
    'Offering to help',
    'Sharing (sometimes)',
    'Following instructions more willingly',
    'Interest in pleasing',
    'Mimicking adult tasks',
  ],
  whatChildLearning:
      'That contributing feels good — and that they\'re a valued part of '
      'the family',
  whatToSay: [
    'You helped! That made a real difference.',
    'We did that together.',
    'The family works because everyone helps.',
  ],
  whatToDo: [
    'Give real responsibilities (not token ones)',
    'Thank them genuinely',
    'Let them see the impact of their help',
  ],
  whatToAvoid: [
    'Over-praising with "good boy/girl"',
    'Giving rewards for cooperation',
    'Making help conditional on behaviour',
  ],
  scientificBasis:
      'Prosocial behaviour emerges naturally between 18-30 months. Children '
      'are intrinsically motivated to cooperate — external rewards can '
      'undermine this natural drive (Deci & Ryan\'s self-determination theory).',
  relevantTraits: ['sensitivity'],
  signals: [],
);

const _resetPhase = RhythmPhase(
  id: 'reset-phase',
  label: 'Reset',
  emoji: '🫧',
  whatHappening:
      'Your child is processing and consolidating. After a period of rapid '
      'growth, they need time to settle. Things may feel calmer — or '
      'regression may appear. Both are normal.',
  whatParentsNotice: [
    'Calmer than usual',
    'Possible regression in skills',
    'Increased sleep/rest needs',
    'Return to comfort objects',
    'Less resistance',
  ],
  whatChildLearning:
      'To integrate what they\'ve absorbed — their brain is organising',
  whatToSay: [
    'It\'s okay to take it easy today.',
    'You\'ve been working so hard. Rest is good.',
    'There\'s no rush.',
  ],
  whatToDo: [
    'Ease up on expectations',
    'Allow comfort objects and routines',
    'Don\'t push new learning right now',
  ],
  whatToAvoid: [
    'Pushing forward when they need pause',
    'Worrying about regression',
    'Filling every moment with stimulation',
  ],
  scientificBasis:
      'Neural consolidation requires periods of reduced input. What looks '
      'like regression is often the brain reorganising and strengthening new '
      'pathways. Sleep science shows increased sleep needs during '
      'consolidation phases.',
  relevantTraits: [],
  signals: [],
);

// ---------------------------------------------------------------------------
// AGE PRESENTATIONS
// ---------------------------------------------------------------------------

const _boundaryTestingAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Throws things', 'Arches back', 'Hits or bites'],
    emotionalPatterns: ['Pure frustration', 'No words for it yet'],
    guidanceStyle: 'Physical comfort, very short phrases',
    scriptComplexity: '1-2 word boundaries. "No throw. I\'m here."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Says no to everything', 'Runs away', 'Screams'],
    emotionalPatterns: ['Anger', 'Defiance', 'Testing reactions'],
    guidanceStyle: 'Short clear limits with one choice',
    scriptComplexity: '2-3 short sentences. "I won\'t let you. You\'re upset. Red cup or blue?"',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Argues back', 'Negotiates', '"But why?"'],
    emotionalPatterns: ['Frustration', 'Sense of injustice', 'Attempts at reasoning'],
    guidanceStyle: 'Brief explanation + firm limit + choice',
    scriptComplexity: 'Full sentences. "The rule is X. I know that\'s hard. You can choose A or B."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Tests fairness', 'Compares to others', 'Sophisticated push-back'],
    emotionalPatterns: ['Sense of justice', 'Bargaining', 'Social awareness'],
    guidanceStyle: 'Collaborative language within clear limits',
    scriptComplexity: 'Conversational. "I hear you. The answer is still X. What would help you right now?"',
  ),
};

const _independenceSurgeAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Grabs spoon', 'Pushes hand away', 'Cries when helped'],
    emotionalPatterns: ['Frustration at limitations', 'Determination'],
    guidanceStyle: 'Let them try, keep it safe, minimal words',
    scriptComplexity: '"You try. I\'m here."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['"I do it!"', 'Resists dressing help', 'Wants to pour own drink'],
    emotionalPatterns: ['Pride in success', 'Rage when overridden'],
    guidanceStyle: 'Offer minimum help, celebrate effort',
    scriptComplexity: '"You want to do it. I get it. You try first."',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Insists on choosing clothes', 'Rejects help with tasks', 'Wants to lead'],
    emotionalPatterns: ['Frustration gap between intent and ability', 'Need for recognition'],
    guidanceStyle: 'Step back, name the effort, offer structured help',
    scriptComplexity: '"I can see you\'re working hard on that. Want me to hold this part?"',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Wants own decisions about activities', 'Challenges adult choices', 'Teaches younger children'],
    emotionalPatterns: ['Competence drive', 'Leadership instinct', 'Frustration with limits on autonomy'],
    guidanceStyle: 'Give real responsibility, respect capability, collaborate',
    scriptComplexity: '"You decide how. The rule is X. I trust you to figure out the rest."',
  ),
};

const _sensitivityWaveAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Startles easily', 'Cries at loud sounds', 'Clings to parent'],
    emotionalPatterns: ['Overwhelm without words', 'Need for physical comfort'],
    guidanceStyle: 'Hold, soothe, reduce stimulation, minimal words',
    scriptComplexity: '"I\'m here. You\'re safe."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Meltdowns from minor changes', 'Refuses new places', 'Emotional at bedtime'],
    emotionalPatterns: ['Big feelings from small triggers', 'Need for routine'],
    guidanceStyle: 'Name the feeling, validate, offer comfort',
    scriptComplexity: '"That felt really big. I\'m here with you."',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Worries about things', 'Gets upset by stories or images', 'Empathy overload'],
    emotionalPatterns: ['Imagination-driven anxiety', 'Absorbs others\' emotions'],
    guidanceStyle: 'Validate, reassure, help name and process feelings',
    scriptComplexity: '"That worried you. That makes sense. Let\'s talk about it."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Overthinks social situations', 'Picks up on adult stress', 'Perfectionism emerging'],
    emotionalPatterns: ['Social anxiety', 'Need for fairness', 'Fear of failure'],
    guidanceStyle: 'Listen first, validate the complexity, normalise imperfection',
    scriptComplexity: '"That sounds hard. It\'s okay to feel that way. You don\'t have to be perfect."',
  ),
};

const _connectionSeekingAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Cries at separation', 'Reaches for parent constantly', 'Won\'t be put down'],
    emotionalPatterns: ['Separation distress', 'Need for physical contact'],
    guidanceStyle: 'Meet the need, brief confident goodbyes',
    scriptComplexity: '"I\'m here. I\'ll come back."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Follows parent room to room', 'Wants to sleep in parent\'s bed', 'Regresses from independence'],
    emotionalPatterns: ['Attachment activation', 'Need for reassurance'],
    guidanceStyle: 'Fill connection cup first, predictable routines',
    scriptComplexity: '"You want to be close. I love that. I\'m right here."',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Asks "do you love me?"', 'Needs more stories at bedtime', 'Clingy after time apart'],
    emotionalPatterns: ['Verbal processing of attachment', 'Need for verbal reassurance'],
    guidanceStyle: 'Proactive connection, reunion rituals, quality time',
    scriptComplexity: '"I always love you. Even when I\'m not here, I\'m thinking of you."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Worry about parent leaving', 'Wants to know the plan', 'Emotional at goodbyes'],
    emotionalPatterns: ['Future-oriented anxiety', 'Need for predictability'],
    guidanceStyle: 'Preview separations, create rituals, honour their feelings',
    scriptComplexity: '"Here\'s what\'s happening today. I\'ll pick you up at X. What helps you feel ready?"',
  ),
};

const _skillStretchAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Cries when block tower falls', 'Throws toy that won\'t work', 'Frustrated with spoon'],
    emotionalPatterns: ['Immediate frustration', 'No coping strategies yet'],
    guidanceStyle: 'Sit with them, model patience, minimal help',
    scriptComplexity: '"Tricky! You try again."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Melts down when puzzle piece won\'t fit', 'Gives up and screams', 'Demands help then refuses it'],
    emotionalPatterns: ['Frustration spiral', 'Wanting to but can\'t'],
    guidanceStyle: 'Name the struggle, sit beside, offer one small help',
    scriptComplexity: '"That\'s hard. You\'re frustrated. Want me to hold this part?"',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Says "I can\'t do it"', 'Avoids challenging tasks', 'Gets angry at mistakes'],
    emotionalPatterns: ['Self-awareness of failure', 'Perfectionism emerging'],
    guidanceStyle: 'Normalise struggle, celebrate the attempt, reframe failure',
    scriptComplexity: '"Mistakes are how your brain learns. I make mistakes too. Let\'s try together."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Compares self to peers', 'Frustrated by slow progress', 'Wants to be "the best"'],
    emotionalPatterns: ['Social comparison', 'Achievement pressure', 'Growth mindset emerging'],
    guidanceStyle: 'Focus on personal progress, not comparison; growth over performance',
    scriptComplexity: '"You\'re not trying to be better than anyone. You\'re trying to be better than yesterday."',
  ),
};

const _cooperationBloomAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Hands you things', 'Mimics tidying', 'Points to share attention'],
    emotionalPatterns: ['Pleasure in shared activity', 'Proto-cooperation'],
    guidanceStyle: 'Accept every offer warmly, model together-language',
    scriptComplexity: '"Thank you! We did it together."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Wants to help cook', 'Puts shoes by door', 'Shares (briefly)'],
    emotionalPatterns: ['Pride in helping', 'Desire to belong'],
    guidanceStyle: 'Give real jobs, name their contribution',
    scriptComplexity: '"You carried that all by yourself. That really helped."',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Sets the table', 'Helps with younger sibling', 'Follows multi-step instructions'],
    emotionalPatterns: ['Team identity', 'Responsibility pride'],
    guidanceStyle: 'Acknowledge their role, give meaningful tasks, build family identity',
    scriptComplexity: '"You\'re someone who helps. That\'s what our family does."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Negotiates fairly', 'Takes turns willingly', 'Helps without being asked'],
    emotionalPatterns: ['Internalised cooperation', 'Social conscience developing'],
    guidanceStyle: 'Trust them with real responsibility, reflect their growth',
    scriptComplexity: '"You noticed that needed doing and you just did it. That\'s maturity."',
  ),
};

const _resetPhaseAges = {
  '1-2': AgePresentation(
    ageRange: '1-2',
    behaviours: ['Sleeps more', 'Wants comfort objects', 'Less adventurous'],
    emotionalPatterns: ['General calm', 'Need for familiar'],
    guidanceStyle: 'Follow their lead, reduce demands, comfort freely',
    scriptComplexity: '"Rest is good. No rush today."',
  ),
  '2-3': AgePresentation(
    ageRange: '2-3',
    behaviours: ['Regression in potty or speech', 'Extra cuddly', 'Less defiant than usual'],
    emotionalPatterns: ['Consolidation calm', 'Temporary regression'],
    guidanceStyle: 'Don\'t worry about regression, keep routine gentle',
    scriptComplexity: '"That\'s okay. You\'ve been learning so much. Take your time."',
  ),
  '3-4': AgePresentation(
    ageRange: '3-4',
    behaviours: ['Returns to old comfort habits', 'Less interested in new things', 'More compliant'],
    emotionalPatterns: ['Processing pause', 'Need for predictability'],
    guidanceStyle: 'Honour the pause, don\'t push new milestones',
    scriptComplexity: '"It\'s okay to go slow. You\'ve been working really hard."',
  ),
  '4-5': AgePresentation(
    ageRange: '4-5',
    behaviours: ['Wants simpler activities', 'Re-reads favourite books', 'Less social energy'],
    emotionalPatterns: ['Intentional rest', 'Self-regulation emerging'],
    guidanceStyle: 'Respect their pace, acknowledge the growth that preceded this',
    scriptComplexity: '"You\'re allowed to take a break. Even grown-ups need that."',
  ),
};

// ---------------------------------------------------------------------------
// BEHAVIOUR ANTICIPATION DATA
// ---------------------------------------------------------------------------

const allAnticipations = <BehaviourAnticipation>[
  BehaviourAnticipation(
    headsUp: 'You may notice more fierce "no" reactions right now',
    why: 'Autonomy drive is peaking — this is their will coming online',
    whatToSay: 'I hear you. The answer is still no.',
    whatToDo: 'Offer two clear choices before they escalate',
    relevantTemperaments: ['strong-willed'],
    relevantPhases: ['boundary-testing', 'independence-surge'],
    ageMinMonths: 24,
    ageMaxMonths: 36,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice more tears at drop-off or separation',
    why: 'Separation awareness is developing — they understand you leave',
    whatToSay: 'I\'ll always come back. You\'re safe here.',
    whatToDo: 'Create a consistent goodbye ritual — same words, same sequence',
    relevantTemperaments: ['sensitive'],
    relevantPhases: ['connection-seeking', 'sensitivity-wave'],
    ageMinMonths: 12,
    ageMaxMonths: 24,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice reluctance at playgroup or parties',
    why: 'Social awareness is growing faster than social confidence',
    whatToSay: 'You don\'t have to join in yet. I\'ll stay close.',
    whatToDo: 'Arrive early so they can warm up before the crowd arrives',
    relevantTemperaments: ['cautious'],
    relevantPhases: ['sensitivity-wave', 'connection-seeking'],
    ageMinMonths: 24,
    ageMaxMonths: 36,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice more "I do it myself" frustration',
    why: 'Capability is lagging behind ambition — and they know it',
    whatToSay: 'I can see you want to do this. That\'s great.',
    whatToDo: 'Offer the minimum help: "Want me to hold this part?"',
    relevantTemperaments: ['independent'],
    relevantPhases: ['independence-surge', 'skill-stretch'],
    ageMinMonths: 30,
    ageMaxMonths: 48,
  ),
  BehaviourAnticipation(
    headsUp: 'Check in — quiet doesn\'t always mean content',
    why: 'Easygoing children can suppress needs to keep the peace',
    whatToSay: 'I want to know how you\'re really feeling.',
    whatToDo: 'Create daily 1-on-1 time to draw out their voice',
    relevantTemperaments: ['easygoing'],
    relevantPhases: ['reset-phase', 'cooperation-bloom'],
    ageMinMonths: 24,
    ageMaxMonths: 48,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice biting or hitting appearing',
    why: 'They have big feelings and no words yet — the body acts first',
    whatToSay: 'I won\'t let you bite. You\'re frustrated.',
    whatToDo: 'Stay close and block gently. Teach "gentle hands"',
    relevantTemperaments: ['strong-willed', 'sensitive', 'cautious', 'independent', 'easygoing'],
    relevantPhases: ['boundary-testing', 'sensitivity-wave'],
    ageMinMonths: 18,
    ageMaxMonths: 24,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice bedtime negotiations getting intense',
    why: 'They\'re testing whether persistence changes the outcome',
    whatToSay: 'Bedtime is bedtime. You choose: one story or two songs.',
    whatToDo: 'Be boringly consistent. Same routine, same words, same calm',
    relevantTemperaments: ['strong-willed'],
    relevantPhases: ['boundary-testing'],
    ageMinMonths: 36,
    ageMaxMonths: 48,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice worry about things that haven\'t happened',
    why: 'Their imagination is outpacing their emotional regulation',
    whatToSay: 'That sounds scary. I\'m right here.',
    whatToDo: 'Validate the feeling, don\'t dismiss the worry. Keep bedtime calm.',
    relevantTemperaments: ['sensitive'],
    relevantPhases: ['sensitivity-wave'],
    ageMinMonths: 36,
    ageMaxMonths: 60,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice reluctance to try new activities',
    why: 'Self-awareness means they can predict failure — and avoid it',
    whatToSay: 'You don\'t have to be perfect. You just have to try.',
    whatToDo: 'Celebrate the attempt, not the result. Model your own mistakes.',
    relevantTemperaments: ['cautious'],
    relevantPhases: ['skill-stretch'],
    ageMinMonths: 36,
    ageMaxMonths: 60,
  ),
  BehaviourAnticipation(
    headsUp: 'You may notice more questions about fairness',
    why: 'Moral reasoning is developing — they\'re building their sense of justice',
    whatToSay: 'That does feel unfair. Let me explain why.',
    whatToDo: 'Take their sense of fairness seriously. They\'re practising ethics.',
    relevantTemperaments: ['strong-willed', 'sensitive', 'cautious', 'independent', 'easygoing'],
    relevantPhases: ['boundary-testing', 'cooperation-bloom'],
    ageMinMonths: 48,
    ageMaxMonths: 60,
  ),
];

// ---------------------------------------------------------------------------
// CONSTANTS — collected lists
// ---------------------------------------------------------------------------

const allRhythmPhases = <RhythmPhase>[
  _boundaryTesting,
  _independenceSurge,
  _sensitivityWave,
  _connectionSeeking,
  _skillStretch,
  _cooperationBloom,
  _resetPhase,
];

const allPhasesWithAge = <RhythmPhaseWithAge>[
  RhythmPhaseWithAge(phase: _boundaryTesting, agePresentations: _boundaryTestingAges),
  RhythmPhaseWithAge(phase: _independenceSurge, agePresentations: _independenceSurgeAges),
  RhythmPhaseWithAge(phase: _sensitivityWave, agePresentations: _sensitivityWaveAges),
  RhythmPhaseWithAge(phase: _connectionSeeking, agePresentations: _connectionSeekingAges),
  RhythmPhaseWithAge(phase: _skillStretch, agePresentations: _skillStretchAges),
  RhythmPhaseWithAge(phase: _cooperationBloom, agePresentations: _cooperationBloomAges),
  RhythmPhaseWithAge(phase: _resetPhase, agePresentations: _resetPhaseAges),
];

// ---------------------------------------------------------------------------
// DETECTION LOGIC
// ---------------------------------------------------------------------------

/// Detect the current rhythm phase from recent behaviour patterns.
///
/// NOT deterministic — uses signal frequency, temperament weighting,
/// and confidence levels. Phases can overlap.
RhythmDetectionResult detectRhythmPhase({
  required List<String> recentBehaviours,
  String? temperamentType,
  required int ageInMonths,
}) {
  if (recentBehaviours.isEmpty) {
    return const RhythmDetectionResult(
      primaryPhase: 'reset-phase',
      confidence: 'low',
      explanation: 'Not enough data yet. We\'re watching for patterns.',
    );
  }

  // Count signal frequency
  final signalCounts = <String, int>{};
  for (final behaviour in recentBehaviours) {
    signalCounts[behaviour] = (signalCounts[behaviour] ?? 0) + 1;
  }

  // Score each phase
  final phaseScores = <String, double>{};
  for (final phase in allRhythmPhases) {
    double score = 0;
    for (final signal in phase.signals) {
      score += (signalCounts[signal] ?? 0) * 1.0;
    }

    // Temperament weighting: boost phases whose traits match temperament
    if (temperamentType != null) {
      final traitMap = {
        'strong-willed': 'persistence',
        'sensitive': 'sensitivity',
        'cautious': 'caution',
        'independent': 'independence',
        'easygoing': 'adaptability',
      };
      final trait = traitMap[temperamentType];
      if (trait != null && phase.relevantTraits.contains(trait)) {
        score *= 1.3; // 30% boost for temperament match
      }
    }

    phaseScores[phase.id] = score;
  }

  // Handle low/no signals → cooperation or reset
  final totalSignals = signalCounts.values.fold<int>(0, (a, b) => a + b);
  if (totalSignals < 2) {
    // Very few incidents — likely cooperation or reset
    phaseScores['cooperation-bloom'] = (phaseScores['cooperation-bloom'] ?? 0) + 2;
    phaseScores['reset-phase'] = (phaseScores['reset-phase'] ?? 0) + 1;
  }

  // Sort by score
  final sorted = phaseScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final primary = sorted.first;
  final primaryId = primary.key;

  // Secondary phase (if >= 50% of primary)
  String? secondaryId;
  if (sorted.length > 1 && primary.value > 0 &&
      sorted[1].value >= primary.value * 0.5) {
    secondaryId = sorted[1].key;
  }

  // Confidence
  final matchCount = primary.value.round();
  String confidence;
  if (matchCount >= 5) {
    confidence = 'high';
  } else if (matchCount >= 3) {
    confidence = 'medium';
  } else {
    confidence = 'low';
  }

  // Human-readable explanation
  final phaseLabel = allRhythmPhases
      .firstWhere((p) => p.id == primaryId,
          orElse: () => _resetPhase)
      .label;

  final explanation = _buildExplanation(primaryId, matchCount, temperamentType);

  return RhythmDetectionResult(
    primaryPhase: primaryId,
    secondaryPhase: secondaryId,
    confidence: confidence,
    explanation: explanation,
  );
}

String _buildExplanation(String phaseId, int matchCount, String? temperament) {
  final base = {
    'boundary-testing': 'Recent behaviour shows increased limit-testing and pushback.',
    'independence-surge': 'We\'re seeing a strong drive for autonomy and self-direction.',
    'sensitivity-wave': 'Emotional reactions have been bigger than usual recently.',
    'connection-seeking': 'There\'s a pattern of seeking closeness and reassurance.',
    'skill-stretch': 'Frustration around new skills suggests active learning.',
    'cooperation-bloom': 'We\'re seeing more cooperation and helpfulness.',
    'reset-phase': 'Things feel calmer — this may be a consolidation period.',
  };

  var text = base[phaseId] ?? 'We\'re still learning their patterns.';

  if (temperament != null) {
    final addition = {
      'strong-willed': ' This is especially common for determined children.',
      'sensitive': ' Sensitive children feel this more intensely.',
      'cautious': ' Cautious children may need extra time through this.',
      'independent': ' Independent children often express this strongly.',
      'easygoing': ' Even easygoing children go through this.',
    };
    text += addition[temperament] ?? '';
  }

  return text;
}

/// Get relevant behaviour anticipations for a child's current state.
List<BehaviourAnticipation> getAnticipations({
  String? temperamentType,
  required int ageInMonths,
  String? currentPhase,
}) {
  return allAnticipations.where((a) {
    // Age must be in range
    if (ageInMonths < a.ageMinMonths || ageInMonths > a.ageMaxMonths) {
      return false;
    }

    // Temperament must match (if specified)
    if (temperamentType != null &&
        !a.relevantTemperaments.contains(temperamentType)) {
      return false;
    }

    // Phase match is a bonus but not required
    return true;
  }).toList();
}

/// Find a specific rhythm phase by id.
RhythmPhase? findRhythmPhase(String id) {
  try {
    return allRhythmPhases.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

/// Get age-specific presentation for a phase.
AgePresentation? getAgePresentation(String phaseId, String ageBand) {
  try {
    final phaseWithAge = allPhasesWithAge.firstWhere(
      (p) => p.phase.id == phaseId,
    );
    return phaseWithAge.agePresentations[ageBand];
  } catch (_) {
    return null;
  }
}
