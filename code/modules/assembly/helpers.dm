/proc/isassembly(O)
	if(istype(O, /obj/item/assembly))
		return 1
	return 0

/proc/isigniter(O)
	if(istype(O, /obj/item/assembly/igniter))
		return 1
	return 0

/proc/isinfared(O)
	if(istype(O, /obj/item/assembly/infra))
		return 1
	return 0

/proc/isprox(O)
	if(istype(O, /obj/item/assembly/prox_sensor))
		return 1
	return 0

/proc/issignaler(O)
	if(istype(O, /obj/item/assembly/signaler))
		return 1
	return 0

/proc/istimer(O)
	if(istype(O, /obj/item/assembly/timer))
		return 1
	return 0
