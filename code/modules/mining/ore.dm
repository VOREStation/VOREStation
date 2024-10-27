/obj/item/ore
	name = "small rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	randpixel = 8
	w_class = ITEMSIZE_SMALL
	var/datum/geosample/geologic_data
	var/material

/obj/item/ore/uranium
	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = "uranium"

/obj/item/ore/iron
	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "hematite"

/obj/item/ore/coal
	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "carbon"

/obj/item/ore/marble
	name = "recrystallized carbonate"
	icon_state = "ore_marble"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "marble"

/obj/item/ore/glass
	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "sand"
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, span_danger("Some of \the [src] gets in your eyes!"))
		H.Blind(5)
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


/obj/item/ore/phoron
	name = "phoron crystals"
	icon_state = "ore_phoron"
	origin_tech = list(TECH_MATERIAL = 2)
	material = "phoron"

/obj/item/ore/silver
	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = "silver"

/obj/item/ore/gold
	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = "gold"

/obj/item/ore/diamond
	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = "diamond"

/obj/item/ore/osmium
	name = "raw platinum"
	icon_state = "ore_platinum"
	material = "platinum"

/obj/item/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = "mhydrogen"

/obj/item/ore/verdantium
	name = "verdantite dust"
	icon_state = "ore_verdantium"
	material = MAT_VERDANTIUM
	origin_tech = list(TECH_MATERIAL = 7)

// POCKET ... Crystal dust.
/obj/item/ore/verdantium/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, span_danger("Some of \the [src] gets in your eyes!"))
		H.Blind(10)
		H.eye_blurry += 15
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)

/obj/item/ore/lead
	name = "lead glance"
	icon_state = "ore_lead"
	material = MAT_LEAD
	origin_tech = list(TECH_MATERIAL = 3)
/*
/obj/item/ore/copper
	name = "raw copper"
	icon_state = "ore_copper"
	material = "copper"

/obj/item/ore/tin
	name = "raw tin"
	icon_state = "ore_tin"
	material = "tin"

/obj/item/ore/bauxite
	name = "raw bauxite"
	icon_state = "ore_bauxite"
	material = "bauxite"
*/
/obj/item/ore/rutile
	name = "raw rutile"
	icon_state = "ore_rutile"
	material = "rutile"
/*
/obj/item/ore/void_opal
	name = "raw void opal"
	icon_state = "ore_void_opal"
	material = "void opal"

/obj/item/ore/painite
	name = "raw painite"
	icon_state = "ore_painite"
	material = "painite"

/obj/item/ore/quartz
	name = "raw quartz"
	icon_state = "ore_quartz"
	material = "quartz"
*/
/obj/item/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null

/obj/item/ore/Initialize()
	. = ..()
	randpixel_xy()

/obj/item/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

//VOREStation Add
/obj/item/ore/attack(mob/living/M as mob, mob/living/user as mob)
	if(M.handle_eat_minerals(src, user))
		return
	..()

/obj/item/ore/attack_generic(var/mob/living/user) //Allow adminbussed mobs to eat ore if they click it while NOT on help intent.
	if(user.handle_eat_minerals(src))
		return
	..()
//VOREStation Add End

/obj/item/ore_chunk
	name = "ore chunk"
	desc = "A conglomerate of ore."
	icon = 'icons/obj/mining_ore_vr.dmi'
	icon_state = "strange"
	randpixel = 8
	w_class = ITEMSIZE_SMALL
	var/list/stored_ore = list(
		"sand" = 0,
		"hematite" = 0,
		"carbon" = 0,
		"raw copper" = 0,
		"raw tin" = 0,
		"void opal" = 0,
		"painite" = 0,
		"quartz" = 0,
		"raw bauxite" = 0,
		"phoron" = 0,
		"silver" = 0,
		"gold" = 0,
		"marble" = 0,
		"uranium" = 0,
		"diamond" = 0,
		"platinum" = 0,
		"lead" = 0,
		"mhydrogen" = 0,
		"verdantium" = 0,
		"rutile" = 0)

/obj/item/ore_chunk/examine(mob/user)
	. = ..()

	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return .

	add_fingerprint(user) //You pick it up to look at it.

	. += "It is composed of:"
	var/has_ore = 0
	for(var/ore in stored_ore)
		if(stored_ore[ore] > 0)
			. += "- [stored_ore[ore]] [ore]"
			has_ore = 1
	if(!has_ore)
		. += "Nothing. You should contact a developer."
