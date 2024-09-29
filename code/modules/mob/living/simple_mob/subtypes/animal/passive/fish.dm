// Different types of fish! They are all subtypes of this tho
/datum/category_item/catalogue/fauna/invasive_fish
	name = "Invasive Fauna - Fish"
	desc = "This fish is considered an invasive species according \
	to Sivian wildlife regulations. Removal or relocation is advised."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/fish
	name = "fish"
	desc = "Its a fishy.  No touchy fishy."
	icon = 'icons/mob/fish.dmi'
	item_state = "fish"

	//catalogue_data = list(/datum/category_item/catalogue/fauna/invasive_fish)		 //TODO: write non-sif lore

	mob_size = MOB_SMALL
	// So fish are actually underwater.
	plane = TURF_PLANE
	layer = UNDERWATER_LAYER

	organ_names = /decl/mob_organ_names/fish

	holder_type = /obj/item/holder/fish

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish
	meat_amount = 3

	// By default they can be in any water turf.  Subtypes might restrict to deep/shallow etc
	var/global/list/suitable_turf_types =  list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/water
	)

	var/randomize_location = TRUE

/mob/living/simple_mob/animal/passive/fish/Initialize()
	. = ..()

	if(!default_pixel_x && randomize_location)
		default_pixel_x = rand(-12, 12)

	if(!default_pixel_y && randomize_location)
		default_pixel_y = rand(-6, 10)

// Makes the AI unable to willingly go on land.
/mob/living/simple_mob/animal/passive/fish/IMove(turf/newloc, safety = TRUE)
	if(is_type_in_list(newloc, suitable_turf_types))
		return ..() // Procede as normal.
	return MOVEMENT_FAILED // Don't leave the water!

// Take damage if we are not in water
/mob/living/simple_mob/animal/passive/fish/handle_breathing()
	if(istype(loc, /obj/item/glass_jar/fish))
		var/obj/item/glass_jar/fish/F = loc
		if(F.filled)
			return

	var/turf/T = get_turf(src)
	if(T && !is_type_in_list(T, suitable_turf_types))
		if(prob(50))
			say(pick("Blub", "Glub", "Burble"))
		adjustBruteLoss(unsuitable_atoms_damage)

// Subtypes.
/mob/living/simple_mob/animal/passive/fish/bass
	name = "bass"
	tt_desc = "E Micropterus notius"
	icon_state = "bass-swim"
	icon_living = "bass-swim"
	icon_dead = "bass-dead"

/mob/living/simple_mob/animal/passive/fish/trout
	name = "trout"
	tt_desc = "E Salmo trutta"
	icon_state = "trout-swim"
	icon_living = "trout-swim"
	icon_dead = "trout-dead"

/mob/living/simple_mob/animal/passive/fish/salmon
	name = "salmon"
	tt_desc = "E Oncorhynchus nerka"
	icon_state = "salmon-swim"
	icon_living = "salmon-swim"
	icon_dead = "salmon-dead"

/mob/living/simple_mob/animal/passive/fish/perch
	name = "perch"
	tt_desc = "E Perca flavescens"
	icon_state = "perch-swim"
	icon_living = "perch-swim"
	icon_dead = "perch-dead"

/mob/living/simple_mob/animal/passive/fish/pike
	name = "pike"
	tt_desc = "E Esox aquitanicus"
	icon_state = "pike-swim"
	icon_living = "pike-swim"
	icon_dead = "pike-dead"

/mob/living/simple_mob/animal/passive/fish/koi
	name = "koi"
	tt_desc = "E Cyprinus rubrofuscus"
	icon_state = "koi-swim"
	icon_living = "koi-swim"
	icon_dead = "koi-dead"

/datum/category_item/catalogue/fauna/javelin
	name = "Sivian Fauna - Javelin Shark"
	desc = "Classification: S Cetusan minimalix\
	<br><br>\
	A small breed of fatty shark native to the waters near the Ullran Expanse.\
	The creatures are not known to attack humans or larger animals, possibly \
	due to their size. It is speculated that they are actually scavengers, \
	as they are most commonly found near the gulf floor. \
	<br>\
	The Javelin's reproductive cycle only recurs between three and four \
	Sivian years. \
	<br>\
	These creatures are considered a protected species, and thus require an \
	up-to-date license to be hunted."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/fish/javelin
	name = "javelin"
	tt_desc = "S Cetusan minimalix"
	icon_state = "javelin-swim"
	icon_living = "javelin-swim"
	icon_dead = "javelin-dead"

	catalogue_data = list(/datum/category_item/catalogue/fauna/javelin)

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sif

/datum/category_item/catalogue/fauna/icebass
	name = "Sivian Fauna - Glitter Bass"
	desc = "Classification: X Micropterus notius crotux\
	<br><br>\
	Initially a genetically engineered hybrid of the common Earth bass and \
	the Sivian Rock-Fish. These were designed to deal with the invasive \
	fish species, however to their creators' dismay, they instead \
	began to form their own passive niche. \
	<br>\
	Due to the brilliant reflective scales earning them their name, the \
	animals pose a specific issue for Sivian animals relying on \
	bioluminesence to aid in their hunt. \
	<br>\
	Despite their beauty, they are considered an invasive species."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/fish/icebass
	name = "glitter bass"
	tt_desc = "X Micropterus notius crotux"
	icon_state = "sifbass-swim"
	icon_living = "sifbass-swim"
	icon_dead = "sifbass-dead"

	catalogue_data = list(/datum/category_item/catalogue/fauna/icebass)

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sif

	var/max_red = 150
	var/min_red = 50

	var/max_blue = 255
	var/min_blue = 50

	var/max_green = 150
	var/min_green = 50

	var/dorsal_color = "#FFFFFF"
	var/belly_color = "#FFFFFF"

	var/image/dorsal_image
	var/image/belly_image

/mob/living/simple_mob/animal/passive/fish/icebass/Initialize()
	. = ..()
	dorsal_color = rgb(rand(min_red,max_red), rand(min_green,max_green), rand(min_blue,max_blue))
	belly_color = rgb(rand(min_red,max_red), rand(min_green,max_green), rand(min_blue,max_blue))
	update_icon()

/mob/living/simple_mob/animal/passive/fish/icebass/update_icon()
	cut_overlays()
	..()

	if(!dorsal_image)
		dorsal_image = image(icon, "[icon_state]_mask-body")
	if(!belly_image)
		belly_image = image(icon, "[icon_state]_mask-belly")

	dorsal_image.icon_state = "[icon_state]_mask-body"
	belly_image.icon_state = "[icon_state]_mask-belly"

	dorsal_image.color = dorsal_color
	belly_image.color = belly_color

	add_overlay(dorsal_image)
	add_overlay(belly_image)

/datum/category_item/catalogue/fauna/rockfish
	name = "Sivian Fauna - Rock Puffer"
	desc = "Classification: S Tetraodontidae scopulix\
	<br><br>\
	A species strangely resembling the puffer-fish of Earth. These \
	creatures do not use toxic spines to protect themselves, instead \
	utilizing an incredibly durable exoskeleton that is molded by the \
	expansion of its ventral fluid bladders. \
	<br>\
	Rock Puffers or 'Rock-fish' are often host to smaller creatures which \
	maneuver their way into the gap between the fish's body and shell. \
	<br>\
	The species is also capable of pulling its vibrantly colored head into \
	the safer confines of its shell, the action being utilized in their \
	attempts to find a mate."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/fish/rockfish
	name = "rock-fish"
	tt_desc = "S Tetraodontidae scopulix"
	icon_state = "rockfish-swim"
	icon_living = "rockfish-swim"
	icon_dead = "rockfish-dead"

	catalogue_data = list(/datum/category_item/catalogue/fauna/rockfish)

	armor = list(
		"melee" = 90,
		"bullet" = 50,
		"laser" = -15,
		"energy" = 30,
		"bomb" = 30,
		"bio" = 100,
		"rad" = 100)

	var/max_red = 255
	var/min_red = 50

	var/max_blue = 255
	var/min_blue = 50

	var/max_green = 255
	var/min_green = 50

	var/head_color = "#FFFFFF"

	var/image/head_image

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sif

/mob/living/simple_mob/animal/passive/fish/rockfish/Initialize()
	. = ..()
	head_color = rgb(rand(min_red,max_red), rand(min_green,max_green), rand(min_blue,max_blue))
	update_icon()

/mob/living/simple_mob/animal/passive/fish/rockfish/update_icon()
	cut_overlays()
	..()
	if(!head_image)
		head_image = image(icon, "[icon_state]_mask")

	head_image.icon_state = "[icon_state]_mask"

	head_image.color = head_color

	add_overlay(head_image)

/datum/category_item/catalogue/fauna/solarfish
	name = "Sivian Fauna - Solar Fin"
	desc = "Classification: S Exocoetidae solarin\
	<br><br>\
	An incredibly rare species of Sivian fish.\
	The solar-fin missile fish is a specialized omnivore capable of \
	catching insects or small birds venturing too close to the water's \
	surface. \
	<br>\
	The glimmering fins of the solar-fin are actually biofluorescent, \
	'charged' by the creature basking at the surface of the water, most \
	commonly by the edge of an ice-shelf, as a rapid means of cover. \
	<br>\
	These creatures are considered a protected species, and thus require an \
	up-to-date license to be hunted."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/passive/fish/solarfish
	name = "sun-fin"
	tt_desc = "S Exocoetidae solarin"
	icon_state = "solarfin-swim"
	icon_living = "solarfin-swim"
	icon_dead = "solarfin-dead"

	catalogue_data = list(/datum/category_item/catalogue/fauna/solarfish)

	has_eye_glow = TRUE

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sif

/datum/category_item/catalogue/fauna/murkin
	name = "Sivian Fauna - Murkfish"
	desc = "Classification: S Perca lutux\
	<br><br>\
	A small, Sivian fish most known for its bland-ness.\
	<br>\
	The species is incredibly close in appearance to the Earth \
	perch, aside from its incredibly tall dorsal fin. The animals use \
	the fin to assess the wind direction while near the surface. \
	<br>\
	The murkfish earns its name from the fact its dense meat tastes like mud \
	thanks to a specially formed protein, most likely an adaptation to \
	protect the species from predation."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/fish/murkin
	name = "murkin"
	tt_desc = "S Perca lutux"

	icon_state = "murkin-swim"
	icon_living = "murkin-swim"
	icon_dead = "murkin-dead"

	catalogue_data = list(/datum/category_item/catalogue/fauna/murkin)

	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/sif/murkfish

/decl/mob_organ_names/fish
	hit_zones = list("head", "body", "dorsal fin", "left pectoral fin", "right pectoral fin", "tail fin")