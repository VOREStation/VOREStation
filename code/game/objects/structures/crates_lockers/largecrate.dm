/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage_vr.dmi'	//VOREStation Edit
	icon_state = "densecrate"
	density = 1
	var/list/starts_with

/obj/structure/largecrate/Initialize()
	. = ..()
	if(starts_with)
		create_objects_in_loc(src, starts_with)
		starts_with = null
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || !I.simulated)
			continue
		I.forceMove(src)
	update_icon()

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>You need a crowbar to pry this open!</span>")
	return

/obj/structure/largecrate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "<span class='notice'>You can't open this here!</span>")
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)

		for(var/atom/movable/AM in contents)
			if(AM.simulated)
				AM.forceMove(T)

		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/mule
	name = "MULE crate"

/obj/structure/largecrate/hoverpod
	name = "\improper Hoverpod assembly crate"
	desc = "It comes in a box for the fabricator's sake. Where does the wood come from? ... And why is it lighter?"
	icon_state = "mulecrate"

/obj/structure/largecrate/hoverpod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar())
		var/obj/item/mecha_parts/mecha_equipment/ME
		var/obj/mecha/working/hoverpod/H = new (loc)

		ME = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
		ME.attach(H)
		ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
		ME.attach(H)
	..()

/obj/structure/largecrate/vehicle
	name = "vehicle crate"
	desc = "It comes in a box for the consumer's sake. ..How is this lighter?"
	icon_state = "vehiclecrate"

/obj/structure/largecrate/vehicle/Initialize()
	. = ..()
	for(var/obj/O in contents)
		O.update_icon()

/obj/structure/largecrate/vehicle/bike
	name = "spacebike crate"
	starts_with = list(/obj/structure/vehiclecage/spacebike)

/obj/structure/largecrate/vehicle/quadbike
	name = "\improper ATV crate"
	starts_with = list(/obj/structure/vehiclecage/quadbike)

/obj/structure/largecrate/vehicle/quadtrailer
	name = "\improper ATV trailer crate"
	starts_with = list(/obj/structure/vehiclecage/quadtrailer)

/obj/structure/largecrate/animal
	icon_state = "lisacrate"	//VOREStation Edit

/obj/structure/largecrate/animal/mulebot
	name = "Mulebot crate"
	icon_state = "mulecrate"	//VOREStation Edit
	starts_with = list(/mob/living/bot/mulebot)

/obj/structure/largecrate/animal/corgi
	name = "corgi carrier"
	starts_with = list(/mob/living/simple_mob/animal/passive/dog/corgi)

/obj/structure/largecrate/animal/cow
	name = "cow crate"
	starts_with = list(/mob/living/simple_mob/animal/passive/cow)

/obj/structure/largecrate/animal/goat
	name = "goat crate"
	starts_with = list(/mob/living/simple_mob/animal/goat)

/obj/structure/largecrate/animal/cat
	name = "cat carrier"
	starts_with = list(/mob/living/simple_mob/animal/passive/cat)

/obj/structure/largecrate/animal/cat/bones
	starts_with = list(/mob/living/simple_mob/animal/passive/cat/bones)

/obj/structure/largecrate/animal/chick
	name = "chicken crate"
	starts_with = list(/mob/living/simple_mob/animal/passive/chick = 5)
