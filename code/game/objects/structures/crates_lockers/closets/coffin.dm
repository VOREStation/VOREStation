/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon = 'icons/obj/closets/coffin.dmi'

	icon_state = "closed_unlocked"
	seal_tool = /obj/item/weapon/tool/screwdriver
	breakout_sound = 'sound/weapons/tablehit1.ogg'
	closet_appearance = null // Special icon for us

/* Graves */
/obj/structure/closet/grave
	name = "grave"
	desc = "Dirt."
	icon = 'icons/obj/closets/grave.dmi'
	icon_state = "closed_unlocked"
	seal_tool = null
	breakout_sound = 'sound/weapons/thudswoosh.ogg'
	anchored = TRUE
	max_closets = 1
	opened = 1
	closet_appearance = null // Special icon for us
	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'

/obj/structure/closet/grave/attack_hand(mob/user as mob)
	if(opened)
		visible_message("<span class='notice'>[user] starts to climb into \the [src.name].</span>", \
						"<span class='notice'>You start to lower yourself into \the [src.name].</span>")
		if(do_after(user, 50))
			user.forceMove(src.loc)
			visible_message("<span class='notice'>[user] climbs into \the [src.name].</span>", \
							"<span class='notice'>You climb into \the [src.name].</span>")
		else
			visible_message("<span class='notice'>[user] decides not to climb into \the [src.name].</span>", \
							"<span class='notice'>You stop climbing into \the [src.name].</span>")
	return

/obj/structure/closet/grave/CanPass(atom/movable/mover, turf/target)
	if(opened && ismob(mover))
		var/mob/M = mover
		add_fingerprint(M)
		if(ishuman(M))
			var/mob/living/human/H = M
			if(H.m_intent == "walk")
				to_chat(H, "<span class='warning'>You stop at the edge of \the [src.name].</span>")
				return FALSE
			else
				to_chat(H, "<span class='warning'>You fall into \the [src.name]!</span>")
				fall_in(H)
				return TRUE
		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.a_intent == I_HELP)
				to_chat(R, "<span class='warning'>You stop at the edge of \the [src.name].</span>")
				return FALSE
			else
				to_chat(R, "<span class='warning'>You enter \the [src.name].</span>")
				return TRUE
	return TRUE	//Everything else can move over the graves

/obj/structure/closet/grave/proc/fall_in(mob/living/L)	//Only called on humans for now, but still
	L.Weaken(5)
	if(ishuman(L))
		var/mob/living/human/H = L
		var/limb_damage = rand(5,25)
		H.adjustBruteLoss(limb_damage)

/obj/structure/closet/grave/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/weapon/shovel))
			user.visible_message("<span class='notice'>[user] piles dirt into \the [src.name].</span>", \
								 "<span class='notice'>You start to pile dirt into \the [src.name].</span>", \
								 "<span class='notice'>You hear dirt being moved.</span>")
			if(do_after(user, 40 * W.toolspeed))
				user.visible_message("<span class='notice'>[user] pats down the dirt on top of \the [src.name].</span>", \
								 "<span class='notice'>You finish filling in \the [src.name].</span>")
				close()
				return
			else
				user.visible_message("<span class='notice'>[user] stops filling in \the [src.name].</span>", \
								 "<span class='notice'>You change your mind and stop filling in \the [src.name].</span>")
				return
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			src.MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weapon/storage/laundry_basket) && W.contents.len)
			var/obj/item/weapon/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message("<span class='notice'>[user] empties \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You empty \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You hear rustling of clothes.</span>")
			return
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		usr.drop_item()
		if(W)
			W.forceMove(src.loc)
	else
		if(istype(W, /obj/item/weapon/shovel))
			if(user.a_intent == I_HURT)	// Hurt intent means you're trying to kill someone, or just get rid of the grave
				user.visible_message("<span class='notice'>[user] begins to smoothe out the dirt of \the [src.name].</span>", \
									 "<span class='notice'>You start to smoothe out the dirt of \the [src.name].</span>", \
									 "<span class='notice'>You hear dirt being moved.</span>")
				if(do_after(user, 40 * W.toolspeed))
					user.visible_message("<span class='notice'>[user] finishes smoothing out \the [src.name].</span>", \
										 "<span class='notice'>You finish smoothing out \the [src.name].</span>")
					if(LAZYLEN(contents))
						alpha = 40	// If we've got stuff inside, like maybe a person, just make it hard to see us
					else
						qdel(src)	// Else, go away
					return
				else
					user.visible_message("<span class='notice'>[user] stops concealing \the [src.name].</span>", \
										 "<span class='notice'>You stop concealing \the [src.name].</span>")
					return
			else
				user.visible_message("<span class='notice'>[user] begins to unearth \the [src.name].</span>", \
									 "<span class='notice'>You start to unearth \the [src.name].</span>", \
									 "<span class='notice'>You hear dirt being moved.</span>")
				if(do_after(user, 40 * W.toolspeed))
					user.visible_message("<span class='notice'>[user] reaches the bottom of \the [src.name].</span>", \
										 "<span class='notice'>You finish digging out \the [src.name].</span>")
					break_open()
					return
				else
					user.visible_message("<span class='notice'>[user] stops digging out \the [src.name].</span>", \
										 "<span class='notice'>You stop digging out \the [src.name].</span>")
					return
	return

/obj/structure/closet/grave/close()
	..()
	if(!opened)
		sealed = TRUE

/obj/structure/closet/grave/open()
	.=..()
	alpha = 255	// Needed because of grave hiding

/obj/structure/closet/grave/bullet_act(var/obj/item/projectile/P)
	return PROJECTILE_CONTINUE	// It's a hole in the ground, doesn't usually stop or even care about bullets

/obj/structure/closet/grave/return_air_for_internal_lifeform(var/mob/living/L)
	var/gasid = "carbon_dioxide"
	if(ishuman(L))
		var/mob/living/human/H = L
		if(H.species && H.species.exhale_type)
			gasid = H.species.exhale_type
	var/datum/gas_mixture/grave_breath = new()
	var/datum/gas_mixture/above_air = return_air()
	grave_breath.adjust_gas(gasid, BREATH_MOLES)
	grave_breath.temperature = (above_air.temperature) - 30	//Underground
	return grave_breath

/obj/structure/closet/grave/dirthole
	name = "hole"
