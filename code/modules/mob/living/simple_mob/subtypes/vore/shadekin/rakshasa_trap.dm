/obj/structure/gootrap
	name = "goo"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	var/base_icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	var/basecolor="#030303"
	desc = ""
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	var/deployed = 1
	anchored = 1

/obj/structure/gootrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/structure/gootrap/update_icon()
	..()
	color = basecolor

/obj/structure/gootrap/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/gootrap/attack_hand(mob/user as mob)
	if(has_buckled_mobs() && can_use(user))
		var/victim = english_list(buckled_mobs)
		user.visible_message(
			span_notice("[user] begins freeing [victim] from \the [src]."),
			span_notice("You carefully begin to free [victim] from \the [src]."),
			)
		if(do_after(user, 5))
			user.visible_message(span_notice("[victim] has been freed from \the [src] by [user]."))
			for(var/A in buckled_mobs)
				unbuckle_mob(A)
			anchored = 0
	else
		..()

/obj/structure/gootrap/proc/attack_mob(mob/living/L)
	//trap the victim in place
	set_dir(L.dir)
	can_buckle = 1
	buckle_mob(L)
	var/goo_sounds = list (
			'sound/rakshasa/Decay1.ogg',
			'sound/rakshasa/Decay2.ogg',
			'sound/rakshasa/Decay3.ogg'
			)
	var/sound = pick(goo_sounds)
	playsound(src, sound, 100, 1)
	L << span_danger("You hear a gooey schlorp as \the [src] ensnares your leg, trapping you in place!")
	deployed = 0
	can_buckle = initial(can_buckle)


/obj/structure/gootrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == I_RUN)
			L.visible_message(
				span_danger("[L] steps on \the [src]."),
				span_danger("You step on \the [src]!"),
				span_hear(span_bold("You hear a gooey schlorp as the goo ensnares your leg!"))
				)
			attack_mob(L)
			if(!has_buckled_mobs())
				anchored = 0
			deployed = 0
			message_admins("[key_name(usr)] has stepped in the goo trap.")
	..()
