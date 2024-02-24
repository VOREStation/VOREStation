/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/
/obj/effect
	light_on = TRUE

/obj/effect/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = 0
	unacidable = TRUE//So effect are not targeted by alien acid.
	pass_flags = PASSTABLE | PASSGRILLE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	light_on = TRUE
	plane = ABOVE_OBJ_PLANE

/datum/effect/effect/system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = 0

/datum/effect/effect/system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = 1

/datum/effect/effect/system/proc/attach(atom/atom)
	holder = atom

/datum/effect/effect/system/proc/start()

/datum/effect/effect/system/Destroy()
	holder = null
	return ..()

/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = FALSE

/datum/effect/effect/system/steam_spread/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect/effect/system/steam_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/effect/steam/steam = new /obj/effect/effect/steam(src.location)
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(steam,direction)
			spawn(20)
				qdel(steam)

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/effect/sparks
	name = "sparks"
	icon_state = "sparks"
	var/amount = 6.0
	anchored = TRUE
	mouse_opacity = 0

/obj/effect/effect/sparks/Initialize()
	. = ..()
	playsound(src, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/effect/sparks/Destroy()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return ..()

/obj/effect/effect/sparks/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(isturf(loc))
		var/turf/T = loc
		T.hotspot_expose(1000,100)

/datum/effect/effect/system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect/effect/system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/effect/system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/effect/sparks/sparks = new /obj/effect/effect/sparks(src.location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(sparks,direction)
			spawn(20)
				src.total_sparks--



/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = FALSE
	mouse_opacity = 0
	var/amount = 6.0
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/effect/smoke/New()
	..()
	if(time_to_live)
		spawn (time_to_live)
			if(!QDELETED(src))
				qdel(src)

/obj/effect/effect/smoke/Crossed(mob/living/carbon/M as mob )
	if(M.is_incorporeal())
		return
	..()
	if(istype(M))
		affect(M)

/obj/effect/effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (!istype(M))
		return 0
	if(M.wear_mask && (M.wear_mask.item_flags & AIRTIGHT))
		return 0
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.head && (H.head.item_flags & AIRTIGHT))
			return 0
	return 1

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////

/obj/effect/effect/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/effect/smoke/illumination/New(var/newloc, var/lifetime=10, var/range=null, var/power=null, var/color=null)
	time_to_live=lifetime
	..()
	set_light(range, power, color)

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	time_to_live = 600
	//var/list/projectiles

/obj/effect/effect/smoke/bad/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	for(var/mob/living/L in get_turf(src))
		affect(L)

/obj/effect/effect/smoke/bad/affect(var/mob/living/L)
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.adjustOxyLoss(1)
		if(prob(25))
			L.emote("cough")

/obj/effect/effect/smoke/bad/noxious
	opacity = 0

/obj/effect/effect/smoke/bad/noxious/affect(var/mob/living/L)
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.adjustToxLoss(1)

/* Not feasile until a later date
/obj/effect/effect/smoke/bad/Crossed(atom/movable/M as mob|obj)
	..()
	if(istype(M, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = M
		if(!(B in projectiles))
			B.damage = (B.damage/2)
			projectiles += B
			destroyed_event.register(B, src, /obj/effect/effect/smoke/bad/proc/on_projectile_delete)
		to_world("Damage is: [B.damage]")
	return 1

/obj/effect/effect/smoke/bad/proc/on_projectile_delete(obj/item/projectile/beam/proj)
	projectiles -= proj
*/

// Burnt Food Smoke (Specialty for Cooking Failures)
/obj/effect/effect/smoke/bad/burntfood
	color = "#000000"
	time_to_live = 600

/obj/effect/effect/smoke/bad/burntfood/process()
	for(var/mob/living/L in get_turf(src))
		affect(L)

/obj/effect/effect/smoke/bad/burntfood/affect(var/mob/living/L) // This stuff is extra-vile.
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.emote("cough")

/////////////////////////////////////////////
// 'Elemental' smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/elemental
	name = "cloud"
	desc = "A cloud of some kind that seems really generic and boring."
	opacity = FALSE
	var/strength = 5 // How much damage to do inside each affect()

/obj/effect/effect/smoke/elemental/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/effect/smoke/elemental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/effect/smoke/elemental/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	for(var/mob/living/L in range(1, src))
		affect(L)

/obj/effect/effect/smoke/elemental/process()
	for(var/mob/living/L in range(1, src))
		affect(L)


/obj/effect/effect/smoke/elemental/fire
	name = "burning cloud"
	desc = "A cloud of something that is on fire."
	color = "#FF9933"
	light_color = "#FF0000"
	light_range = 2
	light_power = 5

/obj/effect/effect/smoke/elemental/fire/affect(mob/living/L)
	L.inflict_heat_damage(strength)
	L.add_modifier(/datum/modifier/fire, 6 SECONDS) // Around 15 damage per stack.

/obj/effect/effect/smoke/elemental/frost
	name = "freezing cloud"
	desc = "A cloud filled with brutally cold mist."
	color = "#00CCFF"

/obj/effect/effect/smoke/elemental/frost/affect(mob/living/L)
	L.inflict_cold_damage(strength)

/obj/effect/effect/smoke/elemental/shock
	name = "charged cloud"
	desc = "A cloud charged with electricity."
	color = "#4D4D4D"

/obj/effect/effect/smoke/elemental/shock/affect(mob/living/L)
	L.inflict_shock_damage(strength)

/obj/effect/effect/smoke/elemental/mist
	name = "misty cloud"
	desc = "A cloud filled with water vapor."
	color = "#F0FFFF"
	alpha = 128
	strength = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/effect/smoke/elemental/mist/affect(mob/living/L)
	L.water_act(strength)

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/effect/smoke

/datum/effect/effect/system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
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

/datum/effect/effect/system/smoke_spread/start(var/I)
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/effect/smoke/smoke = new smoke_type(src.location)
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

/datum/effect/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/effect/smoke/bad

/datum/effect/effect/system/smoke_spread/bad/burntfood
	smoke_type = /obj/effect/effect/smoke/bad/burntfood

/datum/effect/effect/system/smoke_spread/noxious
	smoke_type = /obj/effect/effect/smoke/bad/noxious

/datum/effect/effect/system/smoke_spread/fire
	smoke_type = /obj/effect/effect/smoke/elemental/fire

/datum/effect/effect/system/smoke_spread/frost
	smoke_type = /obj/effect/effect/smoke/elemental/frost

/datum/effect/effect/system/smoke_spread/shock
	smoke_type = /obj/effect/effect/smoke/elemental/shock

/datum/effect/effect/system/smoke_spread/mist
	smoke_type = /obj/effect/effect/smoke/elemental/mist

/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effect/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/datum/effect/effect/system/ion_trail_follow
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect/effect/system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/effect/system/ion_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			var/turf/T
			if(istype(holder, /atom/movable))
				var/atom/movable/AM = holder
				if(AM.locs && AM.locs.len)
					T = get_turf(pick(AM.locs))
				else
					T = get_turf(AM)
			else //when would this ever be attached a non-atom/movable?
				T = get_turf(src.holder)
			if(T != src.oldposition)
				if(isturf(T))
					var/obj/effect/effect/ion_trails/I = new /obj/effect/effect/ion_trails(src.oldposition)
					src.oldposition = T
					I.set_dir(src.holder.dir)
					flick("ion_fade", I)
					I.icon_state = "blank"
					spawn( 20 )
						qdel(I)
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect/effect/system/ion_trail_follow/proc/stop()
		src.processing = 0
		src.on = 0




/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect/effect/system/steam_trail_follow
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect/effect/system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/effect/system/steam_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			if(src.number < 3)
				var/obj/effect/effect/steam/I = new /obj/effect/effect/steam(src.oldposition)
				src.number++
				src.oldposition = get_turf(holder)
				I.set_dir(src.holder.dir)
				spawn(10)
					qdel(I)
					src.number--
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect/effect/system/steam_trail_follow/proc/stop()
	src.processing = 0
	src.on = 0

/datum/effect/effect/system/reagents_explosion
	var/amount 						// TNT equivalent
	var/flashing = 0			// does explosion creates flash effect?
	var/flashing_factor = 0		// factor of how powerful the flash effect relatively to the explosion

/datum/effect/effect/system/reagents_explosion/set_up(amt, loc, flash = 0, flash_fact = 0)
	amount = amt
	if(istype(loc, /turf/))
		location = loc
	else
		location = get_turf(loc)

	flashing = flash
	flashing_factor = flash_fact

	return

/datum/effect/effect/system/reagents_explosion/start()
	if (amount <= 2)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
		s.set_up(2, 1, location)
		s.start()

		for(var/mob/M in viewers(5, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")
		for(var/mob/M in viewers(1, location))
			if (prob (50 * amount))
				to_chat(M, "<span class='warning'>The explosion knocks you down.</span>")
				M.Weaken(rand(1,5))
		return
	else
		var/devst = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to fractions of max_explosion_range, following the same pattern as for tank transfer bombs
		if (round(amount/12) > 0)
			devst = devst + amount/12

		if (round(amount/6) > 0)
			heavy = heavy + amount/6

		if (round(amount/3) > 0)
			light = light + amount/3

		if (flashing && flashing_factor)
			flash = (amount/4) * flashing_factor

		for(var/mob/M in viewers(8, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")

		explosion(
			location,
			round(min(devst, BOMBCAP_DVSTN_RADIUS)),
			round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
			round(min(light, BOMBCAP_LIGHT_RADIUS)),
			round(min(flash, BOMBCAP_FLASH_RADIUS))
			)
