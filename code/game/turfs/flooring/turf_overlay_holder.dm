//
// Initialize floor decals!	 Woo! This is crazy.
//

var/global/floor_decals_initialized = FALSE

// The Turf Decal Holder
// Since it is unsafe to add overlays to turfs, we hold them here for now.
// Since I want this object to basically not exist, I am modeling it in part after lighting_overlay
/atom/movable/turf_overlay_holder
	name = "turf overlay holder"
	density = 0
	simulated = 0
	anchored = 1
	layer = TURF_LAYER
	icon = null
	icon_state = null
	mouse_opacity = 0
	auto_init = 0

/atom/movable/turf_overlay_holder/New(var/atom/newloc)
	..()
	verbs.Cut()
	var/turf/T = loc
	T.overlay_holder = src

/atom/movable/turf_overlay_holder/Destroy()
	if(loc)
		var/turf/T = loc
		if(T.overlay_holder == src)
			T.overlay_holder = null
	. = ..()

// Variety of overrides so the overlays don't get affected by weird things.
/atom/movable/turf_overlay_holder/ex_act()
	return

/atom/movable/turf_overlay_holder/singularity_act()
	return

/atom/movable/turf_overlay_holder/singularity_pull()
	return

/atom/movable/turf_overlay_holder/forceMove()
	return 0 //should never move

/atom/movable/turf_overlay_holder/Move()
	return 0

/atom/movable/turf_overlay_holder/throw_at()
	return 0

/obj/effect/floor_decal/proc/add_to_turf_decals()
	if(src.supplied_dir) src.set_dir(src.supplied_dir)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))
		var/cache_key = "[src.alpha]-[src.color]-[src.dir]-[src.icon_state]-[T.layer]"
		var/image/I = floor_decals[cache_key]
		if(!I)
			I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.layer = T.layer
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		//world.log << "About to add img:\ref[I] onto decals at turf:\ref[T] ([T.x],[T.y],[T.z]) which has appearance:\ref[T.appearance] and decals.len=[T.decals.len]"
		T.decals += I
		return T
	// qdel(D)
	src.loc = null
	src.tag = null

// Changes to turf to let us do this
/turf
	var/atom/movable/turf_overlay_holder/overlay_holder = null

// After a turf change, destroy the old overlay holder since we will have lost access to it.
/turf/post_change()
	var/atom/movable/turf_overlay_holder/TOH = locate(/atom/movable/turf_overlay_holder, src)
	if(TOH)
		qdel(TOH)
	..()

/turf/proc/apply_decals()
	if(decals)
		if(!overlay_holder)
			overlay_holder = new(src)
		overlay_holder.overlays = src.decals
	else if(overlay_holder)
		overlay_holder.overlays.Cut()
