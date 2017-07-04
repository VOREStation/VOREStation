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
	tree_chance = 100/obj/random/cargopod
	name = "Random Cargo Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 0
/obj/random/cargopod/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/pill_bottle/tramadol,
				prob(8);/obj/item/weapon/haircomb,
				prob(4);/obj/item/weapon/storage/pill_bottle/happy,
				prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
				prob(10);/obj/item/weapon/contraband/poster,
				prob(4);/obj/item/weapon/material/butterfly,
				prob(6);/obj/item/weapon/material/butterflyblade,
				prob(6);/obj/item/weapon/material/butterflyhandle,
				prob(6);/obj/item/weapon/material/wirerod,
				prob(2);/obj/item/weapon/material/butterfly/switchblade,
				prob(2);/obj/item/weapon/material/knuckledusters,
				prob(1);/obj/item/weapon/material/hatchet/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/weapon/beartrap,
				prob(1);/obj/item/weapon/handcuffs,
				prob(1);/obj/item/weapon/legcuffs,
				prob(2);/obj/item/weapon/reagent_containers/syringe/drugs,
				prob(1);/obj/item/weapon/reagent_containers/syringe/steroid)