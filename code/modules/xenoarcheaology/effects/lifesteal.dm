/datum/artifact_effect/extreme/lifesteal
	name = "lifesteal"
	effect_color = "#3b1f3b"
	effect_type = EFFECT_ENERGY


/datum/artifact_effect/extreme/lifesteal/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/extreme/lifesteal/proc/steal(var/mob/living/carrier)
	if(!istype(carrier))
		return

	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(world.view, get_master_holder()))
		if(L.stat != DEAD)
			nearby_mobs |= L

	if(nearby_mobs.len)
		for(var/mob/living/victim in nearby_mobs)
			var/need_beam = FALSE

			if(carrier.getBruteLoss())
				need_beam = TRUE
				victim.adjustBruteLoss(3 / nearby_mobs.len)
				carrier.adjustBruteLoss(-3 / nearby_mobs.len)

			if(carrier.getFireLoss())
				need_beam = TRUE
				victim.adjustFireLoss(3 / nearby_mobs.len)
				carrier.adjustFireLoss(-3 / nearby_mobs.len)

			if(need_beam)
				carrier.Beam(victim, icon_state = "lichbeam", time = 2 SECONDS)
		var/atom/A = get_master_holder()
		A.visible_message(
			"<span class='alien'>[bicon(get_master_holder())] \The [get_master_holder()] sends noxious spores toward \the [carrier]. A sickly light emanates from them!</span>")


/datum/artifact_effect/extreme/lifesteal/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		steal(user)


/datum/artifact_effect/extreme/lifesteal/DoEffectPulse()
	var/mob/living/target = locate() in oview(world.view, get_turf(get_master_holder()))
	if(target)
		steal(target)
