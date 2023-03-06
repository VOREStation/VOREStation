//POI landmarks for the Debris field. Check Readme for details.
//Define your subtypes here, rather than in the map editor
//Makes it easier to change if found problematic or to simply review
/obj/effect/landmark/overmap_renamer/debris_field
	name = "Debries Field Landmarks" //Please change name to be indicative of which POI for better debugging


/obj/effect/landmark/overmap_renamer/debris_field/Initialize()
	..()
	for(var/obj/effect/overmap/visitable/D in visitable_overmap_object_instances)
		if(D.unique_identifier == "Debris Field")
			if(D.possible_descriptors && islist(D.possible_descriptors))
				D.possible_descriptors |= list(descriptors)
