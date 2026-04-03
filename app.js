// ══════════════════════════════════════════════════════════════
// OBuddy — Interactive Web Prototype
// Temperament System + Rhythm Phases + Blended Parenting Engine
// ══════════════════════════════════════════════════════════════

// ── State ──
let currentTab = 0;
let currentOverlay = null;
let quizActive = false;
let quizStep = 0;
let quizAnswers = [];
let helpTaps = [];
let onboardingActive = true;
let onboardingStep = 0;
let onboardingIsMigrant = false;

// ── Family (multi-child + partner) ──
const family = {
  children: [],       // [{name, age, ageMonths, temperament, rhythm, quizCompleted}]
  activeChildIndex: 0,
  partner: null,       // {name, role, email, status}
  migratedFromOBubba: false,
};

// ── Active child shortcut ──
function activeChild() { return family.children[family.activeChildIndex] || family.children[0]; }

// Legacy alias
const childProfile = { get name() { return activeChild()?.name || 'Child'; }, get age() { return activeChild()?.age || ''; },
  get ageMonths() { return activeChild()?.ageMonths || 24; },
  get temperament() { return activeChild()?.temperament; }, set temperament(v) { if (activeChild()) activeChild().temperament = v; },
  get rhythm() { return activeChild()?.rhythm; }, set rhythm(v) { if (activeChild()) activeChild().rhythm = v; },
};

// ── Onboarding temp state ──
let onboardingChildName = '';
let onboardingChildDob = '';
let onboardingPartnerName = '';
let onboardingPartnerEmail = '';
let onboardingPartnerRole = 'Co-parent';

// ══════════════════════════════════════════════════════════════
// TEMPERAMENT SYSTEM
// ══════════════════════════════════════════════════════════════

const temperamentTypes = {
  'strong-willed': {
    id: 'strong-willed', label: 'Strong-Willed', emoji: '🦁',
    strengthLabel: 'Future leader energy',
    description: 'A determined child who knows what they want and will persist until they get it.',
    strengths: ['Determined', 'Confident', 'Knows their own mind', 'Natural leader'],
    challenges: ['Power struggles', 'Difficulty with flexibility', 'Intensity of reactions'],
    whatWorks: ['Clear boundaries with limited choices', 'Consistency', 'Controlled autonomy', '"You decide: A or B"'],
    whatToAvoid: ['Open power struggles', 'Giving in after saying no', 'Too many open-ended choices', 'Reasoning mid-meltdown'],
    daily: 'Expects to be heard. Will push until they find the wall — then feels safe.',
    prefix: 'I can see you feel strongly about this.',
    tone: 'Confident and calm. They respect strength.',
  },
  'sensitive': {
    id: 'sensitive', label: 'Sensitive', emoji: '🌸',
    strengthLabel: 'Deeply tuned-in soul',
    description: 'Notices everything. Feels everything. Needs calm to feel safe.',
    strengths: ['Empathetic', 'Deeply caring', 'Observant', 'Emotionally intelligent'],
    challenges: ['Overwhelm in busy environments', 'Slow transitions', 'Heightened emotional reactions'],
    whatWorks: ['Gentle transitions with warnings', 'Calm environment', 'Extra validation', 'Soft tone', 'Predictable routine'],
    whatToAvoid: ['Abrupt changes', 'Raised voices', 'Dismissing feelings', '"You\'re fine"', 'Busy overstimulating environments'],
    daily: 'Notices everything. Feels everything. Needs calm to feel safe.',
    prefix: 'I can see this is hard for you right now.',
    tone: 'Warm, soft, unhurried. They need to feel safe.',
  },
  'cautious': {
    id: 'cautious', label: 'Cautious', emoji: '🦉',
    strengthLabel: 'Thoughtful observer',
    description: 'Watches before joining. Processes deeply. Warms up beautifully with time.',
    strengths: ['Thoughtful', 'Careful', 'Detail-oriented', 'Wise beyond their years'],
    challenges: ['Reluctance with new experiences', 'Social hesitancy', 'Rigidity with routine changes'],
    whatWorks: ['Extra warm-up time', 'No forced participation', 'Gentle exposure', '"I\'ll be right here"', 'Patience'],
    whatToAvoid: ['Pushing into new situations too fast', 'Comparing to bolder children', 'Labelling as "shy"', 'Forcing social interaction'],
    daily: 'Watches before joining. Processes deeply. Warms up beautifully with time.',
    prefix: 'I know this feels different. Let\'s go through it together.',
    tone: 'Patient, warm, predictable. They need to know what\'s coming.',
  },
  'independent': {
    id: 'independent', label: 'Independent', emoji: '🚀',
    strengthLabel: 'Self-driven explorer',
    description: 'Wants to conquer the world themselves. Needs space to try — and a safety net when they fall.',
    strengths: ['Self-motivated', 'Problem-solver', 'Brave', 'Resourceful'],
    challenges: ['Frustration when capability doesn\'t match ambition', 'Resistance to necessary help', 'Safety concerns'],
    whatWorks: ['Safe boundaries for exploration', '"You try first"', 'Step-back approach', 'Celebrate effort not outcome'],
    whatToAvoid: ['Doing things for them', 'Hovering', 'Removing all challenge', 'Over-praising results'],
    daily: 'Wants to conquer the world themselves. Needs space to try — and a safety net when they fall.',
    prefix: 'I trust you to figure this out.',
    tone: 'Respectful, peer-like. They need to feel trusted.',
  },
  'easygoing': {
    id: 'easygoing', label: 'Easygoing', emoji: '☀️',
    strengthLabel: 'Calm in the storm',
    description: 'Seems fine — and usually is. But still needs to be seen, heard, and asked.',
    strengths: ['Adaptable', 'Resilient', 'Easy to be around', 'Emotionally steady'],
    challenges: ['Needs may go unnoticed', 'May not speak up', 'Can be overlooked', 'May suppress feelings'],
    whatWorks: ['Actively check in on their feelings', 'Create space for their voice', 'Don\'t assume they\'re always fine', 'Name their quiet wins'],
    whatToAvoid: ['Taking their calmness for granted', 'Forgetting to ask how they feel', 'Giving all attention to louder siblings', 'Assuming no needs'],
    daily: 'Seems fine — and usually is. But still needs to be seen, heard, and asked.',
    prefix: 'I want to hear what you think about this.',
    tone: 'Engaging, present. Make sure they feel seen.',
  },
};

// ── Quiz Questions (10 scenario-based) ──
const quizQuestions = [
  {
    scenario: "When your child doesn't get what they want, they usually:",
    options: [
      { label: 'Push harder, insist, escalate', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Cry or become overwhelmed', scores: { 'sensitive': 3, 'cautious': 1 } },
      { label: 'Withdraw or go quiet', scores: { 'cautious': 3, 'sensitive': 1 } },
      { label: 'Shrug it off, move on', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "In a new environment (playgroup, party), your child:",
    options: [
      { label: 'Charges right in', scores: { 'strong-willed': 2, 'independent': 2 } },
      { label: 'Clings to you at first', scores: { 'sensitive': 2, 'cautious': 2 } },
      { label: 'Watches from the side for a long time', scores: { 'cautious': 3, 'sensitive': 1 } },
      { label: 'Finds their place after a moment', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When getting dressed, your child:",
    options: [
      { label: 'Has strong opinions about what to wear', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Gets upset if routine changes', scores: { 'sensitive': 2, 'cautious': 2 } },
      { label: 'Needs time and doesn\'t like being rushed', scores: { 'cautious': 3 } },
      { label: 'Wears whatever, no fuss', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When another child takes their toy, your child:",
    options: [
      { label: 'Takes it back or gets loud', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Cries or comes to you', scores: { 'sensitive': 3 } },
      { label: 'Watches and waits', scores: { 'cautious': 3, 'easygoing': 1 } },
      { label: 'Finds something else to play with', scores: { 'easygoing': 3, 'independent': 1 } },
    ]
  },
  {
    scenario: "At bedtime, your child:",
    options: [
      { label: 'Negotiates for more time', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Needs lots of comfort and closeness', scores: { 'sensitive': 3, 'cautious': 1 } },
      { label: 'Follows the routine if it\'s consistent', scores: { 'cautious': 2, 'easygoing': 2 } },
      { label: 'Falls asleep fairly easily', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When trying something new (food, activity), your child:",
    options: [
      { label: 'Dives in confidently', scores: { 'independent': 3, 'strong-willed': 1 } },
      { label: 'Needs encouragement and reassurance', scores: { 'sensitive': 2, 'cautious': 2 } },
      { label: 'Refuses until they\'ve watched others first', scores: { 'cautious': 3 } },
      { label: 'Gives it a go without much fuss', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When you say 'no' to something, your child:",
    options: [
      { label: 'Pushes back, argues, or has a big reaction', scores: { 'strong-willed': 3 } },
      { label: 'Gets visibly upset or hurt', scores: { 'sensitive': 3 } },
      { label: 'Goes quiet and processes', scores: { 'cautious': 2, 'sensitive': 1, 'easygoing': 1 } },
      { label: 'Accepts it and moves on', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When your child is learning a new skill and struggling:",
    options: [
      { label: 'Gets frustrated but keeps trying', scores: { 'strong-willed': 2, 'independent': 2 } },
      { label: 'Gets upset and needs comfort', scores: { 'sensitive': 3 } },
      { label: 'Gives up quickly and avoids trying again', scores: { 'cautious': 3 } },
      { label: 'Tries casually, not too bothered either way', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "Your child's energy level is best described as:",
    options: [
      { label: 'Intense — always on the go, hard to settle', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Variable — can be very up or very down', scores: { 'sensitive': 3 } },
      { label: 'Measured — careful and deliberate', scores: { 'cautious': 3 } },
      { label: 'Steady — calm and consistent', scores: { 'easygoing': 3 } },
    ]
  },
  {
    scenario: "When transitioning between activities, your child:",
    options: [
      { label: 'Resists strongly, wants to finish their way', scores: { 'strong-willed': 3, 'independent': 1 } },
      { label: 'Gets emotional or clingy', scores: { 'sensitive': 3, 'cautious': 1 } },
      { label: 'Needs lots of warning and preparation', scores: { 'cautious': 3 } },
      { label: 'Switches pretty smoothly', scores: { 'easygoing': 3 } },
    ]
  },
];

// ── Rhythm Phases ──
const rhythmPhases = {
  'boundary-testing': { id: 'boundary-testing', label: 'Boundary Testing', emoji: '🧱',
    what: 'Your child is mapping the edges of their world. Every "no" is them checking: "Is this wall still here? Am I safe?"',
    signals: ['tantrum', 'refusing', 'not_listening', 'hitting'] },
  'independence-surge': { id: 'independence-surge', label: 'Independence Surge', emoji: '🚀',
    what: 'Your child is driven to do things themselves. This is their autonomy system firing.',
    signals: ['refusing', 'not_listening'] },
  'sensitivity-wave': { id: 'sensitivity-wave', label: 'Sensitivity Wave', emoji: '🌊',
    what: 'Emotional antenna is turned up high. Everything feels bigger right now.',
    signals: ['tantrum', 'bedtime_struggle'] },
  'connection-seeking': { id: 'connection-seeking', label: 'Connection Phase', emoji: '🤗',
    what: 'Attachment system activated. They need closeness and reassurance.',
    signals: ['bedtime_struggle'] },
  'skill-stretch': { id: 'skill-stretch', label: 'Skill Stretch', emoji: '🌱',
    what: 'Pushing the edge of what they can do. The gap between want and ability is frustrating.',
    signals: ['tantrum', 'refusing'] },
  'cooperation-bloom': { id: 'cooperation-bloom', label: 'Cooperation Bloom', emoji: '🌻',
    what: 'Discovering the pleasure of doing things together. Social learning in action.',
    signals: [] },
  'reset-phase': { id: 'reset-phase', label: 'Reset', emoji: '🫧',
    what: 'Processing and consolidating. After rapid growth, they need time to settle.',
    signals: [] },
};

// ── Scenario Data (7 scenarios, Blended Response Model) ──
const scenarios = {
  tantrum: {
    type: 'tantrum', icon: '😤', label: 'Tantrum',
    why: "They're overwhelmed and don't yet have the skills to regulate big emotions. This is normal brain development, not bad behaviour.",
    boundary: "I'm staying right here. We're going to get through this.",
    validation: "I can see you're really upset. That feeling is very big right now.",
    action: "Move to a quieter spot if possible. Get low, stay calm, wait it out. Offer comfort when the wave passes.",
    script: "I'm here. You're safe. I'll wait with you until this big feeling passes.",
    avoid: "Don't threaten, bribe, or reason mid-tantrum. Their thinking brain is offline."
  },
  refusing: {
    type: 'refusing', icon: '🙅', label: 'Refusing',
    why: "They're testing independence and control. This is normal at this age — they want to make decisions about their own body.",
    boundary: "I won't let you skip brushing. Your teeth need looking after.",
    validation: "I know you don't feel like it. That's okay to feel.",
    action: "Offer two choices: toothbrush colour or who goes first. Give them control within the limit.",
    script: "I won't let you skip brushing. I know you don't feel like it. You choose: blue brush or green brush?",
    avoid: "Don't force their mouth open or turn it into a battle. Don't negotiate away the boundary."
  },
  hitting: {
    type: 'hitting', icon: '✋', label: 'Hitting',
    why: "Young children hit because they lack words for big feelings. It's impulse, not malice.",
    boundary: "I won't let you hit. Hitting hurts. I'm going to keep everyone safe.",
    validation: "I can see you're really angry. It's okay to feel angry.",
    action: "Gently block the hit. Name the feeling. Offer an alternative: stamp feet, squeeze hands, hit a cushion.",
    script: "I won't let you hit. You're angry — I get it. You can stamp your feet or squeeze my hands.",
    avoid: "Don't hit back, yell, or say 'we don't hit' with no follow-through."
  },
  not_listening: {
    type: 'not_listening', icon: '🙉', label: 'Not listening',
    why: "Their attention is absorbed in what they're doing. Young children can't easily switch focus.",
    boundary: "I need you to listen now. This is important.",
    validation: "I can see you're really into what you're doing. It's hard to stop.",
    action: "Get on their level, make eye contact, use their name first. Give a short warning before transitions.",
    script: "Oliver. I can see you're playing. In two minutes, we need to put shoes on. I'll help you.",
    avoid: "Don't shout from across the room. Don't repeat yourself 10 times."
  },
  bedtime_struggle: {
    type: 'bedtime_struggle', icon: '🌙', label: 'Bedtime struggle',
    why: "Separation anxiety, overtiredness, or need for connection. Bedtime means saying goodbye to you.",
    boundary: "It's time for bed now. Your body needs rest to grow.",
    validation: "I know you want to keep playing. I love being with you too.",
    action: "Offer a choice within the routine: story or song first? Keep the sequence consistent.",
    script: "It's bedtime now. I know you want more time. Choose: one story or two songs tonight?",
    avoid: "Don't engage in endless negotiations. Don't make bedtime feel like punishment."
  },
  potty_refusal: {
    type: 'potty_refusal', icon: '🚽', label: 'Potty refusal',
    why: "Potty training involves giving up control of their body. Resistance is often about autonomy.",
    boundary: "The potty is here when you're ready. We'll try again later.",
    validation: "I understand you don't want to sit right now. That's okay.",
    action: "Back off without drama. Try again in 20 minutes. Keep it matter-of-fact.",
    script: "No problem. The potty will be here. We'll try again after we play.",
    avoid: "Don't shame accidents, show frustration, or force them to sit."
  },
  refusing_dinner: {
    type: 'refusing_dinner', icon: '🍽️', label: 'Mealtime battle',
    why: "Toddlers have small, unpredictable appetites. They may also be testing boundaries.",
    boundary: "This is what we're having tonight. You don't have to eat it.",
    validation: "I understand you don't feel like this right now.",
    action: "Serve one safe food alongside the meal. No pressure. Remove food calmly after 20 minutes.",
    script: "This is dinner. You don't have to eat it. The pasta is there if you'd like some.",
    avoid: "Don't beg, bribe, or make alternative meals."
  }
};

// ── Path & Skills Data ──
const paths = [
  { id: 'potty', icon: '🚽', title: 'Potty Path', stage: 'Getting familiar', progress: 0.4, bg: 'bg-sage' },
  { id: 'food', icon: '🥦', title: 'Food Explorer', stage: 'Expanding exposure', progress: 0.6, bg: 'bg-amber' },
  { id: 'feelings', icon: '🧠', title: 'Big Feelings', stage: 'Naming emotions', progress: 0.2, bg: 'bg-lavender' },
  { id: 'skills', icon: '🌟', title: 'Life Skills', stage: 'Trying with help', progress: 0.2, bg: 'bg-peach' },
  { id: 'routine', icon: '🌙', title: 'Routine Path', stage: 'Setting rhythm', progress: 0.4, bg: 'bg-blue' },
];

const skills = [
  { icon: '🪥', title: 'Brush teeth', reward: 'Building consistency' },
  { icon: '🧸', title: 'Tidy toys', reward: 'Learning responsibility' },
  { icon: '👕', title: 'Get dressed', reward: 'Growing independence' },
  { icon: '🧼', title: 'Wash hands', reward: 'Healthy habits' },
  { icon: '🏠', title: 'Help at home', reward: 'Caring & contributing' },
  { icon: '👟', title: 'Put on shoes', reward: 'Growing independence' },
  { icon: '💛', title: 'Say please & thank you', reward: 'Practising kindness' },
];

// ══════════════════════════════════════════════════════════════
// QUIZ SCORING ENGINE
// ══════════════════════════════════════════════════════════════

function scoreQuiz(answers) {
  const totals = { 'strong-willed': 0, 'sensitive': 0, 'cautious': 0, 'independent': 0, 'easygoing': 0 };
  for (const answer of answers) {
    for (const [type, score] of Object.entries(answer)) {
      totals[type] = (totals[type] || 0) + score;
    }
  }
  const max = Math.max(...Object.values(totals));
  const normalised = {};
  for (const [k, v] of Object.entries(totals)) {
    normalised[k] = max > 0 ? Math.round((v / max) * 100) : 0;
  }
  const sorted = Object.entries(normalised).sort((a, b) => b[1] - a[1]);
  const primary = sorted[0][0];
  const secondary = sorted.length > 1 && sorted[1][1] >= sorted[0][1] * 0.6 ? sorted[1][0] : null;
  return { primaryType: primary, secondaryType: secondary, traitScores: normalised };
}

// ══════════════════════════════════════════════════════════════
// RHYTHM DETECTION
// ══════════════════════════════════════════════════════════════

function detectRhythm() {
  if (helpTaps.length < 2) {
    childProfile.rhythm = { phase: 'reset-phase', secondary: null, confidence: 'low',
      explanation: 'Not enough data yet. We\'re watching for patterns.' };
    return;
  }
  const counts = {};
  for (const t of helpTaps) counts[t] = (counts[t] || 0) + 1;
  const phaseScores = {};
  for (const [id, phase] of Object.entries(rhythmPhases)) {
    let score = 0;
    for (const sig of phase.signals) score += (counts[sig] || 0);
    if (childProfile.temperament) {
      const tempTraitMap = { 'strong-willed': ['persistence'], 'sensitive': ['sensitivity'],
        'cautious': ['caution'], 'independent': ['independence'], 'easygoing': ['adaptability'] };
      const traits = tempTraitMap[childProfile.temperament.primaryType] || [];
      const relevantTraits = { 'boundary-testing': ['persistence','independence'],
        'independence-surge': ['independence','persistence'], 'sensitivity-wave': ['sensitivity','caution'],
        'connection-seeking': ['sensitivity','caution'], 'skill-stretch': ['persistence','independence'] };
      const phaseTraits = relevantTraits[id] || [];
      if (traits.some(t => phaseTraits.includes(t))) score *= 1.3;
    }
    phaseScores[id] = score;
  }
  const sorted = Object.entries(phaseScores).sort((a, b) => b[1] - a[1]);
  const primary = sorted[0];
  const secondary = sorted.length > 1 && primary[1] > 0 && sorted[1][1] >= primary[1] * 0.5 ? sorted[1][0] : null;
  const matchCount = Math.round(primary[1]);
  const confidence = matchCount >= 5 ? 'high' : matchCount >= 3 ? 'medium' : 'low';
  const explanations = {
    'boundary-testing': 'Recent behaviour shows increased limit-testing and pushback.',
    'independence-surge': 'A strong drive for autonomy and self-direction.',
    'sensitivity-wave': 'Emotional reactions have been bigger than usual.',
    'connection-seeking': 'A pattern of seeking closeness and reassurance.',
    'skill-stretch': 'Frustration around new skills suggests active learning.',
    'cooperation-bloom': 'More cooperation and helpfulness.',
    'reset-phase': 'Things feel calmer — this may be a consolidation period.',
  };
  childProfile.rhythm = { phase: primary[0], secondary, confidence,
    explanation: explanations[primary[0]] || '' };
}

// ── SVG Progress Ring ──
function ringSvg(pct, size=44, stroke=3.5) {
  const r = (size - stroke) / 2;
  const circ = 2 * Math.PI * r;
  const offset = circ * (1 - pct);
  return `<svg width="${size}" height="${size}"><circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="rgba(111,168,152,0.12)" stroke-width="${stroke}"/><circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="#6FA898" stroke-width="${stroke}" stroke-linecap="round" stroke-dasharray="${circ}" stroke-dashoffset="${offset}" transform="rotate(-90 ${size/2} ${size/2})"/></svg>`;
}

// ══════════════════════════════════════════════════════════════
// ONBOARDING FLOW
// ══════════════════════════════════════════════════════════════

const onboardingSteps = ['welcome','childName','childDob','addAnother','quizIntro','partnerInvite','done'];
const onboardingMigrantSteps = ['welcome','migration','addAnother','quizIntro','partnerInvite','done'];

function getOnboardingSteps() { return onboardingIsMigrant ? onboardingMigrantSteps : onboardingSteps; }

function renderOnboarding() {
  const steps = getOnboardingSteps();
  const step = steps[onboardingStep];
  const total = steps.length;
  const dots = steps.map((_,i) => `<div style="width:${i===onboardingStep?'24px':'8px'};height:8px;border-radius:4px;background:${i<=onboardingStep?'var(--sage)':'rgba(111,168,152,0.15)'};transition:all 0.3s"></div>`).join('');

  let content = '';
  switch (step) {
    case 'welcome':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🌿</div>
        <div class="t-display">${onboardingIsMigrant ? 'Welcome back' : 'Welcome to OBuddy'}</div>
        <p class="t-body t-muted mt-sm">${onboardingIsMigrant ? 'OBuddy is the next chapter of OBubba —<br>everything you had, plus so much more.' : 'Calm guidance. Confident parenting.<br>For toddlers aged 1–5.'}</p>
        ${onboardingIsMigrant ? '<p class="t-small t-muted mt-md">We\'ve found your family data and brought it across. Nothing was lost.</p>' : ''}
        <div style="flex:1"></div>
        <button class="btn btn-sage" style="width:100%" onclick="onboardingNext()">${onboardingIsMigrant ? 'Continue' : 'Get started'}</button>`;
      break;
    case 'migration':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🏡</div>
        <div class="t-display">We found your family</div>
        <div class="mt-lg">
          ${family.children.map(c => `<div class="card card-sm mb-sm"><div class="row"><div class="avatar" style="width:32px;height:32px;font-size:13px">${c.name[0]}</div><span class="t-body-m flex-1">${c.name}</span><span class="t-small t-muted">imported</span></div></div>`).join('')}
          <div class="row gap-sm mt-md"><span style="color:var(--sage)">✓</span><span class="t-small t-muted">Active paths preserved</span></div>
          <div class="row gap-sm mt-xs"><span style="color:var(--sage)">✓</span><span class="t-small t-muted">Behaviour history carried over</span></div>
        </div>
        <div style="flex:1"></div>
        <button class="btn btn-sage" style="width:100%" onclick="onboardingNext()">Looks good — continue</button>`;
      break;
    case 'childName':
      content = `
        <div style="font-size:40px;margin-bottom:16px">👶</div>
        <div class="t-display">What's your child's name?</div>
        <p class="t-small t-muted mt-sm">You can add more children later.</p>
        <div class="mt-lg">
          <input type="text" id="ob-name" class="ob-input" placeholder="First name" value="${onboardingChildName}" oninput="obNameInput(this)" autocapitalize="words" style="font-size:22px;font-weight:600;border:none;outline:none;background:none;width:100%;padding:8px 0;color:var(--text);border-bottom:2px solid var(--sage)">
        </div>
        <div style="flex:1"></div>
        <button id="ob-name-btn" class="btn btn-sage" style="width:100%;opacity:${onboardingChildName?1:0.4}" onclick="onboardingChildName.trim() && onboardingNext()">Continue</button>`;
      break;
    case 'childDob':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🎂</div>
        <div class="t-display">When were they born?</div>
        <p class="t-small t-muted mt-sm">We use this to tailor guidance to their developmental stage.</p>
        <div class="mt-lg">
          <input type="date" id="ob-dob" class="ob-input" value="${onboardingChildDob}" onchange="onboardingChildDob=this.value;obUpdateBtn('ob-dob-btn',this.value)" style="font-size:18px;padding:14px 16px;border:1px solid var(--border);border-radius:12px;background:var(--card);color:var(--text);width:100%">
        </div>
        <div style="flex:1"></div>
        <button id="ob-dob-btn" class="btn btn-sage" style="width:100%;opacity:${onboardingChildDob?1:0.4}" onclick="onboardingChildDob && onboardingSaveChild()">Continue</button>`;
      break;
    case 'addAnother':
      content = `
        <div style="font-size:40px;margin-bottom:16px">👦👧</div>
        <div class="t-display">Any more little ones?</div>
        <p class="t-body t-muted mt-sm">You can add siblings aged 1–5. Each child gets their own profile.</p>
        <div class="mt-lg">
          ${family.children.map(c => `<div class="card card-sm mb-sm"><div class="row"><div class="avatar" style="width:32px;height:32px;font-size:13px">${c.name[0]}</div><span class="t-body-m flex-1">${c.name}</span><span style="color:var(--sage);font-size:14px">✓</span></div></div>`).join('')}
        </div>
        <button class="btn btn-outline mt-md" style="width:100%" onclick="onboardingAddAnother()">Add another child</button>
        <div style="flex:1"></div>
        <button class="btn btn-sage" style="width:100%" onclick="onboardingNext()">That's everyone</button>`;
      break;
    case 'quizIntro':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🧩</div>
        <div class="t-display">Discover their temperament</div>
        <p class="t-body t-muted mt-sm">10 quick questions about how your child reacts to everyday moments. Takes about 90 seconds.</p>
        <p class="t-small t-muted mt-md">${onboardingIsMigrant ? 'We\'ll blend your answers with what we already know from your behaviour history.' : 'This helps us personalise every piece of guidance — boundaries, validation, scripts — all shaped for YOUR child.'}</p>
        <div style="flex:1"></div>
        <button class="btn btn-sage" style="width:100%" onclick="onboardingStartQuiz()">Start the quiz</button>
        <button class="btn-text mt-sm" style="width:100%;text-align:center;color:var(--text-lt);background:none;border:none;padding:12px;cursor:pointer" onclick="onboardingNext()">I'll do this later</button>`;
      break;
    case 'partnerInvite':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🤝</div>
        <div class="t-display">Invite your co-parent</div>
        <p class="t-body t-muted mt-sm">Both carers see the same guidance, the same scripts, the same boundaries. Consistency made easy.</p>
        <div class="mt-lg">
          <input type="text" class="ob-input" placeholder="Their name" value="${onboardingPartnerName}" oninput="onboardingPartnerName=this.value;obUpdateBtn('ob-partner-btn',this.value)" style="font-size:16px;padding:12px 16px;border:1px solid var(--border);border-radius:12px;background:var(--card);color:var(--text);width:100%;margin-bottom:12px">
          <input type="email" class="ob-input" placeholder="Email (optional)" value="${onboardingPartnerEmail}" oninput="onboardingPartnerEmail=this.value" style="font-size:16px;padding:12px 16px;border:1px solid var(--border);border-radius:12px;background:var(--card);color:var(--text);width:100%;margin-bottom:12px">
          <div class="row gap-sm" style="flex-wrap:wrap">
            ${['Co-parent','Grandparent','Nanny','Other'].map(r => `<span class="chip ${onboardingPartnerRole===r?'chip-sage':'chip-muted'}" onclick="onboardingPartnerRole='${r}';render()" style="cursor:pointer">${r}</span>`).join('')}
          </div>
        </div>
        <div style="flex:1"></div>
        <button id="ob-partner-btn" class="btn btn-sage" style="width:100%" onclick="if(onboardingPartnerName.trim()){onboardingSavePartner()}onboardingNext()">
          ${onboardingPartnerName ? 'Send invite' : 'Not right now'}
        </button>
        <button class="btn-text mt-sm" style="width:100%;text-align:center;color:var(--text-lt);background:none;border:none;padding:12px;cursor:pointer" onclick="onboardingNext()">Skip</button>`;
      break;
    case 'done':
      content = `
        <div style="font-size:40px;margin-bottom:16px">🌿</div>
        <div class="t-display">You're all set</div>
        <p class="t-body t-muted mt-sm">OBuddy is ready. Every piece of guidance is now shaped for your family.</p>
        <div class="mt-lg">
          ${family.children.map(c => {
            const t = c.temperament ? temperamentTypes[c.temperament.primaryType] : null;
            return `<div class="card card-sm mb-sm"><div class="row"><div class="avatar" style="width:36px;height:36px;font-size:14px">${c.name[0]}</div><div class="col gap-xs flex-1" style="margin-left:8px"><span class="t-body-m">${c.name}</span>${t ? `<span class="t-small t-sage">${t.emoji} ${t.label}</span>` : '<span class="t-small t-muted">Quiz pending</span>'}</div><span style="font-size:14px;color:${t?'var(--sage)':'var(--text-lt)'}">${t?'✓':'⏳'}</span></div></div>`;
          }).join('')}
          ${family.partner ? `<div class="card card-sm mb-sm"><div class="row"><span style="font-size:20px">🤝</span><div class="col gap-xs flex-1" style="margin-left:8px"><span class="t-body-m">${family.partner.name}</span><span class="t-small t-muted">${family.partner.role} · invited</span></div></div></div>` : ''}
        </div>
        <div style="flex:1"></div>
        <button class="btn btn-sage" style="width:100%" onclick="finishOnboarding()">Enter OBuddy</button>`;
      break;
  }

  return `
    <div class="screen pt-safe" style="display:flex;flex-direction:column;min-height:100vh">
      <div class="row mb-lg" style="padding-top:8px;justify-content:center;gap:6px">${dots}</div>
      ${content}
    </div>`;
}

// Update a button's opacity based on whether a value is truthy
function obUpdateBtn(btnId, val) {
  const btn = document.getElementById(btnId);
  if (btn) btn.style.opacity = val && val.trim() ? 1 : 0.4;
}

// Handle name input — update variable + button without full re-render
function obNameInput(el) {
  onboardingChildName = el.value;
  obUpdateBtn('ob-name-btn', el.value);
}

function onboardingNext() { const steps = getOnboardingSteps(); if (onboardingStep < steps.length - 1) { onboardingStep++; render(); } }
function onboardingBack() { if (onboardingStep > 0) { onboardingStep--; render(); } }

function onboardingSaveChild() {
  if (!onboardingChildName || !onboardingChildDob) return;
  const dob = new Date(onboardingChildDob);
  const now = new Date();
  const months = (now.getFullYear() - dob.getFullYear()) * 12 + now.getMonth() - dob.getMonth();
  const years = Math.floor(months / 12);
  const rem = months % 12;
  const ageStr = months < 24 ? `${months} months` : rem === 0 ? `${years} years` : `${years} yr ${rem}m`;
  family.children.push({ name: onboardingChildName, age: ageStr, ageMonths: months, temperament: null, rhythm: null, quizCompleted: false });
  onboardingChildName = '';
  onboardingChildDob = '';
  onboardingNext();
}

function onboardingAddAnother() {
  // Go back to childName step
  const steps = getOnboardingSteps();
  const nameIdx = steps.indexOf('childName');
  if (nameIdx >= 0) { onboardingStep = nameIdx; render(); }
}

function onboardingSavePartner() {
  if (!onboardingPartnerName) return;
  family.partner = { name: onboardingPartnerName, role: onboardingPartnerRole, email: onboardingPartnerEmail || null, status: 'invited' };
}

function onboardingStartQuiz() {
  quizActive = true;
  quizStep = 0;
  quizAnswers = [];
  render();
}

function finishOnboarding() {
  onboardingActive = false;
  family.activeChildIndex = 0;
  currentTab = 0;
  render();
}

// ── Multi-child switcher ──
let childSwitcherOpen = false;
function toggleChildSwitcher() {
  if (family.children.length < 2) return;
  childSwitcherOpen = !childSwitcherOpen;
  render();
}
function switchToChild(index) {
  family.activeChildIndex = index;
  childSwitcherOpen = false;
  render();
}

// ══════════════════════════════════════════════════════════════
// QUIZ SCREEN
// ══════════════════════════════════════════════════════════════

function renderQuizScreen() {
  const q = quizQuestions[quizStep];
  const progress = (quizStep + 1) / quizQuestions.length;
  const isLast = quizStep === quizQuestions.length - 1;
  return `
    <div class="screen pt-safe" style="min-height:100vh">
      <div class="row mb-md" style="padding-top:8px">
        <button class="back-btn" onclick="${quizStep > 0 ? 'quizBack()' : 'skipQuiz()'}">${quizStep > 0 ? '←' : '✕'}</button>
        <span class="flex-1 t-sub" style="text-align:center">Understanding ${childProfile.name}</span>
        <span class="t-small t-muted">${quizStep+1}/${quizQuestions.length}</span>
      </div>
      <div class="progress-bar mb-lg"><div class="fill" style="width:${progress*100}%"></div></div>
      <div class="t-heading mb-lg">${q.scenario}</div>
      <div class="col gap-sm">
        ${q.options.map((opt, i) => `
          <div class="card card-sm quiz-option ${quizAnswers[quizStep] === i ? 'quiz-selected' : ''}"
               onclick="selectQuizOption(${i})">
            <div class="row">
              <div class="quiz-radio ${quizAnswers[quizStep] === i ? 'quiz-radio-on' : ''}">
                ${quizAnswers[quizStep] === i ? '✓' : ''}
              </div>
              <span class="t-body flex-1">${opt.label}</span>
            </div>
          </div>
        `).join('')}
      </div>
      <div style="flex:1"></div>
      <button class="btn btn-sage mt-lg" style="width:100%;opacity:${quizAnswers[quizStep] !== undefined ? 1 : 0.4}"
              onclick="${quizAnswers[quizStep] !== undefined ? (isLast ? 'finishQuiz()' : 'quizNext()') : ''}">
        ${isLast ? 'See results' : 'Continue'}
      </button>
    </div>`;
}

function selectQuizOption(i) {
  quizAnswers[quizStep] = i;
  render();
}
function quizNext() {
  if (quizAnswers[quizStep] === undefined) return;
  quizStep++;
  render();
}
function quizBack() {
  if (quizStep > 0) { quizStep--; render(); }
}
function finishQuiz() {
  const answerScores = quizAnswers.map((ai, qi) => quizQuestions[qi].options[ai].scores);
  const result = scoreQuiz(answerScores);

  if (onboardingActive) {
    // During onboarding — assign to current child being set up
    const child = family.children[family.children.length - 1] || family.children[0];
    if (child) { child.temperament = result; child.quizCompleted = true; }
    quizActive = false;
    onboardingNext(); // move past quizIntro
  } else {
    // Post-onboarding retake
    activeChild().temperament = result;
    activeChild().quizCompleted = true;
    quizActive = false;
    currentTab = 4; // show profile
  }
  render();
}
function skipQuiz() {
  quizActive = false;
  if (onboardingActive) {
    onboardingNext();
  }
  render();
}
function startQuiz() {
  quizActive = true;
  quizStep = 0;
  quizAnswers = [];
  render();
}

// ══════════════════════════════════════════════════════════════
// SCREEN RENDERERS
// ══════════════════════════════════════════════════════════════

function renderHome() {
  const t = childProfile.temperament;
  const tType = t ? temperamentTypes[t.primaryType] : null;
  const r = childProfile.rhythm;
  const rPhase = r ? rhythmPhases[r.phase] : null;

  // Personalised hero content
  let observation = 'Oliver is showing more awareness of the world around them.';
  let challenge = 'Transitions may feel a little harder today.';
  let action = 'Pause 3 seconds before stepping in.';
  let focus = 'patience';

  if (rPhase) {
    const obs = { 'boundary-testing': 'Oliver is pushing limits right now — that\'s them checking the walls are still there.',
      'independence-surge': 'Oliver wants to do it all themselves. That determination is a strength.',
      'sensitivity-wave': 'Oliver\'s feelings are running close to the surface. Extra gentleness today.',
      'connection-seeking': 'Oliver needs closeness right now. That\'s their way of refuelling.',
      'skill-stretch': 'Oliver is reaching for new skills. The frustration means they\'re learning.',
      'cooperation-bloom': 'Oliver is showing a real desire to help and be part of things.',
      'reset-phase': 'Oliver seems calmer. Their brain is consolidating everything.' };
    const ch = { 'boundary-testing': 'You may hear a lot of "no" today.',
      'independence-surge': 'Things may take longer. That\'s okay — they\'re practising.',
      'sensitivity-wave': 'Small things may trigger big feelings.',
      'connection-seeking': 'Separations may be harder right now.',
      'skill-stretch': 'Frustration may spike when tasks feel just out of reach.',
      'cooperation-bloom': 'They may want to help with everything.',
      'reset-phase': 'You might see some regression. That\'s consolidation, not backsliding.' };
    const act = { 'boundary-testing': 'State your limit once, calmly. Then hold.',
      'independence-surge': 'Ask: "Do you want to try that yourself first?"',
      'sensitivity-wave': 'Lower the volume on the day.',
      'connection-seeking': '10 minutes of undivided attention first.',
      'skill-stretch': 'Sit beside them. Don\'t fix. Just be there.',
      'cooperation-bloom': 'Give them one real job today.',
      'reset-phase': 'Take the pressure off today.' };
    observation = obs[r.phase] || observation;
    challenge = ch[r.phase] || challenge;
    action = act[r.phase] || action;
  } else if (tType) {
    const tObs = { 'strong-willed': 'Oliver knows what they want. That persistence will serve them well.',
      'sensitive': 'Oliver is tuning into the world deeply today.',
      'cautious': 'Oliver is watching carefully before joining in — wise.',
      'independent': 'Oliver is showing real self-motivation today.',
      'easygoing': 'Oliver is rolling with the day — check in on how they really feel.' };
    observation = tObs[t.primaryType] || observation;
  }

  return `
    <div class="screen pt-safe">
      <div class="row mb-lg" style="padding-top:8px">
        <div class="avatar" onclick="toggleChildSwitcher()">${(activeChild()?.name || 'O')[0]}</div>
        <div class="col gap-xs flex-1" onclick="toggleChildSwitcher()" style="cursor:pointer">
          <div class="row gap-sm"><span class="t-sub">${childProfile.name}</span>${family.children.length > 1 ? '<span class="t-muted" style="font-size:16px">▾</span>' : ''}</div>
          <span class="t-small">${childProfile.age}${tType ? ' · ' + tType.emoji + ' ' + tType.label : ''}</span>
        </div>
        <div style="width:40px;height:40px;border-radius:50%;background:var(--card);box-shadow:var(--shadow-sm);display:flex;align-items:center;justify-content:center">
          <span style="font-size:18px;color:var(--text-mid)">🔔</span>
        </div>
      </div>

      ${childSwitcherOpen ? `
      <div class="card mb-md" style="border:1px solid var(--sage);background:var(--card)">
        <div class="t-label mb-sm">SWITCH CHILD</div>
        ${family.children.map((c, i) => `
          <div class="row gap-sm mb-xs" onclick="switchToChild(${i})" style="cursor:pointer;padding:8px;border-radius:8px;${i===family.activeChildIndex?'background:rgba(111,168,152,0.08)':''}">
            <div class="avatar" style="width:32px;height:32px;font-size:13px;${i===family.activeChildIndex?'background:var(--sage);color:white':'background:var(--sand)'}">${c.name[0]}</div>
            <div class="flex-1"><span class="t-body-m">${c.name}</span><br><span class="t-small t-muted">${c.age}</span></div>
            ${i===family.activeChildIndex ? '<span style="color:var(--sage);font-size:14px">✓</span>' : ''}
          </div>
        `).join('')}
      </div>` : ''}

      <!-- Hero Card -->
      <div class="card" style="padding:24px">
        <div class="t-label t-sage mb-sm">TODAY'S FOCUS</div>
        <div class="t-display" style="margin-bottom:16px">Today ${childProfile.name} is learning <span style="color:var(--sage-dark)">${focus}</span> 🌱</div>
        <p class="t-body t-muted" style="margin-bottom:4px">${observation}</p>
        <p class="t-body t-muted" style="margin-bottom:16px">${challenge}</p>
        <div style="background:rgba(111,168,152,0.12);border-radius:12px;padding:8px 14px">
          <span class="t-small" style="color:var(--sage-dark);font-weight:600">Try this</span>
          <span class="t-small" style="color:var(--sage-dark)"> ${action}</span>
        </div>
      </div>

      ${rPhase ? `
      <!-- Rhythm Phase -->
      <div class="card card-sm mt-md" style="border-left:3px solid var(--sage)">
        <div class="row">
          <span style="font-size:20px">${rPhase.emoji}</span>
          <div class="flex-1 col gap-xs" style="margin-left:8px">
            <span class="t-body-m">Current Phase: ${rPhase.label}</span>
            <span class="t-small t-muted">${r.explanation}</span>
          </div>
          <span class="chip chip-sage" style="font-size:10px">${r.confidence}</span>
        </div>
      </div>` : ''}

      <!-- Active Path -->
      <div class="section-hdr mt-lg"><div class="t-label">YOUR ACTIVE PATH</div></div>
      <div class="card card-sm" onclick="switchTab(1)">
        <div class="row">
          <div class="flex-1 col gap-xs">
            <span class="t-sub">Potty Path</span>
            <span class="t-small">Getting familiar with the potty</span>
            <div class="progress-bar mt-xs"><div class="fill" style="width:40%"></div></div>
          </div>
          <div class="ring" style="width:52px;height:52px">
            ${ringSvg(0.4, 52, 4)}
            <span class="ring-label">40%</span>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="section-hdr mt-lg"><div class="t-label">QUICK ACTIONS</div></div>
      <div class="row" style="justify-content:space-evenly;padding:8px 0">
        <div class="quick-btn" onclick="switchTab(3)">
          <div class="icon bg-rose">❤️</div>
          <span class="t-caption" style="color:var(--text-mid)">Quick Help</span>
        </div>
        <div class="quick-btn" onclick="showOverlay('food')">
          <div class="icon bg-amber">🍽️</div>
          <span class="t-caption" style="color:var(--text-mid)">Food Today</span>
        </div>
        <div class="quick-btn" onclick="showOverlay('skills')">
          <div class="icon bg-sage">⭐</div>
          <span class="t-caption" style="color:var(--text-mid)">Life Skills</span>
        </div>
      </div>
    </div>`;
}

function renderPaths() {
  return `
    <div class="screen pt-safe">
      <div style="padding-top:8px">
        <div class="t-display">Your Paths</div>
        <p class="t-body t-muted mt-xs">Small steps. Big growth.</p>
      </div>
      <div class="mt-lg">
        ${paths.map(p => `
          <div class="card card-sm">
            <div class="row">
              <div class="icon-box ${p.bg}">${p.icon}</div>
              <div class="flex-1 col gap-xs">
                <span class="t-sub">${p.title}</span>
                <span class="t-small">${p.stage}</span>
              </div>
              <div class="ring" style="width:44px;height:44px">
                ${ringSvg(p.progress, 44, 3.5)}
                <span class="ring-label">${Math.round(p.progress*100)}%</span>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>`;
}

function renderToday() {
  const t = childProfile.temperament;
  const tType = t ? temperamentTypes[t.primaryType] : null;
  const r = childProfile.rhythm;

  // Personalised nudge
  let nudgeText = 'Today may feel harder after nursery. You might want an earlier bedtime.';
  if (r && r.phase === 'boundary-testing') nudgeText = 'Expect some pushback today. Hold your boundaries calmly.';
  else if (r && r.phase === 'sensitivity-wave') nudgeText = 'Keep things quieter today. Less stimulation helps.';
  else if (tType && t.primaryType === 'strong-willed') nudgeText = 'Offer choices before transitions to reduce friction.';

  // Anticipation
  let anticipation = '';
  if (tType) {
    const tips = {
      'strong-willed': { heads: 'You may notice more fierce "no" reactions', why: 'Autonomy drive is peaking' },
      'sensitive': { heads: 'Emotional reactions may be bigger today', why: 'Their emotional antenna is turned up' },
      'cautious': { heads: 'New situations may feel harder', why: 'Social awareness is growing faster than confidence' },
      'independent': { heads: '"I do it myself" moments may increase', why: 'Capability is lagging behind ambition' },
      'easygoing': { heads: 'Check in — quiet doesn\'t always mean content', why: 'They may suppress needs to keep the peace' },
    };
    const tip = tips[t.primaryType];
    if (tip) anticipation = `
      <div class="card card-sm mt-md" style="border-left:3px solid var(--amber)">
        <div class="col gap-xs">
          <span class="t-label" style="color:var(--amber)">HEADS UP</span>
          <span class="t-body-m">${tip.heads}</span>
          <span class="t-small t-muted">${tip.why}</span>
        </div>
      </div>`;
  }

  const items = [
    { title: 'Nursery drop-off', period: 'morning', time: '9:00', who: 'You', done: false },
    { title: 'Pack spare clothes', period: 'morning', done: true },
    { title: 'Pickup', period: 'afternoon', time: '3:30', who: 'Mike', done: false },
    { title: 'Potty practice after snack', period: 'afternoon', nudge: 'Keep it calm — no pressure', done: false },
    { title: 'Bath night', period: 'evening', done: false },
    { title: 'Early bedtime recommended', period: 'evening', nudge: 'Nursery days can be tiring', done: false },
  ];

  function itemsFor(period) {
    return items.filter(i => i.period === period).map(i => `
      <div class="card card-sm">
        <div class="row">
          <div class="today-check ${i.done ? 'done' : ''}">${i.done ? '✓' : ''}</div>
          <div class="flex-1 col gap-xs">
            <span class="t-body-m" style="${i.done ? 'text-decoration:line-through;color:var(--text-lt)' : ''}">${i.title}</span>
            ${i.nudge ? `<span class="t-caption t-sage t-italic">${i.nudge}</span>` : ''}
          </div>
          <div class="col" style="align-items:flex-end;gap:2px">
            ${i.time ? `<span class="t-small">${i.time}</span>` : ''}
            ${i.who ? `<span style="background:var(--sand);border-radius:99px;padding:2px 8px;font-size:10px;color:var(--text-mid)">${i.who}</span>` : ''}
          </div>
        </div>
      </div>
    `).join('');
  }

  return `
    <div class="screen pt-safe">
      <div style="padding-top:8px">
        <div class="t-display">Today</div>
        <p class="t-body t-muted mt-xs">Your family brain. Less to carry.</p>
      </div>
      <div class="mt-lg">
        <div class="encourage mb-md">
          <div class="icon-box-sm" style="background:rgba(111,168,152,0.12)"><span style="font-size:14px">✨</span></div>
          <p>${nudgeText}</p>
        </div>
        ${anticipation}
        <div class="row gap-sm mb-sm mt-md"><span>☀️</span><span class="t-label">MORNING</span></div>
        ${itemsFor('morning')}
        <div class="mt-md"></div>
        <div class="row gap-sm mb-sm"><span>🌤️</span><span class="t-label">AFTERNOON</span></div>
        ${itemsFor('afternoon')}
        <div class="mt-md"></div>
        <div class="row gap-sm mb-sm"><span>🌙</span><span class="t-label">EVENING</span></div>
        ${itemsFor('evening')}
      </div>
    </div>`;
}

function renderQuickHelp() {
  const cats = Object.values(scenarios).slice(0, 7);
  const bgColors = ['bg-rose', 'bg-amber', 'bg-peach', 'bg-lavender', 'bg-blue', 'bg-sage', 'bg-amber'];
  const t = childProfile.temperament;

  // Prioritise based on temperament
  let sortedCats = [...cats];
  if (t) {
    const weights = { 'strong-willed': ['tantrum','refusing','not_listening'],
      'sensitive': ['bedtime_struggle','tantrum','refusing_dinner'],
      'cautious': ['bedtime_struggle','potty_refusal'],
      'independent': ['refusing','not_listening','tantrum'] };
    const boosted = weights[t.primaryType] || [];
    sortedCats.sort((a, b) => {
      const aW = boosted.includes(a.type) ? 1 : 0;
      const bW = boosted.includes(b.type) ? 1 : 0;
      return bW - aW;
    });
  }

  return `
    <div class="screen pt-safe">
      <div style="padding-top:8px">
        <div class="t-display">What's happening<br>right now?</div>
        <p class="t-body t-muted mt-xs">You choose, we'll guide.</p>
      </div>
      <div class="cat-grid mt-lg">
        ${sortedCats.map((c, i) => `
          <div class="cat-tile ${bgColors[i % bgColors.length]}" onclick="showOverlay('guidance','${c.type}')">
            <span class="emoji">${c.icon}</span>
            <span class="t-body-m">${c.label}</span>
          </div>
        `).join('')}
      </div>
      <div class="encourage mt-xl">
        <span class="icon">♥</span>
        <p>You're doing better than you think. We're here.</p>
      </div>
    </div>`;
}

function renderProfile() {
  const t = childProfile.temperament;
  const tType = t ? temperamentTypes[t.primaryType] : null;
  const r = childProfile.rhythm;
  const rPhase = r ? rhythmPhases[r.phase] : null;

  return `
    <div class="screen pt-safe">
      <div class="center" style="padding-top:16px">
        <div class="avatar avatar-lg" style="margin:0 auto">O</div>
        <div class="t-display mt-md">${childProfile.name}</div>
        <div class="t-body t-muted mt-xs">${childProfile.age}</div>
      </div>

      ${tType ? `
      <!-- Temperament -->
      <div class="section-hdr mt-lg"><div class="t-label">TEMPERAMENT</div></div>
      <div class="card">
        <div class="row mb-sm">
          <span style="font-size:24px">${tType.emoji}</span>
          <div class="col gap-xs" style="margin-left:8px">
            <span class="chip chip-sage">${tType.label}</span>
            ${t.secondaryType ? `<span class="t-small t-muted">with ${temperamentTypes[t.secondaryType]?.label || t.secondaryType} tendencies</span>` : ''}
          </div>
        </div>
        <div style="background:rgba(111,168,152,0.1);border-radius:8px;padding:8px 12px;margin-bottom:12px">
          <span style="font-size:12px;color:var(--sage-dark)">✨ ${tType.strengthLabel}</span>
        </div>
        <p class="t-body" style="font-style:italic;color:var(--text-mid)">${tType.daily}</p>
      </div>

      <!-- Strengths -->
      <div class="section-hdr mt-md"><div class="t-label">STRENGTHS</div></div>
      <div class="row gap-sm" style="flex-wrap:wrap">
        ${tType.strengths.map(s => `<span class="chip chip-green">${s}</span>`).join('')}
      </div>

      <!-- What works best -->
      <div class="section-hdr mt-md"><div class="t-label">WHAT WORKS BEST</div></div>
      <div class="card">
        ${tType.whatWorks.map(w => `
          <div class="row gap-sm mb-xs">
            <span style="color:var(--sage);font-size:10px">●</span>
            <span class="t-body">${w}</span>
          </div>
        `).join('')}
      </div>

      <!-- What to avoid -->
      <div class="section-hdr mt-md"><div class="t-label">WHAT TO AVOID</div></div>
      <div class="card" style="border-left:3px solid rgba(232,196,196,0.5)">
        ${tType.whatToAvoid.map(w => `
          <div class="row gap-sm mb-xs">
            <span style="color:#d4a0a0;font-size:10px">●</span>
            <span class="t-body">${w}</span>
          </div>
        `).join('')}
      </div>
      ` : `
      <!-- No temperament yet -->
      <div class="section-hdr mt-lg"><div class="t-label">TEMPERAMENT</div></div>
      <div class="card" style="text-align:center;padding:24px">
        <span style="font-size:32px">🧠</span>
        <p class="t-body mt-sm">Understand how ${childProfile.name} works</p>
        <p class="t-small t-muted mb-md">2-minute quiz, 10 questions</p>
        <button class="btn btn-sage" onclick="startQuiz()">Take the Quiz</button>
      </div>
      `}

      ${rPhase ? `
      <!-- Rhythm Phase -->
      <div class="section-hdr mt-lg"><div class="t-label">CURRENT PHASE</div></div>
      <div class="card" style="border-left:3px solid var(--sage)">
        <div class="row mb-sm">
          <span style="font-size:22px">${rPhase.emoji}</span>
          <span class="chip chip-sage" style="margin-left:8px">${rPhase.label}</span>
          <span class="t-label" style="margin-left:auto;color:${r.confidence==='high'?'var(--sage)':r.confidence==='medium'?'var(--amber)':'var(--text-lt)'}">${r.confidence}</span>
        </div>
        <p class="t-body">${r.explanation}</p>
        ${r.secondary ? `<p class="t-small t-muted mt-xs">Also showing: ${rhythmPhases[r.secondary]?.label || r.secondary}</p>` : ''}
      </div>` : ''}

      <!-- Path Progress -->
      <div class="section-hdr mt-lg"><div class="t-label">PATH PROGRESS</div></div>
      ${paths.map(p => `
        <div class="card card-sm">
          <div class="row">
            <span style="font-size:20px">${p.icon}</span>
            <span class="t-body-m flex-1">${p.title}</span>
            <div class="ring" style="width:36px;height:36px">
              ${ringSvg(p.progress, 36, 3)}
              <span class="ring-label" style="font-size:9px">${Math.round(p.progress*100)}%</span>
            </div>
          </div>
        </div>
      `).join('')}

      ${tType ? `
      <button class="btn btn-outline mt-lg" onclick="startQuiz()" style="width:100%">Retake Quiz</button>
      ` : ''}
    </div>`;
}

// ── Overlay Screens ──

function renderGuidance(type) {
  const s = scenarios[type];
  if (!s) return '';
  const t = childProfile.temperament;
  const tType = t ? temperamentTypes[t.primaryType] : null;

  // Track for rhythm detection
  helpTaps.push(type);
  if (helpTaps.length > 20) helpTaps.shift();
  detectRhythm();

  return `
    <div class="screen pt-safe">
      <div class="row mb-lg" style="padding-top:8px">
        <button class="back-btn" onclick="hideOverlay()">←</button>
        <span class="chip chip-rose">${s.label.toUpperCase()}</span>
      </div>
      <div class="t-display">Here's how to<br>handle it</div>
      <p class="t-body t-muted mt-xs mb-lg">Calm, connected, and consistent.</p>

      ${tType ? `
      <div class="encourage mb-md" style="border-left:3px solid var(--sage)">
        <div class="col gap-xs">
          <span class="t-label t-sage">FOR ${tType.label.toUpperCase()} CHILDREN</span>
          <p class="t-body">${tType.prefix}</p>
          <p class="t-small t-muted">Tone: ${tType.tone}</p>
        </div>
      </div>` : ''}

      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:var(--amber)">💡</div><span class="t-small" style="font-weight:600;color:var(--text)">Why this is happening</span></div>
        <div class="content"><p class="t-body">${s.why}</p></div>
      </div>

      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:rgba(111,168,152,0.15)">💬</div><span class="t-small" style="font-weight:600;color:var(--text)">What to say</span></div>
        <div class="content"><p class="quote t-body">"${s.script}"</p></div>
      </div>

      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:rgba(168,195,170,0.3)">→</div><span class="t-small" style="font-weight:600;color:var(--text)">What to do</span></div>
        <div class="content"><p class="t-body">${s.action}</p></div>
      </div>

      <div class="result-section" style="background:rgba(232,196,196,0.08);border-color:rgba(232,196,196,0.2)">
        <div class="hdr"><div class="dot" style="background:rgba(232,196,196,0.3)">⚠</div><span class="t-small" style="font-weight:600;color:var(--text)">What to avoid</span></div>
        <div class="content"><p class="t-body">${s.avoid}</p></div>
      </div>

      <div class="encourage mt-md">
        <span class="icon">♥</span>
        <p>You stayed calm. You're teaching them more than you know.</p>
      </div>
      <button class="btn btn-sage mt-lg" onclick="hideOverlay()">📑 Save to Library</button>
    </div>`;
}

function renderFood() {
  return `
    <div class="screen pt-safe">
      <div class="row mb-md" style="padding-top:8px">
        <button class="back-btn" onclick="hideOverlay()">←</button>
      </div>
      <div class="t-display">Food Explorer</div>
      <p class="t-body t-muted mt-xs">Today's gentle plan</p>
      <div class="section-hdr mt-lg"><div class="t-label">SAFE FOOD</div></div>
      <div class="card card-sm"><div class="row"><span style="color:var(--sage);font-size:18px">✓</span><span class="t-body-m">Pasta</span></div></div>
      <div class="section-hdr mt-md"><div class="t-label">NEW EXPOSURE</div></div>
      <div class="card card-sm"><div class="row"><span style="font-size:20px">🥦</span><span class="t-body-m">Broccoli</span></div></div>
      <div class="section-hdr mt-md"><div class="t-label">YOUR APPROACH</div></div>
      <div class="encourage"><p>Place it on the plate, no pressure.</p></div>
      <div class="section-hdr mt-lg"><div class="t-label">TODAY'S PROGRESS</div></div>
      ${[{icon:'👀',label:'Seen',count:3},{icon:'🤚',label:'Touched',count:1},{icon:'👃',label:'Smelled',count:0},{icon:'👅',label:'Tasted',count:0}].map(s => `
        <div class="card card-sm"><div class="row">
          <span style="font-size:20px">${s.icon}</span><span class="t-body-m flex-1">${s.label}</span>
          <span class="t-small">${s.count} time${s.count!==1?'s':''}</span>
          <div class="dots" style="margin-left:8px">${[0,1,2,3,4].map(i=>`<div class="dot ${i<s.count?'dot-on':'dot-off'}"></div>`).join('')}</div>
        </div></div>
      `).join('')}
      <div class="encourage mt-md"><p>Exposure builds confidence. You're doing great.</p></div>
    </div>`;
}

function renderSkills() {
  return `
    <div class="screen pt-safe">
      <div class="row mb-md" style="padding-top:8px">
        <button class="back-btn" onclick="hideOverlay()">←</button>
      </div>
      <div class="t-display">Life Skills Quests</div>
      <p class="t-body t-muted mt-xs mb-lg">Little moments, big impact.</p>
      ${skills.map(s => `
        <div class="card card-sm"><div class="row">
          <div class="icon-box bg-sage">${s.icon}</div>
          <div class="flex-1 col gap-xs">
            <span class="t-sub">${s.title}</span>
            <span class="t-small t-sage t-italic">${s.reward}</span>
          </div>
          <span style="color:var(--text-lt);font-size:18px">›</span>
        </div></div>
      `).join('')}
    </div>`;
}

// ══════════════════════════════════════════════════════════════
// NAVIGATION
// ══════════════════════════════════════════════════════════════

function switchTab(index) { currentTab = index; currentOverlay = null; render(); }
function showOverlay(type, data) { currentOverlay = { type, data }; render(); }
function hideOverlay() { currentOverlay = null; render(); }

function render() {
  const main = document.getElementById('main');
  const nav = document.getElementById('nav');

  if (onboardingActive && !quizActive) {
    nav.classList.add('hidden');
    main.innerHTML = renderOnboarding();
  } else if (quizActive) {
    nav.classList.add('hidden');
    main.innerHTML = renderQuizScreen();
  } else if (currentOverlay) {
    nav.classList.add('hidden');
    switch (currentOverlay.type) {
      case 'guidance': main.innerHTML = renderGuidance(currentOverlay.data); break;
      case 'food': main.innerHTML = renderFood(); break;
      case 'skills': main.innerHTML = renderSkills(); break;
      default: main.innerHTML = '';
    }
  } else {
    nav.classList.remove('hidden');
    switch (currentTab) {
      case 0: main.innerHTML = renderHome(); break;
      case 1: main.innerHTML = renderPaths(); break;
      case 2: main.innerHTML = renderToday(); break;
      case 3: main.innerHTML = renderQuickHelp(); break;
      case 4: main.innerHTML = renderProfile(); break;
    }
    document.querySelectorAll('.nav-item').forEach((el, i) => {
      el.classList.toggle('active', i === currentTab);
    });
  }
  window.scrollTo(0, 0);
}

// ── Init: start with onboarding ──
document.addEventListener('DOMContentLoaded', () => {
  // Check if already onboarded (localStorage)
  const saved = localStorage.getItem('obuddy_family');
  if (saved) {
    try {
      const data = JSON.parse(saved);
      family.children = data.children || [];
      family.activeChildIndex = data.activeChildIndex || 0;
      family.partner = data.partner || null;
      family.migratedFromOBubba = data.migratedFromOBubba || false;
      onboardingActive = false;
    } catch (_) {}
  }
  render();
});

// ── Persist family on changes ──
function saveFamily() {
  localStorage.setItem('obuddy_family', JSON.stringify(family));
}

// Override finishOnboarding to also persist
const _origFinish = finishOnboarding;
finishOnboarding = function() {
  onboardingActive = false;
  family.activeChildIndex = 0;
  saveFamily();
  currentTab = 0;
  render();
};
