/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/vfx/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/vfx/smoke/Initialize()
	. = ..()
	QDEL_IN(src, time_to_live)

/obj/effect/vfx/smoke/Crossed(mob/living/human/M as mob )
	if(M.is_incorporeal())
		return
	..()
	if(istype(M))
		affect(M)

/obj/effect/vfx/smoke/proc/affect(var/mob/living/human/M)
	if (!istype(M))
		return 0
	if(M.wear_mask && (M.wear_mask.item_flags & AIRTIGHT))
		return 0
	if(istype(M,/mob/living/human))
		var/mob/living/human/H = M
		if(H.head && (H.head.item_flags & AIRTIGHT))
			return 0
	return 1

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////

/obj/effect/vfx/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/vfx/smoke/illumination/New(var/newloc, var/lifetime=10, var/range=null, var/power=null, var/color=null)
	time_to_live=lifetime
	..()
	set_light(range, power, color)

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/vfx/smoke/bad
	time_to_live = 600
	//var/list/projectiles

/obj/effect/vfx/smoke/bad/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	for(var/mob/living/L in get_turf(src))
		affect(L)

/obj/effect/vfx/smoke/bad/affect(var/mob/living/L)
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.adjustOxyLoss(1)
		if(prob(25))
			L.emote("cough")

/obj/effect/vfx/smoke/bad/noxious
	opacity = 0

/obj/effect/vfx/smoke/bad/noxious/affect(var/mob/living/L)
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.adjustToxLoss(1)

// Burnt Food Smoke (Specialty for Cooking Failures)
/obj/effect/vfx/smoke/bad/burntfood
	color = "#000000"
	time_to_live = 600
	
/obj/effect/vfx/smoke/bad/burntfood/process()
	for(var/mob/living/L in get_turf(src))
		affect(L)
	
/obj/effect/vfx/smoke/bad/burntfood/affect(var/mob/living/L) // This stuff is extra-vile.
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.emote("cough")

/////////////////////////////////////////////
// 'Elemental' smoke
/////////////////////////////////////////////

/obj/effect/vfx/smoke/elemental
	name = "cloud"
	desc = "A cloud of some kind that seems really generic and boring."
	opacity = FALSE
	var/strength = 5 // How much damage to do inside each affect()

/obj/effect/vfx/smoke/elemental/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/vfx/smoke/elemental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/vfx/smoke/elemental/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	for(var/mob/living/L in range(1, src))
		affect(L)

/obj/effect/vfx/smoke/elemental/process()
	for(var/mob/living/L in range(1, src))
		affect(L)


/obj/effect/vfx/smoke/elemental/fire
	name = "burning cloud"
	desc = "A cloud of something that is on fire."
	color = "#FF9933"
	light_color = "#FF0000"
	light_range = 2
	light_power = 5

/obj/effect/vfx/smoke/elemental/fire/affect(mob/living/L)
	L.inflict_heat_damage(strength)
	L.add_modifier(/datum/modifier/fire, 6 SECONDS) // Around 15 damage per stack.

/obj/effect/vfx/smoke/elemental/frost
	name = "freezing cloud"
	desc = "A cloud filled with brutally cold mist."
	color = "#00CCFF"

/obj/effect/vfx/smoke/elemental/frost/affect(mob/living/L)
	L.inflict_cold_damage(strength)

/obj/effect/vfx/smoke/elemental/shock
	name = "charged cloud"
	desc = "A cloud charged with electricity."
	color = "#4D4D4D"

/obj/effect/vfx/smoke/elemental/shock/affect(mob/living/L)
	L.inflict_shock_damage(strength)

/obj/effect/vfx/smoke/elemental/mist
	name = "misty cloud"
	desc = "A cloud filled with water vapor."
	color = "#CCFFFF"
	alpha = 128
	strength = 1

/obj/effect/vfx/smoke/elemental/mist/affect(mob/living/L)
	L.water_act(strength)

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect_system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/vfx/smoke

/datum/effect_system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect_system/smoke_spread/start(var/I)
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/vfx/smoke/smoke = new smoke_type(src.location)
			src.total_smoke++
			if(I)
				smoke.color = I
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)
			spawn(smoke.time_to_live*0.75+rand(10,30))
				if (smoke) qdel(smoke)
				src.total_smoke--

/datum/effect_system/smoke_spread/bad
	smoke_type = /obj/effect/vfx/smoke/bad
	
/datum/effect_system/smoke_spread/bad/burntfood
	smoke_type = /obj/effect/vfx/smoke/bad/burntfood

/datum/effect_system/smoke_spread/noxious
	smoke_type = /obj/effect/vfx/smoke/bad/noxious

/datum/effect_system/smoke_spread/fire
	smoke_type = /obj/effect/vfx/smoke/elemental/fire

/datum/effect_system/smoke_spread/frost
	smoke_type = /obj/effect/vfx/smoke/elemental/frost

/datum/effect_system/smoke_spread/shock
	smoke_type = /obj/effect/vfx/smoke/elemental/shock

/datum/effect_system/smoke_spread/mist
	smoke_type = /obj/effect/vfx/smoke/elemental/mist