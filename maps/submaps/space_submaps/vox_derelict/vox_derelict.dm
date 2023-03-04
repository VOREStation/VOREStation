/*

/obj/effect/overmap/visitable/event_vox_derelict
	name = "vox derelict"
	desc = "A sundered fragment of a much larger vessel. LADAR paints a partial vox silhouette."
	scanner_desc = "A sundered fragment of a much larger vessel. LADAR paints a partial vox silhouette."
	icon_state = "object"
	in_space = 1
	start_x =  7
	start_y =  4

/datum/map_template/space/vox_derelict
	name = "Vox Derelict"
	desc = "A sheared-off chunk of a derelict vox vessel."
	mappath = 'maps/submaps/space_submaps/vox_derelict/vox_derelict.dmm'
	cost = INFINITY

/area/vox_derelict/hallway/e
	name = "Vox Derelict - Starboard Arm"

/area/vox_derelict/hallway/n
	name = "Vox Derelict - Fore Arm"

/area/vox_derelict/hallway/w
	name = "Vox Derelict - Port Arm"

/area/vox_derelict/hallway/s
	name = "Vox Derelict - Aft Arm"

/area/vox_derelict/hallway/se
	name = "Vox Derelict - Aft Starboard Arm"

/area/vox_derelict/hallway/ne
	name = "Vox Derelict - Fore Starboard Arm"

/area/vox_derelict/hallway/sw
	name = "Vox Derelict - Aft Port Arm"

/area/vox_derelict/hallway/nw
	name = "Vox Derelict - Fore Port Arm"

/area/vox_derelict/fluid_processing
	name = "Vox Derelict - Fluid Process"

/area/vox_derelict/grove_one
	name = "Vox Derelict - Primary Auxillary Grove"

/area/vox_derelict/grove_two
	name = "Vox Derelict - Secondary Auxillary Grove"

/area/vox_derelict/grove_three
	name = "Vox Derelict - Tertiary Auxillary Grove"

/area/vox_derelict/storage
	name = "Vox Derelict - Storage Nook"

/area/vox_derelict/mass_reclamation
	name = "Vox Derelict - Mass Reclamation"

/area/vox_derelict/core
	name = "Vox Derelict - Apex Core"

/obj/effect/shuttle_landmark/automatic/vox_derelict
*/

/decl/flooring/vox_tiles
	name = "vox tiling"
	desc = "Tight-fitting plates of some blue-green vox composite."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/tiles_vox.dmi'
	icon_base = "floor"
	has_base_range = 4

/turf/simulated/floor/vox
	name = "vox plating"
	desc = "It quivers uneasily, and feels like hard leather."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/plating_vox.dmi'
	icon_state = "plating"
	base_name = "vox plating"
	base_desc = "It quivers uneasily, and feels like hard leather."
	base_icon = 'maps/submaps/space_submaps/vox_derelict/icons/plating_vox.dmi'
	oxygen = 0
	nitrogen = MOLES_O2STANDARD + MOLES_N2STANDARD

/turf/simulated/floor/vox/tiled
	name = "vox tiling"
	desc = "Tight-fitting plates of some blue-green vox composite."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/tiles_vox.dmi'
	icon_state = "floor1"
	initial_flooring = /decl/flooring/vox_tiles

/obj/structure/vox/apex_body
	name = "vox biocomputer"
	desc = "An enormous spiralling mass of metal and leathery vox biomatter. Whatever life must have once resided in this monstrous shell has fled it."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/vox_large.dmi'
	icon_state = "apex"
	pixel_x = -48
	pixel_y = 64

/obj/structure/vox/apex_pool
	name = "vox reclamation pool"
	desc = "A wide, shallow pool of inky liquid, stirred by invisible motion below the surface."
	pixel_x = -48
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/vox_large.dmi'
	icon_state = "pit"

/obj/structure/vox_conduit
	name = "ark conduit"
	desc = "Some kind of energy conduit, ribbed and ridged and occasionally twitching."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/vox_conduit.dmi'
	icon_state = "conduit"
	layer = TURF_LAYER+0.01
	plane = TURF_PLANE

/obj/structure/vox_light
	name = "ark light"
	desc = "A dim, steady light set into the hull, gleaming like deep sea bioluminescence."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/vox_conduit.dmi'
	icon_state = "light"
	layer = TURF_LAYER+0.01
	plane = TURF_PLANE

/obj/structure/vox_light/Initialize()
	. = ..()
	set_light(8, 0.3, COLOR_CYAN)

/obj/effect/landmark/corpse/vox
	species = SPECIES_VOX

/obj/effect/landmark/corpse/vox/worker
	name = "Vox Worker"
	corpse_outfit = /decl/hierarchy/outfit/vox/survivor

/obj/effect/landmark/corpse/vox/raider
	name = "Vox Raider"
	corpse_outfit = /decl/hierarchy/outfit/vox/raider

/decl/mob_organ_names/vox_drone
	hit_zones = list(
		"chassis",
		"crown",
		"tail",
		"left claw",
		"right claw",
		"left motivator",
		"right motivator"
	)

/datum/ai_holder/simple_mob/vox_drone
	pointblank = TRUE
	conserve_ammo = TRUE
	firing_lanes = TRUE
	can_flee = FALSE

/datum/say_list/vox_drone

/mob/living/simple_mob/mechanical/ark_adjunct
	name = "vox worker drone"
	desc = "Some kind of vox-made drone, all clicking bioalloy and glowing magenta lights."
	icon = 'maps/submaps/space_submaps/vox_derelict/icons/vox_mobs.dmi'
	icon_state = "improvised"
	icon_living = "improvised"
	icon_dead = "improvised_dead"
	faction = "vox_ark"
	maxHealth = 3 LASERS_TO_KILL
	health = 3 LASERS_TO_KILL
	water_resist = 1
	movement_sound = 'sound/effects/servostep.ogg'
	attacktext = list("slashed")
	organ_names = /decl/mob_organ_names/vox_drone
	ai_holder_type = /datum/ai_holder/simple_mob/vox_drone
	say_list_type = /datum/say_list/vox_drone
	melee_damage_lower = 8
	melee_damage_upper = 8
	attack_armor_pen = 5

/mob/living/simple_mob/mechanical/ark_adjunct/soldier
	name = "vox soldier drone"
	icon_state = "arkmade"
	icon_living = "arkmade"
	icon_dead = "arkmade_dead"
	maxHealth = 6 LASERS_TO_KILL
	health = 6 LASERS_TO_KILL
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_armor_pen = 25

// VOX PROPS: todo proper icons
/obj/machinery/portable_atmospherics/hydroponics/vox
	name = "biofoundry growth vat"
	color = COLOR_GREEN_GRAY

/obj/structure/table/vox
	color = COLOR_GREEN_GRAY

/obj/structure/rack/vox
	color = COLOR_GREEN_GRAY

/obj/machinery/door/airlock/vox
	name = "vox bulkhead orifice"
	color = COLOR_GREEN_GRAY
