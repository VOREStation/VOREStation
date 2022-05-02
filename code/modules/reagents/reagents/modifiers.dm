/*
 * Modifier-applying chemicals.
 */

/datum/reagent/modapplying
	name = "brute juice"
	id = "berserkmed"
	description = "A liquid that is capable of causing a prolonged state of heightened aggression and durability."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#ff5555"
	metabolism = REM

	var/modifier_to_add = /datum/modifier/berserk
	var/modifier_duration = 3 SECONDS	// How long, per unit dose, will this last?
										// 2 SECONDS is the resolution of life code, and the modifier will expire before chemical processing tries to re-add it

/datum/reagent/modapplying/affect_blood(var/mob/living/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_modifier(modifier_to_add, modifier_duration, suppress_failure = TRUE)

/datum/reagent/modapplying/cryofluid
	name = "cryogenic slurry"
	id = "cryoslurry"
	description = "An incredibly strange liquid that rapidly absorbs thermal energy from materials it contacts."
	taste_description = "siberian hellscape"
	color = "#4CDBDB"
	metabolism = REM * 0.5

	modifier_to_add = /datum/modifier/cryogelled
	modifier_duration = 3 SECONDS

/datum/reagent/modapplying/cryofluid/affect_blood(var/mob/living/human/M, var/alien, var/removed)
	..(M, alien, removed)
	M.bodytemperature -= removed * 20

/datum/reagent/modapplying/cryofluid/affect_ingest(var/mob/living/human/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 2.5)

/datum/reagent/modapplying/cryofluid/affect_touch(var/mob/living/human/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.6)

/datum/reagent/modapplying/cryofluid/touch_mob(var/mob/M, var/amount)
	..()
	if(isliving(M))
		var/mob/living/L = M
		for(var/I = 1 to rand(1, round(amount + 1)))
			L.add_modifier(modifier_to_add, amount * rand(modifier_duration / 2, modifier_duration * 2))
	return

/datum/reagent/modapplying/cryofluid/touch_turf(var/turf/T, var/amount)
	..()
	if(istype(T, /turf/simulated/floor/water) && prob(amount))
		T.visible_message("<span class='danger'>\The [T] crackles loudly as the cryogenic fluid causes it to boil away, leaving behind a hard layer of ice.</span>")
		T.ChangeTurf(/turf/simulated/floor/outdoors/ice, 1, 1, TRUE)
	else
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.freeze_floor()
	return

/datum/reagent/modapplying/vatstabilizer
	name = "clone growth inhibitor"
	id = "vatstabilizer"
	description = "A compound produced by NanoTrasen using a secret blend of phoron and toxins to stop the rampant growth of a clone beyond intended states."
	taste_description = "sour glue"
	color = "#060501"
	metabolism = REM * 0.2

	modifier_to_add = /datum/modifier/clone_stabilizer
	modifier_duration = 30 SECONDS
