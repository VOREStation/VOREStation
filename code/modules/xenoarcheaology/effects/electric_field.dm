/// Modified to work with the Artifact Harvester
/datum/artifact_effect/electric_field
	name = "Electric Field"
	effect_type = EFFECT_ELECTIC_FIELD

	effect_color = "#ffff00"
	var/last_used = 0
	var/use_delay = 5 SECONDS //Time between uses.

/datum/artifact_effect/electric_field/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(last_used >= world.time + use_delay)
		return
	else
		last_used = world.time
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		var/obj/item/anodevice/utilizer = holder.loc
		use_delay = 0 //We're in an artifact, our delay is handled by the utilizer iself.
		battery.stored_charge = 0 //You only get ONE use of this. This is WAY too strong.
		holder = utilizer
		user = utilizer.last_user_touched
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(user && L == user)	// You're "grounded" when you contact the artifact...
			continue
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, span_danger("ERROR: Electrical fault detected!"))
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(25, 40), holder, H.get_siemens_coefficient_organ(affected), affected)
			var/turf/T = get_turf(H)
			if(istype(T))
				lightning_strike(T, TRUE)
		else
			L.electrocute_act(rand(25, 40), holder, 0.75, BP_TORSO)
			var/turf/T = get_turf(L)
			if(istype(T))
				lightning_strike(T, TRUE)

/datum/artifact_effect/electric_field/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(last_used >= world.time + use_delay)
		return
	else
		last_used = world.time
	var/mob/living/user
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		var/obj/item/anodevice/utilizer = holder.loc
		use_delay = 0 //We're in an artifact, our delay is handled by the utilizer iself.
		battery.stored_charge = max(0, battery.stored_charge-100) //This one isn't TOO terrible. It doesn't stun, so lets just have it do extra drain.
		holder = utilizer
		user = utilizer.last_user_touched
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(L == user)	// You're "grounded" when you contact the artifact...
			continue
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, span_danger("ERROR: Electrical fault detected!"))
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(1, 10), holder, H.get_siemens_coefficient_organ(affected), affected)
			lightning_strike(H.loc, TRUE)
		else
			L.electrocute_act(rand(1, 10), holder, 0.75, BP_TORSO)
			lightning_strike(L.loc, TRUE)

/datum/artifact_effect/electric_field/DoEffectPulse()
	var/atom/holder = get_master_holder()
	var/mob/living/user
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anodevice/utilizer = holder.loc
		var/obj/item/anobattery/battery = holder
		holder = utilizer
		user = utilizer.last_user_touched
		battery.stored_charge = 0
		use_delay = 0 //We're in an artifact, our delay is handled by the utilizer iself.
	if(last_used >= world.time + use_delay)
		return
	else
		last_used = world.time
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(user && L == user)	// You're "grounded" when you contact the artifact...
			continue
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, span_danger("ERROR: Electrical fault detected!"))
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(10, 30), holder, H.get_siemens_coefficient_organ(affected), affected)
			lightning_strike(H.loc, TRUE)
		else
			L.electrocute_act(rand(10, 30), holder, 0.75, BP_TORSO)
			lightning_strike(L.loc, TRUE)
