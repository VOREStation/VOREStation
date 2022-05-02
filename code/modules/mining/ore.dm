/obj/item/weapon/ore
	name = "small rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	randpixel = 8
	w_class = ITEMSIZE_SMALL
	var/datum/geosample/geologic_data
	var/material

/obj/item/weapon/ore/uranium
	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = "uranium"

/obj/item/weapon/ore/iron
	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "hematite"

/obj/item/weapon/ore/coal
	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "carbon"

/obj/item/weapon/ore/marble
	name = "recrystallized carbonate"
	icon_state = "ore_marble"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "marble"

/obj/item/weapon/ore/glass
	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "sand"
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/weapon/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(5)
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


/obj/item/weapon/ore/phoron
	name = "phoron crystals"
	icon_state = "ore_phoron"
	origin_tech = list(TECH_MATERIAL = 2)
	material = "phoron"

/obj/item/weapon/ore/silver
	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = "silver"

/obj/item/weapon/ore/gold
	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = "gold"

/obj/item/weapon/ore/diamond
	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = "diamond"

/obj/item/weapon/ore/osmium
	name = "raw platinum"
	icon_state = "ore_platinum"
	material = "platinum"

/obj/item/weapon/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = "mhydrogen"

/obj/item/weapon/ore/verdantium
	name = "verdantite dust"
	icon_state = "ore_verdantium"
	material = MAT_VERDANTIUM
	origin_tech = list(TECH_MATERIAL = 7)

// POCKET ... Crystal dust.
/obj/item/weapon/ore/verdantium/throw_impact(atom/hit_atom)
	..()
	var/mob/living/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(10)
		H.eye_blurry += 15
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)

/obj/item/weapon/ore/lead
	name = "lead glance"
	icon_state = "ore_lead"
	material = MAT_LEAD
	origin_tech = list(TECH_MATERIAL = 3)
/*
/obj/item/weapon/ore/copper
	name = "raw copper"
	icon_state = "ore_copper"
	material = "copper"

/obj/item/weapon/ore/tin
	name = "raw tin"
	icon_state = "ore_tin"
	material = "tin"

/obj/item/weapon/ore/bauxite
	name = "raw bauxite"
	icon_state = "ore_bauxite"
	material = "bauxite"
*/
/obj/item/weapon/ore/rutile
	name = "raw rutile"
	icon_state = "ore_rutile"
	material = "rutile"
/*
/obj/item/weapon/ore/void_opal
	name = "raw void opal"
	icon_state = "ore_void_opal"
	material = "void opal"

/obj/item/weapon/ore/painite
	name = "raw painite"
	icon_state = "ore_painite"
	material = "painite"

/obj/item/weapon/ore/quartz
	name = "raw quartz"
	icon_state = "ore_quartz"
	material = "quartz"
*/
/obj/item/weapon/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null

/obj/item/weapon/ore/Initialize()
	. = ..()
	randpixel_xy()

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

//VOREStation Add
/obj/item/weapon/ore/attack(mob/living/M as mob, mob/living/user as mob)
	if(M.handle_eat_minerals(src, user))
		return
	..()

/obj/item/weapon/ore/attack_generic(var/mob/living/user) //Allow adminbussed mobs to eat ore if they click it while NOT on help intent.
	if(user.handle_eat_minerals(src))
		return
	..()
//VOREStation Add End
