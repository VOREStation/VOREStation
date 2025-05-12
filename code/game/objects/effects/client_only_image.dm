/*
* Sending images to clients can cause memory leaks if not handled safely.
* This is a wrapper for handling it safely. Mostly used by self deleting effects.
*/
/image/client_only
	var/list/clients = list()

/image/client_only/proc/append_client(var/client/C)
	C.images += src
	clients.Add(WEAKREF(C))

/image/client_only/Destroy(force)
	. = ..()
	for(var/datum/weakref/CW in clients)
		var/client/C = CW?.resolve()
		if(C)
			C.images -= src

// Mostly for motion echos, but someone will probably find another use for it... So parent type gets it instead!
/image/client_only/proc/place_from_root(var/turf/At)
	var/rand_limit = 12
	pixel_x += ((At.x - loc.x) * 32) + rand(-rand_limit,rand_limit)
	pixel_y += ((At.y - loc.y) * 32) + rand(-rand_limit,rand_limit)
