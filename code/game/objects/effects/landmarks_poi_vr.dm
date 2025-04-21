/obj/effect/landmark/poi_loader
	name = "PoI Loader"
	var/size_x
	var/size_y
	var/poi_type = null
	var/remove_from_pool = TRUE

INITIALIZE_IMMEDIATE(/obj/effect/landmark/poi_loader)

/obj/effect/landmark/poi_loader/Initialize(mapload)
	SSpoints_of_interest.poi_queue += src
	return ..()
