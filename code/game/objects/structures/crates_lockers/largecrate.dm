/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "densecrate"
	density = TRUE
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
	if(W.has_tool_quality(TOOL_CROWBAR))
		new /obj/item/stack/material/wood(src)

		for(var/atom/movable/AM in contents)
			if(AM.simulated)
				AM.forceMove(T)
			//VOREStation Add Start
			if(isanimal(AM))
				var/mob/living/simple_mob/AMBLINAL = AM
				if(!AMBLINAL.mind)
					AMBLINAL.ghostjoin = 1
					AMBLINAL.ghostjoin_icon()
					active_ghost_pods |= AMBLINAL
			//VOREStation Add End
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
	desc = "You aren't sure how this crate is so light, but the Wulf Aeronautics logo might be a hint."
	icon_state = "vehiclecrate"

/obj/structure/largecrate/hoverpod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_CROWBAR))
		var/obj/item/mecha_parts/mecha_equipment/ME
		var/obj/mecha/working/hoverpod/H = new (loc)

		ME = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
		ME.attach(H)
		ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
		ME.attach(H)
	..()

/obj/structure/largecrate/donksoftvendor
	name = "\improper Donk-Soft vendor crate"
	desc = "A hefty wooden crate displaying the logo of Donk-Soft. It's rather heavy."
	starts_with = list(/obj/machinery/vending/donksoft)

/obj/structure/largecrate/vehicle
	name = "vehicle crate"
	desc = "Wulf Aeronautics says it comes in a box for the consumer's sake... How is this so light?"
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
	desc = "A hefty wooden crate proudly displaying the logo of Ward-Takahashi's automotive division."
	starts_with = list(/obj/structure/vehiclecage/quadbike)

/obj/structure/largecrate/vehicle/quadtrailer
	name = "\improper ATV trailer crate"
	desc = "A hefty wooden crate proudly displaying the logo of Ward-Takahashi's automotive division."
	starts_with = list(/obj/structure/vehiclecage/quadtrailer)

/obj/structure/largecrate/animal
	icon_state = "crittercrate"
	desc = "A hefty wooden crate with air holes. It is marked with the logo of NanoTrasen Pastures and the slogan, '90% less cloning defects* than competing brands**, or your money back***!'"

/obj/structure/largecrate/animal/mulebot
	name = "Mulebot crate"
	desc = "A hefty wooden crate labelled 'Proud Product of the Xion Manufacturing Group'"
	icon_state = "mulecrate"
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

/obj/structure/largecrate/animal/catslug
	name = "catslug carrier"
	starts_with = list(/mob/living/simple_mob/vore/alienanimals/catslug)
