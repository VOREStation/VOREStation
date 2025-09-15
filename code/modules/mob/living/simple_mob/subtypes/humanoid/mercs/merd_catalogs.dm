/datum/category_item/catalogue/fauna/mercenary
	name = "Mercenaries"
	desc = "Life on the Frontier is hard, and unregulated. Unlike life in \
	more 'civlized' areas of the Galaxy, violence and piracy remain common \
	this far out. The Megacorporations keep a tight grip on their holdings, \
	but there are always small bands or aspiring companies looking to make a \
	thaler. From simple pirates to legitimate PMCs, Frontier mercs come in \
	all shapes and sizes."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/mercenary)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_mercenaries
	name = "Collection - Mercenaries"
	desc = "You have scanned a large array of different types of mercenary, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/mercenary/human,
		/datum/category_item/catalogue/fauna/mercenary/human/peacekeeper,
		/datum/category_item/catalogue/fauna/mercenary/human/grenadier,
		/datum/category_item/catalogue/fauna/mercenary/human/space,
		/datum/category_item/catalogue/fauna/mercenary/human/space/suppressor,
		/datum/category_item/catalogue/fauna/mercenary/vox,
		/datum/category_item/catalogue/fauna/mercenary/vox/boarder,
		/datum/category_item/catalogue/fauna/mercenary/vox/technician,
		/datum/category_item/catalogue/fauna/mercenary/vox/suppressor,
		/datum/category_item/catalogue/fauna/mercenary/vox/captain
		)

/datum/category_item/catalogue/fauna/mercenary/human
	name = "Mercenaries - Human"
	desc = "Human Mercenary bands are extremely common on the Frontier. Many \
	of the modern outfits operating on the fringe today are veterans of the \
	Phoron Wars. After the dissolution of the Syndicate, these operatives were \
	left without a place to call home. Those who have survived have leveraged \
	their experience into a viable trade."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/mercenary/human/peacekeeper
	name = "Mercenaries - Solar Peacekeeper"
	desc = "Activist groups in Civlized Space often raise moral concerns about \
	conditions on the Frontier. The more organized groups will sometimes gather \
	bands of mercenaries from the core worlds together under the belief that they \
	can come out to the Frontier to enforce their way of life. Due to the Frontier \
	Act, these 'humanitarian operations' are quickly demolished."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/mercenary/human/grenadier
	name = "Mercenaries - Grenadier"
	desc = "After the Phoron Wars, many deniable operatives on both sides of \
	the conflict found that there was no place for them within their home companies \
	any more. Left without options, these highly motivated and trained specialists \
	often seek revenge, or attempt to carve out their own fiefdoms. Well equipped \
	and well trained, these outcasts are not to be taken lightly."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/mercenary/human/space
	name = "Mercenaries - Commando"
	desc = "Commandos, much like their less equipped brethren, are experts in \
	wet work. Honing their skills over years of training, the Commando's iconic \
	equipment summons memories of the bad old days in any survivor who sees them. \
	These mercs make a statement with their equipment - 'I was there. Come get me.' \
	It is usually not an idle boast."
	value = CATALOGUER_REWARD_EASY

// suppressors are just assholes and are intended to be a piss poor experience for everyone on both sides
/datum/category_item/catalogue/fauna/mercenary/human/space/suppressor
	name = "Mercenaries - Suppressor"
	desc = "Just because the Phoron Wars are over, it doesn't 		mean that covert \
	actions and corporate espionage ended too. When you encounter mercs with \
	the latest gear and the best training, you can bet your bottom Thaler that \
	they've got a Corporate sponsor backing them up."
	value = CATALOGUER_REWARD_MEDIUM

/datum/ai_holder/simple_mob/merc/ranged/suppressor
	respect_alpha = FALSE // he really just shoots you
	vision_range = 10 // plutonia experience
	conserve_ammo = FALSE
