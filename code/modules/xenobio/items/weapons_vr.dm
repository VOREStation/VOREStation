/obj/item/weapon/xenobio
	name = "xenobio gun"
	desc = "You shouldn't see this!"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "harpoon-2"
	//fire_sound = 'sound/weapons/taser2.ogg'
	//charge_cost = 120 // Twice as many shots.
	//projectile_type = /obj/item/projectile/beam/xenobio // Place holder for now
	//accuracy = 30 // Just use the same hit rate as xenotasers
	var/loadable_item = null
	var/loaded_item = null
	var/loadable_name = null
	var/firable = TRUE
/obj/item/weapon/xenobio/examine(var/mob/user)
	. = ..()
	if(loaded_item)
		.+= "A [loaded_item] is slotted into the side."
	else
		.+= "There appears to be an empty slot for attaching a [loadable_name]."

/obj/item/weapon/xenobio/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src && loaded_item)
		user.put_in_hands(loaded_item)
		user.visible_message("[user] removes [loaded_item] from [src].", "<span class='notice'>You remove [loaded_item] from [src].</span>")
		loaded_item = null
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	else
		return ..()

/obj/item/weapon/xenobio/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, loadable_item))
		if(loaded_item)
			to_chat(user, "<font color='blue'>[I] doesn't seem to fit into [src].</font>")
			return
		//var/obj/item/weapon/reagent_containers/glass/beaker/B = I
		user.drop_item()
		I.loc = src
		loaded_item = I
		//to_chat(user, "<font color='blue'>You slot [I] into [src].</font>")
		user.visible_message("[user] inserts [I] into [src].", "<font color='blue'>You slot [I] into [src].</span>")
		return 1
	..()

/obj/item/weapon/xenobio/attack_self(mob/living/user as mob)
	if(loaded_item)
		user.put_in_hands(loaded_item)
		user.visible_message("[user] removes [loaded_item] from [src].", "<span class='notice'>You remove [loaded_item] from [src].</span>")
		loaded_item = null
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)

/obj/item/weapon/xenobio/afterattack(atom/A, mob/user as mob)
	if(!loaded_item)
		to_chat(user,"<span class = 'warning'>\The [src] shot fizzles, it appears you need to load something!</span>")
		//playsound(src, 'sound/weapons/wave.ogg', 60, 1)
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		return
	if(!firable)
		return

	playsound(src, 'sound/weapons/wave.ogg', 60, 1)

	user.visible_message("<span class='warning'>[user] fires \the [src]!</span>","<span class='warning'>You fire \the [src]!</span>")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()
	s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, user)
	s.start()

/obj/item/weapon/xenobio/monkey_gun
	name = "Bluespace Cube Rehydrator"
	desc = "Based on the technology of the 'Bluespace Harpoon' this device can teleport a loaded cube to a given target and rehydrate it."
	loadable_item = /obj/item/weapon/reagent_containers/food/snacks/monkeycube
	loadable_name = "Monkey Cube"
	origin_tech = list(TECH_BLUESPACE = 5, TECH_BIO = 6)
	//projectile_type = /obj/item/projectile/beam/xenobio/monkey

/obj/item/weapon/xenobio/monkey_gun/afterattack(atom/A, mob/user as mob)
	..()

	if(!firable)
		return

	var/turf/T = get_turf(A)
	if(!T || (T.check_density(ignore_mobs = TRUE)))
		to_chat(user,"<span class = 'warning'>Your rehydrator flashes an error as it attempts to process your target.</span>")
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		return
	if(istype(A, /mob/living))
		to_chat(user,"<span class = 'warning'>The rehydrator's saftey systems prevent firing into living creatures!</span>")
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		return
	if(loaded_item)
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = loaded_item
		cube.loc = A
		cube.Expand()
		loaded_item = null
		firable = FALSE
		VARSET_IN(src, firable, TRUE, 5 SECONDS)

/* Eh, cutting this. Not much reason for it.
/obj/item/weapon/xenobio/potion_gun
	name = "Ranged Potion Delivery Device"
	desc = "This device is designed to deliver a potion to your target at range, it has a slot to attach a xenobio potion."
	loadable_item = /obj/item/slimepotion
	loadable_name = "Slime Potion"
*/
// Instead of bringing the slime to the grinder, lets bring the grinder to the slime! This will process slimes and monkies one at a time.
/obj/item/weapon/slime_grinder
	name = "portable slime processor"
	desc = "An industrial grinder used to automate the process of slime core extraction.  It can also recycle biomatter. This one appears miniturized"
	//icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "chainsaw0"
	//icon_state = "slimegrinder"
	//item_icons = list(
	//		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
	//		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
	//		)
	var/processing = FALSE // So I heard you like processing.
	var/list/to_be_processed = list()
	var/monkeys_recycled = 0
	description_info = "Click a monkey or slime to begin processing."
/*
/obj/machinery/processor/attack_hand(mob/living/user)
	if(processing)
		to_chat(user, "<span class='warning'>The processor is in the process of processing!</span>")
		return
	if(to_be_processed.len)
		spawn(1)
			begin_processing()
	else
		to_chat(user, "<span class='warning'>The processor is empty.</span>")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return
*/
/obj/item/weapon/slime_grinder/proc/extract(var/atom/movable/AM, var/mob/living/user)
	processing = TRUE
	if(istype(AM, /mob/living/simple_mob/slime))
		var/mob/living/simple_mob/slime/S = AM
		while(S.cores)
			playsound(src, 'sound/machines/juicer.ogg', 25, 1)
			if(do_after(user, 15))
				new S.coretype(get_turf(AM))
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
				S.cores--
				//sleep(1 SECOND)
		//to_be_processed.Remove(S)
		qdel(S)

	if(istype(AM, /mob/living/carbon/human/monkey))
		playsound(src, 'sound/machines/juicer.ogg', 25, 1)
		if(do_after(user, 15))
			var/mob/living/carbon/human/M = AM
			playsound(src, 'sound/effects/splat.ogg', 50, 1)
		//to_be_processed.Remove(M)
			qdel(M)
			monkeys_recycled++
			sleep(1 SECOND)
		while(monkeys_recycled >= 4)
			new /obj/item/weapon/reagent_containers/food/snacks/monkeycube(get_turf(src))
			playsound(src, 'sound/effects/splat.ogg', 50, 1)
			monkeys_recycled -= 4
			sleep(1 SECOND)
	processing = FALSE

/obj/item/weapon/slime_grinder/proc/can_insert(var/atom/movable/AM)
	if(istype(AM, /mob/living/simple_mob/slime))
		var/mob/living/simple_mob/slime/S = AM
		if(S.stat != DEAD)
			return FALSE
		return TRUE
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(!istype(H.species, /datum/species/monkey))
			return FALSE
		if(H.stat != DEAD)
			return FALSE
		return TRUE
	return FALSE

/obj/item/weapon/slime_grinder/attack(mob/M as mob, mob/living/user as mob)
	//if(user.stat || user.incapacitated(INCAPACITATION_DISABLED) || !istype(user))
	//	return
	//insert(M, user)
	if(processing)
		return
	if(!can_insert(M))
		to_chat(user, "<span class='warning'>\The [src] cannot process \the [M] at this time.</span>")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return

	extract(M, user)
	return ..()
/* Cut for balance :)
/obj/item/weapon/gun/energy/xenobio/extract_gun
	name = "Ranged Extract Interaction Device"
	desc = "This is the latest in extract interaction technology! No longer shall you stand in harms way when activating a gold slime."
	loadable_item = /obj/item/slime_extract
*/