//POI landmarks for the Debris field. Check Readme for details.
//Define your subtypes here, rather than in the map editor
//Makes it easier to change if found problematic or to simply review
/obj/effect/landmark/overmap_renamer/debris_field
	name = "Debries Field Landmarks" //Please change name to be indicative of which POI for better debugging
	var/static/reference //Saves us from having to iterate over all visitable overmap obj instances more than once for the debris field.

//Uncomment the testing lines when adding a new landmark and wanting to see if it loaded properly during server init. re-comment after done
/obj/effect/landmark/overmap_renamer/debris_field/Initialize()
	..()
	if(!reference)
//		testing("First overmap descriptor, name: [name]")
		for(var/obj/effect/overmap/visitable/D in visitable_overmap_object_instances)
			if(D.unique_identifier == "Debris Field")
				if(D.possible_descriptors && islist(D.possible_descriptors))
					D.possible_descriptors |= list(descriptors)
					reference = D
	else if (reference  && istype(reference, /obj/effect/overmap/visitable/))
		var/obj/effect/overmap/visitable/D = reference
//		testing("[D] already found, skipping iterating over list. Adding [name] to possible descriptors")
		D.possible_descriptors |= list(descriptors)
