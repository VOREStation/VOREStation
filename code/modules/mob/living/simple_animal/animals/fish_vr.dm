/mob/living/simple_animal/fish/koi/poisonous
	desc = "A genetic marvel, combining the docility and aesthetics of the koi with some of the resiliency and cunning of the noble space carp."
	health = 50
	maxHealth = 50

/mob/living/simple_animal/fish/koi/poisonous/New()
	..()
	create_reagents(60)
	reagents.add_reagent("toxin", 45)
	reagents.add_reagent("impedrezene", 15)

/mob/living/simple_animal/fish/koi/poisonous/Life()
	..()
	var/datum/belly/why = check_belly(src)
	if(why && prob(10))
		sting(why.owner)

/mob/living/simple_animal/fish/koi/poisonous/react_to_attack(var/atom/A)
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

/mob/living/simple_animal/fish/koi/poisonous/proc/sting(var/mob/living/M)
	if(!M.reagents)
		return 0
	M.reagents.add_reagent("toxin", 2)
	M.reagents.add_reagent("impedrezene", 1)
	return 1