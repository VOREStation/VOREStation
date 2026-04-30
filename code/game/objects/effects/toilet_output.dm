// For some reason, /landmark seems to be near-exclusively used for spawnpoints. Yet it's also being used here as the shit output.
// I smell a refactor/repath in the future, but that time is not now.
/obj/effect/landmark/teleplumb_exit
	name = "teleplumbing exit"

/obj/effect/landmark/teleplumb_exit/Entered(atom/movable/thing, atom/old_loc)
	thing.forceMove(get_turf(src))
