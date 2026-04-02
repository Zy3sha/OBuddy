import '../models/guidance_response.dart';

/// All 14 behaviour scenarios with full Blended Response Model outputs.
/// Structure: Calm Boundary → Emotional Validation → Guided Action
const allScenarios = <GuidanceResponse>[
  // ── 1. Tantrum in public ──
  GuidanceResponse(
    behaviourType: 'tantrum',
    whyHappening:
        'They\'re overwhelmed and don\'t yet have the skills to regulate big emotions. This is normal brain development, not bad behaviour.',
    calmBoundary:
        'I\'m staying right here. We\'re going to get through this.',
    emotionalValidation:
        'I can see you\'re really upset. That feeling is very big right now.',
    guidedAction:
        'Move to a quieter spot if possible. Get low, stay calm, wait it out. Offer comfort when the wave passes.',
    sampleScript:
        'I\'m here. You\'re safe. I\'ll wait with you until this big feeling passes.',
    whatToAvoid:
        'Don\'t threaten, bribe, or reason mid-tantrum. Their thinking brain is offline.',
  ),

  // ── 2. Refusing to brush teeth ──
  GuidanceResponse(
    behaviourType: 'refusing',
    whyHappening:
        'They\'re testing independence and control. This is normal at this age — they want to make decisions about their own body.',
    calmBoundary:
        'I won\'t let you skip brushing. Your teeth need looking after.',
    emotionalValidation:
        'I know you don\'t feel like it. That\'s okay to feel.',
    guidedAction:
        'Offer two choices: toothbrush colour or who goes first. Give them control within the limit.',
    sampleScript:
        'I won\'t let you skip brushing. I know you don\'t feel like it. You choose: blue brush or green brush?',
    whatToAvoid:
        'Don\'t force their mouth open or turn it into a battle. Don\'t negotiate away the boundary.',
  ),

  // ── 3. Refusing the potty ──
  GuidanceResponse(
    behaviourType: 'potty_refusal',
    whyHappening:
        'Potty training involves giving up control of their body. Resistance is often about autonomy, not defiance.',
    calmBoundary:
        'The potty is here when you\'re ready. We\'ll try again later.',
    emotionalValidation:
        'I understand you don\'t want to sit right now. That\'s okay.',
    guidedAction:
        'Back off without drama. Try again in 20 minutes. Keep it matter-of-fact, not emotional.',
    sampleScript:
        'No problem. The potty will be here. We\'ll try again after we play.',
    whatToAvoid:
        'Don\'t shame accidents, show frustration, or force them to sit. Pressure creates resistance.',
  ),

  // ── 4. Hitting ──
  GuidanceResponse(
    behaviourType: 'hitting',
    whyHappening:
        'Young children hit because they lack words for big feelings. It\'s impulse, not malice — their prefrontal cortex is years from mature.',
    calmBoundary:
        'I won\'t let you hit. Hitting hurts. I\'m going to keep everyone safe.',
    emotionalValidation:
        'I can see you\'re really angry. It\'s okay to feel angry.',
    guidedAction:
        'Gently block the hit. Name the feeling. Offer an alternative: stamp feet, squeeze hands, hit a cushion.',
    sampleScript:
        'I won\'t let you hit. You\'re angry — I get it. You can stamp your feet or squeeze my hands.',
    whatToAvoid:
        'Don\'t hit back, yell, or say "we don\'t hit" with no follow-through. Don\'t ignore it either.',
  ),

  // ── 5. Not listening ──
  GuidanceResponse(
    behaviourType: 'not_listening',
    whyHappening:
        'Their attention is absorbed in what they\'re doing. Young children can\'t easily switch focus — this is developmental, not disrespectful.',
    calmBoundary:
        'I need you to listen now. This is important.',
    emotionalValidation:
        'I can see you\'re really into what you\'re doing. It\'s hard to stop.',
    guidedAction:
        'Get on their level, make eye contact, use their name first. Give a short warning before transitions.',
    sampleScript:
        'Oliver. I can see you\'re playing. In two minutes, we need to put shoes on. I\'ll help you.',
    whatToAvoid:
        'Don\'t shout from across the room. Don\'t repeat yourself 10 times — it teaches them to tune out.',
  ),

  // ── 6. Bedtime resistance ──
  GuidanceResponse(
    behaviourType: 'bedtime_struggle',
    whyHappening:
        'Separation anxiety, overtiredness, or need for connection. Bedtime means saying goodbye to you — that\'s hard for small children.',
    calmBoundary:
        'It\'s time for bed now. Your body needs rest to grow.',
    emotionalValidation:
        'I know you want to keep playing. I love being with you too.',
    guidedAction:
        'Offer a choice within the routine: story or song first? Keep the sequence consistent. Stay calm, brief, warm.',
    sampleScript:
        'It\'s bedtime now. I know you want more time. Choose: one story or two songs tonight?',
    whatToAvoid:
        'Don\'t engage in endless negotiations. Don\'t threaten ("If you don\'t go to bed..."). Don\'t make bedtime feel like punishment.',
  ),

  // ── 7. Refusing dinner ──
  GuidanceResponse(
    behaviourType: 'refusing_dinner',
    whyHappening:
        'Toddlers have small, unpredictable appetites. They may also be testing boundaries or genuinely not hungry. This is rarely about the food itself.',
    calmBoundary:
        'This is what we\'re having tonight. You don\'t have to eat it.',
    emotionalValidation:
        'I understand you don\'t feel like this right now.',
    guidedAction:
        'Serve one safe food alongside the meal. No pressure. Remove food calmly after 20 minutes without comment.',
    sampleScript:
        'This is dinner. You don\'t have to eat it. The pasta is there if you\'d like some.',
    whatToAvoid:
        'Don\'t beg, bribe, or make alternative meals. Don\'t comment on every bite or lack of it.',
  ),

  // ── 8. Throwing food ──
  GuidanceResponse(
    behaviourType: 'throwing_food',
    whyHappening:
        'Under 2: sensory exploration. Over 2: often signalling "I\'m done" or testing cause and effect. Rarely malicious.',
    calmBoundary:
        'Food stays on the table. If you throw it, mealtime is over.',
    emotionalValidation:
        'I see you might be finished. That\'s okay.',
    guidedAction:
        'Give a clear warning once. If repeated, calmly end the meal without drama. Try again at the next meal.',
    sampleScript:
        'Food stays on the table. If you throw it again, I\'ll know you\'re finished. Are you done?',
    whatToAvoid:
        'Don\'t react with big emotion — that makes it a game. Don\'t punish or withhold the next meal.',
  ),

  // ── 9. Refusing to tidy up ──
  GuidanceResponse(
    behaviourType: 'refusing_tidy',
    whyHappening:
        'Tidying requires executive function that\'s still developing. The task feels overwhelming or they\'re not done playing.',
    calmBoundary:
        'Toys get put away before we move on. That\'s how our home works.',
    emotionalValidation:
        'I know it\'s hard to stop. You were having fun.',
    guidedAction:
        'Make it specific and small: "Can you put the red car in the box?" Do it together. Make it routine, not punishment.',
    sampleScript:
        'Time to tidy. I know — you were having fun. Let\'s do it together. Can you put the train in first?',
    whatToAvoid:
        'Don\'t threaten to throw toys away. Don\'t expect a toddler to tidy a whole room alone.',
  ),

  // ── 10. Difficulty with transitions ──
  GuidanceResponse(
    behaviourType: 'transitions',
    whyHappening:
        'Young children live in the moment. Switching activities requires flexible thinking they\'re still building. Transitions are one of the hardest things for toddlers.',
    calmBoundary:
        'We are leaving in two minutes. Then we\'re going.',
    emotionalValidation:
        'I know you don\'t want to stop. This is a hard part.',
    guidedAction:
        'Give a clear 2-minute warning. Use a consistent phrase. Offer something to look forward to at the next activity.',
    sampleScript:
        'Two more minutes, then shoes on. I know it\'s hard to leave. We\'re going to see the ducks — you can carry the bread.',
    whatToAvoid:
        'Don\'t spring transitions with no warning. Don\'t give 10 warnings — one clear one is enough.',
  ),

  // ── 11. Clinginess ──
  GuidanceResponse(
    behaviourType: 'clinginess',
    whyHappening:
        'Clinginess peaks during developmental leaps, illness, or change. It means their attachment system is activated — they need reassurance, not independence training.',
    calmBoundary:
        'I need to put you down for a moment. I\'m coming right back.',
    emotionalValidation:
        'You want to be close to me. I love being close to you too.',
    guidedAction:
        'Name when you\'re leaving and when you\'ll return. Keep goodbyes brief and confident. Fill their "connection cup" before separating.',
    sampleScript:
        'I can see you want to be close. I love that. I\'m going to the kitchen — I\'ll be right back before you know it.',
    whatToAvoid:
        'Don\'t sneak away. Don\'t dismiss their feelings ("You\'re fine"). Don\'t push independence when they need connection.',
  ),

  // ── 12. Frustration with learning a skill ──
  GuidanceResponse(
    behaviourType: 'frustration_skill',
    whyHappening:
        'They can see what they want to achieve but their body or brain can\'t do it yet. The gap between intention and ability causes genuine frustration.',
    calmBoundary:
        'I can see this is hard. I\'m not going to do it for you — I know you can get closer.',
    emotionalValidation:
        'It\'s really frustrating when it doesn\'t work. I understand that feeling.',
    guidedAction:
        'Sit with the frustration briefly. Offer one small help, not the whole solution. Celebrate effort, not outcome.',
    sampleScript:
        'This is tricky. I can see you\'re frustrated. Want me to hold this part while you try?',
    whatToAvoid:
        'Don\'t rush in and do it for them. Don\'t say "it\'s easy." Don\'t dismiss the difficulty.',
  ),

  // ── 13. Sibling jealousy ──
  GuidanceResponse(
    behaviourType: 'sibling_jealousy',
    whyHappening:
        'A new sibling means sharing the most important people in their world. Jealousy is a normal, healthy response to a massive change.',
    calmBoundary:
        'I won\'t let you hurt the baby. Everyone in this family is safe.',
    emotionalValidation:
        'It\'s hard sharing Mummy and Daddy. You had us all to yourself before.',
    guidedAction:
        'Schedule daily 1-on-1 time. Give them a "big helper" role. Acknowledge the hard feelings without fixing them.',
    sampleScript:
        'I can see you\'re finding this hard. You\'re allowed to feel cross about the baby. Let\'s have our special time now — just you and me.',
    whatToAvoid:
        'Don\'t say "you should love your sibling." Don\'t compare them. Don\'t force affection.',
  ),

  // ── 14. Wanting control over everything ──
  GuidanceResponse(
    behaviourType: 'control',
    whyHappening:
        'Between 2–4, children discover they are separate people with their own will. The drive for autonomy is healthy — it just feels exhausting.',
    calmBoundary:
        'I decide when it\'s safe. You get to choose within that.',
    emotionalValidation:
        'You want to be in charge. I understand — being small is hard sometimes.',
    guidedAction:
        'Offer two acceptable choices wherever possible. Let them "win" on small things. Save your firm boundary for safety and essentials.',
    sampleScript:
        'You want to choose. I get it. Today you can pick: the blue cup or the green cup. I decide when we leave.',
    whatToAvoid:
        'Don\'t fight every battle. Don\'t let them control safety decisions. Don\'t remove all choice — that creates more resistance.',
  ),
];

/// Quick lookup by behaviour type
GuidanceResponse? findScenario(String type) {
  try {
    return allScenarios.firstWhere((s) => s.behaviourType == type);
  } catch (_) {
    return null;
  }
}

/// Quick help categories shown on the Quick Help screen
const quickHelpCategories = [
  {'type': 'tantrum', 'icon': '😤', 'label': 'Tantrum'},
  {'type': 'refusing', 'icon': '🙅', 'label': 'Refusing'},
  {'type': 'hitting', 'icon': '✋', 'label': 'Hitting'},
  {'type': 'not_listening', 'icon': '🙉', 'label': 'Not listening'},
  {'type': 'bedtime_struggle', 'icon': '🌙', 'label': 'Bedtime struggle'},
  {'type': 'potty_refusal', 'icon': '🚽', 'label': 'Potty refusal'},
  {'type': 'refusing_dinner', 'icon': '🍽️', 'label': 'Mealtime battle'},
];
