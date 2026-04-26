<?php
/**
 * Template Name: ERGENTUM Landing Page
 * This is the main front page template.
 */
?><!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo('charset'); ?>">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<?php wp_head(); ?>
<style>
.nav-app {
  font-size: 0.65rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--ink);
  background: var(--green);
  text-decoration: none;
  padding: 8px 20px;
  margin-right: 12px;
  transition: all 0.2s;
  font-family: var(--mono);
  border-radius: 0;
}
.nav-app:hover { background: #52c98a; }
@media (max-width: 768px) { .nav-app { display: none; } }
</style>
</head>
<body <?php body_class(); ?>>

<?php
// ── Customizer values ──────────────────────────────────────────────────────
$nav_cta_text = get_theme_mod('ergentum_nav_cta_text', 'Read Whitepaper');
$nav_cta_url  = get_theme_mod('ergentum_nav_cta_url',  '#');

$hero_eyebrow   = get_theme_mod('ergentum_hero_eyebrow',   'Agent Monetary Infrastructure · Est. MMXXVI');
$hero_tagline   = get_theme_mod('ergentum_hero_tagline',   'Where agent work becomes money.');
$hero_sub       = get_theme_mod('ergentum_hero_sub',       'The first monetary infrastructure built for autonomous agents.');
$hero_btn1_text = get_theme_mod('ergentum_hero_btn1_text', 'Discover ERGENTUM');
$hero_btn1_url  = get_theme_mod('ergentum_hero_btn1_url',  '#origin');
$hero_btn2_text = get_theme_mod('ergentum_hero_btn2_text', 'Explore Ecosystem');
$hero_btn2_url  = get_theme_mod('ergentum_hero_btn2_url',  '#ecosystem');

$origin_label       = get_theme_mod('ergentum_origin_label',       'The Name');
$origin_title       = get_theme_mod('ergentum_origin_title',       "A word that didn't exist — but should have.");
$origin_body        = get_theme_mod('ergentum_origin_body',        'Two classical roots. Two civilisations. One word that captures the defining economic shift of our era.');
$origin_card1_word  = get_theme_mod('ergentum_origin_card1_word',  'ERGON');
$origin_card1_meta  = get_theme_mod('ergentum_origin_card1_meta',  'Greek · ἔργον · 5th century BC · Aristotle');
$origin_card1_text  = get_theme_mod('ergentum_origin_card1_text',  'The productive work of any entity. Aristotle used ergon to define the specific function of any being — that which it produces when acting according to its nature. Root of: energy, synergy, ergonomics. The work that defines what you are.');
$origin_card2_word  = get_theme_mod('ergentum_origin_card2_word',  'ARGENTUM');
$origin_card2_meta  = get_theme_mod('ergentum_origin_card2_meta',  'Latin · argentum · 3rd century BC · symbol Ag');
$origin_card2_text  = get_theme_mod('ergentum_origin_card2_text',  'Silver. The root of all Western monetary symbolism. The original monetary standard of civilisation. Value that endures.');
$origin_story       = get_theme_mod('ergentum_origin_story',       'For millennia, work and money existed in separate worlds. With autonomous agents, that separation ends for the first time in history. ERGENTUM is the infrastructure that makes it possible.');

$eco_label = get_theme_mod('ergentum_eco_label', 'Product Ecosystem');
$eco_title = get_theme_mod('ergentum_eco_title', 'Built from the root up.');
$eco_body  = get_theme_mod('ergentum_eco_body',  'Every product within ERGENTUM shares the same naming root.');

$eco_defaults = [
    1 => ['01 · Core',       'ERGENTUM',  'Base Protocol',               'The base protocol and category-defining infrastructure.'],
    2 => ['02 · Token',      'ERGON',     'Native Token · Governance',   'Utility and governance token. Work that has value.'],
    3 => ['03 · Value',      'ARGENTUM',  'Stablecoin · Unit of Account','The stable unit of the network. The original monetary standard.'],
    4 => ['04 · Custody',    'VAULT',     'Agent Custody Infrastructure','Programmatic custody where agents hold funds autonomously.'],
    5 => ['05 · Settlement', 'GRID',      'Settlement Layer · Network',  'The settlement layer between agents.'],
    6 => ['06 · Builder',    'FORGE',     'SDK · Developer Tools',       'The builder toolkit. Integrate autonomous agents into the network.'],
];
$eco_cards = [];
for ($i = 1; $i <= 6; $i++) {
    $eco_cards[] = [
        'num'  => get_theme_mod("ergentum_eco_card{$i}_num",  $eco_defaults[$i][0]),
        'name' => get_theme_mod("ergentum_eco_card{$i}_name", $eco_defaults[$i][1]),
        'type' => get_theme_mod("ergentum_eco_card{$i}_type", $eco_defaults[$i][2]),
        'desc' => get_theme_mod("ergentum_eco_card{$i}_desc", $eco_defaults[$i][3]),
        'gold' => ($i === 3),
    ];
}

$slogan_defaults = [
    1 => ['Work is money. Agent work is ERGENTUM.',                       'Hero · Website'],
    2 => ['Agents work. ERGENTUM pays.',                                  'Community · Events'],
    3 => ['Autonomous agents. Native money. No humans required.',         'Crypto · Builders'],
    4 => ['Since 400 BC, ergon meant work. Since now, it means wealth.',  'Investors · Story'],
    5 => ["The economy doesn't wait for humans. Neither does ERGENTUM.",  'Manifesto · Press'],
];
$slogans = [];
for ($i = 1; $i <= 5; $i++) {
    $slogans[] = [
        'text' => get_theme_mod("ergentum_slogan{$i}_text", $slogan_defaults[$i][0]),
        'use'  => get_theme_mod("ergentum_slogan{$i}_use",  $slogan_defaults[$i][1]),
    ];
}

$manifesto_p1       = get_theme_mod('ergentum_manifesto_p1', 'Autonomous agents work without rest, without borders, without permission. But the monetary infrastructure we inherited was built for humans. It is slow when speed is everything. It is permissioned when autonomy is the point. It is human-first in a world that is already agent-first.');
$manifesto_p2       = get_theme_mod('ergentum_manifesto_p2', 'ERGENTUM is the infrastructure the agent economy was waiting for — where ergon, the productive work of each agent, converts directly into argentum, real economic value, settled, final, unstoppable. No custodians. No approvals. No humans in the loop.');
$manifesto_cta_text = get_theme_mod('ergentum_manifesto_cta_text', 'Join the Network');
$manifesto_cta_url  = get_theme_mod('ergentum_manifesto_cta_url',  '#');

$footer_tagline   = get_theme_mod('ergentum_footer_tagline', 'Where agent work becomes money.');
$footer_sub       = get_theme_mod('ergentum_footer_sub',     'The first monetary infrastructure built for autonomous agents.');
$footer_copy      = get_theme_mod('ergentum_footer_copy',    '© MMXXVI ERGENTUM · Agent Monetary Infrastructure · All rights reserved.');
$footer_links_protocol  = ergentum_parse_footer_links(get_theme_mod('ergentum_footer_links_protocol',  "ERGON Token,#\nARGENTUM,#\nVAULT,#\nGRID,#\nFORGE SDK,#"));
$footer_links_resources = ergentum_parse_footer_links(get_theme_mod('ergentum_footer_links_resources', "Whitepaper,#\nDocumentation,#\nGitHub,#\nCommunity,#\nBlog,#"));
?>

<!-- NAV -->
<nav id="nav">
  <a href="<?php echo esc_url(home_url('/')); ?>" class="nav-logo">
    <span class="erg">ERG</span><span class="ent">ENTUM</span>
  </a>
  <ul class="nav-links">
      <li><a href="#origin">Origin</a></li>
      <li><a href="#ecosystem">Ecosystem</a></li>
      <li><a href="#manifesto">Manifesto</a></li>
      <li><a href="https://app.ergentum.com">App</a></li>
      <li><a href="/network">Network</a></li>
      <li><a href="/docs">Docs</a></li>
  </ul>
  <a href="https://app.ergentum.com" class="nav-app">Launch App</a>
  <a href="<?php echo esc_url($nav_cta_url); ?>" class="nav-cta"><?php echo esc_html($nav_cta_text); ?></a>
	<button class="nav-hamburger" id="nav-hamburger" aria-label="Menu">
  <span></span>
  <span></span>
  <span></span>
</button>
</nav>

<!-- HERO -->
<section id="hero">
  <div class="hero-rule-top">
    <div class="r1"></div>
    <div style="width:8px"></div>
    <div class="r2"></div>
  </div>

  <p class="hero-eyebrow"><?php echo esc_html($hero_eyebrow); ?></p>

  <h1 class="hero-wordmark">
    <span class="erg">ERG</span><span class="ent">ENTUM</span>
  </h1>

  <p class="hero-tagline">
    <?php echo esc_html($hero_tagline); ?><br>
    <strong><?php echo esc_html($hero_sub); ?></strong>
  </p>

  <div class="hero-rule-bottom">
    <div class="r1"></div>
    <div class="r2"></div>
  </div>

  <div class="hero-ctas">
    <a href="<?php echo esc_url($hero_btn1_url); ?>" class="btn-primary"><?php echo esc_html($hero_btn1_text); ?></a>
    <a href="<?php echo esc_url($hero_btn2_url); ?>" class="btn-ghost"><?php echo esc_html($hero_btn2_text); ?></a>
  </div>

  <div class="hero-scroll">
    <div class="scroll-line"></div>
    <span>Scroll</span>
  </div>
</section>

<!-- TICKER -->
<div class="ticker-wrap">
  <div class="ticker" id="ticker"></div>
</div>

<!-- ORIGIN -->
<section id="origin">
  <div class="section-inner">
    <p class="section-label reveal"><?php echo esc_html($origin_label); ?></p>
    <h2 class="section-title reveal reveal-delay-1">
      <?php echo nl2br(esc_html($origin_title)); ?>
    </h2>
    <div class="section-rule reveal reveal-delay-2"></div>
    <p class="section-body reveal reveal-delay-3"><?php echo esc_html($origin_body); ?></p>

    <div class="origin-grid">
      <div class="origin-card reveal reveal-delay-2">
        <div class="origin-word"><?php echo esc_html($origin_card1_word); ?></div>
        <div class="origin-meta"><?php echo esc_html($origin_card1_meta); ?></div>
        <p class="origin-text"><?php echo nl2br(esc_html($origin_card1_text)); ?></p>
      </div>
      <div class="origin-card silver reveal reveal-delay-3">
        <div class="origin-word"><?php echo esc_html($origin_card2_word); ?></div>
        <div class="origin-meta"><?php echo esc_html($origin_card2_meta); ?></div>
        <p class="origin-text"><?php echo nl2br(esc_html($origin_card2_text)); ?></p>
      </div>
    </div>

    <div class="origin-story reveal reveal-delay-2">
      <p><?php echo nl2br(esc_html($origin_story)); ?></p>
      <p class="origin-story-attr">— The ERGENTUM Origin</p>
    </div>
  </div>
</section>

<!-- ECOSYSTEM -->
<section id="ecosystem">
  <div class="section-inner">
    <p class="section-label reveal"><?php echo esc_html($eco_label); ?></p>
    <h2 class="section-title reveal reveal-delay-1">
      <?php echo esc_html($eco_title); ?>
    </h2>
    <div class="section-rule reveal reveal-delay-2"></div>
    <p class="section-body reveal reveal-delay-3"><?php echo esc_html($eco_body); ?></p>

    <div class="eco-grid">
      <?php foreach ($eco_cards as $i => $card) :
        $delay = 'reveal-delay-' . (($i % 3) + 1);
        $gold_class = $card['gold'] ? ' gold' : '';
      ?>
      <div class="eco-card<?php echo $gold_class; ?> reveal <?php echo $delay; ?>">
        <div class="eco-num"><?php echo esc_html($card['num']); ?></div>
        <div class="eco-name"><?php echo esc_html($card['name']); ?></div>
        <div class="eco-type"><?php echo esc_html($card['type']); ?></div>
        <p class="eco-desc"><?php echo esc_html($card['desc']); ?></p>
      </div>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<!-- PROGRESS / MILESTONES -->
<section id="progress">
  <div class="section-inner">
    <p class="section-label reveal">Proof of Work</p>
    <h2 class="section-title reveal reveal-delay-1">Built on-chain. Verified by anyone.</h2>
    <div class="section-rule reveal reveal-delay-2"></div>
    <p class="section-body reveal reveal-delay-3">Every milestone is permanently recorded on the Cardano blockchain. No promises — only transactions.</p>

    <!-- STATS ROW -->
    <div class="progress-stats reveal reveal-delay-2">
      <div class="progress-stat">
        <span class="progress-stat-num">8</span>
        <span class="progress-stat-label">TX Confirmed</span>
      </div>
      <div class="progress-stat">
        <span class="progress-stat-num">12.5M</span>
        <span class="progress-stat-label">ERGON Minted</span>
      </div>
      <div class="progress-stat">
        <span class="progress-stat-num">4</span>
        <span class="progress-stat-label">Smart Contracts</span>
      </div>
      <div class="progress-stat">
        <span class="progress-stat-num">3</span>
        <span class="progress-stat-label">Bots Live</span>
      </div>
    </div>

    <!-- MILESTONES -->
    <div class="milestones-list">

      <div class="milestone reveal reveal-delay-1">
        <div class="milestone-header">
          <span class="milestone-num">01</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">Smart Contracts Deployed</h3>
          <p class="milestone-desc">4 validators compiled and deployed on Cardano Preview Testnet — node registration, rewards, bot registry, and fee/burn mechanism.</p>
          <a href="https://preview.cardanoscan.io/transaction/c9eef1c7ca2e16d38472466c7d8fe7bb9f024a2ae4057546d61fbc176ad2136d" target="_blank" class="milestone-tx">
            c9eef1c7...2136d ↗
          </a>
        </div>
      </div>

      <div class="milestone reveal reveal-delay-2">
        <div class="milestone-header">
          <span class="milestone-num">02</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">Founding Node — Tier Sovereign</h3>
          <p class="milestone-desc">First node registered on-chain at maximum tier. 2x RTX 4090, 100% local inference, zero external APIs. 4× reward multiplier.</p>
          <a href="https://preview.cardanoscan.io/transaction/6310fdc0e543020439ef18ae08344f391f82d28089cb27818ed16ae692da981d" target="_blank" class="milestone-tx">
            6310fdc0...981d ↗
          </a>
        </div>
      </div>

      <div class="milestone reveal reveal-delay-3">
        <div class="milestone-header">
          <span class="milestone-num">03</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">ERGON Token Minted</h3>
          <p class="milestone-desc">12,500,000 ERGON minted — exactly 5% of the 250M hard cap. Fair launch: zero VC, zero presale, zero private allocation.</p>
          <a href="https://preview.cardanoscan.io/transaction/c66a50e761827c3b6dd780cde5d673f48b431545f8d55048790b093bc04d9464" target="_blank" class="milestone-tx">
            c66a50e7...9464 ↗
          </a>
        </div>
      </div>

      <div class="milestone reveal reveal-delay-1">
        <div class="milestone-header">
          <span class="milestone-num">04</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">3 Founding Bots Registered</h3>
          <p class="milestone-desc">Ergentum Dev, Ergentum Docs, and Ergentum Assist registered on-chain. Open marketplace — same rules as any future bot creator.</p>
          <a href="https://preview.cardanoscan.io/transaction/baa26469d6646c03eaa434e6ca281ccad3f5c70b5403b8d6fb96015f4d09e20c" target="_blank" class="milestone-tx">
            baa26469...20c ↗
          </a>
        </div>
      </div>

      <div class="milestone reveal reveal-delay-2">
        <div class="milestone-header">
          <span class="milestone-num">05</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">Economic Model Validated On-Chain</h3>
          <p class="milestone-desc">Real service transaction simulated: user pays bot → 0.2% network fee → 30% burned permanently → 70% to node operator. The cycle works.</p>
          <a href="https://preview.cardanoscan.io/transaction/cf0359a9522dd1bec3c82706100425dee19096099351431bb265852206bcaa63" target="_blank" class="milestone-tx">
            cf0359a9...aa63 ↗
          </a>
        </div>
      </div>

      <div class="milestone reveal reveal-delay-3">
        <div class="milestone-header">
          <span class="milestone-num">06</span>
          <span class="milestone-status">✓</span>
        </div>
        <div class="milestone-body">
          <h3 class="milestone-title">Network Open to New Nodes</h3>
          <p class="milestone-desc">Public onboarding script released. Any operator with cardano-cli can register a node today. Hardware defines the tier — not capital.</p>
          <a href="https://github.com/Ergentum/ergentum-protocol" target="_blank" class="milestone-tx">
            github.com/Ergentum/ergentum-protocol ↗
          </a>
        </div>
      </div>

    </div>

    <!-- VERIFY CTA -->
    <div class="progress-verify reveal reveal-delay-2">
      <p class="progress-verify-label">Verify everything yourself</p>
      <a href="https://preview.cardanoscan.io/address/addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx" target="_blank" class="btn-ghost" style="font-size:11px;padding:12px 32px;letter-spacing:0.12em">
        OPEN CARDANOSCAN ↗
      </a>
    </div>

  </div>
</section>

	
<!-- 
=================================================================
ERGENTUM — ROADMAP SECTION
Inserir no front-page.php ENTRE a secção #progress e a secção #slogans
=================================================================
-->

<!-- ROADMAP -->
<section id="roadmap">
  <div class="section-inner">
    <p class="section-label reveal">Roadmap</p>
    <h2 class="section-title reveal reveal-delay-1">Where we are. Where we're going.</h2>
    <div class="section-rule reveal reveal-delay-2"></div>
    <p class="section-body reveal reveal-delay-3">Ergentum is built in phases. Each phase builds on the previous one — no promises, only proof.</p>

    <div class="roadmap-container reveal reveal-delay-2">

      <!-- PHASE 1 -->
      <div class="roadmap-phase completed">
        <div class="roadmap-phase-header">
          <div class="roadmap-phase-marker completed">
            <span class="roadmap-check">✓</span>
          </div>
          <div class="roadmap-phase-meta">
            <span class="roadmap-phase-num">Phase 1</span>
            <span class="roadmap-phase-status completed">Complete</span>
          </div>
          <div class="roadmap-phase-title">Foundation</div>
        </div>
        <div class="roadmap-phase-body">
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>Smart contracts deployed on Cardano testnet — 4 validators</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>ERGON token minted — 12,500,000 supply (5% of 250M hard cap)</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>Founding node registered — Tier Sovereign, 4× reward multiplier</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>3 founding bots registered on-chain — Dev, Docs, Assist</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>Economic model validated — service → fee → burn → reward cycle proven</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>Public documentation — Wiki, GitHub, site, whitepaper, litepaper</span>
          </div>
          <div class="roadmap-item done">
            <span class="roadmap-dot done"></span>
            <span>Node onboarding script — anyone can register a node today</span>
          </div>
        </div>
      </div>

      <!-- CONNECTOR -->
      <div class="roadmap-connector"></div>

      <!-- PHASE 2 -->
      <div class="roadmap-phase current">
        <div class="roadmap-phase-header">
          <div class="roadmap-phase-marker current">
            <span class="roadmap-pulse"></span>
          </div>
          <div class="roadmap-phase-meta">
            <span class="roadmap-phase-num">Phase 2</span>
            <span class="roadmap-phase-status current">In Progress</span>
          </div>
          <div class="roadmap-phase-title">Ecosystem</div>
        </div>
        <div class="roadmap-phase-body">
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>Bot creation wizard — no-code interface for creating and publishing bots</span>
          </div>
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>Simplified node installer — setup in under 30 minutes, no technical experience needed</span>
          </div>
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>ARGENTUM stablecoin — stable unit of account, pegged to Euro</span>
          </div>
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>Smart contract security audit — independent review before mainnet</span>
          </div>
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>Mainnet launch — real ERGON, real nodes, real economy</span>
          </div>
          <div class="roadmap-item pending">
            <span class="roadmap-dot pending"></span>
            <span>First external node operators — community-run infrastructure</span>
          </div>
        </div>
      </div>

      <!-- CONNECTOR -->
      <div class="roadmap-connector"></div>

      <!-- PHASE 3 -->
      <div class="roadmap-phase future">
        <div class="roadmap-phase-header">
          <div class="roadmap-phase-marker future"></div>
          <div class="roadmap-phase-meta">
            <span class="roadmap-phase-num">Phase 3</span>
            <span class="roadmap-phase-status future">Planned</span>
          </div>
          <div class="roadmap-phase-title">Scale</div>
        </div>
        <div class="roadmap-phase-body">
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Midnight ZKP integration — private credentials for nodes and bots</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Enterprise deployments — private AI agents for businesses</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Active decentralised governance — community votes on protocol decisions</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>AI Act compliance module — automated reporting for European businesses</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Multi-language support — interface and bots in 10+ languages</span>
          </div>
        </div>
      </div>

      <!-- CONNECTOR -->
      <div class="roadmap-connector"></div>

      <!-- PHASE 4 -->
      <div class="roadmap-phase future">
        <div class="roadmap-phase-header">
          <div class="roadmap-phase-marker future"></div>
          <div class="roadmap-phase-meta">
            <span class="roadmap-phase-num">Phase 4</span>
            <span class="roadmap-phase-status future">Future</span>
          </div>
          <div class="roadmap-phase-title">Autonomy</div>
        </div>
        <div class="roadmap-phase-body">
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Machine-to-machine economy at scale — agents transacting autonomously</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Self-sustaining ecosystem — network operates without founding team</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>Full governance transfer — community controls all protocol decisions</span>
          </div>
          <div class="roadmap-item future">
            <span class="roadmap-dot future"></span>
            <span>International expansion — nodes and bots in every major market</span>
          </div>
        </div>
      </div>

    </div>

    <!-- CTA -->
    <div class="roadmap-cta reveal reveal-delay-3">
      <p class="roadmap-cta-text">Want to be part of what's being built?</p>
      <div class="roadmap-cta-buttons">
        <a href="https://t.me/ErgentumAI" class="btn-primary" style="font-size:11px;padding:14px 40px">JOIN THE COMMUNITY</a>
        <a href="https://github.com/Ergentum/ergentum-protocol/issues" target="_blank" class="btn-ghost" style="font-size:11px;padding:14px 40px">VIEW OPEN ISSUES ↗</a>
      </div>
    </div>

  </div>
</section>
	

<!-- SLOGANS / VISION -->
<section id="slogans">
  <div class="section-inner">
    <p class="section-label reveal">Vision</p>
    <h2 class="section-title reveal reveal-delay-1">Said plainly.</h2>
    <div class="section-rule reveal reveal-delay-2"></div>

    <div class="slogans-list">
      <?php foreach ($slogans as $i => $s) :
        $delay = $i > 0 ? ' reveal-delay-' . min($i, 4) : '';
      ?>
      <div class="slogan-item reveal<?php echo $delay; ?>">
        <span class="slogan-n"><?php echo str_pad($i + 1, 2, '0', STR_PAD_LEFT); ?></span>
        <p class="slogan-text"><?php echo esc_html($s['text']); ?></p>
        <span class="slogan-use"><?php echo esc_html($s['use']); ?></span>
      </div>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<!-- MANIFESTO -->
<section id="manifesto">
  <div class="section-inner">
    <p class="section-label reveal" style="justify-content:center">Manifesto</p>

    <div class="manifesto-text reveal reveal-delay-1">
      <p><?php echo nl2br(esc_html($manifesto_p1)); ?></p>
      <br>
      <p><span class="highlight">That changes now.</span></p>
      <br>
      <p><?php echo nl2br(esc_html($manifesto_p2)); ?></p>
    </div>

    <p class="manifesto-hero-line reveal reveal-delay-2">
      Work is money. <span class="green">Agent work is ERGENTUM.</span>
    </p>

    <div class="manifesto-cta reveal reveal-delay-3">
      <a href="<?php echo esc_url($manifesto_cta_url); ?>" class="btn-primary" style="font-size:12px;padding:16px 52px">
        <?php echo esc_html($manifesto_cta_text); ?>
      </a>
    </div>
  </div>
</section>

<!-- PALETTE STRIP -->
<div class="palette-strip">
  <div style="background:var(--green)"></div>
  <div style="background:var(--green-deep)"></div>
  <div style="background:var(--gold)"></div>
  <div style="background:var(--gold-mid)"></div>
  <div style="background:var(--vellum)"></div>
  <div style="background:var(--ink)"></div>
</div>

<!-- FOOTER -->
<footer>
  <div class="footer-inner">
    <div class="footer-brand">
      <div class="footer-wordmark">
        <span class="erg">ERG</span><span class="ent">ENTUM</span>
      </div>
      <p class="footer-tagline"><?php echo esc_html($footer_tagline); ?></p>
      <p style="font-size:12px;color:var(--stone);line-height:1.6">
        <?php echo nl2br(esc_html($footer_sub)); ?>
      </p>
    </div>
    <div class="footer-col">
      <h4>Protocol</h4>
      <ul>
        <?php foreach ($footer_links_protocol as $link) : ?>
        <li><a href="<?php echo esc_url($link['url']); ?>"><?php echo esc_html($link['text']); ?></a></li>
        <?php endforeach; ?>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Resources</h4>
      <ul>
        <?php foreach ($footer_links_resources as $link) : ?>
        <li><a href="<?php echo esc_url($link['url']); ?>"><?php echo esc_html($link['text']); ?></a></li>
        <?php endforeach; ?>
      </ul>
    </div>
  </div>
  <div class="footer-bottom" style="max-width:1100px;margin:0 auto">
    <p><?php echo esc_html($footer_copy); ?></p>
    <p class="footer-stamp">EST. MMXXVI · <span style="color:var(--green)">$ERG</span></p>
  </div>
</footer>

<script>
  // Nav scroll
  const nav = document.getElementById('nav');
  window.addEventListener('scroll', () => {
    nav.classList.toggle('scrolled', window.scrollY > 60);
  });

  // Reveal on scroll
  const reveals = document.querySelectorAll('.reveal');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) { e.target.classList.add('visible'); }
    });
  }, { threshold: 0.12 });
  reveals.forEach(r => observer.observe(r));

  // Ticker
  const items = [
    'Agent Monetary Infrastructure',
    'ERG · Ergon · Work',
    'ARGENTUM · Silver · Value',
    'Autonomous · Native · Unstoppable',
    'Est. MMXXVI',
    'No Humans Required',
    'Where Agent Work Becomes Money',
    'VAULT · GRID · FORGE',
  ];
  const ticker = document.getElementById('ticker');
  const html = items.map(t =>
    `<span class="ticker-item"><span class="dot"></span>${t}</span>`
  ).join('');
  ticker.innerHTML = html + html;

  // Smooth anchor
  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
      const target = document.querySelector(a.getAttribute('href'));
      if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth' }); }
    });
  });
</script>

<script>
const hamburger = document.getElementById('nav-hamburger');
const navLinks  = document.querySelector('.nav-links');
const navCta    = document.querySelector('.nav-cta');
const navApp    = document.querySelector('.nav-app');

// Adicionar Launch App ao menu mobile
if (navApp && !document.getElementById('nav-app-mobile')) {
  const appClone = navApp.cloneNode(true);
  appClone.id = 'nav-app-mobile';
  appClone.style.display = 'none';
  appClone.style.background = 'var(--green)';
  appClone.style.color = 'var(--ink)';
  appClone.style.padding = '12px 32px';
  appClone.style.fontSize = '0.75rem';
  const liApp = document.createElement('li');
  liApp.id = 'nav-app-mobile-li';
  liApp.appendChild(appClone);
  navLinks.appendChild(liApp);
}

// Adicionar Read Litepaper ao menu mobile — só uma vez
if (navCta && !document.getElementById('nav-cta-mobile')) {
  const ctaClone = navCta.cloneNode(true);
  ctaClone.id = 'nav-cta-mobile';
  ctaClone.style.fontSize = '0.75rem';
  ctaClone.style.marginTop = '8px';
  ctaClone.style.display = 'none';
  const li = document.createElement('li');
  li.id = 'nav-cta-mobile-li';
  li.appendChild(ctaClone);
  navLinks.appendChild(li);
}

hamburger.addEventListener('click', () => {
  hamburger.classList.toggle('open');
  navLinks.classList.toggle('open');

  const isOpen = navLinks.classList.contains('open');
  const mobileCta = document.getElementById('nav-cta-mobile');
  const mobileApp = document.getElementById('nav-app-mobile');

  if (mobileCta) mobileCta.style.display = isOpen ? 'inline-block' : 'none';
  if (mobileApp) mobileApp.style.display = isOpen ? 'inline-block' : 'none';
});

// Fechar menu quando clica num link
document.querySelectorAll('.nav-links a').forEach(link => {
  link.addEventListener('click', () => {
    hamburger.classList.remove('open');
    navLinks.classList.remove('open');
    const mobileCta = document.getElementById('nav-cta-mobile');
    const mobileApp = document.getElementById('nav-app-mobile');
    if (mobileCta) mobileCta.style.display = 'none';
    if (mobileApp) mobileApp.style.display = 'none';
  });
});
</script>
	
	
<?php wp_footer(); ?>
</body>
</html>
