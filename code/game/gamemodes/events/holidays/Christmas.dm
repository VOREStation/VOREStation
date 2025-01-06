/proc/Christmas_Game_Start()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))	continue
		for(var/turf/simulated/floor/T in orange(1,xmas))
			for(var/i=1,i<=rand(1,5),i++)
				new /obj/item/a_gift(T)
	//for(var/mob/living/simple_mob/corgi/Ian/Ian in mob_list)
	//	Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))

/proc/ChristmasEvent()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		var/mob/living/simple_mob/animal/space/tree/evil_tree = new /mob/living/simple_mob/animal/space/tree(xmas.loc)
		evil_tree.icon_state = xmas.icon_state
		evil_tree.icon_living = evil_tree.icon_state
		evil_tree.icon_dead = evil_tree.icon_state
		evil_tree.icon_gib = evil_tree.icon_state
		qdel(xmas)

/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/christmas.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	var/cracked = 0

/obj/item/toy/xmas_cracker/New()
	..()

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user)
	if( !cracked && (issilicon(target) || (ishuman(target) && !target.get_active_hand())) && target.stat == CONSCIOUS)
		target.visible_message(span_notice("[user] and [target] pop \an [src]! *pop*"), span_notice("You pull \an [src] with [target]! *pop*"), span_notice("You hear a *pop*."))
		var/obj/item/paper/Joke = new /obj/item/paper(user.loc)
		Joke.name = "[pick("awful","terrible","unfunny")] joke"
		Joke.info = pick("What did one snowman say to the other?\n\n" + span_italics("'Is it me or can you smell carrots?'"),
			"Why couldn't the snowman get laid?\n\n" + span_italics("He was frigid!"),
			"Where are santa's helpers educated?\n\n" + span_italics("Nowhere, they're ELF-taught."),
			"What happened to the man who stole advent calanders?\n\n" + span_italics("He got 25 days."),
			"What does Santa get when he gets stuck in a chimney?\n\n" + span_italics("Claus-trophobia."),
			"Where do you find chili beans?\n\n" + span_italics("The north pole."),
			"What do you get from eating tree decorations?\n\n" + span_italics("Tinsilitis!"),
			"What do snowmen wear on their heads?\n\n" + span_italics("Ice caps!"),
			"Why is Christmas just like life on ss13?\n\n" + span_italics("You do all the work and the fat guy gets all the credit."),
			"Why doesn't Santa have any children?\n\n" + span_italics("Because he only comes down the chimney."))
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icons()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		return 1
	return ..()

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	flags_inv = 0
	body_parts_covered = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
