/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)
		new /mob/living/simple_mob/animal/passive/bird(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/kea(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/eclectus(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen(src)
		new /mob/living/simple_mob/animal/passive/bird/black_bird(src)
		new /mob/living/simple_mob/animal/passive/bird/azure_tit(src)
		new /mob/living/simple_mob/animal/passive/bird/european_robin(src)
		new /mob/living/simple_mob/animal/passive/bird/goldcrest(src)
		new /mob/living/simple_mob/animal/passive/bird/ringneck_dove(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/animal/pred
	name = "Predator carrier"
	starts_with = list(/mob/living/simple_mob/vore/catgirl)

/obj/structure/largecrate/animal/pred/Initialize() //This is nessesary to get a random one each time.
	starts_with = list(pick(/mob/living/simple_mob/vore/bee,
						/mob/living/simple_mob/vore/catgirl;3,
						/mob/living/simple_mob/vore/aggressive/frog,
						/mob/living/simple_mob/vore/horse,
						/mob/living/simple_mob/vore/aggressive/panther,
						/mob/living/simple_mob/vore/aggressive/giant_snake,
						/mob/living/simple_mob/animal/wolf,
						/mob/living/simple_mob/animal/space/bear;0.5,
						/mob/living/simple_mob/animal/space/carp,
						/mob/living/simple_mob/vore/aggressive/mimic,
						/mob/living/simple_mob/vore/aggressive/rat,
						/mob/living/simple_mob/vore/aggressive/rat/tame,
						/mob/living/simple_mob/vore/rabbit,
						/mob/living/simple_mob/vore/weretiger;0.5,
//						/mob/living/simple_mob/otie;0.5
						))
	return ..()

/obj/structure/largecrate/animal/dangerous
	name = "Dangerous Predator carrier"
	starts_with = list(/mob/living/simple_mob/animal/space/alien)

/obj/structure/largecrate/animal/dangerous/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/animal/space/carp/large,
						/mob/living/simple_mob/vore/aggressive/deathclaw,
						/mob/living/simple_mob/vore/aggressive/dino,
						/mob/living/simple_mob/animal/space/alien,
						/mob/living/simple_mob/animal/space/alien/drone,
						/mob/living/simple_mob/animal/space/alien/sentinel,
						/mob/living/simple_mob/animal/space/alien/queen,
//						/mob/living/simple_mob/otie/feral,
//						/mob/living/simple_mob/otie/red,
						/mob/living/simple_mob/vore/aggressive/corrupthound))
	return ..()
/*
/obj/structure/largecrate/animal/guardbeast
	name = "VARMAcorp autoNOMous security solution"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_mob/otie/security)

/obj/structure/largecrate/animal/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments."
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs. This one can survive hostile atmosphere."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	starts_with = list(/mob/living/simple_mob/otie/security/phoron)

/obj/structure/largecrate/animal/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	desc = "A warning on the side says the creature inside was returned to the supplier after injuring or devouring several unlucky members of the previous adoption family. It was given a second chance with the next customer. Godspeed and good luck with your new pet!"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "otiecrate2"
	starts_with = list(/mob/living/simple_mob/otie/cotie)
	var/taped = 1

/obj/structure/largecrate/animal/otie/phoron
	name = "VARMAcorp adaptive beta subject (Experimental)"
	desc = "VARMAcorp experimental hostile environment adaptive breeding development kit. WARNING, DO NOT RELEASE IN WILD!"
	starts_with = list(/mob/living/simple_mob/otie/cotie/phoron)

/obj/structure/largecrate/animal/otie/phoron/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/otie/cotie/phoron;2,
						/mob/living/simple_mob/otie/red/friendly;0.5))
	return ..()

/obj/structure/largecrate/animal/otie/attack_hand(mob/living/carbon/human/M as mob)//I just couldn't decide between the icons lmao
	if(taped == 1)
		playsound(src, 'sound/items/poster_ripped.ogg', 50, 1)
		icon_state = "otiecrate"
		taped = 0
	..()
*/ //VORESTATION AI REMOVAL, Oties are still fucking broken.

/obj/structure/largecrate/animal/catgirl
	name = "Catgirl Crate"
	desc = "A sketchy looking crate with airholes that seems to have had most marks and stickers removed. You can almost make out 'genetically-engineered subject' written on it."
	starts_with = list(/mob/living/simple_mob/vore/catgirl)

/obj/structure/largecrate/animal/wolfgirl
	name = "Wolfgirl Crate"
	desc = "A sketchy looking crate with airholes that shakes and thuds every now and then. Someone seems to be demanding they be let out."
	starts_with = list(/mob/living/simple_mob/vore/wolfgirl)

/obj/structure/largecrate/animal/fennec
	name = "Fennec Crate"
	desc = "Bounces around a lot. Looks messily packaged, were they in a hurry?"
	starts_with = list(/mob/living/simple_mob/vore/fennec)

/obj/structure/largecrate/animal/fennec/Initialize()
	starts_with = list(pick(/mob/living/simple_mob/vore/fennec,
						/mob/living/simple_mob/vore/fennix;0.5))
	return ..()

/obj/structure/largecrate/animal/jerboa
	name = "Jerboa Crate"
	desc = "Lots, and lots of squeaking."
	starts_with = list(/mob/living/simple_mob/animal/passive/mouse/jerboa)

/obj/structure/largecrate/animal/weretiger
	name = "Weretiger Crate"
	desc = "You can hear a lot of annoyed scratches, clearly someone doesn't enjoy being locked up."
	starts_with = list(/mob/living/simple_mob/vore/weretiger)