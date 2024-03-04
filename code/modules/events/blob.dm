/datum/event/blob
	announceWhen	= 12
	endWhen			= 120

	var/obj/structure/blob/core/Blob


/datum/event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		kill()
		return

	Blob = new /obj/structure/blob/core/random_medium(T)


/datum/event/blob/tick()
	if(!Blob || !Blob.loc)
		Blob = null
		kill()
		return
