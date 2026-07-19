/// [NewsArticle] represents a short-form news card containing structured facts.
/// Use this model for rendering card components in the feed, search results, and bookmarks.
class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String body;
  final String category;
  final String imageUrl;
  final String? videoUrl;
  final String source;
  final String timestamp;
  final int readTimeMinutes;
  final String sourceUrl;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.imageUrl,
    this.videoUrl,
    required this.source,
    required this.timestamp,
    required this.readTimeMinutes,
    this.sourceUrl = 'https://news.google.com',
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
}

// Global list of mock news articles for the FactShot prototype.
final List<NewsArticle> mockArticles = [
  const NewsArticle(
    id: 'art-1',
    category: 'TECH',
    title: 'Quantum Leap: Silicon Spin-Qubit Computer Achieves 99.9% Fidelity',
    summary:
        'A team of researchers has successfully operated silicon-based spin-qubits with over 99.9% gate fidelity, breaching the critical threshold required for fault-tolerant quantum error correction. This breakthrough paves the path for scaling up quantum processors using standard commercial semiconductor manufacturing pipelines, promising commercial quantum utility within this decade.',
    body:
        'Quantum computing has taken a massive step toward commercial viability. By achieving 99.9% gate fidelity using silicon spin-qubits, researchers have successfully cleared the error-rate hurdle that has stalled quantum progress for years.\n\nThe research, published in Nature, demonstrates that standard silicon wafers can be used to fabricate stable quantum dots. These dots house electron spins that act as qubits. Since they use existing CMOS manufacturing lines, scaling from tens of qubits to millions is suddenly a hardware engineering problem rather than a theoretical physics one.\n\nTech companies are already lining up to license the technology. The implications are profound, ranging from rapid drug discovery to breaking modern cryptographic standards. Quantum error correction requires thousands of physical qubits to create a single logical qubit, and silicon spin-qubits are currently the most compact option available.',
    imageUrl:
        'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=800',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    source: 'TechCrunch',
    timestamp: '12m ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://techcrunch.com',
  ),
  const NewsArticle(
    id: 'art-2',
    category: 'INDIA',
    title: 'ISRO Unveils Gaganyaan-2 Lunar Orbital Mission Targets for 2028',
    summary:
        'The Indian Space Research Organisation (ISRO) has officially detailed targets for the Gaganyaan-2 mission. Slated for 2028, the mission will launch a crewed orbiter to perform advanced research around the moon. ISRO confirmed the launch vehicles are being upgraded with semi-cryogenic engines, reinforcing India’s active stance in deep-space exploration.',
    body:
        'ISRO has announced its next major milestone: the Gaganyaan-2 mission. Following the success of Chandrayaan-3 and the upcoming crewed Earth orbit test, Gaganyaan-2 aims to send three Indian astronauts into lunar orbit by 2028.\n\nSpeaking at a space summit, the ISRO Chairman detailed that the spacecraft will spend 14 days orbiting the moon at an altitude of 100 kilometers. The mission will test life-support systems in deep space, radiation shielding, and autonomous return navigation.\n\nUpgrades to the Launch Vehicle Mark 3 (LVM3) are already underway. A new semi-cryogenic engine will replace the current liquid stage to provide the necessary thrust. The development represents a collaborative effort with multiple private Indian aerospace firms, showcasing India\'s rapidly maturing commercial space ecosystem.',
    imageUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=800',
    source: 'The Hindu',
    timestamp: '1h ago',
    readTimeMinutes: 4,
    sourceUrl: 'https://www.thehindu.com',
  ),
  const NewsArticle(
    id: 'art-3',
    category: 'BUSINESS',
    title:
        'Global Energy Transition: Wind & Solar Surpass Coal Power Generation',
    summary:
        'For the first time in history, the combined electricity generated globally from wind and solar infrastructure has eclipsed coal power generation. Renewable capacity added over 500 gigawatts last year, driven by policy shifts in Europe and rapid infrastructure scale-ups across Asia, marking a historic turning point in the global decarbonization timeline.',
    body:
        'The global energy landscape has reached a monumental tipping point. Wind and solar power collectively generated more electricity than coal in the last fiscal year, a milestone once thought to be decades away.\n\nAccording to the International Energy Agency (IEA), solar photovoltaic installations accounted for nearly 70% of all new power generation capacity. Massive grid connections in China and aggressive offshore wind projects in Northern Europe spearheaded the surge.\n\nEconomically, renewable projects are now cheaper to build and operate than fossil-fuel counterparts in most major markets. Financial analysts predict a accelerated divestment from coal assets, forcing utility firms to speed up transition schedules. However, grid storage and transmission line bottlenecks remain critical challenges to address before reaching complete grid decarbonization.',
    imageUrl:
        'https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&q=80&w=800',
    source: 'Bloomberg',
    timestamp: '3h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.bloomberg.com',
  ),
  const NewsArticle(
    id: 'art-4',
    category: 'SPORTS',
    title:
        'Sensational Finish: 18-Year-Old Prodigy Secures Chess Candidates Victory',
    summary:
        'In an unprecedented final round, an 18-year-old chess grandmaster has clinched the Candidates Tournament, becoming the youngest challenger in history for the World Chess Championship. Capitalizing on a late-game positional error by the top-seeded opponent, the prodigy secured the win with precise endgame execution, rewriting chess history books.',
    body:
        'An extraordinary chapter in chess history has been written. At just 18 years of age, the young grandmaster dominated a field of seasoned veterans to win the Candidates Tournament, earning the right to challenge the reigning World Champion.\n\nThe final game was a masterclass in psychological resilience. Needing a win with black pieces, the prodigy chose a sharp, double-edged opening. When the top seed miscalculated a tactical knight retreat on move 37, the challenger seized the initiative, converting a complex endgame with clinical accuracy.\n\nGrandmasters worldwide have praised the performance, noting the prodigy\'s mature defensive style and tactical speed. The upcoming championship match is already being billed as a classic battle of generations.',
    imageUrl:
        'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?auto=format&fit=crop&q=80&w=800',
    source: 'ESPN Sports',
    timestamp: '5h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.espn.com',
  ),
  const NewsArticle(
    id: 'art-5',
    category: 'ENTERTAINMENT',
    title: 'Cinematic Revival: Indie Sci-Fi Sweep Sweeps Golden Globe Awards',
    summary:
        'A micro-budget independent science-fiction film, created using virtual production volumes and custom neural styling filters, has clean swept the Golden Globe Awards, taking home Best Picture and Best Director. The victory highlights a growing disruption in traditional Hollywood studio dominance, proving technology democratizes cinema.',
    body:
        'The film industry has been shaken by the overwhelming success of a micro-budget indie film at the Golden Globe Awards. Winning five major categories, the project bypassed traditional studio distribution, launching directly to streaming platforms.\n\nFilmed entirely inside a custom virtual studio setup, the creators utilized artificial intelligence tools to render hyper-realistic alien landscapes on a budget of under \$2 million. Critics have lauded the storytelling for its depth, contrasting the visual grandeur with intimate, character-driven subplots.\n\nStudio executives are acknowledging this as a watershed moment. The democratizing effect of high-fidelity rendering software means independent filmmakers can now compete with major blockbusters on visual scales, shifting the industry focus back to original screenplays and innovative concepts.',
    imageUrl:
        'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&q=80&w=800',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    source: 'Variety',
    timestamp: '6h ago',
    readTimeMinutes: 4,
    sourceUrl: 'https://variety.com',
  ),
  const NewsArticle(
    id: 'art-6',
    category: 'TECH',
    title: 'Apple Glasses Air: Next-Gen AR Wearables Redefine Spatial OS',
    summary:
        'Apple has unveiled the "Glasses Air," a lightweight augmented reality eyewear weighing just 75 grams. Equipped with miniature micro-LED displays and a dual-chip custom R3 silicon architecture, the Glasses Air projects spatial computing interfaces directly into the user’s line of sight, featuring hand-gesture controls and eye-tracking navigation.',
    body:
        'Apple has officially entered the mainstream augmented reality market with Glasses Air. Pushing the boundaries of miniaturization, these glasses look like standard designer frames but contain high-resolution micro-LED projection displays.\n\nRunning on a brand-new iteration of visionOS, the glasses connect wirelessly to a companion iPhone or Mac to offload heavy rendering tasks. The glasses themselves house the new R3 spatial chip, which handles real-time mapping, hand tracking, and eye detection with zero latency.\n\nDevelopers are already building apps for the system, from real-time directions mapped onto streets to virtual screens hovering above workstations. With a starting price of \$799, Apple intends to make spatial computing accessible to everyday consumers.',
    imageUrl:
        'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?auto=format&fit=crop&q=80&w=800',
    source: '9to5Mac',
    timestamp: '8h ago',
    readTimeMinutes: 2,
    sourceUrl: 'https://9to5mac.com',
  ),
  const NewsArticle(
    id: 'art-7',
    category: 'INDIA',
    title: 'Mumbai Coastal Road Project Phase 2 Officially Opens to Traffic',
    summary:
        'The second phase of the ambitious Mumbai Coastal Road project, featuring a 4.5-kilometer undersea twin tunnel, has officially opened, cutting travel times between South Mumbai and Western suburbs by 70%. Built using advanced trenchless boring machines, the project resolves heavy gridlocks and integrates automated traffic monitoring systems.',
    body:
        'Commuters in Mumbai received a major upgrade today as Phase 2 of the Coastal Road project became active. The project promises to revolutionize travel inside India\'s financial capital.\n\nThe highlight of the project is the undersea tunnel, which dips beneath the Arabian Sea. It features advanced safety systems, including fire-suppressant materials, emergency evacuation shafts, and real-time air quality sensors. Traffic is managed by a centralized AI control room that adjusts speed limits based on vehicle density.\n\nUrban planners note that the project sets a new benchmark for infrastructure development in dense coastal cities, proving that ecological mitigation and infrastructure expansion can coexist.',
    imageUrl:
        'https://images.unsplash.com/photo-1566837945700-30057527ade0?auto=format&fit=crop&q=80&w=800',
    source: 'Times of India',
    timestamp: '12h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://timesofindia.indiatimes.com',
  ),
  const NewsArticle(
    id: 'art-8',
    category: 'BUSINESS',
    title: 'EV Market Shift: Hybrid Car Sales Surge 45% as Pure EVs Plateau',
    summary:
        'Global automotive reports indicate a significant pivot in consumer preferences, with hybrid and plug-in hybrid vehicle sales growing 45% year-on-year. While pure battery-electric vehicle sales experienced plateauing demand due to charging infrastructure anxieties, hybrids emerged as the dominant transitional choice for mass-market buyers.',
    body:
        'The electric vehicle revolution is taking a practical detour. While initial forecasts predicted pure electric vehicles would dominate sales by 2026, recent registration data reveals a massive consumer surge toward hybrid systems.\n\nBuyers cite range anxiety, high replacement battery costs, and a lack of public charging stations as reasons for selecting hybrids. Automobile giants are responding by reallocating budgets, delaying pure-EV models to double-down on advanced hybrid platforms.\n\nAnalysts claim this shift is beneficial for overall emissions reductions in the short term, as hybrids represent a more immediate, affordable upgrade for average households. However, governments are debating whether to adjust their long-term fossil-fuel bans to accommodate the hybrid surge.',
    imageUrl:
        'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&q=80&w=800',
    source: 'Reuters',
    timestamp: '1d ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.reuters.com',
  ),
  const NewsArticle(
    id: 'art-9',
    category: 'SCIENCE',
    title: 'James Webb Telescope Detects Atmospheric Water on Rocky Exoplanet',
    summary:
        'Astronomers using the James Webb Space Telescope have confirmed the presence of water vapor in the atmosphere of a rocky exoplanet orbiting a red dwarf star in the habitable zone. This represents the first time atmospheric signatures have been detected on a rocky world outside our solar system, marking a massive leap forward in the search for extraterrestrial life.',
    body:
        'Astronomers using the James Webb Space Telescope (JWST) have made a historic discovery: detecting water vapor in the atmosphere of a distant, rocky exoplanet. Named GJ 486 b, the planet orbits a red dwarf star located 26 light-years away in the constellation Virgo.\n\nWhile GJ 486 b is too hot for liquid water, its surface temperature being roughly 430 degrees Celsius, the presence of an atmosphere containing water vapor on a rocky planet in a red dwarf system is a crucial milestone. Red dwarf stars are the most common type of star in the universe, but they are also highly active, often unleashing powerful flares that can strip away exoplanetary atmospheres.\n\nUsing JWST\'s Near-Infrared Spectrograph, the researchers observed the planet during two transits. The detection suggests that rocky planets orbiting active red dwarfs can indeed maintain atmospheres, keeping the dream of finding habitable worlds in such systems alive.',
    imageUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=800',
    source: 'NASA Spaceflight',
    timestamp: '1d ago',
    readTimeMinutes: 4,
    sourceUrl: 'https://www.nasa.gov',
  ),
  const NewsArticle(
    id: 'art-10',
    category: 'HISTORY',
    title: 'Lost Bronze Age City Discovered Beneath the Aegean Sea',
    summary:
        'Marine archaeologists have uncovered the ruins of a sprawling Bronze Age city submerged off the coast of Greece. The site, dating back to approximately 2500 BCE, features intact stone foundations, paved roadways, and hundreds of clay storage vessels. The discovery promises to reshape our understanding of early Mediterranean trade networks and maritime civilizations.',
    body:
        'A team of international marine archaeologists has announced the discovery of a massive, submerged Bronze Age settlement in the Aegean Sea. Located off the coast of the Greek island of Hydra, the site spans over 12 acres at a depth of 3 to 10 meters.\n\nUsing side-scan sonar and underwater photogrammetry, the team mapped out stone foundations of buildings, fortified walls, and paved streets. They also retrieved hundreds of clay pottery shards, including large amphorae used for storing olive oil and wine, suggesting the city was a thriving commercial port.\n\nResearchers believe the city was flooded around 1500 BCE due to tectonic activity or rising sea levels. The discovery provides invaluable data on Bronze Age maritime commerce and engineering, offering a rare glimpse into a civilization that existed at the dawn of European history.',
    imageUrl:
        'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?auto=format&fit=crop&q=80&w=800',
    source: 'Nat Geo',
    timestamp: '2d ago',
    readTimeMinutes: 5,
    sourceUrl: 'https://www.nationalgeographic.com',
  ),
];
