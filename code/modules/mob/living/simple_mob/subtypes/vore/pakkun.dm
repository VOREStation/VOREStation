/datum/category_item/catalogue/fauna/pakkun
	name = "Wildlife - Pakkun"
	desc = "Classification: Mordens Lacerta\
	<br><br>\
	Their diet is primarily pescatarian, but they known to consume other species and even their own - this activity doesn't appear to be malicious \
	or even borne out of hunger, but more of a form of playfighting among packmates."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/pakkun
	name = "pakkun"
	desc = "A small, blue, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	tt_desc = "Mordens Lacerta"
	catalogue_data = list(/datum/category_item/catalogue/fauna/pakkun)

	icon_dead = "pakkun-dead"
	icon_living = "pakkun"
	icon_state = "pakkun"
	icon = 'icons/mob/vore.dmi'

	faction = "pakkun"

	movement_cooldown = 6
	can_be_drop_pred = 1 //They can tongue vore.

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	vore_active = 1
	vore_icons = SA_ICON_LIVING

	harm_intent_damage = 3
	melee_damage_lower = 3
	melee_damage_upper = 5

	base_attack_cooldown = 5 SECONDS
	projectiletype = /obj/item/projectile/beam/appendage
	projectilesound = 'sound/effects/slime_squish.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/pakkun

/datum/ai_holder/simple_mob/ranged/pakkun
	pointblank = TRUE

/datum/ai_holder/simple_mob/ranged/pakkun/list_targets()
	var/list/our_targets = ..()
	for(var/list_target in our_targets)
		if(!isliving(list_target))
			our_targets -= list_target
			continue
		var/mob/living/L = list_target
		if(!(L.can_be_drop_prey && L.throw_vore && L.allowmobvore))
			our_targets -= list_target
			continue
	return our_targets

/datum/ai_holder/simple_mob/ranged/pakkun/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	.=..()
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(!(L.can_be_drop_prey && L.throw_vore && L.allowmobvore))
			return FALSE
	else
		return FALSE