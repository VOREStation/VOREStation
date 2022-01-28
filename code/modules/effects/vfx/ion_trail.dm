/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effect/vfx/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = 1.0

/datum/effect_system/ion_trail_follow
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect_system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/ion_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			var/turf/T
			if(istype(holder, /atom/movable))
				var/atom/movable/AM = holder
				if(AM.locs && AM.locs.len)
					T = get_turf(pick(AM.locs))
				else
					T = get_turf(AM)
			else //when would this ever be attached a non-atom/movable?
				T = get_turf(src.holder)
			if(T != src.oldposition)
				if(isturf(T))
					var/obj/effect/vfx/ion_trails/I = new /obj/effect/vfx/ion_trails(src.oldposition)
					src.oldposition = T
					I.set_dir(src.holder.dir)
					flick("ion_fade", I)
					I.icon_state = "blank"
					spawn( 20 )
						qdel(I)
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect_system/ion_trail_follow/proc/stop()
		src.processing = 0
		src.on = 0