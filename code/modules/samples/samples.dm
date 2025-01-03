/obj/item/research_sample
	name = "research sample"
	desc = "A curious sample of unknown material. Destructive analysis might yield scientific advances. Alternatively, it may be possible to stabilize it to yield useful resources instead.<br/>" + span_warning("It looks dangerous to handle without heavy gloves or other protective equipment.")
	icon = 'icons/obj/samples.dmi'
	icon_state = "sample"
	w_class = ITEMSIZE_TINY
	var/tech_level = 0	//base level
	var/rand_level = 0	//random level between 0 and this value is added during spawn, if the techgroup is randomized
	var/fixed_tech = null	//do we have a predetermined tech-group, per request? if so, overrides randomization for icon and name
	var/rand_tech = null	//randomized tech-group from the list below
	var/list/valid_techs = list(TECH_COMBAT,TECH_MAGNET,TECH_POWER,TECH_BIO,TECH_DATA,TECH_ENGINEERING,TECH_PHORON,TECH_MATERIAL,TECH_BLUESPACE,TECH_ILLEGAL,TECH_ARCANE,TECH_PRECURSOR)
	origin_tech = list()	//blank list creation, or else we get a runtime trying to assign the new techgroup

	persist_storable = FALSE //don't shove hazardous shinies into the item bank!! also their properties are (usually) randomized on creation, so saving them is pointless-- you won't get out what you put in

	//handling requirements; you need gloves with a low permeability threshold, RIG gauntlets, or luck- otherwise you get hand burns
	var/handle_risk		= 20		//20% chance to hurty if you handle it wrong
	var/min_damage		= 3			//min: 3 burn per hand
	var/max_damage		= 5			//max: 5 burn per hand
	var/damage_type		= "BURN"	//defaults to burn, but randomized and can be preset if desired; currently supports brute, burn, tox, oxy, emp, and pain

	//resource returns when crunched; a small amount of OK stuff by default
	var/min_ore			= 3
	var/max_ore			= 5
	var/list/resource_list	=	list(/obj/item/ore/glass,/obj/item/ore/coal,/obj/item/ore/iron,/obj/item/ore/lead,/obj/item/ore/marble,/obj/item/ore/phoron,/obj/item/ore/silver,/obj/item/ore/gold)

/obj/item/research_sample/New()
	var/tech_mod = rand(0,rand_level)
	var/tech_value = tech_level+tech_mod
	if(fixed_tech)
		origin_tech.Add(list("[fixed_tech]" = tech_value))
	else	//if we're not a preset, randomize the name, icon, and associated tech, to make sure samples aren't predictable/metagamable
		var/name_prefix = "[pick("strange","anomalous","exotic","atypical","unusual","incongruous","weird","aberrant","eccentric")]"
		var/name_suffix		//blank because it's randomized per sample appearance
		var/sample_icon = rand(1,10)
		icon_state = "generic_sample[sample_icon]"
		damage_type = pick("BRUTE","BURN","TOX","OXY","EMP","PAIN")
		//per-state tweaks, like glows/light emission or narrower valid tech defs, if desired
		switch(sample_icon)
			if(1)	//prism
				name_suffix = "[pick("alloy","object","sample","element","chunk")]"
			if(2)	//ring
				name_suffix = "[pick("ring","band","torus","circuit","halo","hoop")]"
			if(3)	//red stone
				name_suffix = "[pick("gem","crystal","jewel","stone","bauble","rock")]"
			if(4)	//circuit scrap
				name_suffix = "[pick("circuit","board","scrap","junk","object","device")]"
			if(5)	//crystal star
				name_suffix = "[pick("gem","crystal","jewel","stone","bauble","rock","star")]"
			if(6)	//spore
				name_suffix = "[pick("glob","spore","blob","corpuscle","macroorganism","vacuole")]"
			if(7)	//device
				name_suffix = "[pick("device","gadget","widget","object","apparatus","contraption","gizmo","object","doohickey")]"
			if(8)	//purple shard
				name_suffix = "[pick("shard","fragment","sliver","remnant")]"
			if(9)	//purple rock
				name_suffix = "[pick("rock","stone","slab","rubble","mineral","mass","boulder","slag")]"
			if(10)	//green rock
				name_suffix = "[pick("rock","stone","slab","rubble","mineral","mass","boulder","slag")]"
			else	//none
				name_suffix = "[pick("object","sample","thing","fragment","specimen","element","alloy","chunk","remnant","scrap","sliver")]"
		name = "[name_prefix] [name_suffix]"
		rand_tech = pick(valid_techs)	//assign techs last
		origin_tech.Add(list("[rand_tech]" = tech_value))

/obj/item/research_sample/attack_hand(mob/user)
	. = ..()
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		var/obj/item/clothing/suit/S = H.wear_suit
		var/gloves_permeability	= 1
		var/suit_permeability = 1
		if(istype(G))
			gloves_permeability = G.permeability_coefficient
		if(istype(S) && S.body_parts_covered & HANDS)	//if it's a suit *and* it covers our hands
			suit_permeability = S.permeability_coefficient
		if((min(gloves_permeability,suit_permeability) < 0.25) || !prob(handle_risk))
			burn_user = FALSE

		if(burn_user)
			switch(damage_type)
				if("BRUTE")
					H.visible_message(span_danger("\The [src] creaks as it ravages [H]'s hands!"))
					H.apply_damage(rand(min_damage,max_damage), BRUTE, "r_hand", used_weapon="Anomalous Material")
					H.apply_damage(rand(min_damage,max_damage), BRUTE, "l_hand", used_weapon="Anomalous Material")
				if("BURN")
					H.visible_message(span_danger("\The [src] flashes as it scorches [H]'s hands!"))
					H.apply_damage(rand(min_damage,max_damage), BURN, "r_hand", used_weapon="Anomalous Material")
					H.apply_damage(rand(min_damage,max_damage), BURN, "l_hand", used_weapon="Anomalous Material")
				if("TOX")
					H.visible_message(span_danger("\The [src] seethes and hisses like burning acid!"))
					if(!H.isSynthetic())
						to_chat(user,span_danger("A wave of nausea washes over you!"))
						H.adjustToxLoss(rand(min_damage,max_damage)+rand(min_damage,max_damage))
				if("OXY")
					H.visible_message(span_danger("\The [src] seems to draw something into itself!"))
					if(!H.isSynthetic())
						to_chat(user,span_danger("You feel dizzy and short of breath!"))
						H.adjustOxyLoss(rand(min_damage,max_damage)+rand(min_damage,max_damage))
				if("EMP")
					H.visible_message(span_danger("\The [src] ripples and distorts, emitting some kind of pulse!"))
					empulse(H,0,1,1,1)
				if("PAIN")
					H.visible_message(span_danger("\The [src] flashes with coruscating energy!"))
					to_chat(user,span_danger("Blinding pain assails your senses!"))
					H.adjustHalLoss(rand(min_damage,max_damage)*5)
				else
					H.visible_message(span_notice("\The [src] flickers with kaleidoscopic light. You should report this to someone immediately."))
			H.drop_from_inventory(src, get_turf(H))
			return

	if(isrobot(user))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(rand(min_damage,max_damage), BURN, null, used_weapon="Anomalous Material")

/obj/item/research_sample/attack_self(mob/user)
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		var/obj/item/clothing/suit/S = H.wear_suit
		var/gloves_permeability	= 1
		var/suit_permeability = 1
		if(istype(G))
			gloves_permeability = G.permeability_coefficient
		if(istype(S) && S.body_parts_covered & HANDS)	//if it's a suit *and* it covers our hands
			suit_permeability = S.permeability_coefficient
		if((min(gloves_permeability,suit_permeability) < 0.25) || !prob(handle_risk))
			burn_user = FALSE

		if(burn_user)
			switch(damage_type)
				if("BRUTE")
					H.visible_message(span_danger("\The [src] creaks as it ravages [H]'s hands!"))
					H.apply_damage(rand(min_damage,max_damage), BRUTE, "r_hand", used_weapon="Anomalous Material")
					H.apply_damage(rand(min_damage,max_damage), BRUTE, "l_hand", used_weapon="Anomalous Material")
				if("BURN")
					H.visible_message(span_danger("\The [src] flashes as it scorches [H]'s hands!"))
					H.apply_damage(rand(min_damage,max_damage), BURN, "r_hand", used_weapon="Anomalous Material")
					H.apply_damage(rand(min_damage,max_damage), BURN, "l_hand", used_weapon="Anomalous Material")
				if("TOX")
					H.visible_message(span_danger("\The [src] seethes and hisses like burning acid!"))
					if(!H.isSynthetic())
						to_chat(user,span_danger("A wave of nausea washes over you!"))
						H.adjustToxLoss(rand(min_damage,max_damage)+rand(min_damage,max_damage))
				if("OXY")
					H.visible_message(span_danger("\The [src] seems to draw something into itself!"))
					if(!H.isSynthetic())
						to_chat(user,span_danger("You feel dizzy and short of breath!"))
						H.adjustOxyLoss(rand(min_damage,max_damage)+rand(min_damage,max_damage))
				if("EMP")
					H.visible_message(span_danger("\The [src] ripples and distorts, emitting some kind of pulse!"))
					empulse(H,0,1,1,1)
				if("PAIN")
					H.visible_message(span_danger("\The [src] flashes with coruscating energy!"))
					to_chat(user,span_danger("Blinding pain assails your senses!"))
					H.adjustHalLoss(rand(min_damage,max_damage)*5)
				else
					H.visible_message(span_notice("\The [src] flickers with kaleidoscopic light. You should report this to someone immediately."))
			H.drop_from_inventory(src, get_turf(H))
			return

		else if(do_after(user,3 SECONDS))	//short delay, so you can abort/cancel if you misclick
			H.visible_message(span_notice("[H] crushes \the [src], stabilizing its anomalous properties and rendering it into a pile of assorted minerals."))
			var/i = rand(min_ore,max_ore)
			while(i>1)
				var/ore = pick(resource_list)
				new ore(H.loc)
				i--
			H.drop_from_inventory(src,get_turf(H))
			qdel(src)

	if(isrobot(user))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(rand(min_damage,max_damage), BURN, null, used_weapon="Anomalous Material")

/obj/item/research_sample/attackby(obj/item/P as obj, mob/user as mob)
	..()

	if(istype(P, /obj/item/storage/sample_container))
		var/obj/item/storage/sample_container/SC = P
		if(SC.contents.len >= SC.max_storage_space)
			to_chat(user, span_notice("\The [SC] is full!"))
			return
		else
			src.loc = SC
			SC.update_icon()
			to_chat(user, span_notice("You store \the [src] in \the [SC]."))

	if(istype(P, /obj/item/cataloguer))
		to_chat(user, span_notice("You start to scan \the [src] with \the [P]..."))
		if(do_after(user, 2 SECONDS))
			to_chat(user, span_notice("\The [src] seems to have [origin_tech[1]] properties?"))

/obj/item/research_sample/common
	tech_level = 2 //2~3
	rand_level = 1
	valid_techs = list(TECH_COMBAT,TECH_MAGNET,TECH_POWER,TECH_BIO,TECH_DATA,TECH_ENGINEERING,TECH_PHORON,TECH_MATERIAL)
	catalogue_data = list(/datum/category_item/catalogue/information/research_sample/common)

/obj/item/research_sample/uncommon
	tech_level = 4 //4~6
	rand_level = 2
	valid_techs = list(TECH_COMBAT,TECH_MAGNET,TECH_POWER,TECH_BIO,TECH_DATA,TECH_ENGINEERING,TECH_PHORON,TECH_MATERIAL,TECH_BLUESPACE,TECH_ILLEGAL)
	catalogue_data = list(/datum/category_item/catalogue/information/research_sample/uncommon)

	handle_risk		= 50
	min_damage		= 4
	max_damage		= 6

	//modest amount of decent stuff
	min_ore			= 4
	max_ore			= 6
	resource_list	= list(/obj/item/ore/phoron,/obj/item/ore/silver,/obj/item/ore/gold,/obj/item/ore/osmium,/obj/item/ore/diamond)

/obj/item/research_sample/rare
	tech_level = 6 //6~8
	rand_level = 2
	valid_techs = list(TECH_COMBAT,TECH_MAGNET,TECH_POWER,TECH_BIO,TECH_DATA,TECH_ENGINEERING,TECH_PHORON,TECH_MATERIAL,TECH_BLUESPACE,TECH_ILLEGAL,TECH_ARCANE,TECH_PRECURSOR)
	catalogue_data = list(/datum/category_item/catalogue/information/research_sample/rare)

	handle_risk		= 80
	min_damage		= 5
	max_damage		= 10

	//a decent amount of rare stuff only
	min_ore			= 8
	max_ore			= 10
	resource_list	=	list(/obj/item/ore/osmium,/obj/item/ore/uranium,/obj/item/ore/hydrogen,/obj/item/ore/diamond,/obj/item/ore/verdantium)

/obj/item/research_sample/bluespace
	name = "bluespace anomaly"
	desc = "A small, solidified fragment of bluespace? It shimmers in and out of phase with reality, flickering ominously."
	icon_state = "sample_bluespace"
	tech_level = 6 //always 6
	rand_level = 0
	fixed_tech = TECH_BLUESPACE
	var/lightcolor = "#0066CC"
	catalogue_data = list(/datum/category_item/catalogue/information/research_sample/bluespace)

	handle_risk		= 80
	min_damage		= 5
	max_damage		= 10

	//a single bluespace crystal
	min_ore			= 1
	max_ore			= 1
	resource_list	=	list(/obj/item/bluespace_crystal)

/obj/item/research_sample/bluespace/New()
	..()
	set_light(1, 3, lightcolor)

//catalogue data
/datum/category_item/catalogue/information/research_sample/core_data
	name = "Collection - Anomalous Matter"
	desc = "Samples of various kinds of matter exposed to strange energy fields, exotic stellar radiation, or other unusual conditions, these objects are of great interest to most scientific institutions as they present novel research opportunities in a wide variety of fields, whether it's studying the material compositions themselves, the effects that exposure has had on them, or their other properties such as conductivity, flammability, and so on. There's no telling what kind of breakthroughs could be made.\
	<br><br>\
	Perhaps the best known example of this type of object would be the now-ubiquitous Phoron. Whilst many of these samples are the equivalent of evolutionary \'dead ends\' in most respects, many can still yield intriguing results and unique possibilities - not to mention wealth and fame for those who discover a promising specimen.\
	<br><br>\
	Their exact composition often varies wildly, which means handling them without protective equipment can be a risky endeavour."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/information/research_sample/common,
		/datum/category_item/catalogue/information/research_sample/uncommon,
		/datum/category_item/catalogue/information/research_sample/rare,
		/datum/category_item/catalogue/information/research_sample/bluespace
		)

/datum/category_item/catalogue/information/research_sample/common
	name = "Anomalous Sample - Common"
	desc = "A chunk of mildly anomalous matter. It seems mostly safe to handle, but care should be taken nonetheless."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/information/research_sample/uncommon
	name = "Anomalous Sample - Uncommon"
	desc = "A chunk of moderately anomalous matter. Could be quite dangerous to handle unprotected."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/information/research_sample/rare
	name = "Anomalous Sample - Rare"
	desc = "A chunk of exceptionally anomalous matter. It's likely very dangerous to handle without protective equipment."
	value = CATALOGUER_REWARD_HARD

/datum/category_item/catalogue/information/research_sample/bluespace
	name = "Anomalous Sample - Bluespace"
	desc = "A semi-crystalline particle of anomalous origin. Cataloguer sensors indicate it has extremely strong quasidimensional entanglements. Handling it without protective equipment is likely very unwise."
	value = CATALOGUER_REWARD_HARD

/obj/random/research_sample_type1
	name = "Random Research Sample"
	desc = "Spawns a random research sample of any quality."
	icon = 'icons/obj/samples.dmi'
	icon_state = "sample_spawner1"

/obj/random/research_sample_type1/item_to_spawn()
	return pick(prob(50);/obj/item/research_sample/common,
				prob(35);/obj/item/research_sample/uncommon,
				prob(15);/obj/item/research_sample/rare)

/obj/random/research_sample_type2
	name = "Random Common/Uncommon Research Sample"
	desc = "Spawns a random research sample of common or uncommon quality."
	icon = 'icons/obj/samples.dmi'
	icon_state = "sample_spawner2"

/obj/random/research_sample_type2/item_to_spawn()
	return pick(prob(70);/obj/item/research_sample/common,
				prob(30);/obj/item/research_sample/uncommon)

/obj/random/research_sample_type3
	name = "Random Uncommon/Rare Research Sample"
	desc = "Spawns a random research sample of uncommon or rare quality."
	icon = 'icons/obj/samples.dmi'
	icon_state = "sample_spawner3"

/obj/random/research_sample_type3/item_to_spawn()
	return pick(prob(70);/obj/item/research_sample/uncommon,
				prob(30);/obj/item/research_sample/rare)
