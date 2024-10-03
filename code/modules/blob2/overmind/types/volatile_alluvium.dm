// A blob that steals your weapon.
/datum/blob_type/volatile_alluvium
	name = "volatile alluvium"
	desc = "A churning, earthy mass that moves in waves."
	ai_desc = "earthen"
	effect_desc = "Moves slowly, producing weak ranged spores to defend itself, and inflicts brute attacks. Attempts to disarm nearby attackers. Weak to water."
	difficulty = BLOB_DIFFICULTY_HARD //Slow-starting, but can be overwhelming if left alone.
	color = "#6B481E"
	complementary_color = "#7F471F"
	damage_lower = 10
	damage_upper = 20
	armor_pen = 40
	brute_multiplier = 0.7
	burn_multiplier = 0.5
	spread_modifier = 0.5
	ai_aggressiveness = 50
	attack_message = "The alluvium crashes against you"
	attack_verb = "crashes against"
	can_build_factories = TRUE
	can_build_resources = TRUE
	spore_type = /mob/living/simple_mob/blob/spore/weak
	ranged_spores = TRUE
	spore_range = 3
	spore_projectile = /obj/item/projectile/energy/blob/splattering
	spore_accuracy = 15
	spore_dispersion = 45
	factory_type = /obj/structure/blob/factory/sluggish
	resource_type = /obj/structure/blob/resource/sluggish
	chunk_active_ability_cooldown = 2 MINUTES

/datum/blob_type/volatile_alluvium/on_received_damage(var/obj/structure/blob/B, damage, damage_type, mob/living/attacker)
	if(damage > 0 && attacker && get_dist(B, attacker) <= 2 && prob(min(damage, 70)) && istype(attacker, /mob/living/carbon/human)) // Melee weapons of any type carried by a human will have a high chance of being stolen.
		var/mob/living/carbon/human/H = attacker
		var/obj/item/I = H.get_active_hand()
		H.drop_item()
		if(I)
			if((I.sharp || I.edge) && !istype(I, /obj/item/gun))
				I.forceMove(get_turf(B)) // Disarmed entirely.
				B.visible_message(span_danger("The [name] heaves, \the [attacker]'s weapon becoming stuck in the churning mass!"))
			else
				I.throw_at(B, 2, 4) // Just yoinked.
				B.visible_message(span_danger("The [name] heaves, pulling \the [attacker]'s weapon from their hands!"))
		B.blob_attack_animation(attacker, B.overmind)
	return ..()

/datum/blob_type/volatile_alluvium/on_water(obj/structure/blob/B, amount)
	spawn(1)
		var/damage = amount * 4
		B.adjust_integrity(-(damage))
		if(B && prob(damage))
			B.visible_message(span_danger("The [name] begins to crumble!"))

/datum/blob_type/volatile_alluvium/on_chunk_use(obj/item/blobcore_chunk/B, mob/living/user)
	if(user)
		user.add_modifier(/datum/modifier/fortify, 60 SECONDS)
