/mob/living/simple_mob/animal/passive/fish/koi/poisonous
	desc = "A genetic marvel, combining the docility and aesthetics of the koi with some of the resiliency and cunning of the noble space carp."
	health = 50
	maxHealth = 50
	meat_amount = 0

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/Initialize()
	. = ..()
	create_reagents(60)
	reagents.add_reagent("toxin", 45)
	reagents.add_reagent("impedrezene", 15)

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/Life()
	..()
	if(isbelly(loc) && prob(10))
		var/obj/belly/B = loc
		sting(B.owner)

/mob/living/simple_mob/animal/passive/fish/koi/poisonous/attack_hand(mob/living/L)
	..()
	if(isliving(L) && Adjacent(L))
		var/mob/living/M = L
		visible_message("<span class='warning'>\The [src][is_dead()?"'s corpse":""] flails at [M]!</span>")
		SpinAnimation(7,1)
		if(prob(75))
			if(sting(M))
				to_chat(M, "<span class='warning'>You feel a tiny prick.</span>")
		if(is_dead())
			return
		for(var/i = 1 to 3)
			var/turf/T = get_step_away(src, M)
			if(T && is_type_in_list(T, suitable_turf_types))
				Move(T)
			else
				break
			sleep(3)
/*
/mob/living/simple_mob/animal/passive/fish/koi/poisonous/react_to_attack(var/atom/A)
	if(isliving(A) && Adjacent(A))
		var/mob/living/M = A
		visible_message("<span class='warning'>\The [src][is_dead()?"'s corpse":""] flails at [M]!</span>")
		SpinAnimation(7,1)
		if(prob(75))
			if(sting(M))
				to_chat(M, "<span class='warning'>You feel a tiny prick.</span>")
		if(is_dead())
			return
		for(var/i = 1 to 3)
			var/turf/T = get_step_away(src, M)
			if(T && is_type_in_list(T, suitable_turf_types))
				Move(T)
			else
				break
			sleep(3)
*/
/mob/living/simple_mob/animal/passive/fish/koi/poisonous/proc/sting(var/mob/living/M)
	if(!M.reagents)
		return 0
	M.reagents.add_reagent("toxin", 2)
	M.reagents.add_reagent("impedrezene", 1)
	return 1

/mob/living/simple_mob/animal/passive/fish/measelshark
	name = "Measel Shark"
	tt_desc = "Spot Pistris"
	desc = "An evil measel shark that refuses to get vaccinated, causing other fish to get fish measels."
	icon = 'icons/mob/shark.dmi'
	icon_state = "measelshark"
	icon_living = "measelshark"
	icon_dead = "measelshark-dead"
	meat_amount = 8 //Big fish, tons of meat. Great for feasts.
	meat_type = /obj/item/reagent_containers/food/snacks/sliceable/sharkchunk
	vore_active = 1
	vore_bump_chance = 100
	vore_default_mode = DM_HOLD //docile shark
	vore_capacity = 5
	pixel_x = -50
