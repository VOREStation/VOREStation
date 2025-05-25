/datum/component/drippy
	var/drip_chance = 5
	var/blood_color = "#A10808"

	var/mob/living/owner

/datum/component/drippy/Initialize()

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent

	if(ishuman(parent))
		var/mob/living/carbon/human/temp_owner = parent
		blood_color = rgb(temp_owner.r_skin,temp_owner.g_skin,temp_owner.b_skin)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/drippy/proc/process_component()
	if(QDELETED(parent))
		return
	if(!prob(drip_chance))
		return
	if(owner.stat == DEAD)
		return
	if(owner.inStasisNow())
		return
	var/turf/T = get_turf(owner.loc)
	if(!isturf(T))
		return
	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(drips.len < 4)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len)
		drop.add_overlay(drips)
		drop.drips |= drips

	B.basecolor = blood_color
	B.update_icon()
	if(istype(B, drop)) //We're a drop.
		B.name = "drips of something"
	else //We're a puddle.
		B.name = "puddle of something"
	B.desc = "It's thick and gooey. Perhaps it's the chef's cooking?"
	B.dryname = "dried something"
	B.drydesc = "It's dry and crusty. The janitor isn't doing their job."
	B.fluorescent  = 0
	B.invisibility = INVISIBILITY_NONE


/datum/component/drippy/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner = null
	. = ..()
