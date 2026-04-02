// ══════════════════════════════════════════════════════════════
// OBuddy — Interactive Web Prototype
// All screens, navigation, and the Blended Parenting Engine
// ══════════════════════════════════════════════════════════════

// ── State ──
let currentTab = 0;
let currentOverlay = null; // null or { type, data }

// ── Scenario Data (14 scenarios, Blended Response Model) ──
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
    why: "Young children hit because they lack words for big feelings. It's impulse, not malice — their prefrontal cortex is years from mature.",
    boundary: "I won't let you hit. Hitting hurts. I'm going to keep everyone safe.",
    validation: "I can see you're really angry. It's okay to feel angry.",
    action: "Gently block the hit. Name the feeling. Offer an alternative: stamp feet, squeeze hands, hit a cushion.",
    script: "I won't let you hit. You're angry — I get it. You can stamp your feet or squeeze my hands.",
    avoid: "Don't hit back, yell, or say 'we don't hit' with no follow-through. Don't ignore it either."
  },
  not_listening: {
    type: 'not_listening', icon: '🙉', label: 'Not listening',
    why: "Their attention is absorbed in what they're doing. Young children can't easily switch focus — this is developmental, not disrespectful.",
    boundary: "I need you to listen now. This is important.",
    validation: "I can see you're really into what you're doing. It's hard to stop.",
    action: "Get on their level, make eye contact, use their name first. Give a short warning before transitions.",
    script: "Oliver. I can see you're playing. In two minutes, we need to put shoes on. I'll help you.",
    avoid: "Don't shout from across the room. Don't repeat yourself 10 times — it teaches them to tune out."
  },
  bedtime_struggle: {
    type: 'bedtime_struggle', icon: '🌙', label: 'Bedtime struggle',
    why: "Separation anxiety, overtiredness, or need for connection. Bedtime means saying goodbye to you — that's hard for small children.",
    boundary: "It's time for bed now. Your body needs rest to grow.",
    validation: "I know you want to keep playing. I love being with you too.",
    action: "Offer a choice within the routine: story or song first? Keep the sequence consistent. Stay calm, brief, warm.",
    script: "It's bedtime now. I know you want more time. Choose: one story or two songs tonight?",
    avoid: "Don't engage in endless negotiations. Don't threaten. Don't make bedtime feel like punishment."
  },
  potty_refusal: {
    type: 'potty_refusal', icon: '🚽', label: 'Potty refusal',
    why: "Potty training involves giving up control of their body. Resistance is often about autonomy, not defiance.",
    boundary: "The potty is here when you're ready. We'll try again later.",
    validation: "I understand you don't want to sit right now. That's okay.",
    action: "Back off without drama. Try again in 20 minutes. Keep it matter-of-fact, not emotional.",
    script: "No problem. The potty will be here. We'll try again after we play.",
    avoid: "Don't shame accidents, show frustration, or force them to sit. Pressure creates resistance."
  },
  refusing_dinner: {
    type: 'refusing_dinner', icon: '🍽️', label: 'Mealtime battle',
    why: "Toddlers have small, unpredictable appetites. They may also be testing boundaries or genuinely not hungry.",
    boundary: "This is what we're having tonight. You don't have to eat it.",
    validation: "I understand you don't feel like this right now.",
    action: "Serve one safe food alongside the meal. No pressure. Remove food calmly after 20 minutes without comment.",
    script: "This is dinner. You don't have to eat it. The pasta is there if you'd like some.",
    avoid: "Don't beg, bribe, or make alternative meals. Don't comment on every bite or lack of it."
  }
};

// ── Path Data ──
const paths = [
  { id: 'potty', icon: '🚽', title: 'Potty Path', stage: 'Getting familiar', progress: 0.4, bg: 'bg-sage' },
  { id: 'food', icon: '🥦', title: 'Food Explorer', stage: 'Expanding exposure', progress: 0.6, bg: 'bg-amber' },
  { id: 'feelings', icon: '🧠', title: 'Big Feelings', stage: 'Naming emotions', progress: 0.2, bg: 'bg-lavender' },
  { id: 'skills', icon: '🌟', title: 'Life Skills', stage: 'Trying with help', progress: 0.2, bg: 'bg-peach' },
  { id: 'routine', icon: '🌙', title: 'Routine Path', stage: 'Setting rhythm', progress: 0.4, bg: 'bg-blue' },
];

// ── Skills Data ──
const skills = [
  { icon: '🪥', title: 'Brush teeth', reward: 'Building consistency' },
  { icon: '🧸', title: 'Tidy toys', reward: 'Learning responsibility' },
  { icon: '👕', title: 'Get dressed', reward: 'Growing independence' },
  { icon: '🧼', title: 'Wash hands', reward: 'Healthy habits' },
  { icon: '🏠', title: 'Help at home', reward: 'Caring & contributing' },
  { icon: '👟', title: 'Put on shoes', reward: 'Growing independence' },
  { icon: '💛', title: 'Say please & thank you', reward: 'Practising kindness' },
];

// ── SVG Progress Ring ──
function ringSvg(pct, size=44, stroke=3.5) {
  const r = (size - stroke) / 2;
  const circ = 2 * Math.PI * r;
  const offset = circ * (1 - pct);
  return `<svg width="${size}" height="${size}"><circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="rgba(111,168,152,0.12)" stroke-width="${stroke}"/><circle cx="${size/2}" cy="${size/2}" r="${r}" fill="none" stroke="#6FA898" stroke-width="${stroke}" stroke-linecap="round" stroke-dasharray="${circ}" stroke-dashoffset="${offset}" transform="rotate(-90 ${size/2} ${size/2})"/></svg>`;
}

// ══════════════════════════════════════════════
// SCREEN RENDERERS
// ══════════════════════════════════════════════

function renderHome() {
  return `
    <div class="screen pt-safe">
      <!-- Child Header -->
      <div class="row mb-lg" style="padding-top:8px">
        <div class="avatar">O</div>
        <div class="col gap-xs flex-1">
          <div class="row gap-sm"><span class="t-sub">Oliver</span><span class="t-muted" style="font-size:16px">▾</span></div>
          <span class="t-small">2 yr 3m</span>
        </div>
        <div style="width:40px;height:40px;border-radius:50%;background:var(--card);box-shadow:var(--shadow-sm);display:flex;align-items:center;justify-content:center">
          <span style="font-size:18px;color:var(--text-mid)">🔔</span>
        </div>
      </div>

      <!-- Hero Card -->
      <div class="card" style="padding:24px">
        <div class="t-label t-sage mb-sm">TODAY'S FOCUS</div>
        <div class="t-display" style="margin-bottom:16px">Today Oliver is learning <span style="color:var(--sage-dark)">patience</span> 🌱</div>
        <p class="t-body t-muted" style="margin-bottom:4px">He paused briefly before reacting — that's growth.</p>
        <p class="t-body t-muted" style="margin-bottom:16px">Transitions may feel a little harder today.</p>
        <div class="row-between">
          <div style="background:rgba(111,168,152,0.12);border-radius:12px;padding:8px 14px">
            <span class="t-small" style="color:var(--sage-dark);font-weight:600">Try this</span>
            <span class="t-small" style="color:var(--sage-dark)"> Pause 3 seconds before stepping in.</span>
          </div>
          <span style="font-size:22px;opacity:0.4;cursor:pointer">♡</span>
        </div>
      </div>

      <!-- Active Path -->
      <div class="section-hdr mt-lg"><div class="t-label">YOUR ACTIVE PATH</div></div>
      <div class="card card-sm" onclick="switchTab(1)">
        <div class="row">
          <div class="flex-1 col gap-xs">
            <span class="t-sub">Potty Path</span>
            <span class="t-small">Getting familiar with the potty</span>
            <div class="progress-bar mt-xs" style="width:100%"><div class="fill" style="width:40%"></div></div>
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
          <div class="card card-sm" style="cursor:pointer">
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
        <!-- Smart nudge -->
        <div class="encourage mb-md">
          <div class="icon-box-sm" style="background:rgba(111,168,152,0.12)"><span style="font-size:14px">✨</span></div>
          <p>Today may feel harder after nursery. You might want an earlier bedtime.</p>
        </div>
        <!-- Morning -->
        <div class="row gap-sm mb-sm"><span>☀️</span><span class="t-label">MORNING</span></div>
        ${itemsFor('morning')}
        <div class="mt-md"></div>
        <!-- Afternoon -->
        <div class="row gap-sm mb-sm"><span>🌤️</span><span class="t-label">AFTERNOON</span></div>
        ${itemsFor('afternoon')}
        <div class="mt-md"></div>
        <!-- Evening -->
        <div class="row gap-sm mb-sm"><span>🌙</span><span class="t-label">EVENING</span></div>
        ${itemsFor('evening')}
      </div>
    </div>`;
}

function renderQuickHelp() {
  const cats = Object.values(scenarios).slice(0, 7);
  const bgColors = ['bg-rose', 'bg-amber', 'bg-peach', 'bg-lavender', 'bg-blue', 'bg-sage', 'bg-amber'];
  return `
    <div class="screen pt-safe">
      <div style="padding-top:8px">
        <div class="t-display">What's happening<br>right now?</div>
        <p class="t-body t-muted mt-xs">You choose, we'll guide.</p>
      </div>
      <div class="cat-grid mt-lg">
        ${cats.map((c, i) => `
          <div class="cat-tile ${bgColors[i]}" onclick="showOverlay('guidance','${c.type}')">
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
  return `
    <div class="screen pt-safe">
      <div class="center" style="padding-top:16px">
        <div class="avatar avatar-lg" style="margin:0 auto">O</div>
        <div class="t-display mt-md">Oliver</div>
        <div class="t-body t-muted mt-xs">2 yr 3m</div>
      </div>

      <!-- Temperament -->
      <div class="section-hdr mt-lg"><div class="t-label">TEMPERAMENT</div></div>
      <div class="card">
        <div class="chip chip-sage mb-sm">🧠 Strong-willed</div>
        <p class="t-body">Determined and persistent. Needs clear limits with lots of choice.</p>
      </div>

      <!-- Strengths -->
      <div class="section-hdr mt-md"><div class="t-label">STRENGTHS</div></div>
      <div class="row gap-sm" style="flex-wrap:wrap">
        <span class="chip chip-green">Determined</span>
        <span class="chip chip-green">Confident</span>
        <span class="chip chip-green">Knows their own mind</span>
      </div>

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
    </div>`;
}

// ── Overlay Screens ──

function renderGuidance(type) {
  const s = scenarios[type];
  if (!s) return '';
  return `
    <div class="screen pt-safe">
      <div class="row mb-lg" style="padding-top:8px">
        <button class="back-btn" onclick="hideOverlay()">←</button>
        <span class="chip chip-rose">${s.label.toUpperCase()}</span>
      </div>
      <div class="t-display">Here's how to<br>handle it</div>
      <p class="t-body t-muted mt-xs mb-lg">Calm, connected, and consistent.</p>

      <!-- Why -->
      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:var(--amber)">💡</div><span class="t-small" style="font-weight:600;color:var(--text)">Why this is happening</span></div>
        <div class="content"><p class="t-body">${s.why}</p></div>
      </div>

      <!-- What to say -->
      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:rgba(111,168,152,0.15)">💬</div><span class="t-small" style="font-weight:600;color:var(--text)">What to say</span></div>
        <div class="content"><p class="quote t-body">"${s.script}"</p></div>
      </div>

      <!-- What to do -->
      <div class="result-section">
        <div class="hdr"><div class="dot" style="background:rgba(168,195,170,0.3)">→</div><span class="t-small" style="font-weight:600;color:var(--text)">What to do</span></div>
        <div class="content"><p class="t-body">${s.action}</p></div>
      </div>

      <!-- What to avoid -->
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
      <p class="t-small t-light">No pressure, just progress.</p>

      <div class="section-hdr mt-lg"><div class="t-label">SAFE FOOD</div></div>
      <div class="card card-sm"><div class="row"><span style="color:var(--sage);font-size:18px">✓</span><span class="t-body-m">Pasta</span></div></div>

      <div class="section-hdr mt-md"><div class="t-label">NEW EXPOSURE</div></div>
      <div class="card card-sm"><div class="row"><span style="font-size:20px">🥦</span><span class="t-body-m">Broccoli</span></div></div>

      <div class="section-hdr mt-md"><div class="t-label">YOUR APPROACH</div></div>
      <div class="encourage"><p>Place it on the plate, no pressure.</p></div>

      <div class="section-hdr mt-lg"><div class="t-label">TODAY'S PROGRESS</div></div>
      ${[
        { icon: '👀', label: 'Seen', count: 3 },
        { icon: '🤚', label: 'Touched', count: 1 },
        { icon: '👃', label: 'Smelled', count: 0 },
        { icon: '👅', label: 'Tasted', count: 0 },
      ].map(s => `
        <div class="card card-sm">
          <div class="row">
            <span style="font-size:20px">${s.icon}</span>
            <span class="t-body-m flex-1">${s.label}</span>
            <span class="t-small">${s.count} time${s.count!==1?'s':''}</span>
            <div class="dots" style="margin-left:8px">
              ${[0,1,2,3,4].map(i => `<div class="dot ${i < s.count ? 'dot-on' : 'dot-off'}"></div>`).join('')}
            </div>
          </div>
        </div>
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
        <div class="card card-sm">
          <div class="row">
            <div class="icon-box bg-sage">${s.icon}</div>
            <div class="flex-1 col gap-xs">
              <span class="t-sub">${s.title}</span>
              <span class="t-small t-sage t-italic">${s.reward}</span>
            </div>
            <span style="color:var(--text-lt);font-size:18px">›</span>
          </div>
        </div>
      `).join('')}
    </div>`;
}

// ══════════════════════════════════════════════
// NAVIGATION
// ══════════════════════════════════════════════

function switchTab(index) {
  currentTab = index;
  currentOverlay = null;
  render();
}

function showOverlay(type, data) {
  currentOverlay = { type, data };
  render();
}

function hideOverlay() {
  currentOverlay = null;
  render();
}

function render() {
  const main = document.getElementById('main');
  const nav = document.getElementById('nav');

  if (currentOverlay) {
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
    // Update nav active state
    document.querySelectorAll('.nav-item').forEach((el, i) => {
      el.classList.toggle('active', i === currentTab);
    });
  }
  // Scroll to top on screen change
  window.scrollTo(0, 0);
}

// Init
document.addEventListener('DOMContentLoaded', render);
