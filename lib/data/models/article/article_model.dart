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

final List<NewsArticle> mockArticles = [
  const NewsArticle(
    id: 'art-breaking-0',
    category: 'BREAKING',
    title: 'Air India to Test All Pilots for Banned Substances After Incident',
    summary:
        'Following a serious mid-air incident where a flight from Phuket to New Delhi suddenly lost altitude, Air India has mandated a comprehensive drug screening for all its pilots. A pilot-in-command from the incident flight subsequently tested positive for marijuana. Air India stated that while they already comply with all safety regulations, they chose to go further to restore passenger trust immediately.',
    body:
        'Air India has announced that it will conduct mandatory drug and banned substance tests for all pilots across the group. This proactive safety sweep follows an alarming incident on flight AI 2379 traveling from Phuket to New Delhi last week, during which the aircraft experienced a sudden loss of altitude, causing panic and minor injuries to several passengers.\n\nA subsequent investigation led to a confirmatory drug test for the flight\'s pilot-in-command, which came back positive for marijuana. The pilot has since been suspended, and civil aviation regulators are conducting a thorough probe.\n\nIn a memo to employees, Air India\'s management emphasized that safety is the airline\'s highest priority. While the airline has always fully complied with the mandatory pre-flight and post-flight breathalyzer checks mandated by the Directorate General of Civil Aviation (DGCA), this new drug testing policy represents a voluntary safety standard to guarantee a high level of professionalism and regain customer confidence.',
    imageUrl:
        'https://ichef.bbci.co.uk/news/1024/branded_news/bc16/live/c940eb70-9732-11f1-bdbf-1b7b2a4a87a1.jpg',
    source: 'BBC News',
    timestamp: '1m ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.bbc.com/news/articles/c2352jyvm5xo',
  ),
  const NewsArticle(
    id: 'art-breaking-1',
    category: 'BREAKING',
    title: 'Breaking: Superconductor Achieves Ambient Temperature and Pressure',
    summary:
        'In a stunning scientific breakthrough, researchers have successfully synthesized a new materials matrix that exhibits superconductivity at room temperature and ambient atmospheric pressure. The findings, verified by multiple independent testing laboratories, could revolutionize energy transmission, quantum computing, and electric transportation. The lead-apatite structure enables loss-less power grids and compact fusion reactor designs globally.',
    body:
        'In a stunning scientific breakthrough, researchers have synthesized a new materials matrix that exhibits superconductivity at room temperature and ambient atmospheric pressure. The findings, verified by multiple independent testing laboratories, could revolutionize energy transmission, quantum computing, and electric transportation.\n\nThe material, designated LK-99-Prime, is a modified lead-apatite structure doped with custom transition metal clusters. Previous attempts at room-temperature superconductivity required pressures equivalent to those near the Earth\'s core. The new synthesis protocol, however, enables superconductivity at 21 degrees Celsius and 1 atm.\n\nIndustrial consortia are already organizing to scale up manufacturing, with immediate targets in lossless power grids and compact fusion reactor magnets.',
    imageUrl:
        'https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&q=80&w=800',
    source: 'Nature News',
    timestamp: '1m ago',
    readTimeMinutes: 2,
    sourceUrl: 'https://www.nature.com',
  ),
  const NewsArticle(
    id: 'art-trending-1',
    category: 'TRENDING',
    title: 'Trending: Electric Flight Milestone Reached with New Solid-State Battery',
    summary:
        'A leading aerospace startup has successfully completed a five-hundred-mile crewed flight of its vertical takeoff aircraft utilizing a groundbreaking solid-state lithium-metal battery pack. The flight demonstrates the near-term viability of carbon-free regional aviation, generating viral interest on social platforms. The battery achieves high density, proving to be the catalyst for electric aviation.',
    body:
        'A leading aerospace startup has successfully completed a 500-mile crewed flight of its vertical takeoff aircraft utilizing a groundbreaking solid-state lithium-metal battery pack. The flight demonstrates the viability of carbon-free regional aviation, generating viral interest on social platforms.\n\nThe battery pack, developed in collaboration with energy research labs, achieves an energy density of 550 Wh/kg—nearly double that of conventional lithium-ion batteries. During the flight, the aircraft maintained an average cruise speed of 175 mph and landed with 15% charge capacity remaining.\n\nTechnological progress in battery chemistry has historically been slow, but solid-state configurations are proving to be the catalyst that could electrify flight sooner than expected.',
    imageUrl:
        'https://images.unsplash.com/photo-1540962351504-03099e0a754b?auto=format&fit=crop&q=80&w=800',
    source: 'Wired',
    timestamp: '5m ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.wired.com',
  ),
  const NewsArticle(
    id: 'art-fore',
    category: 'BUSINESS',
    title:
        'Grow your career without taking a break : FORE School of Management',
    summary:
        'Stay ahead in a rapidly evolving business world with the FORE School of Management AICTE-approved PGDM program for working professionals, offered in collaboration with the Frankfurt School of Finance and Management. This comprehensive eighteen-month course combines artificial intelligence, business analytics, global faculty, and industry-standard certifications with flexible evening or weekend classes to accelerate career growth.',
    body:
        'Stay ahead in rapidly evolving business world with FORE School of Management AICTE approved PGDM for working profession, in collaboration with Frankfurt School of Finance and Management. The 18 month course combines AI & analytics, global faculty & industry certifications with flexible evening/weekend classes to aid career growth. Visit www.fsmac.in or email admission@fsm.ac.in for details.',
    imageUrl:
        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&q=80&w=800',
    source: 'FORE School',
    timestamp: 'Just now',
    readTimeMinutes: 1,
    sourceUrl: 'https://www.fsmac.in',
  ),
  const NewsArticle(
    id: 'art-11',
    category: 'INDIA',
    title: 'Bar Council of India Threatens NALSAR Students, Cockroach Janta Party Roars, Order is Withdrawn',
    summary:
        'The Bar Council of India (BCI) threatened to withhold the advocate enrollment of NALSAR University of Law\'s 2026 graduating batch following a student campaign opposing Chief Justice Surya Kant as their convocation guest. The BCI quickly withdrew the order after facing immense backlash and threat of protests by student groups led by the satirical Cockroach Janta Party, resolving the conflict within hours.',
    body:
        'In a dramatic turn of events, the Bar Council of India (BCI) has withdrawn its controversial order that threatened to freeze the advocate enrollment of NALSAR University of Law\'s 2026 graduating class.\n\nThe initial BCI directive ordered state bar councils not to enroll NALSAR graduates until further notice, and demanded the university identify the students behind a campaign opposing the invitation of Chief Justice Surya Kant as the convocation chief guest. Critics and NALSAR students strongly condemned the move as an illegal act of collective punishment.\n\nFollowing the order, Abhijeet Dipke, founder of the satirical Cockroach Janta Party (CJP), reacted on social media by posting, "What if all legal cockroaches come together?"—referencing an earlier controversy. Faced with escalating backlash, potential legal challenges, and threats of protests, the BCI retracted the order just hours after issuing it, restoring normal enrollment eligibility for the graduating batch.',
    imageUrl:
        'https://assets.telegraphindia.com/telegraph/2026/Aug/1786636636_cjp-foces-bar-council-of-india-retreat.jpg',
    source: 'Telegraph India',
    timestamp: '1m ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.telegraphindia.com',
  ),
  const NewsArticle(
    id: 'art-12',
    category: 'INDIA',
    title: 'Punjab Former Deputy CM Sukhbir Singh Badal Attacked in Gurdwara',
    summary:
        'Former Punjab deputy chief minister Sukhbir Singh Badal was attacked by an unidentified assailant inside the historical Nanded Gurdwara premises in Maharashtra. The Akali Dal president suffered minor injuries and was rushed to the hospital. Chief Minister Devendra Fadnavis immediately ordered a high-level inquiry to investigate the security breach and arrest the conspirators behind this political incident.',
    body:
        'Shiromani Akali Dal president and former Punjab deputy chief minister Sukhbir Singh Badal was attacked by an unidentified assailant inside a gurdwara premises in Nanded, Maharashtra. The incident occurred during his visit to the historical Sikh shrine, causing immediate security concerns.\n\nFollowing the attack, security personnel rushed Badal to the hospital for treatment of minor injuries. Maharashtra Chief Minister Devendra Fadnavis immediately ordered a high-level inquiry to investigate the security breach and capture the conspirators. Political leaders across party lines have condemned the act, calling it a grave threat to democratic safety and public peace.',
    imageUrl:
        'https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80&w=800',
    source: 'Telegraph India',
    timestamp: '30m ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.telegraphindia.com',
  ),
  const NewsArticle(
    id: 'art-13',
    category: 'INDIA',
    title: 'Heavy Rain in Odisha Triggers Flood Alerts; IMD Issues Red Warning',
    summary:
        'Torrential rains triggered by a deep weather depression in the Bay of Bengal have swamped multiple districts in Odisha, raising severe flood concerns in low-lying residential areas. The India Meteorological Department (IMD) has issued a Red Alert for several coastal regions. Emergency disaster response teams are actively executing evacuation drives and setting up temporary relief shelters.',
    body:
        'A deep weather depression centered over the Bay of Bengal has brought relentless rainfall across major parts of Odisha, escalating fears of widespread flooding. Low-lying urban areas and agricultural sectors have been submerged, disrupting daily traffic and power grids.\n\nThe India Meteorological Department (IMD) has issued a Red Alert for several coastal and southern districts, warning citizens of heavy to extremely heavy downpours. Rescue teams and disaster response forces have been deployed to high-risk zones, and district administrations are setting up temporary shelter camps to evacuate residents from vulnerable river banks.',
    imageUrl:
        'https://images.unsplash.com/photo-1545087883-bd82593d6b52?auto=format&fit=crop&q=80&w=800',
    source: 'Telegraph India',
    timestamp: '1h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.telegraphindia.com',
  ),
  const NewsArticle(
    id: 'art-14',
    category: 'INDIA',
    title: 'Parliament Adjourned Amid Clashes Over Protests and Temple Donations',
    summary:
        'Both houses of Parliament, the Lok Sabha and Rajya Sabha, were adjourned sine die following persistent disruptions and loud slogans. Members of the ruling NDA coalition and the opposition INDIA bloc clashed intensely over recent student protests in Jharkhand and controversial temple donations. The speaker concluded the session prematurely due to the continuous uproar from both sides.',
    body:
        'Proceedings in both houses of Parliament were adjourned sine die today after facing persistent disruptions. Members of the ruling NDA and the opposition INDIA bloc clashed over recent student agitation protests in Jharkhand and issues surrounding religious temple donations.\n\nOpposition leaders demanded a structured debate on public grievances and student welfare in Jharkhand, while treasury benches defended state policy and raised counter-allegations. Despite attempts by the speaker to restore order, continuous sloganeering and paper-tearing led to the final adjournment, concluding the session with unresolved legislative items.',
    imageUrl:
        'https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80&w=800',
    source: 'Telegraph India',
    timestamp: '2h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.telegraphindia.com',
  ),
  const NewsArticle(
    id: 'art-15',
    category: 'BUSINESS',
    title: 'Waterlogging at Noida Airport Triggers Allegations of Construction Graft',
    summary:
        'A single spell of heavy monsoon rainfall caused severe waterlogging and swamped runways at the under-construction Noida International Airport site. Opposition parties quickly launched political attacks against the government, raising serious allegations of financial graft and sub-standard construction audits. Airport authorities clarified that drainage systems are still incomplete and mitigation pumping is currently underway.',
    body:
        'The under-construction Noida International Airport site became swamped following a single spell of heavy rainfall, triggering sharp political reactions. Images of submerged runways and waterlogged terminals circulated on social media, drawing criticism from transport analysts and opposition leaders.\n\nOpposition spokespersons have alleged financial graft and sub-standard construction audits, demanding a judicial probe into the contractors and developers. Airport authorities issued a statement clarifying that the drainage system is still under construction and remedial water-pumping measures have been deployed to clear the airfield.',
    imageUrl:
        'https://images.unsplash.com/photo-1541348263662-e0c8643c21ee?auto=format&fit=crop&q=80&w=800',
    source: 'Telegraph India',
    timestamp: '4h ago',
    readTimeMinutes: 3,
    sourceUrl: 'https://www.telegraphindia.com',
  ),
  const NewsArticle(
    id: 'art-1',
    category: 'TECH',
    title: 'Quantum Leap: Silicon Spin-Qubit Computer Achieves 99.9% Fidelity',
    summary:
        'A research team has successfully operated silicon-based spin-qubits with over 99.9% gate fidelity, breaching the critical threshold required for fault-tolerant quantum error correction. Published in Nature, this historic breakthrough paves the path for scaling up quantum processors using standard commercial semiconductor manufacturing pipelines, which promises to bring commercial quantum utility and advanced cryptographic security closer within this decade.',
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
        'The Indian Space Research Organisation (ISRO) has officially detailed targets for the Gaganyaan-2 mission. Slated for 2028, this space flight will launch a crewed orbiter to perform advanced scientific research around the moon. ISRO confirmed the launch vehicles are being upgraded with semi-cryogenic engines, reinforcing India’s active stance in deep-space exploration and preparing for future crewed landings.',
    body:
        'ISRO has announced its next major milestone: the Gaganyaan-2 mission. Following the success of Chandrayaan-3 and the upcoming crewed Earth orbit test, Gaganyaan-2 aims to send three Indian astronauts into lunar orbit by 2028.\n\nSpeaking at a space summit, the ISRO Chairman detailed that the spacecraft will spend 14 days orbiting the moon at an altitude of 100 kilometers. The mission will test life-support systems in deep space, radiation shielding, and autonomous return navigation.\n\nUpgrades to the Launch Vehicle Mark 3 (LVM3) are already underway. A new semi-cryogenic engine will replace the current liquid stage to provide the necessary thrust. The development represents a collaborative effort with multiple private Indian aerospace firms, showcasing India\'s rapidly maturing commercial space ecosystem.',
    imageUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=800',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
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
        'For the first time in history, the combined electricity generated globally from wind and solar infrastructure has eclipsed coal power generation. Renewable capacity added over 500 gigawatts last year, driven by major policy shifts in Europe and rapid infrastructure scale-ups across Asia, marking a historic turning point in the global decarbonization timeline and transitioning markets to cleaner energy.',
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
        'In an unprecedented final round, an 18-year-old chess grandmaster has clinched the Candidates Tournament, becoming the youngest challenger in history for the World Chess Championship. Capitalizing on a late-game positional error by the top-seeded opponent, the prodigy secured this stunning victory with precise endgame execution, rewriting chess history books and capturing international sports headlines.',
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
        'A micro-budget independent science-fiction film, created using virtual production volumes and custom neural styling filters, has clean swept the Golden Globe Awards, taking home Best Picture and Best Director. This historic victory highlights a growing disruption in traditional Hollywood studio dominance, proving that modern affordable technology democratizes cinema and opens doors for indie creators worldwide.',
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
        'Apple has officially unveiled the Glasses Air, a lightweight augmented reality eyewear weighing just 75 grams. Equipped with miniature micro-LED displays and a dual-chip custom R3 silicon architecture, this eyewear projects spatial computing interfaces directly into the user’s line of sight, featuring advanced hand-gesture controls, eye-tracking navigation, and seamless iPhone wireless integration.',
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
        'The second phase of the ambitious Mumbai Coastal Road project, featuring a 4.5-kilometer undersea twin tunnel, has officially opened to commuters, cutting travel times between South Mumbai and Western suburbs by 70%. Built using advanced trenchless boring machines, this mega project resolves heavy traffic gridlocks and integrates automated smart monitoring systems for safety.',
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
        'Global automotive reports indicate a significant pivot in consumer preferences, with hybrid and plug-in hybrid vehicle sales growing 45% year-on-year. While pure battery-electric vehicle sales experienced plateauing demand due to widespread charging infrastructure anxieties, hybrid models emerged as the dominant, affordable transitional choice for mass-market buyers looking to reduce emissions.',
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
        'Astronomers using the James Webb Space Telescope have confirmed the presence of water vapor in the atmosphere of a rocky exoplanet orbiting a red dwarf star in the habitable zone. This represents the first time atmospheric signatures have been detected on a rocky world outside our solar system, marking a massive, historical leap forward in the search for habitable extraterrestrial life.',
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
        'Marine archaeologists have uncovered the ruins of a sprawling Bronze Age city submerged off the coast of Greece. The site, dating back to approximately 2500 BCE, features intact stone foundations, paved roadways, and hundreds of clay storage vessels. This discovery promises to reshape our understanding of early Mediterranean trade networks, maritime transport systems, and ancient civilizations.',
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
