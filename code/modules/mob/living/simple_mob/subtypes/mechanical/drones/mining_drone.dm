/*
	Mining drones have a slow-firing, armor-piercing beam that can destroy rocks.
	They will, if "tamed", collect ore and deposit it into nearby oreboxes when adjacent.
*/

/datum/category_item/catalogue/technology/drone/mining_drone
	name = "Drone - Mining Drone"
	desc = "A crude modification of the commonly seen combat drone model, usually created\
	from the salvaged husks that litter debris fields. Capable of crude problem solving,\
	the drone's targeting system has been repurposed for locating suitable ores, though even\
	that is only functional in certain conditions.\
	<br><br>\
	These drones are armed with high-power mining emitters, which makes their decrepit forms\
	just as lethal as they were in their prime. Modified thrust vectoring devices allow them\
	to gather ore effectively without expending mechanical energy."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/mechanical/mining_drone
	name = "mining drone"
	desc = "An automated drone with a worn-out appearance, but an ominous gaze."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/mining_drone)

	icon_state = "miningdrone"
	icon_living = "miningdrone"
	icon_dead = "miningdrone_dead"
	has_eye_glow = TRUE

	faction = "malf_drone"

	maxHealth = 50
	health = 50
	movement_cooldown = 5
	hovering = TRUE

	base_attack_cooldown = 2.5 SECONDS
	projectiletype = /obj/item/projectile/energy/excavate
	projectilesound = 'sound/weapons/pulse3.ogg'

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	organ_names = /decl/mob_organ_names/miningdrone

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening
	say_list_type = /datum/say_list/malf_drone

	tame_items = list(
	/obj/item/weapon/ore/verdantium = 90,
	/obj/item/weapon/ore/hydrogen = 90,
	/obj/item/weapon/ore/osmium = 70,
	/obj/item/weapon/ore/diamond = 70,
	/obj/item/weapon/ore/gold = 55,
	/obj/item/weapon/ore/silver = 55,
	/obj/item/weapon/ore/lead = 40,
	/obj/item/weapon/ore/marble = 30,
	/obj/item/weapon/ore/coal = 25,
	/obj/item/weapon/ore/iron = 25,
	/obj/item/weapon/ore/glass = 15,
	/obj/item/weapon/ore = 5
	)

	var/datum/effect/effect/system/ion_trail_follow/ion_trail = null
	var/obj/item/shield_projector/shields = null
	var/obj/item/weapon/storage/bag/ore/my_storage = null

	var/last_search = 0
	var/search_cooldown = 5 SECONDS

/mob/living/simple_mob/mechanical/mining_drone/Initialize()
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

	my_storage = new /obj/item/weapon/storage/bag/ore(src)
	shields = new /obj/item/shield_projector/rectangle/automatic/drone(src)
	return ..()

/mob/living/simple_mob/mechanical/mining_drone/Destroy()
	QDEL_NULL(ion_trail)
	QDEL_NULL(shields)
	QDEL_NULL(my_storage)
	return ..()

/mob/living/simple_mob/mechanical/mining_drone/death()
	my_storage.forceMove(get_turf(src))
	my_storage = null
	..(null,"suddenly breaks apart.")
	qdel(src)

/mob/living/simple_mob/mechanical/mining_drone/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/mechanical/mining_drone/IIsAlly(mob/living/L)
	. = ..()

	var/mob/living/carbon/human/H = L
	if(!istype(H))
		return .

	if(!.)
		var/has_tool = FALSE
		var/obj/item/I = H.get_active_hand()
		if(istype(I,/obj/item/weapon/pickaxe))
			has_tool = TRUE
		return has_tool

/mob/living/simple_mob/mechanical/mining_drone/handle_special()
	if (!isturf(loc))
		return
	if (!my_storage)
		return
	if (ai_holder?.busy)
		return
	if (world.time < last_search + search_cooldown)
		return
	switch (get_AI_stance())
		if (STANCE_APPROACH, STANCE_IDLE, STANCE_FOLLOW)
			. = . //noop
		else
			return
	var/max_space = my_storage.max_storage_space
	var/obj/structure/ore_box/box = locate() in view(3, src)
	if (istype(box))
		if (length(my_storage.contents))
			Beam(box, icon_state = "holo_beam", time = 1 SECONDS)
			box.contents += my_storage.contents
			my_storage.stored_ore_dirty = TRUE
			box.stored_ore_dirty = TRUE
	else if (length(my_storage.contents) >= max_space)
		audible_message(SPAN_NOTICE("\The [src] emits a shrill beep; it's full!"))
		return
	for (var/turf/simulated/floor/floor in view(4, src))
		if (length(my_storage.contents) >= max_space)
			audible_message(SPAN_NOTICE("\The [src] emits a shrill beep; it's full!"))
			return
		if (prob(50))
			continue
		if (!(locate(/obj/item/ore) in floor))
			continue
		Beam(floor, icon_state = "holo_beam", time = 0.5 SECONDS)
		if (box)
			for (var/obj/item/ore/ore in floor)
				box.contents += ore
			box.stored_ore_dirty = TRUE
			Beam(box, icon_state = "holo_beam", time = 0.5 SECONDS)
		else
			my_storage.gather_all(floor, src)
			my_storage.stored_ore_dirty = TRUE

<<<<<<< HEAD
		for(var/turf/T in view(world.view,src))
			if(my_storage.contents.len >= my_storage.max_storage_space)
				break

			if((locate(/obj/item/weapon/ore) in T) && prob(40))
				src.Beam(T, icon_state = "holo_beam", time = 0.5 SECONDS)
				my_storage.rangedload(T, src)

		if(my_storage.contents.len >= my_storage.max_storage_space)
			visible_message("<b>\The [src]</b> emits a shrill beep, indicating its storage is full.")

		var/obj/structure/ore_box/OB = locate() in view(2, src)

		if(istype(OB) && my_storage && my_storage.contents.len)
			src.Beam(OB, icon_state = "rped_upgrade", time = 1 SECONDS)
			for(var/obj/item/I in my_storage)
				my_storage.remove_from_storage(I, OB)
=======
>>>>>>> 6ae04e1d641... Merge pull request #8840 from Spookerton/spkrtn/cng/rock-and-stone

/decl/mob_organ_names/miningdrone
	hit_zones = list("chassis", "comms array", "sensor suite", "left excavator module", "right excavator module", "maneuvering thruster")