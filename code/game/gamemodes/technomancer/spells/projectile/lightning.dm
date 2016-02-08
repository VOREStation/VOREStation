/datum/technomancer/spell/lightning
	name = "Lightning"
	desc = "This uses a hidden electrolaser, which creates a laser beam to ionize the enviroment, allowing for ideal conditions \
	for a directed lightning strike to occur.  The lightning is very strong, however it requires a few seconds to prepare a \
	strike."
	cost = 150
	obj_path = /obj/item/weapon/spell/projectile/lightning

/obj/item/weapon/spell/projectile/lightning
	name = "lightning"
	icon_state = "lightning"
	desc = "Send instability from the target to you, for whatever reason you'd want to."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/lightning
	energy_cost_per_shot = 2500
	instability_per_shot = 10
	cooldown = 20
	pre_shot_delay = 2

/obj/item/projectile/beam/lightning
	name = "lightning"
	icon_state = "lightning"
	nodamage = 1
	damage_type = HALLOSS

	muzzle_type = /obj/effect/projectile/lightning/muzzle
	tracer_type = /obj/effect/projectile/lightning/tracer
	impact_type = /obj/effect/projectile/lightning/impact

	var/power = 40				//How hard it will hit for with electrocute_act().

/obj/item/projectile/beam/lightning/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
		H.electrocute_act(power, src, H.get_siemens_coefficient_organ(affected), affected)
	else
		target_mob.electrocute_act(power, src, 1.0, BP_TORSO)
	return 1