//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m", do_gibs, gib_file = 'icons/mob/mob.dmi')
	if(stat != DEAD)
		death(1)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	update_canmove()
	dead_mob_list -= src

	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = gib_file
	animation.master = src

	flick(anim, animation)
	if(do_gibs) gibs(loc, dna)

	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/effect/decal/cleanable/ash)
	death(1)
	var/atom/movable/overlay/animation = null
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	dead_mob_list -= src
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

/mob/proc/ash(anim="dust-m")
	death(1)
	var/atom/movable/overlay/animation = null
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)

	dead_mob_list -= src
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...")

	if(stat == DEAD)
		return 0
	SEND_SIGNAL(src, COMSIG_MOB_DEATH, gibbed)
	if(src.loc && istype(loc,/obj/belly) || istype(loc,/obj/item/device/dogborg/sleeper)) deathmessage = "no message" //VOREStation Add - Prevents death messages from inside mobs
	facing_dir = null

	if(!gibbed && deathmessage != DEATHGASP_NO_MESSAGE)
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	set_stat(DEAD)

	update_canmove()

	dizziness = 0
	jitteriness = 0

	layer = MOB_LAYER

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_r_hand()
	drop_l_hand()

	if(healths)
		healths.overlays = null // This is specific to humans but the relevant code is here; shouldn't mess with other mobs.
		healths.icon_state = "health6"

	timeofdeath = world.time
	if(mind) mind.store_memory("Time of death: [stationtime2text()]", 0)
	living_mob_list -= src
	dead_mob_list |= src

	set_respawn_timer()
	updateicon()
	handle_regular_hud_updates()
	handle_vision()

	if(ticker && ticker.mode)
		ticker.mode.check_win()


	return 1
