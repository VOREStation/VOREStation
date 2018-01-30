/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /obj/item/stack/material/wood(src)
		new /mob/living/simple_animal/bird(src)
		new /mob/living/simple_animal/bird/kea(src)
		new /mob/living/simple_animal/bird/eclectus(src)
		new /mob/living/simple_animal/bird/greybird(src)
		new /mob/living/simple_animal/bird/eclectusf(src)
		new /mob/living/simple_animal/bird/blue_caique(src)
		new /mob/living/simple_animal/bird/white_caique(src)
		new /mob/living/simple_animal/bird/green_budgerigar(src)
		new /mob/living/simple_animal/bird/blue_Budgerigar(src)
		new /mob/living/simple_animal/bird/bluegreen_Budgerigar(src)
		new /mob/living/simple_animal/bird/commonblackbird(src)
		new /mob/living/simple_animal/bird/azuretit(src)
		new /mob/living/simple_animal/bird/europeanrobin(src)
		new /mob/living/simple_animal/bird/goldcrest(src)
		new /mob/living/simple_animal/bird/ringneckdove(src)
		new /mob/living/simple_animal/bird/cockatiel(src)
		new /mob/living/simple_animal/bird/white_cockatiel(src)
		new /mob/living/simple_animal/bird/yellowish_cockatiel(src)
		new /mob/living/simple_animal/bird/grey_cockatiel(src)
		new /mob/living/simple_animal/bird/too(src)
		new /mob/living/simple_animal/bird/hooded_too(src)
		new /mob/living/simple_animal/bird/pink_too(src)
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
	held_type = /mob/living/simple_animal/catgirl

/obj/structure/largecrate/animal/pred/New() //This is nessesary to get a random one each time.

	held_type = pick(/mob/living/simple_animal/retaliate/bee,
						/mob/living/simple_animal/catgirl;3,
						/mob/living/simple_animal/hostile/frog,
						/mob/living/simple_animal/horse,
						/mob/living/simple_animal/hostile/panther,
						/mob/living/simple_animal/hostile/snake,
						/mob/living/simple_animal/hostile/wolf,
						/mob/living/simple_animal/hostile/bear;0.5,
						/mob/living/simple_animal/hostile/bear/brown;0.5,
						/mob/living/simple_animal/hostile/carp,
						/mob/living/simple_animal/hostile/mimic,
						/mob/living/simple_animal/otie;0.5)
	..()


/obj/structure/largecrate/animal/dangerous
	name = "Dangerous Predator carrier"
	held_type = /mob/living/simple_animal/hostile/alien

/obj/structure/largecrate/animal/dangerous/New() //This is nessesary to get a random one each time.

	held_type = pick(/mob/living/simple_animal/hostile/carp/pike,
						/mob/living/simple_animal/hostile/deathclaw,
						/mob/living/simple_animal/hostile/dino,
						/mob/living/simple_animal/hostile/alien,
						/mob/living/simple_animal/hostile/alien/drone,
						/mob/living/simple_animal/hostile/alien/sentinel,
						/mob/living/simple_animal/hostile/alien/queen,
						/mob/living/simple_animal/otie/feral)
	..()

/obj/structure/largecrate/animal/guardbeast
	name = "VARMAcorp autoNOMous security solution"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	held_type = /mob/living/simple_animal/otie/security

/obj/structure/largecrate/animal/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments."
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs. This one can survive hostile atmosphere."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "sotiecrate"
	held_type = /mob/living/simple_animal/otie/security/phoron

/obj/structure/largecrate/animal/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	desc = "A warning on the side says the creature inside was returned to the supplier after injuring or devouring several unlucky members of the previous adoption family. It was given a second chance with the next customer. Godspeed and good luck with your new pet!"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "otiecrate2"
	held_type = /mob/living/simple_animal/otie/cotie
	var/taped = 1

/obj/structure/largecrate/animal/otie/phoron
	name = "VARMAcorp adaptive beta subject (Experimental)"
	desc = "VARMAcorp experimental hostile environment adaptive breeding development kit. WARNING, DO NOT RELEASE IN WILD!"
	held_type = /mob/living/simple_animal/otie/cotie/phoron

/obj/structure/largecrate/animal/otie/attack_hand(mob/living/carbon/human/M as mob)//I just couldn't decide between the icons lmao
	if(taped == 1)
		playsound(src, 'sound/items/poster_ripped.ogg', 50, 1)
		icon_state = "otiecrate"
		taped = 0
	..()