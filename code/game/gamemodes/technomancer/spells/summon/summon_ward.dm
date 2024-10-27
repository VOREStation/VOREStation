/datum/technomancer/spell/summon_ward
	name = "Summon Monitor Ward"
	desc = "Teleports a prefabricated 'ward' drone to the target location, which will alert you when it sees entities \
	moving around it, or when it is attacked.  They can see for up to five meters. It can also see invisible entities, and \
	forcefully decloak them if close enough."
	cost = 25
	obj_path = /obj/item/spell/summon/summon_ward
	category = UTILITY_SPELLS

/obj/item/spell/summon/summon_ward
	name = "summon ward"
	desc = "Finally, someone you can depend on to watch your back."
	cast_methods = CAST_RANGED
	summoned_mob_type = /mob/living/simple_mob/mechanical/ward/monitor
	cooldown = 10
	instability_cost = 5
	energy_cost = 500

/obj/item/spell/summon/summon_ward/on_summon(var/mob/living/simple_mob/mechanical/ward/monitor/my_ward)
	my_ward.owner = owner
