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