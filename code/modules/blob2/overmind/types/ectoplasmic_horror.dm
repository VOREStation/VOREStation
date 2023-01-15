// A blob that drains energy from nearby mobs in order to fuel itself, and 'negates' some attacks extradimensionally.
/datum/blob_type/ectoplasmic_horror
	name = "ectoplasmic horror"
	desc = "A disgusting translucent slime that feels out of place."
	ai_desc = "dodging"
	effect_desc = "Drains energy from nearby life-forms in order to expand itself. Weak to all damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#72109eaa"
	complementary_color = "#1a9de8"
	damage_type = HALLOSS
	damage_lower = 10
	damage_upper = 30
	armor_check = "energy"
	brute_multiplier = 1.5
	burn_multiplier = 1.5
	spread_modifier = 0.9
	ai_aggressiveness = 50
	attack_message = "The horror strikes you"
	attack_message_living = ", and you feel a wave of exhaustion"
	attack_message_synth = ", and your systems begin to slow"
	attack_verb = "strikes"
	can_build_factories = TRUE
	factory_type = /obj/structure/blob/factory/sluggish
	spore_type = /mob/living/simple_mob/blob/spore/weak

	var/list/active_beams = list()

/datum/blob_type/ectoplasmic_horror/on_pulse(var/obj/structure/blob/B)
	if(B.type == /obj/structure/blob && (locate(/obj/structure/blob/node) in oview(2, get_turf(B))))
		B.visible_message("<span class='alien'>The [name] quakes, before hardening.</span>")
		new/obj/structure/blob/shield(get_turf(B), B.overmind)
		qdel(B)

	if(istype(B, /obj/structure/blob/factory))
		listclearnulls(active_beams)
		var/atom/movable/beam_origin = B
		for(var/mob/living/L in oview(world.view, B))
			if(L.stat == DEAD || L.faction == faction)
				continue
			if(prob(5))
				var/beamtarget_exists = FALSE

				if(active_beams.len)
					for(var/datum/beam/Beam in active_beams)
						if(Beam.target == L)
							beamtarget_exists = TRUE
							break

				if(!beamtarget_exists && GetAnomalySusceptibility(L) >= 0.5)
					B.visible_message("<span class='danger'>\The [B] lashes out at \the [L]!</span>")
					var/datum/beam/drain_beam = beam_origin.Beam(L, icon_state = "drain_life", time = 10 SECONDS)
					active_beams |= drain_beam
					spawn(9 SECONDS)
						if(B && drain_beam)
							B.visible_message("<span class='alien'>\The [B] siphons energy from \the [L]</span>")
							L.add_modifier(/datum/modifier/berserk_exhaustion, 60 SECONDS)
							B.overmind.add_points(rand(10,30))
							if(!QDELETED(drain_beam))
								qdel(drain_beam)

/datum/blob_type/ectoplasmic_horror/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	if(prob(round(damage * 0.5)))
		B.visible_message("<span class='alien'>\The [B] shimmers, distorting through some unseen dimension.</span>")
		var/initial_alpha = B.alpha
		spawn()
			animate(B,alpha = initial_alpha, alpha = 10, time = 10)
			animate(B,alpha = 10, alpha = initial_alpha, time = 10)
		return 0
	return ..()
<<<<<<< HEAD

/datum/blob_type/ectoplasmic_horror/on_chunk_tick(obj/item/weapon/blobcore_chunk/B)
	var/mob/living/carrier = B.get_carrier()

	if(!carrier)
		return

	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(world.view, carrier))
		if(L.stat != DEAD)
			nearby_mobs |= L

	if(nearby_mobs.len)
		listclearnulls(active_beams)
		for(var/mob/living/L in nearby_mobs)
			if(L.stat == DEAD || L.faction == faction)
				continue
			if(prob(5))
				var/beamtarget_exists = FALSE

				if(active_beams.len)
					for(var/datum/beam/Beam in active_beams)
						if(Beam.target == L)
							beamtarget_exists = TRUE
							break

				if(!beamtarget_exists && GetAnomalySusceptibility(L) >= 0.5)
					carrier.visible_message("<span class='danger'>\icon [B] \The [B] lashes out at \the [L]!</span>")
					var/datum/beam/drain_beam = carrier.Beam(L, icon_state = "drain_life", time = 10 SECONDS)
					active_beams |= drain_beam
					spawn(9 SECONDS)
						if(B && drain_beam)
							carrier.visible_message("<span class='alien'>\The [B] siphons energy from \the [L]</span>")
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
=======
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)
