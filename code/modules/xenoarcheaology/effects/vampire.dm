
/datum/artifact_effect/vampire
	name = "vampire"
	effect_type = EFFECT_ORGANIC
	var/last_bloodcall = 0
	var/bloodcall_interval = 50
	var/last_eat = 0
	var/eat_interval = 100
	var/charges = 0
	var/list/nearby_mobs = list()

/datum/artifact_effect/vampire/proc/bloodcall(var/mob/living/carbon/human/M)
	last_bloodcall = world.time
	if(istype(M))
		playsound(holder, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), SEARING, target)
		to_chat(M, "<span class='critical'>The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out.</span>")
		var/obj/effect/decal/cleanable/blood/splatter/animated/B = new(M.loc)
		B.basecolor = M.species.get_blood_colour(M)
		B.color = M.species.get_blood_colour(M)
		B.target_turf = pick(range(1, get_turf(holder)))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		M.vessel.remove_reagent("blood",rand(25,50))

/datum/artifact_effect/vampire/DoEffectTouch(var/mob/user)
	bloodcall(user)
	DoEffectAura()

/datum/artifact_effect/vampire/DoEffectAura()
	nearby_mobs.Cut()

	var/turf/T = get_turf(holder)

	for(var/mob/living/L in oview(effectrange, T))
		if(!L.stat && L.mind)
			nearby_mobs |= L

	if(world.time - last_bloodcall > bloodcall_interval && nearby_mobs.len)
		var/mob/living/carbon/human/M = pick(nearby_mobs)
		if(M in view(effectrange,holder) && M.health > 20)
			if(prob(50))
				bloodcall(M)
				holder.Beam(M, icon_state = "drainbeam", time = 1 SECOND)

	if(world.time - last_eat > eat_interval)
		var/obj/effect/decal/cleanable/blood/B = locate() in range(2,holder)
		if(B)
			last_eat = world.time
			B.loc = null
			if(istype(B, /obj/effect/decal/cleanable/blood/drip))
				charges += 0.25
			else
				charges += 1
				playsound(holder, 'sound/effects/splat.ogg', 50, 1, -3)

			qdel(B)

	if(charges >= 10)
		charges -= 10
		var/manifestation = pick(/obj/item/device/soulstone, /mob/living/simple_mob/faithless/cult/strong, /mob/living/simple_mob/creature/cult/strong, /mob/living/simple_mob/animal/space/bats/cult/strong)
		new manifestation(get_turf(pick(view(1,T))))

	if(charges >= 3)
		if(prob(5))
			charges -= 1
			var/spawn_type = pick(/mob/living/simple_mob/animal/space/bats, /mob/living/simple_mob/creature, /mob/living/simple_mob/faithless)
			new spawn_type(get_turf(pick(view(1,T))))
			playsound(holder, pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 50, 1, -3)

	if(charges >= 1 && nearby_mobs.len && prob(15 * nearby_mobs.len))
		var/mob/living/L = pick(nearby_mobs)

		holder.Beam(L, icon_state = "drainbeam", time = 1 SECOND)

		L.add_modifier(/datum/modifier/agonize, 5 SECONDS)

	if(charges >= 0.1)
		if(prob(5))
			holder.visible_message("<span class='alien'>\icon[holder] \The [holder] gleams a bloody red!</span>")
			charges -= 0.1

/datum/artifact_effect/vampire/DoEffectPulse()
	DoEffectAura()
