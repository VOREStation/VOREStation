/datum/maint_recycler_vendor_entry/DIY_Wood
	name = "WOOD. WOOD. WOOD. WOOD."
	desc = "Dear Humanity. we WOULD those alien bastards. we WOULD those earthlings. and we most definately WOOD use these raggedy-ass materials to build something nice!!"
	object_type_to_spawn = /obj/item/stack/material/wood{amount = 20}
	item_cost = 15 //not too pricy
	tagline = "hehehe. Got Wood?"
	ad_message = "WOOD. WOOD. WOOD."
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_HardWood //this one writes itself
	name = "Hard... Knotty Wood... "
	desc = "Seriously! this tree sucked! Unusuable for professional construction due to how hard the knots are, the savings are passed onto YOU!!!"
	tagline = "Hehehehehe"
	ad_message = "🤤"
	icon_state = "knotty_wood"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	per_person_cap = 1
	per_round_cap = 3 //limited supply!


/datum/maint_recycler_vendor_entry/DIY_Steel
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "steel!"
	ad_message = "A Steal of a STEEL!"
	desc = "A steal of a deal! this steel is sure to make you feel like a real deal! buy now, please! I need the money!"
	object_type_to_spawn = /obj/item/stack/material/steel{amount = 20}
	item_cost = 15 //not too pricy
	icon_state = "steal"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Glass
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Glass! Glass! Glass!"
	ad_message = "Crystal Clear!"
	desc = "The savings are crystal clear! You'd be a FREAK to not see straight through it!"
	object_type_to_spawn = /obj/item/stack/material/glass{amount = 20}
	item_cost = 15 //not too pricy
	icon_state = "glass"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_PhoronGlass //technically a straight upgrade but pragmatically people just use it for stripper stages and cyberpunk esq hangouts
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Fru1ty G1a55"
	ad_message = "Fruity!"
	desc = "Not even the top minds at science know why it's pink! some say it's phoron! Sane people say it's gay!"
	object_type_to_spawn = /obj/item/stack/material/glass/phoronglass{amount = 20}
	item_cost = 15 //not too pricy
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Copper
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Copper!"
	ad_message = "Copper!"
	desc = "Used since ancient times, but still more recently than the last time your outfit was in fashion!"
	object_type_to_spawn = /obj/item/stack/material/copper{amount = 20}
	item_cost = 15 //not too pricy
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet
	name = "S0FT CURLY F1BR3S THAT M4TCH THE DRAPE???"
	ad_message = "BLACK!"
	desc = "PR3MIUM C4RP3T @ RESONABL PRICE!"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/fiftyspawner/bcarpet
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
