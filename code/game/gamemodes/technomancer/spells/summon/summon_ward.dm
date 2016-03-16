/datum/technomancer/spell/summon_ward
	name = "Summon Ward"
	desc = "Teleports a prefabricated 'ward' drone to the target location, which will alert you and your allies when it sees entities \
	moving around it, or when it is attacked.  You can have only three active at a time.  Going over the limit results in the oldest \
	ward being dismissed.  Wards expire in six minutes."
	cost = 100
	obj_path = /obj/item/weapon/spell/summon/summon_ward

/obj/item/weapon/spell/summon/summon_ward
	name = "summon ward"
	desc = "Now you can have up to three eyes elsewhere."
	cast_methods = CAST_RANGED
	summoned_mob_type = /mob/living/simple_animal/ward
	cooldown = 10
	instability_cost = 5
	energy_cost = 500

/mob/living/simple_animal/ward
	name = "ward"
	desc = "It's a little flying drone that seems to be watching you..."
	resistance = 5
	wander = 0
	response_help   = "pets the"
	response_disarm = "swats away"
	response_harm   = "punches"