// QUALITY COPYPASTA
/turf/unsimulated/wall/supermatter
	name = "Bluespace"
	desc = "THE END IS right now actually."

	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

	//luminosity = 5
	//l_color="#0066FF"
	plane = PLANE_LIGHTING_ABOVE

	var/spawned=0 // DIR mask
	var/next_check=0
	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST)

/turf/unsimulated/wall/supermatter/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSturfs, src)
	next_check = world.time+5 SECONDS

/turf/unsimulated/wall/supermatter/Destroy()
	STOP_PROCESSING(SSturfs, src)
	return ..()

/turf/unsimulated/wall/supermatter/process()
	// Only check infrequently.
	if(next_check>world.time) return

	// No more available directions? Shut down process().
	if(avail_dirs.len==0)
		STOP_PROCESSING(SSobj, src)
		return 1

	// We're checking, reset the timer.
	next_check = world.time+5 SECONDS

	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T=get_step(src,pdir)

	// EXPAND
	if(!istype(T,type))
		// Do pretty fadeout animation for 1s.
		new /obj/effect/overlay/bluespacify(T)
		spawn(10)
			// Nom.
			for(var/atom/movable/A in T)
				if(A)
					if(istype(A,/mob/living))
						qdel(A)
					else if(istype(A,/mob)) // Observers, AI cameras.
						continue
					else
						qdel(A)
			T.ChangeTurf(type)

	if((spawned & (NORTH|SOUTH|EAST|WEST)) == (NORTH|SOUTH|EAST|WEST))
		STOP_PROCESSING(SSturfs, src)
		return

/turf/unsimulated/wall/supermatter/attack_generic(mob/user as mob)
	return attack_hand(user)

/turf/unsimulated/wall/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, span_warning("What the fuck are you doing?"))
	return

// /vg/: Don't let ghosts fuck with this.
/turf/unsimulated/wall/supermatter/attack_ghost(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_ai(mob/user as mob)
	return user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_hand(mob/user as mob)
	user.visible_message(span_warning("\The [user] reaches out and touches \the [src]... And then blinks out of existance."),\
		span_danger("You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\""),\
		span_warning("You hear an unearthly noise."))

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/unsimulated/wall/supermatter/attackby(obj/item/W as obj, mob/living/user as mob)
	user.visible_message(span_warning("\The [user] touches \a [W] to \the [src] as a silence fills the room..."),\
		span_danger("You touch \the [W] to \the [src] when everything suddenly goes silent.\"") + "\n" + span_notice("\The [W] flashes into dust as you flinch away from \the [src]."),\
		span_warning("Everything suddenly goes silent."))

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W)
	Consume(W)


/turf/unsimulated/wall/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/datum/gender/T = gender_datums[M.get_visible_gender()]
		AM.visible_message(span_warning("\The [AM] slams into \the [src] inducing a resonance... [T.his] body starts to glow and catch flame before flashing into ash."),\
		span_danger("You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\""),\
		span_warning("You hear an unearthly noise as a wave of heat washes over you."))
	else
		AM.visible_message(span_warning("\The [AM] smacks into \the [src] and rapidly flashes to ash."),\
		span_warning("You hear a loud crack as you are washed with a wave of heat."))

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)


/turf/unsimulated/wall/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user,/mob/observer))
		return

	qdel(user)
