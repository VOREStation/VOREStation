/obj/item/organ/external/chest/unbreakable/slime
	nonsolid = 1
	max_damage = 50
	encased = 0
	spread_dam = 1

/obj/item/organ/external/groin/unbreakable/slime
	nonsolid = 1
	max_damage = 30
	spread_dam = 1

/obj/item/organ/external/arm/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/arm/right/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/leg/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/leg/right/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/foot/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/foot/right/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/hand/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/hand/right/unbreakable/slime
	nonsolid = 1
	max_damage = 20
	spread_dam = 1

/obj/item/organ/external/head/unbreakable/slime	//They don't need this anymore.
	nonsolid = 1
	cannot_gib = 0
	vital = 0
	max_damage = 30
	encased = 0
	spread_dam = 1

/*
 * Internal Slime organs.
 */

/obj/item/organ/internal/heart/grey/colormatch/slime
	name = "pneumatic network"
	desc = "A disgusting sac of goo."
	icon_state = "sac_slime"
	dead_icon = null
	standard_pulse_level = PULSE_NONE

/obj/item/organ/internal/heart/grey/colormatch/slime/process()
	..()
	if(!(QDELETED(src)) && src.loc != owner)
		visible_message("<b>\The [src]</b> splatters!")
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/blood/B = new (T)

		B.basecolor = src.color
		B.update_icon()
		qdel(src)

/obj/item/organ/internal/regennetwork
	name = "pneumoregenesis network"
	parent_organ = BP_TORSO
	organ_tag = O_REGBRUTE

	icon_state = "sac_slime"

	var/strain = 0	// The amount of stress this organ is under. Capped at min_broken_damage, usually half its max damage.

	var/last_strain_increase = 0	// World time of the last increase in strain.
	var/strain_regen_cooldown = 5 MINUTES

/obj/item/organ/internal/regennetwork/Initialize()
	. = ..()
	var/mob/living/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.get_blood_colour(H)

/obj/item/organ/internal/regennetwork/proc/get_strain_percent(var/cost)
	adjust_strain(cost)

	if((status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN) || (status & ORGAN_DEAD))
		return 1

	return round((strain / min_broken_damage) * 10) / 10

/obj/item/organ/internal/regennetwork/proc/adjust_strain(var/amount)
	if(amount < 0 && world.time < (last_strain_increase + strain_regen_cooldown))
		return

	else if(amount > 0)
		last_strain_increase = world.time

	strain = CLAMP(strain + amount, 0, min_broken_damage)

/obj/item/organ/internal/regennetwork/process()
	..()

	if(!(QDELETED(src)) && src.loc != owner)
		visible_message("<b>\The [src]</b> splatters!")
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/blood/B = new (T)

		B.basecolor = src.color
		B.update_icon()
		qdel(src)

	if(src && !is_bruised())
		adjust_strain(-0.25 * max(0, (min_broken_damage - damage) / min_broken_damage)) // Decrease the current strain with respect to the current strain level.

/obj/item/organ/internal/regennetwork/burn
	name = "thermoregenesis network"
	organ_tag = O_REGBURN

/obj/item/organ/internal/regennetwork/oxy
	name = "respiroregenesis network"
	organ_tag = O_REGOXY

/obj/item/organ/internal/regennetwork/tox
	name = "toxoregenesis network"
	organ_tag = O_REGTOX
