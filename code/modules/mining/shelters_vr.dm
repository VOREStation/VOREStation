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
		if(is_type_in_typecache(A, banned_areas) || (A.flags & AREA_BLOCK_INSTANT_BUILDING))
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
	description = "(5x5) A cosy self-contained pressurized shelter, with \
		built-in navigation, entertainment, medical facilities and a \
		sleeping area! Order now, and we'll throw in a TINY FAN, \
		absolutely free!"
	mappath = "maps/submaps/shelters/shelter_1.dmm"

/datum/map_template/shelter/beta
	name = "Shelter Beta"
	shelter_id = "shelter_beta"
	description = "(7x7) An extremely luxurious shelter, containing all \
		the amenities of home, including carpeted floors, hot and cold \
		running water, a gourmet three course meal, cooking facilities, \
		and a deluxe companion to keep you from getting lonely during \
		an ash storm."
	mappath = "maps/submaps/shelters/shelter_2.dmm"

/datum/map_template/shelter/gamma
	name = "Shelter Gamma"
	shelter_id = "shelter_gamma"
	description = "(11x11) A luxury elite bar which holds an entire bar \
		along with two vending machines, tables, and a restroom that \
		also has a sink. This isn't a survival capsule and so you can \
		expect that this won't save you if you're bleeding out to \
		death."
	mappath = "maps/submaps/shelters/shelter_3.dmm"

/datum/map_template/shelter/delta
	name = "Shelter Delta"
	shelter_id = "shelter_delta"
	description = "(11x11) A small firebase that contains equipment and supplies \
		for roughly a squad of military troops. Large quantities of \
		supplies allow it to hold out for an extended period of time\
		and a built in medical facility allows field treatment to be \
		possible."
	mappath = "maps/submaps/shelters/shelter_4.dmm"

/datum/map_template/shelter/epsilon
	name = "Shelter Epsilon"
	shelter_id = "shelter_epsilon"
	description = "(10x5) An escape pod, with a mediocre amount of supplies \
		for escaping a dying ship as soon as possible."
	mappath = "maps/offmap_vr/om_ships/shelter_5.dmm"

/datum/map_template/shelter/cabin
	name = "Shelter Cabin"
	shelter_id = "shelter_cab"
	description = "(7x7) A small cabin; turned into a shelter capsule. Includes dorm amenities, and a nice dinner."
	mappath = "maps/submaps/shelters/shelter_cab.dmm"

/datum/map_template/shelter/cabin_deluxe
	name = "Shelter Deluxe Cabin"
	shelter_id = "shelter_cab_deluxe"
	description = "(11x11) A glamorously furnished cabin packed away in your pocket. \
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

/datum/map_template/shelter/chi
	name = "Shelter Chi"
	shelter_id = "shelter_chi"
	description = "A custom, from-the-ground-up variant of the shelter \
	capsule. Many of the survival utilities have been stripped away in favor \
	of recreational facilities and a more comfortable living quarters. The \
	definition of \"form over function,\" in capsule form!"
	mappath = "maps/submaps/shelters/shelter_h.dmm"

/datum/map_template/shelter/rec
	name = "Shelter Rec Room"
	shelter_id = "shelter_recroom"
	description = "(9x9) A recreational room in a pocket, offering a gaming table with poker chips, dice, and cards to host group gaming activities, as well as a small arcade for more individual experiences. While offering absolutely nothing that will help someone survive physically aside from a safely isolated atmosphere, the intellectual stimulation provided from the gaming facilities within have been chosen to assist and keep one's mind sharp."
	mappath = "maps/submaps/shelters/shelter_recroom.dmm"

/datum/map_template/shelter/sauna
	name = "Shelter Sauna"
	shelter_id = "shelter_sauna"
	description = "(7x7) A luxurious sauna in your pocket. Complete with privacy features, a changing and locker room, and of course a decently spacious sauna room with three benches to rest on."
	mappath = "maps/submaps/shelters/shelter_sauna.dmm"

/datum/map_template/shelter/cafe
	name = "Shelter Cafe"
	shelter_id = "shelter_cafe"
	description = "(11x11) A fully stocked and equipped cafe in your pocket. While this won't save you if you're dying, it will ensure that you and anyone who happens to be with you will never suffer from caffeine withdrawal!"
	mappath = "maps/submaps/shelters/shelter_cafe.dmm"

/datum/map_template/shelter/loss_1
	name = "Shelter L1"
	shelter_id = "shelter_loss1"
	description = "(5x5) North-west quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_1.dmm"

/datum/map_template/shelter/loss_2
	name = "Shelter L2"
	shelter_id = "shelter_loss2"
	description = "(5x5) North-east quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_2.dmm"

/datum/map_template/shelter/loss_3
	name = "Shelter L3"
	shelter_id = "shelter_loss3"
	description = "(5x5) South-west quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_3.dmm"

/datum/map_template/shelter/loss_4
	name = "Shelter L4"
	shelter_id = "shelter_loss4"
	description = "(5x5) South-east quadrant."
	mappath = "maps/submaps/shelters/shelter_loss_4.dmm"

// EXTREMELY DANGEROUS ADMIN-ONLY SHELTERS I BEG YOU DO NOT SPAWN THESE EXCEPT FOR A DISASTROUS BIT

/datum/map_template/shelter/tesla
	name = "Shelter Tesla"
	description = "(11x11) A whole tesla engine setup, complete with a fully charged SMES cell ready to power the emitters. Using this is probably an exceptionally terrible idea."
	shelter_id = "shelter_tesla"
	mappath = "maps/submaps/shelters/shelter_tesla.dmm"

//Redspace capsule shelters - here be weird shit.

/datum/map_template/shelter/nerd_dungeon_evil
	name = "Shelter Nerd Dungeon Evil"
	shelter_id = "shelter_nerd_dungeon_evil"
	mappath = "maps/submaps/shelters/randomshelters/shelter_nerd_dungeon_evil.dmm"

/datum/map_template/shelter/nerd_dungeon_good
	name = "Shelter Nerd Dungeon Good"
	shelter_id = "shelter_nerd_dungeon_good"
	mappath = "maps/submaps/shelters/randomshelters/shelter_nerd_dungeon_good.dmm"

/datum/map_template/shelter/dangerous_pool
	name = "Shelter Dangerous Pool"
	shelter_id = "shelter_dangerous_pool"
	mappath = "maps/submaps/shelters/randomshelters/shelter_dangerous_pool.dmm"

/datum/map_template/shelter/pizza_kitchen
	name = "Shelter Pizza Kitchen"
	shelter_id = "shelter_pizza_kitchen"
	mappath = "maps/submaps/shelters/randomshelters/shelter_pizza.dmm"

/datum/map_template/shelter/tiny_space
	name = "Shelter Smole Space"
	shelter_id = "shelter_tiny_space"
	mappath = "maps/submaps/shelters/randomshelters/shelter_tiny_space.dmm"

/datum/map_template/shelter/christmas
	name = "Shelter Christmas"
	shelter_id = "shelter_christmas"
	mappath = "maps/submaps/shelters/randomshelters/shelter_christmas.dmm"

/datum/map_template/shelter/methlab
	name = "Shelter Meth Lab"
	shelter_id = "shelter_methlab"
	mappath = "maps/submaps/shelters/randomshelters/shelter_methlab.dmm"

/datum/map_template/shelter/blacksmith
	name = "Shelter Blacksmith"
	shelter_id = "shelter_blacksmith"
	mappath = "maps/submaps/shelters/randomshelters/shelter_blacksmith.dmm"

/datum/map_template/shelter/gallery
	name = "Shelter Art Gallery"
	shelter_id = "shelter_gallery"
	mappath = "maps/submaps/shelters/randomshelters/shelter_gallery.dmm"

/datum/map_template/shelter/garden
	name = "Shelter Garden"
	shelter_id = "shelter_garden"
	mappath = "maps/submaps/shelters/randomshelters/shelter_garden.dmm"

/datum/map_template/shelter/mimic_hell
	name = "Shelter Mimic Hell"
	shelter_id = "shelter_mimic_hell"
	mappath = "maps/submaps/shelters/randomshelters/shelter_mimic_hell.dmm"

/datum/map_template/shelter/off_color_bedrooms
	name = "Shelter Off-Color Bedrooms"
	shelter_id = "shelter_off_color"
	mappath = "maps/submaps/shelters/randomshelters/shelter_off_color.dmm"

/datum/map_template/shelter/living_room
	name = "Shelter Living Room"
	shelter_id = "shelter_living_room"
	mappath = "maps/submaps/shelters/randomshelters/shelter_living_room.dmm"

/datum/map_template/shelter/candlelit_dinner
	name = "Shelter Candlelit Dinner"
	shelter_id = "shelter_candlelit_dinner"
	mappath = "maps/submaps/shelters/randomshelters/shelter_candlelit_dinner.dmm"
