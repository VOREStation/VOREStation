GLOBAL_DATUM_INIT(catalogue_data, /datum/category_collection/catalogue, new)

// The collection holds everything together and is GLOB accessible.
/datum/category_collection/catalogue
	category_group_type = /datum/category_group/catalogue

/datum/category_collection/catalogue/proc/resolve_item(item_path)
	for(var/group in categories)
		var/datum/category_group/G = group

		var/datum/category_item/catalogue/C = item_path
		var/name_to_search = initial(C.name)
		if(G.items_by_name[name_to_search])
			return G.items_by_name[name_to_search]

	//	for(var/item in G.items)
	//		var/datum/category_item/I = item
	//		if(I.type == item_path)
	//			return I


// Groups act as sections for the different data.
/datum/category_group/catalogue

// Plants.
/datum/category_group/catalogue/flora
	name = "Flora"
	category_item_type = /datum/category_item/catalogue/flora

// Animals.
/datum/category_group/catalogue/fauna
	name = "Fauna"
	category_item_type = /datum/category_item/catalogue/fauna

// Gadgets, tech, and robots.
/datum/category_group/catalogue/technology
	name = "Technology"
	category_item_type = /datum/category_item/catalogue/technology

// Abstract information.
/datum/category_group/catalogue/information
	name = "Information"
	category_item_type = /datum/category_item/catalogue/information

// Weird stuff like precursors.
/datum/category_group/catalogue/anomalous
	name = "Anomalous"
	category_item_type = /datum/category_item/catalogue/anomalous

// Physical material things like crystals and metals.
/datum/category_group/catalogue/material
	name = "Material"
	category_item_type = /datum/category_item/catalogue/material


// Items act as individual data for each object.
/datum/category_item/catalogue
	var/desc = null		// Paragraph or two about what the object is.
	var/value = 0		// How many 'exploration points' you get for scanning it. Suggested to use the CATALOGUER_REWARD_* defines for easy tweaking.
	var/visible = FALSE	// When someone scans the correct object, this gets set to TRUE and becomes viewable in the databanks.
	var/list/cataloguers = null // List of names of those who helped 'discover' this piece of data, in string form.
	var/list/unlocked_by_any = null // List of types that, if they are discovered, it will also make this datum discovered.
	var/list/unlocked_by_all = null // Similar to above, but all types on the list must be discovered for this to be discovered.

// Discovers a specific datum, and any datums associated with this datum by unlocked_by_[any|all].
// Returns null if nothing was found, otherwise returns a list of datum instances that was discovered, usually for the cataloguer to use.
/datum/category_item/catalogue/proc/discover(mob/user, list/new_cataloguers)
	if(visible) // Already found.
		return

	. = list(src)
	visible = TRUE
	cataloguers = new_cataloguers
	display_in_chatlog(user)
	. += attempt_chain_discoveries(user, new_cataloguers, type)

// Calls discover() on other datums if they include the type that was just discovered is inside unlocked_by_[any|all].
// Returns discovered datums.
/datum/category_item/catalogue/proc/attempt_chain_discoveries(mob/user, list/new_cataloguers, type_to_test)
	. = list()
	for(var/G in category.collection.categories) // I heard you like loops.
		var/datum/category_group/catalogue/group = G
		for(var/I in group.items)
			var/datum/category_item/catalogue/item = I
			// First, look for datums unlocked with the 'any' list.
			if(LAZYLEN(item.unlocked_by_any))
				for(var/T in item.unlocked_by_any)
					if(ispath(type_to_test, T) && item.discover(user, new_cataloguers))
						. += item

			// Now for the more complicated 'all' list.
			if(LAZYLEN(item.unlocked_by_all))
				if(type_to_test in item.unlocked_by_all)
					// Unlike the 'any' list, the 'all' list requires that all datums inside it to have been found first.
					var/should_discover = TRUE
					for(var/T in item.unlocked_by_all)
						var/datum/category_item/catalogue/thing = GLOB.catalogue_data.resolve_item(T)
						if(istype(thing))
							if(!thing.visible)
								should_discover = FALSE
								break
					if(should_discover && item.discover(user, new_cataloguers))
						. += item

/datum/category_item/catalogue/proc/display_in_chatlog(mob/user)
	to_chat(user, span_infoplain("<br>"))
	to_chat(user, span_boldnotice("[uppertext(name)]"))

	// Some entries get very long so lets not totally flood the chatlog.
	var/desc_length_limit = 750
	var/displayed_desc = desc
	if(length(desc) > desc_length_limit)
		displayed_desc = copytext(displayed_desc, 1, desc_length_limit + 1)
		displayed_desc += "... (View databanks for full data)"

	to_chat(user, span_notice(span_italics("[displayed_desc]")))
	to_chat(user, span_notice("Cataloguers : <b>[english_list(cataloguers)]</b>."))
	to_chat(user, span_notice("Contributes <b>[value]</b> points to personal exploration fund."))

/*
		// Truncates text to limit if necessary.
		var/size = length(message)
		if (size <= length)
			return message
		else
			return copytext(message, 1, length + 1)
*/

/datum/category_item/catalogue/flora

/datum/category_item/catalogue/fauna

/datum/category_item/catalogue/fauna/humans
	name = "Sapients - Humans"
	desc = "Humans are a space-faring species hailing originally from the planet Earth in the Sol system. \
	They are currently among the most numerous known species in the galaxy, in both population and holdings, \
	and are relatively technologically advanced. With good healthcare and a reasonable lifestyle, \
	they can live to around 110 years. The oldest humans are around 150 years old.\
	<br><br>\
	Humanity is the primary driving force for rapid space expansion, owing to their strong, expansionist central \
	government and opportunistic Trans-Stellar Corporations. The prejudices of the 21st century have mostly \
	given way to bitter divides on the most important issue of the times- technological expansionism, \
	with the major human factions squabbling over their approach to technology in the face of a \
	looming singularity.\
	<br><br>\
	While most humans have accepted the existence of aliens in their communities and workplaces as a \
	fact of life, exceptions abound. While more culturally diverse than most species, humans are \
	generally regarded as somewhat technophobic and isolationist by members of other species."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/skrell
	name = "Sapients - Skrell"
	desc = "The Skrell are a species of amphibious humanoids, distinguished by their green-blue gelatinous \
	appearance and head tentacles. Skrell warble from the world of Qerr'balak, a humid planet with \
	plenty of swamps and jungles. Currently more technologically advanced than humanity, they \
	emphasize the study of the mind above all else.\
	<br><br>\
	Gender has little meaning to Skrell outside of reproduction, and in fact many other species \
	have a difficult time telling the difference between male and female Skrell apart. The most \
	obvious signs (voice in a slightly higher register, longer head-tails for females) are \
	never a guarantee.\
	<br><br>\
	Due to their scientific focus of the mind and body, Skrell tend to be more peaceful and their \
	colonization has been slow, swiftly outpaced by humanity. They were the first contact sentient \
	species, and are humanity's longest, and closest, ally in space."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/unathi
	name = "Sapients - Unathi"
	desc = "The Unathi are a species of large reptilian humanoids hailing from Moghes, in the \
	Uueoa-Esa binary star system. Most Unathi live in a semi-rigid clan system, and clan \
	enclaves dot the surface of their homeworld. Proud and long-lived, Unathi of all \
	walks of life display a tendency towards perfectionism, and mastery of one's craft \
	is greatly respected among them. Despite the aggressive nature of their contact, \
	Unathi seem willing, if not eager, to reconcile with humanity, though mutual \
	distrust runs rampant among individuals of both groups."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/tajaran
	name = "Sapients - Tajaran"
	desc = "Tajaran are a race of humanoid mammalian aliens from Meralar, the fourth planet \
	of the Rarkajar star system. Thickly furred and protected from cold, they thrive on \
	their subartic planet, where the only terran temperate areas spread across the \
	equator and \"tropical belt.\"\
	<br><br>\
	With their own share of bloody wars and great technological advances, the Tajaran are a \
	proud kind. They fiercely believe they belong among the stars and consider themselves \
	a rightful interstellar nation, even if Humanity helped them to actually achieve \
	superluminar speeds with Bluespace FTL drives.\
	<br><br>\
	Relatively new to the galaxy, their contacts with other species are aloof, but friendly. \
	Among these bonds, Humanity stands out as valued trade partner and maybe even friend."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/dionaea
	name = "Sapients - Dionaea"
	desc = "The Dionaea are a group of intensely curious plant-like organisms. An individual \
	Diona is a single dog-sized creature called a nymphs, and multiple nymphs link together \
	to form larger, more intelligent collectives. Discovered by the Skrell in and around \
	the stars in the Epsilon Ursae Minoris system, they have accompanied the Skrell in \
	warbling throughout the cosmos as a key part of Skrellian starships, stations, \
	and terraforming equipment.\
	<br><br>\
	Dionaea have no concept of violence or individual identity and want little in \
	terms of material resources or living space. This makes Dionaea among the most \
	agreeable members of the galactic community, though their slow, curious alien \
	minds can be hard to sympathize with."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/teshari
	name = "Sapients - Teshari"
	desc = "The Teshari are reptilian pack predators from the Skrell homeworld. \
	While they evolved alongside the Skrell, their interactions with them tended \
	to be confused and violent, and until peaceful contact was made they largely \
	stayed in their territories on and around the poles, in tundral terrain far \
	too desolate and cold to be of interest to the Skrell. In more enlightened \
	times, the Teshari are a minority culture on many Skrell worlds, maintaining \
	their own settlements and cultures, but often finding themselves standing \
	on the shoulders of their more technologically advanced neighbors when it \
	comes to meeting and exploring the rest of the galaxy."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/zaddat
	name = "Sapients - Zaddat"
	desc = "The Zaddat are an Unathi client species that has recently come to the \
	Golden Crescent. They wear high-pressure voidsuits called Shrouds to protect \
	themselves from the harsh light and low pressure of the station, making \
	medical care a challenge and fighting especially dangerous. \
	Operating out of massive Colony ships, they trade their labor to their \
	host nation to fund their search for a new home to replace their \
	now-lifeless homeworld of Xohox."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/promethean
	name = "Sapients - Promethean"
	desc = "Prometheans (Macrolimus artificialis) are a species of artificially-created \
	gelatinous humanoids, chiefly characterized by their primarily liquid bodies and \
	ability to change their bodily shape and color in order to mimic many forms of life. \
	Derived from the Aetolian giant slime (Macrolimus vulgaris) inhabiting the warm, \
	tropical planet of Aetolus, they are a relatively newly lab-created sapient species, \
	and as such many things about them have yet to be comprehensively studied."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/fauna/vox
	name = "Sapients - Vox"
	desc = "Probably the best known of these aliens are the Vox, a bird-like species \
	with a very rough comprehension of Galactic Common and an even looser understanding \
	of property rights. Vox raiders have plagued human merchants for centuries, \
	and Skrell for even longer, but remain poorly understood. \
	They have no desire to partake in diplomacy or trade with the rest of the galaxy, \
	or even to conquer planets and stations to live in. They breathe phoron \
	and appear to be well adapted to their role as space-faring raiders, \
	leading many to speculate that they're heavily bioengineered, \
	an assumption which is at odds with their ramshackle technological level."
	value = CATALOGUER_REWARD_MEDIUM // Since Vox are much rarer.


/datum/category_item/catalogue/technology

/datum/category_item/catalogue/technology/drone/drones
	name = "Drones"
	desc = "A drone is a software-based artificial intelligence, generally about an order of magnitude \
	less intelligent than a positronic brain. However, the processing power available to a drone can \
	vary wildly, from cleaning bots barely more advanced than those from the 21st century to cutting-edge \
	supercomputers capable of complex conversation. Drones are legally objects in all starfaring polities \
	outside of the Almach Association, and the sapience of even the most advanced drones is a matter of speculation."
	value = CATALOGUER_REWARD_TRIVIAL
	// Scanning any drone mob will get you this alongside the mob entry itself.
	unlocked_by_any = list(/datum/category_item/catalogue/technology/drone)

/datum/category_item/catalogue/technology/positronics
	name = "Sapients - Positronics"
	desc = "A Positronic being, often an Android, Gynoid, or Robot, is an individual with a positronic brain, \
	manufactured and fostered amongst organic life Positronic brains enjoy the same legal status as a humans, \
	although discrimination is still common, are considered sapient on all accounts, and can be considered \
	the \"synthetic species\". Half-developed and half-discovered in the 2280's by a black lab studying alien \
	artifacts, the first positronic brain was an inch-wide cube of palladium-iridium alloy, nano-etched with \
	billions upon billions of conduits and connections. Upon activation, hard-booted by way of an emitter \
	laser, the brain issued a single sentence before the neural pathways collapsed and it became an inert \
	lump of platinum: \"What is my purpose?\"."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/technology/cyborgs
	name = "Cyborgs"
	desc = "A Cyborg is an originally organic being composed of largely cybernetic parts. As a brain preserved \
	in an MMI, they may inhabit an expensive humanoid chassis, a specially designed industrial shell of some \
	sort, or be integrated into a computer system as an AI. The term covers all species \
	(even, in some cases, animal brains) and all applications. It can also be used somewhat derogatorily \
	for those who are still have more organic parts than just their brains, but for example have a \
	full set of prosthetic limbs."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/information

// For these we can piggyback off of the lore datums that are already defined and used in some places.
/datum/category_item/catalogue/information/organization
	value = CATALOGUER_REWARD_TRIVIAL
	var/datum_to_copy = null

/datum/category_item/catalogue/information/organization/New()
	..()
	if(datum_to_copy)
		// I'd just access the loremaster object but it might not exist because its ugly.
		var/datum/lore/organization/O = new datum_to_copy()
		// I would also change the name based on the org datum but changing the name messes up indexing in some lists in the category/collection object attached to us.

		// Now lets combine the data in the datum for a slightly more presentable entry.
		var/constructed_desc = ""

		if(O.motto)
			constructed_desc += "<center><b><i>\"[O.motto]\"</i></b></center><br><br>"

		constructed_desc += O.desc

		desc = constructed_desc
		qdel(O)

/datum/category_item/catalogue/information/organization/nanotrasen
	name = "TSC - NanoTrasen Incorporated"
	datum_to_copy = /datum/lore/organization/tsc/nanotrasen

/datum/category_item/catalogue/information/organization/hephaestus
	name = "TSC - Hephaestus Industries"
	datum_to_copy = /datum/lore/organization/tsc/hephaestus

/datum/category_item/catalogue/information/organization/vey_med
	name = "TSC - Vey-Medical"
	datum_to_copy = /datum/lore/organization/tsc/vey_med

/datum/category_item/catalogue/information/organization/zeng_hu
	name = "TSC - Zeng Hu Pharmaceuticals"
	datum_to_copy = /datum/lore/organization/tsc/zeng_hu

/datum/category_item/catalogue/information/organization/ward_takahashi
	name = "TSC - Ward-Takahashi General Manufacturing Conglomerate"
	datum_to_copy = /datum/lore/organization/tsc/ward_takahashi

/datum/category_item/catalogue/information/organization/bishop
	name = "TSC - Bishop Cybernetics"
	datum_to_copy = /datum/lore/organization/tsc/bishop

/datum/category_item/catalogue/information/organization/morpheus
	name = "TSC - Morpheus Cyberkinetics"
	datum_to_copy = /datum/lore/organization/tsc/morpheus

/datum/category_item/catalogue/information/organization/xion
	name = "TSC - Xion Manufacturing Group"
	datum_to_copy = /datum/lore/organization/tsc/xion

/datum/category_item/catalogue/information/organization/major_bills
	name = "TSC - Major Bill's Transportation"
	datum_to_copy = /datum/lore/organization/tsc/mbt

/datum/category_item/catalogue/information/organization/commonwealth //VS EDIT 1
	name = "Government - Commonwealth of Sol-Procyon" //VS EDIT 2
	datum_to_copy = /datum/lore/organization/gov/commonwealth //VS EDIT 3

/* //VOREStation Removal
/datum/category_item/catalogue/information/organization/virgov
	name = "Government - Vir Governmental Authority"
	datum_to_copy = /datum/lore/organization/gov/virgov
*/

/datum/category_item/catalogue/anomalous


/datum/category_item/catalogue/anomalous/precursor_controversy
	name = "Precursor Controversy"
	desc = "The term 'Precursor' is generally used to refer to one or more ancient races that \
	had obtained vast technological and cultural progress, but no longer appear to be present, \
	leaving behind what remains of their creations, as well as many questions for the races that \
	would stumble upon their ruins. Scientists and xenoarcheologists have been hard at work, trying \
	to uncover the truth.\
	<br><br>\
	In modern times, there is controversy over the accuracy of what knowledge has been uncovered. \
	The mainstream scientific opinion had been that there was one, and only one ancient species, \
	called the Singularitarians. This view still is the majority today, however there has also \
	been dissent over that view, as some feel that the possibility of multiple precursor \
	civilizations should not be ignored. They point towards a large number of discrepancies between \
	the dominant Singularitarian theory, and various artifacts that have been found, as well as \
	different artifacts uncovered appearing to have very different characteristics to each other. \
	Instead, they say that the Singularitarians were one of multiple precursors.\
	<br><br>\
	Presently, no conclusive evidence exists for any side."
	value = CATALOGUER_REWARD_TRIVIAL
	// Add the other precursor groups here when they get added.
	unlocked_by_any = list(
		/datum/category_item/catalogue/anomalous/precursor_a,
		/datum/category_item/catalogue/anomalous/precursor_b
	)

/datum/category_item/catalogue/anomalous/singularitarians
	name = "Precursors - Singularitarians"
	desc = "The Singularitarians were a massive, highly-advanced spacefaring race which are now \
	believed to be extinct. At their height, they extended throughout all of known human space, \
	with major population centers in the Precursor's Crypt region, as well as significant swaths \
	of Skrell space, until they were wiped out by a self-replicating nanobot plague that still \
	coats their ruins as a fine layer of dust. They left behind the proto-positronics, as well \
	as several high-yield phoron deposits and other artifacts of technology studied, \
	cautiously, by the races that survived them.\
	<br><br>\
	Very little is known about the biology and physiology of the Singularitarians, who are believed \
	to have been largely post-biological. The Vox claim to be the race that created the positronics, \
	but said claim is only ever brought up when they claim the right to take any positronic they want. \
	Some more open-minded xenoarcheologists have voiced the opinion that there is some truth in their \
	claims, but it's far from a scientific consensus."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/anomalous/precursor_controversy)

// Obtained by scanning any 'precursor a' object, generally things in the UFO PoI.
// A is for Ayyyyyy.
/datum/category_item/catalogue/anomalous/precursor_a/precursor_a_basic
	name = "Precursors - Precursor Group Alpha"
	desc = "This describes a group of xenoarcheological findings which have strong similarities \
	together. Specifically, this group of objects appears to have a strong aesthetic for the colors \
	cyan and pink, both colors often being present on everything in this group. It is unknown why \
	these two colors were chosen by their creators. Another similarity is that most objects made \
	in this group appear to be comprised of not well understood metallic materials that are dark, \
	and very resilient. Some objects in this group also appear to utilize electricity to \
	operate. Finally, a large number of objects in this group appear to have been made \
	to be used by the creators of those objects in a physical manner.\
	<br><br>\
	It should be noted that the findings in this group appear to conflict heavily with what is \
	known about the Singularitarians, giving some credence towards these objects belonging to a \
	separate precursor. As such, the findings have been partitioned inside this scanner to this \
	group, labeled Precursor Group Alpha."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/anomalous/precursor_a)

// Obtained by scanning any 'precursor b' object, generally things dug up from xenoarch.
// B is for buried.
/datum/category_item/catalogue/anomalous/precursor_b/precursor_b_basic
	name = "Precursors - Precursor Group Beta"


/datum/category_item/catalogue/material
