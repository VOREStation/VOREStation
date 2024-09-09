// Blob that fires biological mortar shells from its factories.
/datum/blob_type/roiling_mold
	name = "roiling mold"
	desc = "A bubbling, creeping mold."
	ai_desc = "bombarding"
	effect_desc = "Bombards nearby organisms with toxic spores. Weak to all damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#571509"
	complementary_color = "#ec4940"
	damage_type = BRUTE
	damage_lower = 5
	damage_upper = 20
	armor_check = "melee"
	brute_multiplier = 1.2
	burn_multiplier = 1.2
	spread_modifier = 0.8
	can_build_factories = TRUE
	ai_aggressiveness = 50
	attack_message = "The mold whips you"
	attack_message_living = ", and you feel a searing pain"
	attack_message_synth = ", and your shell buckles"
	attack_verb = "lashes"
	spore_projectile = /obj/item/projectile/arc/spore
	factory_type = /obj/structure/blob/factory/turret

/datum/blob_type/roiling_mold/proc/find_target(var/obj/structure/blob/B, var/tries = 0, var/list/previous_targets = null)
	if(tries > 3)
		return
	var/mob/living/L = locate() in (view(world.view + 3, get_turf(B)) - view(2,get_turf(B)) - previous_targets)	// No adjacent mobs.

	if(!(L in check_trajectory(L, B, PASSTABLE)))
		if(!LAZYLEN(previous_targets))
			previous_targets = list()

		previous_targets |= L

		return find_target(B, tries + 1, previous_targets)

	return L

/datum/blob_type/roiling_mold/on_pulse(var/obj/structure/blob/B)
	var/mob/living/L = find_target(B)

	if(!istype(L))
		return

	if(istype(B, /obj/structure/blob/factory) && L.stat != DEAD && prob(ai_aggressiveness) && L.faction != faction)
		var/obj/item/projectile/arc/spore/P = new(get_turf(B))
		P.launch_projectile(L, BP_TORSO, B)

/datum/blob_type/roiling_mold/on_chunk_use(obj/item/blobcore_chunk/B, mob/living/user)
	for(var/mob/living/L in oview(world.view, get_turf(B)))
		if(istype(user) && user == L)
			continue

		if(!(L in check_trajectory(L, B, PASSTABLE)))	// Can't fire at things on the other side of walls / windows.
			continue

		var/obj/item/projectile/P = new spore_projectile(get_turf(B))

		user.visible_message("<span class='danger'>[icon2html(B,viewers(user))] \The [B] discharges energy toward \the [L]!</span>")
		P.launch_projectile(L, BP_TORSO, user)

	return
