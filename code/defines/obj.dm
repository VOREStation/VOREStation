/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = 1
	density = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		switch(alert("Travel back to ss13?",,"Yes","No"))
			if("Yes")
				if(user.z != src.z)	return
				user.forceMove(pick(latejoin))
			if("No")
				return

/obj/effect/mark
		var/mark = ""
		icon = 'icons/misc/mark.dmi'
		icon_state = "blank"
		anchored = 1
		layer = 99
		mouse_opacity = 0
		unacidable = 1//Just to be sure.

/obj/effect/beam
	name = "beam"
	density = 0
	unacidable = 1//Just to be sure.
	var/def_zone
	pass_flags = PASSTABLE


/obj/effect/begin
	name = "begin"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "begin"
	anchored = 1.0
	unacidable = 1

/*
 * This item is completely unused, but removing it will break something in R&D and Radio code causing PDA and Ninja code to fail on compile
 */

/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "[prefix] ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/obj/effect/laser
	name = "laser"
	desc = "IT BURNS!!!"
	icon = 'icons/obj/projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0

/obj/effect/projection
	name = "Projection"
	desc = "This looks like a projection of something."
	anchored = 1.0

/obj/effect/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )

/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/structure/showcase/sign
	name = "WARNING: WILDERNESS"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wilderness1"
	desc = "This appears to be a sign warning people that the other side is dangerous. It also says that NanoTrasen cannot guarantee your safety beyond this point."

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/weapon/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "beachball"
	name = "beach ball"
	density = 0
	anchored = 0
	w_class = ITEMSIZE_LARGE
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed, user)

/obj/effect/spawner
	name = "object spawner"
