
/datum/artifact_effect/vampire
	name = "Cultic Vampirism"
	effect_type = EFFECT_VAMPIRE
	var/last_bloodcall = 0
	var/bloodcall_interval = 50
	var/last_eat = 0
	var/eat_interval = 100
	var/charges = 0
	var/list/nearby_mobs = list()
	var/harvested = FALSE

	effect_state = "gravisphere"
	effect_color = "#ff0000"

/datum/artifact_effect/vampire/proc/bloodcall(var/mob/living/carbon/human/M)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
		eat_interval = 10 //If we're in an artifact just CRUNCH through those blood piles!
		harvested = 1 //We're in a harvester. We need special handling for this.
	if(istype(holder.loc, /mob/living))
		holder = holder.loc
	last_bloodcall = world.time
	if(istype(M))
		playsound(holder, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), SEARING, target)
		to_chat(M, span_critical("The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out."))
		var/obj/effect/decal/cleanable/blood/splatter/animated/B = new(M.loc)
		B.basecolor = M.species.get_blood_colour(M)
		B.color = M.species.get_blood_colour(M)
		B.target_turf = pick(RANGE_TURFS(1, holder))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		var/blood_to_remove = (rand(10,30))
		M.remove_blood(blood_to_remove)
		if(harvested)
			charges += blood_to_remove/10 //Anywhere from 1 to 3 charges based on how much it sucks, plus the extra blood puddle.. This means you can reasonably get things from the harvested variant.

/datum/artifact_effect/vampire/DoEffectTouch(var/mob/user)
	bloodcall(user)
	DoEffectAura()

/datum/artifact_effect/vampire/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(istype(holder.loc, /mob/living))
		holder = holder.loc
	if(nearby_mobs.len)
		nearby_mobs.Cut()
	var/turf/T = get_turf(holder)

	for(var/mob/living/L in oview(effectrange, T))
		if(!L.stat && L.mind)
			nearby_mobs |= L

	if(world.time - bloodcall_interval >= last_bloodcall && LAZYLEN(nearby_mobs))
		var/mob/living/carbon/human/M = pick(nearby_mobs)
		if(get_dist(M, T) <= effectrange && M.health > 20)
			bloodcall(M)
			holder.Beam(M, icon_state = "drainbeam", time = 1 SECOND)

	if(world.time - last_eat >= eat_interval)
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

	if(charges >= 10) //Listen, if you have INTENTIONALLY FED THE SPOOKY, SCARY ARTIFACT THAT IS DRAINING YOUR BLOOD, then go ahead and have your spooky reward.
		charges -= 10
		var/manifestation = pick(/obj/item/soulstone, /obj/item/melee/artifact_blade, /obj/item/book/tome, /obj/item/clothing/head/helmet/space/cult, /obj/item/clothing/suit/space/cult, /obj/structure/constructshell)
		new manifestation(pick(RANGE_TURFS(1,T)))

	if(charges >= 3)
		if(prob(5))
			charges -= 1
			var/spawn_type = pick(/mob/living/simple_mob/animal/space/bats, /mob/living/simple_mob/creature, /mob/living/simple_mob/faithless)
			new spawn_type(pick(RANGE_TURFS(1,T)))
			playsound(holder, pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 50, 1, -3)

	if(charges >= 1 && nearby_mobs.len && prob(15 * nearby_mobs.len))
		var/mob/living/L = pick(nearby_mobs)

		holder.Beam(L, icon_state = "drainbeam", time = 1 SECOND)

		L.add_modifier(/datum/modifier/agonize, 5 SECONDS)

	if(charges >= 0.1)
		if(prob(5))
			holder.visible_message(span_alien("[icon2html(holder,viewers(holder))] \The [holder] gleams a bloody red!"))
			charges -= 0.1

/datum/artifact_effect/vampire/DoEffectPulse()
	DoEffectAura()
