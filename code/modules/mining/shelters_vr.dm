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

/datum/map_template/shelter/cabin_deluxe
	name = "Shelter Deluxe Cabin"
	shelter_id = "shelter_cab_deluxe"
	description = "A glamorously furnished cabin packed away in your pocket. \
		Includes a private dormitory, bathroom, dining room, and a very \
		compactly designed kitchen. Designed for a comfortable extended \
		stay in isolated wilderness survival scenarios."
	mappath = "maps/submaps/shelters/shelter_luxury_cabin.dmm"

/datum/map_template/shelter/phi
	name = "Shelter Phi"
	shelter_id = "shelter_phi"
	description = "An heavily modified variant of the luxury shelter, \
		this particular model has extra food, drinks, and other supplies. \
		Originally designed for use by colonists on worlds with little to \
		to no contact, the expense of these shelters have prevented them \
		from seeing common use."
	mappath = "maps/submaps/shelters/shelter_a.dmm"

/datum/map_template/shelter/rec
	name = "Shelter Rec Room"
	shelter_id = "shelter_recroom"
	description = "A recreational room in a pocket, offering a gaming table with poker chips, dice, and cards to host group gaming activities, as well as a small arcade for more individual experiences. While offering absolutely nothing that will help someone survive physically aside from a safely isolated atmosphere, the intellectual stimulation provided from the gaming facilities within have been chosen to assist and keep one's mind sharp."
	mappath = "maps/submaps/shelters/shelter_recroom.dmm"

/datum/map_template/shelter/loss_1
	name = "Shelter L1"
	shelter_id = "shelter_loss1"
	description = "North-west quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_1.dmm"

/datum/map_template/shelter/loss_2
	name = "Shelter L2"
	shelter_id = "shelter_loss2"
	description = "North-east quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_2.dmm"

/datum/map_template/shelter/loss_3
	name = "Shelter L3"
	shelter_id = "shelter_loss3"
	description = "South-west quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_3.dmm"

/datum/map_template/shelter/loss_4
	name = "Shelter L4"
	shelter_id = "shelter_loss4"
	description = "South-east quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_4.dmm"
