/datum/event/lore_news
	endWhen = 10

/datum/event/lore_news/announce()
	var/author = "Oculus v6rev7"
	var/channel = "Oculum Content Aggregator"


	//locations by region for later pick()
	//probably would be good to move these to a global somehwere but fuck if I know how to do that
	var/list/rim = list("Shelf", "Vounna", "Relan", "Whythe", "Angessa's Pearl") // this is also the Association list for most purposes
	var/list/crescent = list("Saint Columbia", "Ganesha", "Gavel", "Oasis", "Kess-Gendar") //Vir not included
	var/list/core = list("Sol", "Alpha Centauri", "Tau Ceti", "Altair")
	var/list/heights = list("New Ohio", "Mahi-Mahi", "Parvati", "Sidhe", "New Seoul")
	var/list/bowl = list("Zhu Que", "New Singapore", "Isavau's Gamble", "Love", "Viola", "Stove")
	var/list/crypt = list("El", "Jahan's Post", "Abel's Rest", "Raphael", "Thoth", "Terminus")
	var/list/weird = list("Silk", "Nyx") //no region

	//by government
	var/list/solgov = crescent + core + heights + bowl + crypt + weird
	var/list/skrell = list("Qerr'Vallis", "Qerma-Lakirr", "Harrqak", "Kauq'xum")
	var/list/skrellfar = list("The Far Kingdom of Light and Shifting Shadow")// more colonies Elgeon
	var/list/unathi = list("Moghes", "Qerrna-Qamxea", "Abel's Rest") // more colonies Anewbe
	var/list/tajara = list("Rarkajar", "Mesomori", "Arathiir")
	var/list/independent = list("New Kyoto", "Casini's Reach", "Ue'Orsi", "Natuna", "Neon Light")

	//this is what you should pick for most applications
	//whether or not the rim goes there is something that should be changed per the metaplot
	var/list/loc = solgov + skrell + tajara

	//this includes systems Sol doesn't really have eyes on
	var/list/allloc = loc + unathi + skrellfar + independent + rim

	//copied right from organizations.dm
	var/list/ship_names = list(
		"Kestrel",
		"Beacon",
		"Signal",
		"Freedom",
		"Glory",
		"Axiom",
		"Eternal",
		"Harmony",
		"Light",
		"Discovery",
		"Endeavor",
		"Explorer",
		"Swift",
		"Dragonfly",
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous"
		)

	//generated based on Cerebulon's thing on the wiki
	var/list/prefixes = list("IAV","ICV","IDV","IDV","IEV","IFV","IIV","ILV","IMV","IRV","ISV","ITV","SCG-A","SCG-C","SCG-D","SCG-D","SCG-E","SCG-F","SCG-I","SCG-L","SCG-M","SCG-R","SCG-S","SCG-T","BAV","BCV","BDV","BDV","BEV","BFV","BIV","BLV","BMV","BRV","BSV","BTV","HAV","HCV","HDV","HDV","HEV","HFV","HIV","HLV","HMV","HRV","HSV","HTV","MAV","MCV","MDV","MDV","MEV","MFV","MIV","MLV","MMV","MRV","MSV","MTV","NAV","NCV","NDV","NDV","NEV","NFV","NIV","NLV","NMV","NRV","NSV","NTV","VAV","VCV","VDV","VDV","VEV","VFV","VIV","VLV","VMV","VRV","VSV","VTV","WAV","WCV","WDV","WDV","WEV","WFV","WIV","WLV","WMV","WRV","WSV","WTV","XAV","XCV","XDV","XDV","XEV","XFV","XIV","XLV","XMV","XRV","XSV","XTV","ZAV","ZCV","ZDV","ZDV","ZEV","ZFV","ZIV","ZLV","ZMV","ZRV","ZSV","ZTV","GAV","GCV","GDV","GDV","GEV","GFV","GIV","GLV","GMV","GRV","GSV","GTV","AAV","ACV","ADV","ADV","AEV","AFV","AIV","ALV","AMV","ARV","ASV","ATV","LAV","LCV","LDV","LDV","LEV","LFV","LIV","LLV","LMV","LRV","LSV","LTV")

	//formatting breaks my fucking eyes
	var/body = pick("A high-ranking Vey-Med executive was revealed to have been experimenting on biological neural enhancement techniques, believed to be of Skrellian origin, which could lead to the production of transhuman entities with an average cognitive capacity 30% greater than a baseline human.",
	"[random_name(MALE)], chairman of the controversial Friends of Ned party, is scheduled to speak at a prominant university in [pick(core)] this Monday, according to a statement on his official newsfeed.",
	"A wing of Ward-Takahashi B-class drones became catatonic this Thursday after tripping late-stage anti-emergence protocols. W-T Chief of Development has declined to comment.",
	"A brand-new shipment of recreational voidcraft has been deemed \"Unsafe for use\" and seized at [pick(solgov)] customs. Wulf Aeronautics blames error in automated manufactory on [pick(solgov)], assures shareholders of \"One time incident\" after shares drop 4%.",
	"Activity in a mostly automated Xion work-site in [pick(solgov)] has been suspended indefinitely, after reports of atypical drone behavior. The EIO's assigned investigator commented on the shutdown, saying \"We'll get them up and running again as soon as we're sure it's safe.\" No comment so far on an estimated time or date of reopening.",
	"The EIO has officially raised the Emergence Threat Level in [pick(solgov)] to Blue. Citizens are reminded to comply with all EIO Agent requests. Failure to do so will be met with legal action, up to and including imprisonment.",
	"All SolGov citizens beware, the scourge know as the Vox have increased the frequency of their attacks on isolated and poorly defended SolGov territories in [pick(bowl)]. Citizens have been advised to travel in groups and remain aware of their surroundings at all times.",
	"The Unathi have recently moved a large amount of material into Abel's Rest, under the premise of building additional power plants. According to our sources, the material is in fact being channeled into domestic terrorist groups on both sides, in an attempt to incite a SolGov response. More news as the story develops.",
	"Controversial Kishari director [random_name(FEMALE)] announced this Friday a sequel to the 2281 animated series Soldiers of the Yearlong War. Open auditions for supporting cast members have been called.",
	"Amid concerns that it promotes a pro-transtech agenda, a high-profile screening of the award-winning animated film \"The Inventor's Marvelous Mechanical Maidens\" was canceled today on [pick(pick(core, heights))].",
	"A radiation leak caused by a power unit rupture at a [pick(solgov)] hazardous materials reclamation plant has left several workers and neighboring residents with acute radiation poisoning. Witnesses report that a basic lifting drone failed to recognize and collided with the misplaced unit.",
	"Xenophobic fringe group Humanity First has claimed credit for a bombing at a local government office on [pick(solgov)] which left three seriously injured. Police report that they have two suspects in custody, but details remain sparse.",
	"Government official [random_name(MALE)] reports that the crew of the [pick(prefixes)] [pick(ship_names)], the vessel boarded by Jaguar Gang pirates earlier this week, are \"Safe, unharmed, and happy to be back at work.\" Officials were unable to comment on future security measures at this time.",
	"Sanitation Technician [random_name(FEMALE)] says she was trapped in her work bathroom for three days after the locking system went haywire! The furious techie says she wants a \"hefty sum\" from her employers and that she won't be visiting that cubicle again any time soon!",
	"Experts at a top university have said that almost every position in modern society might be filled by a robot within the next few decades if production continues at its current rate. Workers' Rights groups have expressed alarm at the news, and have called for protections against the \"Tin menace\".",
	"An alleged cyberattack on Bishop Cybernetics systems reported to have resulted in the theft of customer data including detailed medical and biological records has been dismissed as \"Unfounded scaremongering\" by company executives.",
	"[pick(crescent)] resident [random_name(FEMALE)] says she was overjoyed when her son told her he was planning to get married, but was appalled to find the bride-to-be was a common household cleaning drone! GR3TA assures us that \"Cleaning is complete.\"",
	"Striking workers at a manufacturing plant on [pick(bowl)] have returned to work after news spread that plant owners would relocate operations to an automated facility if production did not resume by the end of the month. Factory investor [random_name(FEMALE)] expressed admiration at the \"Decisive action\" taken by the company.",
	"Police in [pick(core)] report that they have arrested a man in connection with multinationalist fringe group Nation of Mars. Authorities were alerted when the man's ID was flagged by new screening software at the city spaceport as a known sympathizer with the violent terrorist organization.",
	"The mystery of the [pick(prefixes)] [pick(ship_names)] has come to its end as a member of the vessel's skeleton crew was arrested in connection with Golden Tiger activities on the Skrell border. According to authorities, the ship - declared missing some months ago - was illegally sold to criminal elements on its way to breaking yards at [pick(heights)].",
	"[random_name(MALE)] comes clean about his decade-long nightmare kept as a slave on Eutopia in a new book to be released later this year. The harried author has fought lawsuits at every turn that claim that his account is \"A work of pure fiction with an obvious leftist agenda.\"",
	"Gas mask toting Revolutionary Solar People's Party extremists have reportedly attacked police at a rally in [pick(crypt)]. Peace-keeping officers were viscously pelted with objects and several protesters were found to be equipped with bottles containing an \"unknown substance.\"",
	"Be careful what you say around your personal AI device as you never know who might be listening, say top minds! Cybercrime expert [random_name(FEMALE)] says hackers can easily trick your device to listen in on your conversations, record you in secret, or even steal your identity!",
	"Thousands of travellers have been stranded at [pick(loc)] spaceport as a major error with the artificial intelligence system purged weeks worth of scheduling and manifest data from the port's mainframe. Major Bill's Transportation is offering stranded passengers 20% off replacement flights.",
	"An outraged pet owner claims that a cybernetic company in [pick(solgov)] performed \"disturbing\" surgeries on their beloved cat, Pickles. [random_name(PLURAL)], 58 claims that the local cybernetics firm stole the furry friend from the vet's office and \"Replaced his brain with ones and zeroes.\"",
	"Doctors in [pick(pick(skrell, heights))] were left in awe and horror as a Teshari was hatched with the features of an adult human man! Sources say that the youngster hatched with a full head of hair and could recite six nursery rhymes from memory. Could Skrell genetic experiments be to blame?",
	"Miners in [pick(bowl)] were dismayed to discover that their boss was actually a C-class drone intelligence! \"I should've known there was something wrong,\" says dumbfounded miner [random_name(MALE)],\"I'd say good morning and he'd just start listing off mineral densities and coordinates. I just thought he loved his job a little too much.\"",
	"The remains of an early 22nd century voidcraft containing \"Period artifacts, technology and human remains\" has been located on the surface of Luna after centuries of being disregarded as worthless wreck. Historians hope the find will provide insight into daily life under the short-lived Selene Federation.",
	"The unexpected discovery of the remains of a what was believed to be a previously undiscovered species by workers on [pick("Nisp", "Binma", "Sif", "Kishar", "Abel's Rest", "Merelar")] has now been dismissed. Upon close analysis of the specimen, it was identified as a \"Bear with mange\", apparently dumped there some weeks prior.",
	"According to a public statement by electronics giant Ward-Takahashi, many artificial intelligence systems - ranging from household appliances to industrial drones and habitat control networks - manufactured before 2300 could be at risk from a new virus dubbed \"Cap-3k\".",
	"A controversial opera billed as \"The true story of Nos Amis\" has been criticized by law enforcement agencies as \"glorifying\" some of the most infamous gangsters of the 22nd century. The Polish-language \"Z Francji, do Gwiazd\" is to be distributed exclusively in Alpha Centauri for one week only.",
	"Injury count continues to rise in the aftermath of the Positronic Rights Group Rally in [pick(pick(bowl, core, heights))]. Homemade teargas grenades were launched into the crowd at approximately 3:45 pm on Saturday by an unidentified person. Authorities urge anyone with information to call in, toll-free, at any time.",
	"Representatives report that investigations continue on a string of fires on [pick("Nisp", "Binma", "Sif", "Kishar", "Abel's Rest", "Merelar")]. While no information has been released to the public, authorities assure the press that they are doing everything in their power to find those responsible.",
	"En-route to the contentious rim system, a medical aid mission to Natuna was stopped by Ue-Katish pirates masquerading as refugees, who boarded the ship and stripped it of all supplies.",
	"Lead Singer of Strawberry Idol Revealed As Three Teshari In A Trench Coat-- Newest gimmick or shocking revelation??",
	"Shocking art critics throughout the system, a recent submission to the [pick(solgov)] Museum of Absurdism's contemporary exhibit was revealed to actually be the nutritional information on the back of a dehydrated cereal product common in Skrell space.",
	"The celebrated magical kid series \"Petit Yuusha Jossen Temonila\" has announced its newest season at the height of its demicentenial festival. Noted director [random_name(MALE)] has promised to bring a diverse production staff to the venerable series, and has stated a theme of \"the friendships that transcend borders\".",
	"The Hephaestus Industries board of directors announced this Monday the highest annual profits since the height of the Lizard Riots.",
	"A radical group of Mercurials were convicted today of violations of Five Points legislature at an extraordinary court on [pick(solgov)]. These convictions come at the heels of a successful sting operation six years in the making, lead by local Head of EIO [random_name(FEMALE)].",
	"An unnamed official of the shipping TSC Major Bill's Transportation narrowly escaped an attempt on their life by a deranged assassin. The assassin claims to have been driven to this henious act by the corporation's infamous jingle.",
	"In the aftermath of yesterday's synthphobic rally on [pick(solgov)], three positronic citizens were left irreparably damaged by a hostile mob, who claim that the victims were \"AAs\" attempting to infiltrate the rally.",
	"EIO spokesperson [random_name(MALE)] stated in a press conference yesterday that the \"Shakespear\" A-class codeline was briefly available for download on the darknet, although they claim to be \"confident that the leak was shut down before any significant portion could be downloaded\". Experts suspect Association involvement.",
	"[pick("Strives Towards", "Embraces", "Dreams of", "Cultivates", "Advocates", "Exemplifies")] [pick("Strength", "Wisdom", "Independence", "Pragmatism", "Reason", "Development")], a Community Child from Angessa's Pearl, published his memoir today, detailing a shocking level of abuse by caretakers and educators.",
	"Nova Sixty, Mercurial web personality, claims that the disappearence of the SCG-R Song Shi was a plot by \"extradimensional rockmen\" who intend to sow mistrust between the Association and SolGov. Quote Sixty, \"The Far Kingdoms' attempt to hide the TRUTH only proves that they and their rockman allies are NOT to be trusted.\"",
	"Unusual stellar phenomena was detected on [pick(allloc)], sparking concerns about the colonies in the system.",
	)

	news_network.SubmitArticle(body, author, channel, null, 1)
