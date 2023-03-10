/*
 * Fishing! Contains normal fishing rods and nets.
 */

GLOBAL_LIST_INIT(generic_fishing_rare_list, list(
		/mob/living/simple_mob/animal/passive/fish/solarfish = 1,
		/mob/living/simple_mob/animal/passive/fish/icebass = 5,
		/mob/living/simple_mob/animal/passive/fish/koi = 3
		))

GLOBAL_LIST_INIT(generic_fishing_uncommon_list, list(
		/mob/living/simple_mob/animal/passive/fish/salmon = 6,
		/mob/living/simple_mob/animal/passive/fish/pike = 10,
		/mob/living/simple_mob/animal/passive/fish/javelin = 3,
		/mob/living/simple_mob/animal/passive/crab/sif = 1
		))

GLOBAL_LIST_INIT(generic_fishing_common_list, list(
		/mob/living/simple_mob/animal/passive/fish/bass = 10,
		/mob/living/simple_mob/animal/passive/fish/trout = 8,
		/mob/living/simple_mob/animal/passive/fish/perch = 6,
		/mob/living/simple_mob/animal/passive/fish/murkin = 8,
		/mob/living/simple_mob/animal/passive/fish/rockfish = 5,
		/mob/living/simple_mob/animal/passive/crab = 1
		))

GLOBAL_LIST_INIT(generic_fishing_junk_list, list(
		/obj/item/clothing/shoes/boots/cowboy = 1,
		/obj/random/fishing_junk = 10
		))

GLOBAL_LIST_INIT(generic_fishing_pool_list, list(
		/obj/item/weapon/bikehorn/rubberducky = 5,
		/obj/item/toy/plushie/carp = 20,
		/obj/random/junk = 80,
		/obj/random/trash = 80,
		/obj/item/weapon/spacecash/c1 = 10,
		/obj/item/weapon/spacecash/c10 = 5,
		/obj/item/weapon/spacecash/c100 = 1
		))

#define FISHING_RARE     "rare"
#define FISHING_UNCOMMON "uncommon"
#define FISHING_COMMON   "common"
#define FISHING_JUNK     "junk"
#define FISHING_NOTHING  "nothing"

GLOBAL_LIST_INIT(generic_fishing_chance_list, list(FISHING_RARE = 5, FISHING_UNCOMMON = 15, FISHING_COMMON = 30, FISHING_JUNK = 30, FISHING_NOTHING = 40))

/turf/simulated/floor/water
	var/has_fish = TRUE //If the water has fish or not.

	var/list/rare_fish_list	// Rare list.

	var/list/uncommon_fish_list	// Uncommon list.

	var/list/common_fish_list	// Common list.

	var/list/junk_list	// Junk item list.

	var/list/fishing_loot	// Chance list.

	var/fishing_cooldown = 30 SECONDS
	var/last_fished = 0

	var/fish_type
	var/min_fishing_time = 30	// Time in seconds.
	var/max_fishing_time = 90

	var/being_fished = FALSE

/turf/simulated/floor/water/proc/handle_fish()	// Subtypes should over-ride this, and supply their own GLOB lists for maximum Mix and Match power.
	if(has_fish)
		rare_fish_list = GLOB.generic_fishing_rare_list
		uncommon_fish_list = GLOB.generic_fishing_uncommon_list
		common_fish_list = GLOB.generic_fishing_common_list
		junk_list = GLOB.generic_fishing_junk_list
		fishing_loot = GLOB.generic_fishing_chance_list

/turf/simulated/floor/water/pool
	has_fish = FALSE

/turf/simulated/floor/water/deep/pool
	has_fish = TRUE

/turf/simulated/floor/water/deep/pool/handle_fish()
	if(has_fish)
		rare_fish_list = GLOB.generic_fishing_pool_list
		uncommon_fish_list = GLOB.generic_fishing_pool_list
		common_fish_list = GLOB.generic_fishing_pool_list
		junk_list = GLOB.generic_fishing_pool_list
		fishing_loot = GLOB.generic_fishing_chance_list

/turf/simulated/floor/water/ex_act(severity)	// Explosive fishing.
	if(prob(5 * severity))
		pick_fish()
		if(fish_type)
			var/fished = new fish_type(get_turf(src))
			if(isliving(fished))
				var/mob/living/L = fished
				L.death()
	has_fish = FALSE
	..(severity)

/turf/simulated/floor/water/proc/pick_fish()
	if(has_fish)
		var/table = pickweight(fishing_loot)
		if(table == FISHING_RARE && rare_fish_list.len)
			fish_type = pickweight(rare_fish_list)
		else if(table == FISHING_UNCOMMON && uncommon_fish_list.len)
			fish_type = pickweight(uncommon_fish_list)
		else if(table == FISHING_COMMON && common_fish_list.len)
			fish_type = pickweight(common_fish_list)
		else if(table == FISHING_JUNK && junk_list.len)
			fish_type = pickweight(junk_list)
		else
			fish_type = null
	else
		fish_type = null

/turf/simulated/floor/water/attackby(obj/item/weapon/P as obj, mob/user as mob)
//If you use a fishing rod on an open body of water that var/has_fish enabled
	if(istype(P, /obj/item/weapon/material/fishing_rod) && !being_fished)
		var/obj/item/weapon/material/fishing_rod/R = P
		if(!R.strung)
			to_chat(user, "<span class='notice'>It is hard to go fishing without any line!</span>")
			return
		if(R.cast)
			to_chat(user, "<span class='notice'>You can only cast one line at a time!</span>")
			return
		playsound(src, 'sound/effects/slosh.ogg', 5, 1, 5)
		to_chat(user,"You cast \the [P.name] into \the [src].")
		being_fished = TRUE
		R.cast = TRUE
		var/fishing_time = rand(min_fishing_time SECONDS,max_fishing_time SECONDS) * R.toolspeed
		if(do_after(user,fishing_time,user))
			playsound(src, 'sound/effects/slosh.ogg', 5, 1, 5)
			to_chat(user,"<span class='notice'>You feel a tug and begin pulling!</span>")
			if(world.time >= last_fished + fishing_cooldown)
				pick_fish()
				last_fished = world.time
			else
				fish_type = null
				if(prob(3))	// No fish left here..
					has_fish = FALSE
			//List of possible outcomes.
			if(!fish_type)
				to_chat(user,"<span class='filter_notice'>You caught... nothing. How sad.</span>")
			else
				var/fished = new fish_type(get_turf(user))
				if(isliving(fished))
					R.consume_bait()
					var/mob/living/L = fished
					if(prob(rand(L.mob_size) + 10) && R.line_break)
						R.strung = FALSE
						R.update_icon()
						user.visible_message("<span class='danger'>\The [R]'s string snaps!</span>")
					if(prob(33))	// Dead on hook. Good for food, not so much for live catch.
						L.death()
				to_chat(user,"<span class='notice'>You fish out \the [fished] from the water with [P.name]!</span>")
		R.cast = FALSE
		being_fished = FALSE
	else ..()

/obj/random/fishing_junk
	name = "junk"
	desc = "This is a random fishing junk item."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/fishing_junk/item_to_spawn()
	return pickweight(list(
	/obj/random/toy = 60,
	/obj/random/maintenance/engineering = 50,
	/obj/random/maintenance/clean = 40,
	/obj/random/maintenance/security = 40,
	/obj/random/maintenance/research = 40,
	/obj/structure/closet/crate/secure/loot = 30,
	/obj/random/bomb_supply = 30,
	/obj/random/powercell = 30,
	/obj/random/tech_supply/component = 30,
	/obj/random/unidentified_medicine/old_medicine = 30,
	/obj/random/plushie = 30,
	/obj/random/contraband = 20,
	/obj/random/coin = 20,
	/obj/random/medical = 15,
	/obj/random/unidentified_medicine/fresh_medicine = 15,
	/obj/random/action_figure = 15,
	/obj/random/plushielarge = 15,
	/obj/random/firstaid = 10,
	/obj/random/tool/powermaint = 5,
	/obj/random/unidentified_medicine/combat_medicine = 1,
	/obj/random/tool/alien = 1,
	/obj/random/handgun = 1,
	/mob/living/simple_mob/animal/sif/hooligan_crab = 1
	))

#undef FISHING_RARE
#undef FISHING_UNCOMMON
#undef FISHING_COMMON
#undef FISHING_JUNK
#undef FISHING_NOTHING
