// this code here enables people to dig up worms from certain tiles.

/turf/simulated/floor/outdoors/grass/attackby(obj/item/weapon/S as obj, mob/user as mob)
	if(istype(S, /obj/item/stack/tile/floor))
		ChangeTurf(/turf/simulated/floor, preserve_outdoors = TRUE)
		return
	. = ..()