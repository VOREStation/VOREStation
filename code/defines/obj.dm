/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpost/attackby(obj/item/W as obj, mob/user as mob)
	return attack_hand(user)

/obj/structure/signpost/attack_hand(mob/user as mob)
	if(tgui_alert(user, "Travel back to ss13?","Return?",list("Yes","No")) == "Yes")
		if(user.z != src.z)	return
		user.forceMove(get_turf(pick(latejoin)))

/obj/structure/signpost_fake
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpostwood
	name = "signpost"
	desc = "It's a signpost that tells you things!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpostwood"
	anchored = TRUE
	density = TRUE

/obj/structure/signevent //Designed for scene events for people to put their OOC notes on BEFORE going into a room with them.
	name = "sign"
	desc = "It's a sign that tells you things!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sign_event_green"
	anchored = TRUE
	density = FALSE

/obj/structure/signevent/blue
	icon_state = "sign_event_blue"

/obj/structure/signevent/red
	icon_state = "sign_event_red"

/obj/structure/signevent/yellow
	icon_state = "sign_event_yellow"

/obj/effect/mark
		var/mark = ""
		icon = 'icons/misc/mark.dmi'
		icon_state = "blank"
		anchored = TRUE
		layer = 99
		mouse_opacity = 0
		unacidable = TRUE//Just to be sure.

/obj/effect/beam
	name = "beam"
	density = FALSE
	unacidable = TRUE//Just to be sure.
	var/def_zone
	pass_flags = PASSTABLE


/obj/effect/begin
	name = "begin"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "begin"
	anchored = TRUE
	unacidable = TRUE

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
	anchored = TRUE

/obj/effect/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )

/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE//temporary until I decide whether the borg can be removed. -veyveyr

/obj/structure/showcase/sign
	name = "WARNING: WILDERNESS"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wilderness1"
	desc = "This appears to be a sign warning people that the other side is dangerous. It also says that NanoTrasen cannot guarantee your safety beyond this point."

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "beachball"
	name = "beach ball"
	density = FALSE
	anchored = FALSE
	w_class = ITEMSIZE_LARGE
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	user.drop_item()
	src.throw_at(target, throw_range, throw_speed, user)

/obj/item/beach_ball/dodgeball
	icon = 'icons/obj/balls_vr.dmi'
	icon_state = "dodgeball"
	item_state = "dodgeball"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_balls_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_balls_vr.dmi')
	name = "dodgeball"
	desc = "Think fast, chucklenuts!"
	w_class = ITEMSIZE_LARGE //Stops people from hiding it in their bags/pockets
	force = 0.1
	throwforce = 0.1
	throw_speed = 5
	throw_range = 15
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	hitsound = 'sound/weapons/dodgeball.ogg'

/obj/effect/spawner
	name = "object spawner"
