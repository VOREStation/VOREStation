/datum/map_template/shelter
	var/shelter_id
	var/description
	var/blacklisted_turfs
	var/banned_areas
	var/banned_objects

/datum/map_template/shelter/New()
	. = ..()
	blacklisted_turfs = typecacheof(list(/turf/unsimulated, /turf/simulated/floor/tiled))
	banned_areas = typecacheof(/area/shuttle)
	banned_objects = list()

/datum/map_template/shelter/proc/check_deploy(turf/deploy_location, var/is_ship)
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/T in affected)
		var/area/A = get_area(T)
		if(is_type_in_typecache(A, banned_areas))
			return SHELTER_DEPLOY_BAD_AREA

		var/banned = is_type_in_typecache(T, blacklisted_turfs)
		if(banned || T.density)
			return SHELTER_DEPLOY_BAD_TURFS
		//Ships can only deploy in space (bacause their base turf is always turf/space)
		if(is_ship && !is_type_in_typecache(T, typecacheof(/turf/space)))
			return SHELTER_DEPLOY_SHIP_SPACE

		for(var/obj/O in T)
			if((O.density && O.anchored) || is_type_in_typecache(O, banned_objects))
				return SHELTER_DEPLOY_ANCHORED_OBJECTS
	return SHELTER_DEPLOY_ALLOWED

/datum/map_template/shelter/proc/add_roof(turf/deploy_location)
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/T in affected)
		if(isopenspace(T))
			T.ChangeTurf(/turf/simulated/shuttle/floor/voidcraft)

/datum/map_template/shelter/proc/annihilate_plants(turf/deploy_location)
	var/deleted_atoms = 0
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/T in affected)
		for(var/obj/structure/flora/AM in T)
			++deleted_atoms
			qdel(AM)
	admin_notice(span_danger("Annihilated [deleted_atoms] plants."), R_DEBUG)

/datum/map_template/shelter/proc/update_lighting(turf/deploy_location)
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/T in affected)
		T.lighting_build_overlay()

/datum/map_template/shelter/alpha
	name = "Shelter Alpha"
	shelter_id = "shelter_alpha"
	description = "A cosy self-contained pressurized shelter, with \
		built-in navigation, entertainment, medical facilities and a \
		sleeping area! Order now, and we'll throw in a TINY FAN, \
		absolutely free!"
	mappath = "maps/submaps/shelters/shelter_1.dmm"

/datum/map_template/shelter/beta
	name = "Shelter Beta"
	shelter_id = "shelter_beta"
	description = "An extremely luxurious shelter, containing all \
		the amenities of home, including carpeted floors, hot and cold \
		running water, a gourmet three course meal, cooking facilities, \
		and a deluxe companion to keep you from getting lonely during \
		an ash storm."
	mappath = "maps/submaps/shelters/shelter_2.dmm"

/datum/map_template/shelter/gamma
	name = "Shelter Gamma"
	shelter_id = "shelter_gamma"
	description = "A luxury elite bar which holds an entire bar \
		along with two vending machines, tables, and a restroom that \
		also has a sink. This isn't a survival capsule and so you can \
		expect that this won't save you if you're bleeding out to \
		death."
	mappath = "maps/submaps/shelters/shelter_3.dmm"

/datum/map_template/shelter/delta
	name = "Shelter Delta"
	shelter_id = "shelter_delta"
	description = "A small firebase that contains equipment and supplies \
		for roughly a squad of military troops. Large quantities of \
		supplies allow it to hold out for an extended period of time\
		and a built in medical facility allows field treatment to be \
		possible."
	mappath = "maps/submaps/shelters/shelter_4.dmm"

/datum/map_template/shelter/epsilon
	name = "Shelter Epsilon"
	shelter_id = "shelter_epsilon"
	description = "An escape pod, with a mediocre amount of supplies \
		for escaping a dying ship as soon as possible."
	mappath = "maps/offmap_vr/om_ships/shelter_5.dmm"

/datum/map_template/shelter/cabin
	name = "Shelter Cabin"
	shelter_id = "shelter_cab"
	description = "A small cabin; turned into a shelter capsule. Includes dorm amenities, and a nice dinner."
	mappath = "maps/submaps/shelters/shelter_cab.dmm"

/datum/map_template/shelter/zeta
	name = "Shelter Zeta"
	shelter_id = "shelter_zeta"
	description = "An small dropship with a massive number of equipment, \
		weapons, and supplies. Contains exterior weapons, point defense, \
		a shield generator, and extremely advanced technology. It is \
		unknown who manufactued a vessel like this, as it is beyond the \
		technology level of most contemporary powers."
	mappath = "maps/offmap_vr/om_ships/shelter_6.dmm"

/datum/map_template/shelter/phi
	name = "Shelter Phi"
	shelter_id = "shelter_phi"
	description = "An heavily modified variant of the luxury shelter, \
		this particular model has extra food, drinks, and other supplies. \
		Originally designed for use by colonists on worlds with little to \
		to no contact, the expense of these shelters have prevented them \
		from seeing common use."
	mappath = "maps/submaps/shelters/shelter_a.dmm"
