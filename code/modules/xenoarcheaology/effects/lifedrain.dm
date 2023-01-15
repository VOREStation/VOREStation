/datum/artifact_effect/rare/lifedrain
	name = "lifesteal"
	effect_color = "#3b1f3b"
	effect_type = EFFECT_ENERGY
	var/list/active_beams


/datum/artifact_effect/rare/lifedrain/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/rare/lifedrain/proc/steal(var/mob/living/carrier)
	if(!istype(carrier))
		return

	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(world.view, get_master_holder()))
		if(L.stat != DEAD)
			nearby_mobs |= L

	if(nearby_mobs.len)
		listclearnulls(active_beams)
		for(var/mob/living/L in nearby_mobs)
			if(L.stat == DEAD)
				continue
			if(!prob(5))
				continue
			var/beamtarget_exists = FALSE

			if(active_beams.len)
				for(var/datum/beam/Beam in active_beams)
					if(Beam.target == L)
						beamtarget_exists = TRUE
						break

			if(beamtarget_exists || GetAnomalySusceptibility(L) < 0.5)
				continue

			carrier.visible_message(
				"<span class='danger'>A sickly beam lashes out from [bicon(get_master_holder())] \the [get_master_holder()] at \the [L]!</span>")
			var/datum/beam/drain_beam = carrier.Beam(L, icon_state = "drain_life", time = 10 SECONDS)
			active_beams |= drain_beam
			spawn(9 SECONDS)
				if(get_master_holder() && drain_beam)
					carrier.visible_message(
						"<span class='alien'>\The [get_master_holder()] siphons energy from \the [L]</span>")
					L.add_modifier(/datum/modifier/berserk_exhaustion, 30 SECONDS)
					var/total_heal = 0

					if(carrier.getBruteLoss())
						carrier.adjustBruteLoss(-5)
						total_heal += 5

					if(carrier.getFireLoss())
						carrier.adjustFireLoss(-5)
						total_heal += 5

					if(carrier.getToxLoss())
						carrier.adjustToxLoss(-5)
						total_heal += 5

					if(carrier.getOxyLoss())
						carrier.adjustOxyLoss(-5)
						total_heal += 5

					if(carrier.getCloneLoss())
						carrier.adjustCloneLoss(-5)
						total_heal += 5

					carrier.add_modifier(/datum/modifier/berserk_exhaustion, total_heal SECONDS)
					if(!QDELETED(drain_beam))
						qdel(drain_beam)
		var/atom/A = get_master_holder()
		A.visible_message(
			"<span class='alien'>A sickly beam lashes out from [bicon(get_master_holder())] \the [get_master_holder()] at \the [carrier]!</span>")


/datum/artifact_effect/rare/lifedrain/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		steal(user)


/datum/artifact_effect/rare/lifedrain/DoEffectPulse()
	var/mob/living/target = locate() in oview(world.view, get_turf(get_master_holder()))
	if(target)
		steal(target)
