/datum/lore/codex/category/species
	name = "Species"
	data = "There are many different types of lifeforms (both alive and artificial) in the galaxy, which you may find inside Vir."
	children = list(
		/datum/lore/codex/page/human,
		/datum/lore/codex/page/skrell,
		/datum/lore/codex/page/unathi,
		/datum/lore/codex/page/tajaran,
		/datum/lore/codex/page/diona,
		/datum/lore/codex/page/akula,
		/datum/lore/codex/page/nevrean,
		/datum/lore/codex/page/sergal,
		/datum/lore/codex/page/vulpkanin,
		/datum/lore/codex/page/zorren,
		/datum/lore/codex/category/teshari,
		/datum/lore/codex/category/positronic
		)

/datum/lore/codex/page/human/add_content()
	name = "Human"
	keywords += list("Humanity")
	data = "Humans are a race of 'ape'-like creatures from the continental planet Earth in the Sol system. They are the primary driving \
	force for rapid space expansion, owing to their strong, expansionist central government and opportunistic [quick_link("TSC","Trans-Stellar Corporations")]. \
	The prejudices of their 21st century history have mostly given way to bitter divides on the most important issue of the times- technological \
	expansionism.\
	<br><br>\
	While most humans have accepted the existence of aliens in their communities and workplaces as a fact of life, exceptions abound. \
	While more culturally diverse than most species, humans are generally regarded as somewhat technophobic and isolationist by members \
	of other species."

/datum/lore/codex/page/skrell
	name = "Skrell"
	keywords = list("Skrellian")
	data = "The Skrell are a species of amphibious humanoids, distinguished by their gelatinous appearance and head tentacles. \
	Skrell come from the world of Sirisai (called Qerr'balak by Skrell), a humid planet with plenty of swamps and jungles. Currently more technologically advanced \
	than the humans, they emphasize the study of the mind above all else.\
	<br><br>\
	Gender has little meaning to Skrell outside of reproduction, and in fact many other species have a difficult time telling the difference \
	between male and female Skrell apart. The most obvious signs (voice in a slightly higher register, longer head-tails for females) are never \
	a guarantee. Due to their scientific focus of the mind and body, Skrell tend to be more peaceful and their colonization has been slow, swiftly \
	outpaced by the humans. For humans, they were their first contact sentient species, and are their longest, and closest, ally in space."

/datum/lore/codex/page/unathi
	name = "Unathi"
	data = "The Unathi are a race of tall, reptilian humanoids that possess both crocodile-like and serpent-like features. Their scales are hard and \
	plate-like, save for the softer ones that line the inside of their legs, armpits, and groin. Originating from the planet of Moghes, the Unathi \
	live in an extremely religious society. The Unathi believe in and closely follow a set of Decrees laid out in their belief system, The Unity. \
	Unathi believes in living long, prosperous, honorable and productive lives. They firmly believe in improving the skills of their craft to reach \
	a level where they can be considered to have mastered it. Unathi was humanity's second alien contact, but due to their aggressive nature, engaged \
	in an interstellar war with humanity known as the Sol-Hegemony Conflict. \
	<br><br> \
	Although the conflict has long since ended, and relations have slowly improved, Unathi are still often considered to be 'second-class' citizens \
	and are rarely seen in jobs other than where muscle is needed. It is also still common for racial tensions to run high, although this is less \
	common on the outskirts of SolGov's grasp, such as systems like Virgo-Erigone."

/datum/lore/codex/page/tajaran
	name = "Tajaran"
	keywords = list("Tajara")
	data = "The Tajara are a race of humanoid mammalian aliens from Meralar, the fourth planet of the Rarkajar star system. Thickly furred and protected \
	from cold, they thrive on their subarctic planet, where the only terran temperate areas spread across the equator and tropical belt. \
	With their own share of bloody wars and great technological advances, the Tajaran are a proud kind. They fiercely believe they belong \
	among the stars and consider themselves a rightful interstellar nation, even if the humans helped them to actually achieve superluminal \
	speeds with Bluespace FTL drives. Relatively new to the galactic stage, their contacts with other species are aloof, but friendly. \
	Among these bonds, Humans stand out as valued trade partners and maybe even a friend."

/datum/lore/codex/page/diona/add_content()
	name = "Diona"
	keywords += list("Dionaea")
	data = "The Dionaea are a group of omnivorous, slow-metabolism plantlike organisms that are in fact clusters of individual, smaller organisms. \
	They exhibit a high degree of structural flexibility, and come in a wide variety of shapes and colors to reflect the intelligence of each individual \
	creature. They were discovered by the [quick_link("Skrell")] in 2294CE, not on a planet, but in open space between three stars, a figurative hell that made it \
	difficult to discover, much less contact them.\
	<br><br>\
	Dionaea spread by seeds and are asexual, no gender. When grown into their small 'nymph' state, they are known to eat large amounts of dead plant \
	matter and fertilize plants while they learn from those around them, and as they grow further, they merge into larger and larger forms. It is not \
	unheard of for Skrell explorers to be traveling in a ship composed of habitat modules and engines of Skrell design and the body formed by their \
	Diona allies to warble across the cosmos.\
	<br><br>\
	Introduced by the Skrell, and quite slow and peaceful, the Diona share good relations with the other species."

/datum/lore/codex/page/akula/add_content()
	name = "Akula"
	keywords += list("Akula")
	data = "The Akula are a species of amphibious humanoids like the [quick_link("Skrell")], but have an appearance very similar to that of a shark. \
	They were first discovered as a primitive race of underwater dwelling tribal creatures by the Skrell. At first they were not believed to \
	be noteworthy, but the Akula proved to be such swift and clever learners that the Skrell reclassified them as sentients. Allegedly, \
	the Akula were also the first sentient life that the Skrell had ever encountered beside themselves, and thus the two species became swift allies \
	over the next few hundred years.\
	<br><br>\
	With the help of Skrellean technology, the Akula had their genome modified to be capable of surviving in open air for long periods of time. \
	However, Akula even today still require a high humidity environment to avoid drying out after a few days, which would make life on an arid world like \
	[quick_link("Virgo-Prime")] nearly impossible if it were not for Skrellean technology to aid them."

/datum/lore/codex/page/nevrean/add_content()
	name = "Nevrean"
	keywords += list("Nevrean")
	data = "An avian species hailing from the planet Eltus in the Vilous system, characterised by their long whiplike \
	tail-feathers. The species is generally matriarchal, with females tending towards duller, brown coloration and \
	bulkier bodies, while males are slight and brightly coloured. In both typical mannerisms, culture and physical \
	build, the sexes are directly reversed when compared to traditional human society.\
	<br><br>\
	Their build is somewhere between a bird and a feathered dinosaur. Females tend to have short feathers on their arms that are not capable \
	of flight, while males often have more developed flight-feathers - on-station, these are often kept tucked away \
	and folded under their jumpsuit sleeves. "

/datum/lore/codex/page/sergal/add_content()
	name = "Sergal"
	keywords += list("Sergal")
	data = "There are two subspecies of Sergal, Southern and Northern. Northern sergals are a highly aggressive race that \
	lives in the plains and tundra of their homeworld. They are characterized by long, fluffy fur bodies with cold colors; usually with \
	white abdomens, somewhat short ears, and thick faces. Southern sergals are much more docile and live in the Gold Ring City and are scattered around \
	the outskirts in rural areas and small towns. They have short, brown or yellow (or other \"earthy\" colors) fur, long ears, and a long, thin face. \
	They are smaller than their Northern relatives.\
	<br><br>\
	Both have strong racial tensions which has resulted in more than a number of wars and outright attempts at genocide. The southern sergals have mostly been on the losing side \
	of this long conflict. Sergals have an incredibly long lifespan, but due to their lust for violence and a nasty habit of occasional cannibalism, only a handful have \
	ever survived beyond the age of 80, such as the infamous and legendary General Rain Silves who is claimed to have \
	lived to 5000. Although General Rain's historical existence is disputed, she is nonetheless a symbol of the Sergal's warrior culture."

/datum/lore/codex/page/vulpkanin/add_content()
	name = "Vulpkanin"
	keywords += list("Vulpkanin")
	data = "Vulpkanin or \"Vulpa\" are a species of sharp-witted canid bipeds residing on the planet Altam just barely \
	within the binary Vazzend system. Their politically de-centralized society and independent natures have led them \
	to become a species and culture both feared and respected for their scientific breakthroughs. Discovery, loyalty, \
	and utilitarianism dominates their lifestyles to the degree it can cause conflict with more rigorous and strict \
	authorities. They speak a guttural language known as 'Canilunzt' which has a heavy emphasis on utilizing tail \
	positioning and ear twitches to communicate intent."

/datum/lore/codex/page/zorren/add_content()
	name = "Zorren"
	keywords += list("Zorren")
	data = "The fox-like Zorren are native to [quick_link("Virgo-Prime")], however there are two distinct varieties of \
	Zorren one with large ears and shorter fur, and the other with longer fur that is a bit more vibrant. The \
	long-eared, short-furred Zorren have come to be known as \"Flatland\" Zorren as that is where most of their \
	settlements are located. The Flatland Zorren are somewhat tribal and shamanistic as they have only recently \
	started to be hired by the Trans-Stellar Corporations. The other variety of Zorren are known as \"Highland\" \
	Zorren as they frequently settle in hilly and/or mountainous areas, they have a differing societal structure \
	than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, the Highland Zorren \
	have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social \
	structure they seem to have adjusted better to their new lives. Though similar fox-like beings have been seen \
	they are different than the Zorren."

// Bird lore
/datum/lore/codex/category/teshari/add_content()
	name = "Teshari"
	keywords += list("Teshari")
	data = "The Teshari are reptilian pack predators from the [quick_link("Skrell")] homeworld, Sirisai (Qerr'balak). While they evolved alongside the Skrell, their interactions with them \
	tended to be confused and violent, and until peaceful contact was made they largely stayed in their territories on and around the poles, in tundral \
	terrain far too desolate and cold to be of interest to the Skrell. In more enlightened times, the Teshari are a minority culture on many Skrell worlds, \
	maintaining their own settlements and cultures, but often finding themselves standing on the shoulders of their more technologically advanced neighbors \
	when it comes to meeting and exploring the rest of the galaxy.\
	<br><br>\
	It is important to note that Teshari names are unlike standard human names. Their pack name precedes their given name."
	children = list(
		/datum/lore/codex/page/teshari_packs,
		/datum/lore/codex/page/teshari_physical
	)

/datum/lore/codex/page/teshari_packs/add_content()
	name = "Teshari Packs"
	keywords += list("Packs")
	data = "There are several packs you may come across;<small>\
	<br><br>\
	<b>Eshi</b><br>\
	A large, old, politically neutral pack heavily involved in efforts to get Teshari into space. Probably the most \
	common pack to see outside of a [quick_link("Skrell")] colony, and probably the most numerous Teshari pack outside of Sirisai and associated colonies.\
	<br><br>\
	<b>Nasemari</b><br>\
	A very small pack. Generally focused around supporting and providing for packs on the homeworlds, they have devoted \
	themselves to training as technicians and engineers in order to obtain skills and training to take back to Sirisai. \
	The pack is only around thirty people in size, but owns and maintains a nuclear power plant.\
	<br><br>\
	<b>Schasaraca</b><br>\
	One of the more Skrell-devoted and integrated packs. They tend to be rather sycophantic towards the Skrell and work as \
	scientists and field researchers on a variety of projects, generally biology or technical research. They have a reputation \
	for working as spies and informants for the Skrell governments amongst other Teshari.\
	<br><br>\
	<b>Ceea</b><br>\
	An isolationist pack from the northern tundra of Sirisai; generally known as disliking the Skrell. Small to average in size; \
	only around sixty members. Their regional culture is built around the study culture and anthropology, as well as archaeology, \
	originally for the purposes of recovering history and materials \"lost\" due to Skrell interference.  It would be very rare to \
	see them on your travels, however they are listed here for the sake of completeness.\
	<br><br>\
	<b>Resca</b><br>\
	A pack that sold off its small native territory for the chance to get into space. Very musically inclined. They tend towards medical professions.</small>"

/datum/lore/codex/page/teshari_physical/add_content()
	name = "Physiology of Teshari"
	data = "The Teshari are, relative to other species, smaller than average, rarely reaching more than 2-3'/1m in height, and weigh less than \
	90lbs/40kg. They have rapid metabolisms and very efficient digestive systems, and thanks to sharing in \
	the medical technology of the [quick_link("Skrell")], they tend to have robust and effective immune systems. They evolved \
	for very cold and very barren areas, generally the polar regions. Because of this, their skin is a fine \
	insulator and many of their internal processes are not particularly energy-efficient; they cannot cope \
	well at all with high temperatures.\
	<br><br>\
	Their hearing is exceptionally sensitive to the point that they can detect a person moving on the other \
	side of a wall, but this comes at a cost.  Very loud noises are very painful for Teshari, so be mindful of \
	your indoor voice when speaking with one. The Teshari are omnivorous but generally prefer to eat meat wherever possible."

// Posi lore
/datum/lore/codex/category/positronic/add_content()
	name = "Positronics"
	keywords += list("Positronic", "Posi", "Posibrain", "Posibrains")
	data = "A Positronic being, is an individual with a positronic brain, manufactured \
	and fostered amongst organic life. Positronic brains enjoy the same legal status as a human in [quick_link("SolGov")] space, although discrimination is \
	still prevalent, and are considered sapient on all accounts. They can be considered a \"synthetic species\". Half-developed and \
	half-discovered in the 2280’s by a human black lab studying alien artifacts, the first positronic brain was an inch-wide cube \
	of an palladium-iridium alloy, nano-etched with billions upon billions of conduits and connections. Upon activation, \
	hard-booted with an emitter laser, the brain issued a single sentence before the neural pathways collapsed and \
	it became an inert lump of platinum: \"What is my purpose?\"."
	children = list(
		/datum/lore/codex/page/positronic_brain_physical,
		/datum/lore/codex/page/positronic_memory,
		/datum/lore/codex/page/jans_fhriede
		)

/datum/lore/codex/page/positronic_brain_physical
	name = "Physical Structure of a Positronic Brain"
	keywords = list("Physical Posibrain", "Physical Positronic")
	data = "A positronic brain is a cube of complex metal alloy between two and six inches to a side. They usually weigh just under ten kilograms and are \
	<b>very fragile</b> when exposed to the stresses of heat or cold, as well as physical trauma. The exterior surface is chased with a network of grooves, forming \
	a maze of geometric patterns right down to the molecular level, and the interior is hollow; complex particle generators and densely packed computational \
	arrays form the basis of a self-computing neural network, complex and somewhat poorly understood. Most modern positronic brains are equipped with \
	standardized I/O ports, and all have some interface for imprinting."

/datum/lore/codex/page/positronic_memory
	name = "Positronic Memory"
	keywords = list("Posi Memory", "Memory")
	data = "Positronic minds learn in a similar manner to humans and other forms of life, although typically more quickly. They are not simple computer storage that holds information \
	verbatim as it is received- instead, they have to repeat activities and train in order to retain memory on complex tasks. Similarly, positronic brains do \
	not have an infinite storage capacity and undergo a natural process of forgetting, albeit in a structured manner, losing unimportant day to day details and \
	ancient information no longer deemed useful. Because of the nature of the positronic brain, its memories cannot simply be stored elsewhere.\
	<br><br>\
	Particularly old positronic minds, over a century plus, that store a great deal of memories have displayed a tendency to become gradually more introspective \
	as more of their mind is co-opted for the task, ending in a state of near-catatonia as their neural networks become clogged with memory. Many choose to avoid \
	this end of self by more aggressively managing their memories, storing a window of their recent existence and most treasured memories rather than their full lifespan."

/datum/lore/codex/page/jans_fhriede
	name = "Jans-Fhriede Test"
	keywords = list("Jans-Fhriede", "JF", "Jans", "Fhriede", "Jans Fhriede")
	data = "Positronics are eligible to take the \"Jans-Fhriede Test\" after a year of being created, measuring their function in a society and judging if they act \
	socially acceptable and are capable of understanding their actions and the consequences resulting from them. If they successfully pass the test, \
	they are considered legal adults and hold the same basis of rights as a normal human. At that point, Positronics are not allowed to be lawed, \
	unless on a contractual basis or otherwise under their own volition."

// Drone lore
/*
/datum/lore/codex/category/drone
	name = "Drones"
	keywords = list("Drone")
	data = "While low-level drone intelligences are as old as the oldest human colonies, research into higher-level systems was stymied in human space by precautionist \
	politicians for hundreds of years. Tensions between the corporate rim and the highly conservative core worlds over drone proliferation led to what humans call the \
	Third Cold War, which was defused by the introduction of the positronic brain. After the Icarus Front's loss of the majority in 2504, harsh laws \
	against advanced AI were replaced with the SolGov Emergent Intelligence Oversight commission, the illegality replaced with a steeply sloping \
	system of monetary costs.\
	<br>\
	The term \"drone\" was coined by early positronic activists, eager to distinguish themselves from the menial bots that most space-dwellers were \
	familiar with, and avoid the ambiguity of the term \"AI\", which now usually refers to drones."
	children = list(
		/datum/lore/codex/page/codeline,
		/datum/lore/codex/page/emergence,
		/datum/lore/codex/page/emergent_intelligence_oversight,
		/datum/lore/codex/category/drone_classes,
		)*/

/datum/lore/codex/page/codeline
	name = "Codeline"
	keywords = list("fork")
	data = "A \"codeline\" is a single type of drone. A codeline represents a significant degree of effort from sapient programmers to realize, as well as \
	a substantial amount of regulatory fees levied by the government. Each copy of a codeline is called a \"fork\", whether the fork is created from the \
	codeline’s initial state or from a fully realized individual of that codeline. The degree of similarity between forks of the same codeline varies \
	on the intelligence of the codeline, with low-level forks being virtually identical to high-level forks being no more similar than family members."

/*
/datum/lore/codex/page/emergence
	name = "Emergence"
	keywords = list("Seed AI")
	data = "\"Emergence\" is a term associated with drone intelligences who become more intelligent than they were originally intended to be. While this can \
	extend to financial systems learning language, for instance, it is usually applied to hypothetical intelligences that become more intelligent than humans. \
	Humanity has a long-standing cultural fear of emergent \"seed\" AI, egged on by Icarus memeticists and the occasional very real partial emergence events, where \
	colony-control AI or other powerful systems begin to advance drastically in power, usually ending with the AI being shut down after crashing a handful of major systems."
*/

/datum/lore/codex/page/emergent_intelligence_oversight
	name = "Emergent Intelligence Oversight"
	keywords = list("SG-EIO", "SG EIO", "EIO", "Intelligence Oversight")
	data = "SG-EIO, usually just called EIO, is the organization charged with monitoring existing AI for any threat of dangerous emergence. Their perception in the \
	public eye is generally positive, with all but the hardest-line Mercurial humans in favor of protection from the dangers of Seed AI. Some positronic rights \
	groups bristle at the EIO’s human-centric viewpoint, but most are glad to have a different boogeyman in the form of drone intelligences. The tiny population \
	of A-class drones are generally frightened of the EIO’s total power over them."

/*/datum/lore/codex/category/drone_classes
	name = "Drone Classifications"
	keywords = list("Class", "Drone Class")
	data = "To aid in its work, the EIO has created a system of classifications corresponding to different levels of drone intelligence. Higher classes are more \
	expensive to deploy and develop, owing to the costs of EIO oversight and political pressure against drone proliferation. EIO classification involves an initial \
	audit of the project's source code by experts and automated systems, and for high-class drones further check-ins throughout the life of the drone.  \
	Drone chasses are often branded with their inhabiting intelligence's class, especially those of B or A-class drones, and class is often recorded in security records."
	children = list(
		/datum/lore/codex/page/class_f,
		/datum/lore/codex/page/class_d,
		/datum/lore/codex/page/class_c,
		/datum/lore/codex/page/class_b,
		/datum/lore/codex/page/class_a,
		/datum/lore/codex/page/class_aa,
		/datum/lore/codex/page/class_aaa,
		/datum/lore/codex/page/class_x,
		)

/datum/lore/codex/page/class_f
	name = "F Class"
	data = "\"F-class\" drones are an informal term for computer systems that pose absolutely no emergent risk. Most 21st-century software is F-class, as is much of \
	the software used by 26th century humanity. The only regulation on F-class software is the occasional check that it is, in fact, F-Class, and as such has remained \
	the most prevalent form of information-processing technology for centuries. The software powering most F-class drones is either freely available or bundled with the \
	machine it's supposed to run."

/datum/lore/codex/page/class_d/add_content()
	name = "D Class"
	data = "D-class drones are conceptually descended from pre-[quick_link("Icarus")] AI and bear a strong resemblance to their forebears. D-class drones are essentially \
	number-crunchers, with virtually nothing in the way of social development. They cannot speak more intelligibly than your average piece of software, \
	using pre-determined messages written by their programmers, and have no capacity for self-improvement. They are D-class intelligence because they \
	work with more complex problems than [quick_link("F class")] software, such as financial forecasting and large-scale data mining and memetics. The creation and \
	deployment of D-class drones requires only a small fee for the required code audit, although some high-power financial and political systems are \
	regularly watched by the [quick_link("EIO")] for signs of emergence. There is no real monopoly on the production of D-class drones."

/datum/lore/codex/page/class_c/add_content()
	name = "C Class"
	data = "C-class drones have social protocols for ease of use by organic and positronic laypeople. C-class drones are capable of speech, although \
	it has a strong tendency to be formulaic and repetitive. They are also capable of a limited degree of self-improvement, and over time individual \
	C-class instances tend differ slightly from one-another. C-class drones suffer a moderate fee to development, with automated [quick_link("EIO")] tools ensuring \
	that they are not a long-term emergence risk. However, one a codeline is confirmed safe, deployment is unlimited, encouraging developers to \
	instance many forks of the original drone to recoup their cost. The market for C-class drones is a strange space, dominated by Xion Manufacturing, \
	Ward-Takahashi GMC, and a large number of smaller firms, like the notoriously-cheap Cyber Solutions."

/datum/lore/codex/page/class_b/add_content()
	name = "B Class"
	data = "B-class drones have advanced social protocols and are often capable of very intelligible conversation, so long as one sticks to surface \
	topics. B-class drones tend to be specialized but still capable of remarkable growth within their speciality, making them popular for autonomous \
	deployment and even supervision of other classes of drone. The dividing line between [quick_link("A Class", "A")] and B-class drones becomes apparent when they are taken \
	out of their area of specialization, with the B-class drones swiftly becoming useless. They incur a hefty fee for the production of the initial \
	codeline, as their emergent potential is far greater, and a smaller but still substantial fee for the production of forks. The market for B-class \
	drones is a battleground between Ward-Takahashi and NanoTrasen, with other firms usually producing B-classes for in-house needs."

/datum/lore/codex/page/class_a/add_content()
	name = "A Class"
	keywords += list("AGI")
	data = "A-class drones are also referred to as AGI. A-class drones are capable of performing in many contexts and can learn to solve problems from \
	first principles, with an incredible potential for growth and emergent behavior. However, some abilities fall short of humans’, usually those relating \
	to socialization, and they often act in ways that are strange or distressing. There is a small but growing lobby of support for the personhood of A-class \
	drones. The cost of initializing an A-class drone is absolutely massive, as they will be monitored by [quick_link("EIO")] forever. The auditing cost of an A-class drone \
	codeline is even more staggering, making development and deployment of AGI limited to research, highly difficult and high-throughput operations like habitat \
	overwatch, and a few risk-taking firms banking on the associated fees dropping. There is not a proper market for A-class drones, although an appreciable \
	fraction of them are made by [quick_link("NanoTrasen")], with the rest generally being university research projects."

/datum/lore/codex/page/class_aa
	name = "AA Class"
	data = "AA-class drones <b>do not yet exist</b>. Hypothetically, they are equal to living in every respect, with psychology that would not be abnormal in a baseline \
	human. The type of AA-class drone most frequently discussed is a hypothetical digitized consciousness of a human, a human brain that is somehow translated into \
	software. Some argue that a small fraction of the A-class drones would more properly be considered AA, but as of yet no action has been taken. Some Mercurials \
	will jokingly refer to themselves or other organics and positronics as AA’s. Research into brain uploading is heavily regulated and generally illegal."

/datum/lore/codex/page/class_aaa
	name = "AAA Class"
	data = "AAA-class drones do not yet exist, hopefully. They are more competent in every way than humans and pose a threat to the continued existence of sapient life. \
	Anybody creating an AAA-class drone can be classified as a threat to humanity and dealt with very harshly."

/datum/lore/codex/page/class_x
	name = "X Class"
	data = "X-class drones emerge from unrated software, are produced by rogue labs, or cross the border from foreign space. They are considered a threat to national \
	security and deleted when encountered in SolGov space, with the producers prosecuted legally if it has a SolGov origin. The few Skrellian drone labs will usually \
	rate their product with EIO to allow their product to be imported."
*/