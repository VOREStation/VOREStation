/*/turf/simulated/floor/outdoors/grass/sif
	var/mob_chance = 0 // 0 by default, so we don't have angry things on the main map!
	var/list/mob_types = list()

/turf/simulated/floor/outdoors/grass/sif/New()
	if(tree_chance && prob(tree_chance))
		new /obj/structure/flora/tree/sif(src)
	else if (mob_chance && prob(mob_chance))
		var/temp_type = pick(mob_types)
		if (istype(mob_types, /mob/living)) // This is just to prevent runtime errors in case some dev is a dumbass and puts invalid items into the mob_types list.
			var/mob/living/simple_animal/new_mob = new temp_type(loc)
			new_mob.faction = "wild animal"
	..()*/

/turf/simulated/floor/outdoors/grass/sif/forest/dense
	tree_chance = 20

/turf/simulated/floor/outdoors/grass/sif/forest/border
	name = "impassible growth"
	tree_chance = 100