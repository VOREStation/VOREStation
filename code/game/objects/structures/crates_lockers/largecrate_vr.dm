/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /obj/item/stack/material/wood(src)
		new /mob/living/simple_animal/cat/bird(src)
		new /mob/living/simple_animal/cat/bird/fluff/kea(src)
		new /mob/living/simple_animal/cat/bird/fluff/eclectus(src)
		new /mob/living/simple_animal/cat/bird/fluff/greybird(src)
		new /mob/living/simple_animal/cat/bird/fluff/eclectusf(src)
		new /mob/living/simple_animal/cat/bird/fluff/blue_caique(src)
		new /mob/living/simple_animal/cat/bird/fluff/white_caique(src)
		new /mob/living/simple_animal/cat/bird/fluff/green_budgerigar(src)
		new /mob/living/simple_animal/cat/bird/fluff/blue_Budgerigar(src)
		new /mob/living/simple_animal/cat/bird/fluff/bluegreen_Budgerigar(src)
		new /mob/living/simple_animal/cat/bird/fluff/commonblackbird(src)
		new /mob/living/simple_animal/cat/bird/fluff/azuretit(src)
		new /mob/living/simple_animal/cat/bird/fluff/europeanrobin(src)
		new /mob/living/simple_animal/cat/bird/fluff/goldcrest(src)
		new /mob/living/simple_animal/cat/bird/fluff/ringneckdove(src)
		new /mob/living/simple_animal/cat/bird/fluff/cockatiel(src)
		new /mob/living/simple_animal/cat/bird/fluff/white_cockatiel(src)
		new /mob/living/simple_animal/cat/bird/fluff/yellowish_cockatiel(src)
		new /mob/living/simple_animal/cat/bird/fluff/grey_cockatiel(src)
		new /mob/living/simple_animal/cat/bird/fluff/too(src)
		new /mob/living/simple_animal/cat/bird/fluff/hooded_too(src)
		new /mob/living/simple_animal/cat/bird/fluff/pink_too(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)