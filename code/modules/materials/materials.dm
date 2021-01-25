/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/simulated/wall
		obj/item/weapon/material
		obj/structure/barricade
		obj/item/stack/material
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			resin
			ONLY WALLS
				cult
				hull
				curvy
				jaggy
				brick
				REINFORCEMENT
					reinf_over
					reinf_mesh
					reinf_cult
					reinf_metal
		DOORS
			stone
			metal
			resin
			wood
*/

// Assoc list containing all material datums indexed by name.
var/list/name_to_material

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/datum/material/material = get_material()
	if(material)
		return material.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/datum/material) - /datum/material)
		var/datum/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	return name_to_material[name]

/proc/material_display_name(name)
	var/datum/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

// Material definition and procs follow.
/datum/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/use_name
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/icon_colour                                      // Colour applied to products of this material.
	var/icon_base = "metal"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_metal"                       // Overlay used
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.
	var/pass_stack_colors = FALSE                        // Will stacks made from this material pass their colors onto objects?

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/integrity = 150          // General-use HP value for products.
	var/protectiveness = 10      // How well this material works as armor.  Higher numbers are better, diminishing returns applies.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/reflectivity = 0         // How reflective to light is the material?  Currently used for laser reflection and defense.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/negation = 0             // Objects that respect this will randomly absorb impacts with this var as the percent chance.
	var/spatial_instability = 0  // Objects that have trouble staying in the same physical space by sheer laws of nature have this. Percent for respecting items to cause teleportation.
	var/conductive = 1           // Objects without this var add NOCONDUCT to flags on spawn.
	var/conductivity = null      // How conductive the material is. Iron acts as the baseline, at 10.
	var/list/composite_material  // If set, object matter var will be a list containing these values.
	var/luminescence
	var/radiation_resistance = 0 // Radiation resistance, which is added on top of a material's weight for blocking radiation. Needed to make lead special without superrobust weapons.
	var/supply_conversion_value  // Supply points per sheet that this material sells for.

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/created_fulltile_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons.  Also used for bullet protection in armor.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"

// Placeholders for light tiles and rglass.
/datum/material/proc/build_rod_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need one rod and one sheet of [display_name] to make anything useful.</span>")
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/datum/material/proc/build_wired_product(var/mob/living/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>")
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)

// Make sure we have a display name and shard icon even if they aren't explicitly set.
/datum/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!shard_icon)
		shard_icon = shard_type

// This is a placeholder for proper integration of windows/windoors into the system.
/datum/material/proc/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this value locally.
/datum/material/proc/get_blunt_damage()
	return weight //todo

// Return the matter comprising this material.
/datum/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else if(SHEET_MATERIAL_AMOUNT)
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// As above.
/datum/material/proc/get_edge_damage()
	return hardness //todo

// Snowflakey, only checked for alien doors at the moment.
/datum/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects made of uranium to irradiate things.
/datum/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid neighbor merging.
/datum/material/placeholder
	name = "placeholder"

// Places a girder object when a wall is dismantled, also applies reinforced material.
/datum/material/proc/place_dismantled_girder(var/turf/target, var/datum/material/reinf_material, var/datum/material/girder_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()
	if(girder_material)
		if(istype(girder_material, /datum/material))
			girder_material = girder_material.name
		G.set_material(girder_material)


// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/datum/material/proc/place_dismantled_product(var/turf/target)
	place_sheet(target)

// Debris product. Used ALL THE TIME.
/datum/material/proc/place_sheet(var/turf/target)
	if(stack_type)
		return new stack_type(target)

// As above.
/datum/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/weapon/material/shard(target, src.name)

// Used by walls and weapons to determine if they break or not.
/datum/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/datum/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Used by walls to do on-touch things, after checking for crumbling and open-ability.
/datum/material/proc/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	return

// Datum definitions follow.
/datum/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	supply_conversion_value = 2

/datum/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductive = 0
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)
	supply_conversion_value = 8

/datum/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 2

/datum/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#EDD12F"

/datum/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 2

//R-UST port
/datum/material/supermatter
	name = "supermatter"
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = 20
	stack_type = null
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)

/datum/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	supply_conversion_value = 5

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/datum/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas("phoron", phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/

/datum/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/stone/marble
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30 //VOREStation Edit - Please.
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	supply_conversion_value = 2

/datum/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"

/datum/material/steel/hull
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/diona
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/datum/material/steel/holographic
	name = "holo" + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT, "platinum" = SHEET_MATERIAL_AMOUNT) //todo
	supply_conversion_value = 6

/datum/material/plasteel/hull
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)

// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel/hull
	integrity = 600
	melting_point = 7000
	icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list("plasteel" = SHEET_MATERIAL_AMOUNT, "diamond" = SHEET_MATERIAL_AMOUNT) //shrug
	supply_conversion_value = 9

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	name = MAT_DURASTEELHULL
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/plasteel/titanium
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

/datum/material/plasteel/titanium/hull
	name = MAT_TITANIUMHULL
	stack_type = /obj/item/stack/material/titanium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/plasteel/titanium/hull/place_sheet(var/turf/target) //Deconstructed into normal titanium sheets.
	new /obj/item/stack/material/titanium(target)

/datum/material/glass
	name = "glass"
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 30
	weight = 15
	protectiveness = 0 // 0%
	conductive = 0
	conductivity = 1 // Glass shards don't conduct.
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 2)
	created_window = /obj/structure/window/basic
	created_fulltile_window = /obj/structure/window/basic/full
	rod_product = /obj/item/stack/material/glass/reinforced

/datum/material/glass/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)

	if(!user || !used_stack || !created_window || !created_fulltile_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>This task is too complex for your clumsy hands.</span>")
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, "<span class='warning'>You must be standing on open flooring to build a window.</span>")
		return 1

	var/title = "Sheet-[used_stack.name] ([used_stack.get_amount()] sheet\s left)"
	var/choice = input(title, "What would you like to construct?") as null|anything in window_options

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat || user.loc != T)
		return 1

	// Get data for building windows here.
	var/list/possible_directions = cardinal.Copy()
	var/window_count = 0
	for (var/obj/structure/window/check_window in user.loc)
		window_count++
		possible_directions  -= check_window.dir
	for (var/obj/structure/windoor_assembly/check_assembly in user.loc)
		window_count++
		possible_directions -= check_assembly.dir
	for (var/obj/machinery/door/window/check_windoor in user.loc)
		window_count++
		possible_directions -= check_windoor.dir

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	var/failed_to_build

	if(window_count >= 4)
		failed_to_build = 1
	else
		if(choice in list("One Direction","Windoor"))
			if(possible_directions.len)
				for(var/direction in list(user.dir, turn(user.dir,90), turn(user.dir,270), turn(user.dir,180)))
					if(direction in possible_directions)
						build_dir = direction
						break
			else
				failed_to_build = 1
	if(failed_to_build)
		to_chat(user, "<span class='warning'>There is no room in this location.</span>")
		return 1

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		if(is_reinforced())
			build_path = /obj/structure/windoor_assembly/secure
	else if(choice == "Full Window")
		build_path = created_fulltile_window
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, "<span class='warning'>You need at least [sheets_needed] sheets to build this.</span>")
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	new build_path(T, build_dir, 1)
	return 1

/datum/material/glass/proc/is_reinforced()
	return (hardness > 35) //todo

/datum/material/glass/reinforced
	name = "rglass"
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 2, "glass" = SHEET_MATERIAL_AMOUNT)
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 2)
	created_window = /obj/structure/window/reinforced
	created_fulltile_window = /obj/structure/window/reinforced/full
	wire_product = null
	rod_product = null

/datum/material/glass/phoron
	name = "borosilicate glass"
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 100
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/phoronbasic
	created_fulltile_window = /obj/structure/window/phoronbasic/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass

/datum/material/glass/phoron/reinforced
	name = "reinforced borosilicate glass"
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronrglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/phoronreinforced
	created_fulltile_window = /obj/structure/window/phoronreinforced/full
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list() //todo
	rod_product = null

/datum/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/graphite
	name = MAT_GRAPHITE
	stack_type = /obj/item/stack/material/graphite
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_mesh"
	icon_colour = "#333333"
	hardness = 75
	weight = 15
	integrity = 175
	protectiveness = 15
	conductivity = 18
	melting_point = T0C+3600
	radiation_resistance = 15
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2)

/datum/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100
	supply_conversion_value = 6

/datum/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1
	supply_conversion_value = 6

/datum/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 5

/datum/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/lead
	name = MAT_LEAD
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.
	supply_conversion_value = 2

// Particle Smasher and other exotic materials.

/datum/material/verdantium
	name = MAT_VERDANTIUM
	stack_type = /obj/item/stack/material/verdantium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#4FE95A"
	integrity = 80
	protectiveness = 15
	weight = 15
	hardness = 30
	shard_type = SHARD_SHARD
	negation = 15
	conductivity = 60
	reflectivity = 0.3
	radiation_resistance = 5
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"
	supply_conversion_value = 8

/datum/material/morphium
	name = MAT_MORPHIUM
	stack_type = /obj/item/stack/material/morphium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#37115A"
	icon_reinf = "reinf_metal"
	protectiveness = 60
	integrity = 300
	conductive = 0
	conductivity = 1.5
	hardness = 90
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	explosion_resistance = 85
	reflectivity = 0.2
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_ILLEGAL = 1, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_ARCANE = 1)
	supply_conversion_value = 13

/datum/material/morphium/hull
	name = MAT_MORPHIUMHULL
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/valhollide
	name = MAT_VALHOLLIDE
	stack_type = /obj/item/stack/material/valhollide
	icon_base = "stone"
	door_icon_base = "stone"
	icon_reinf = "reinf_mesh"
	icon_colour = "##FFF3B2"
	protectiveness = 30
	integrity = 240
	weight = 30
	hardness = 45
	negation = 2
	conductive = 0
	conductivity = 5
	reflectivity = 0.5
	radiation_resistance = 20
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"


// Adminspawn only, do not let anyone get this.
/datum/material/alienalloy
	name = "alienalloy"
	display_name = "durable alloy"
	stack_type = null
	flags = MATERIAL_UNMELTABLE
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%

// Likewise.
/datum/material/alienalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

// Ditto.
/datum/material/alienalloy/dungeonium
	name = "dungeonium"
	display_name = "ultra-durable"
	icon_base = "dungeon"
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/bedrock
	name = "bedrock"
	display_name = "impassable rock"
	icon_base = "rock"
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/alium
	name = "alium"
	display_name = "alien"
	icon_base = "alien"
	icon_colour = "#FFFFFF"

/datum/material/resin
	name = "resin"
	icon_colour = "#35343a"
	icon_base = "resin"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	icon_reinf = "reinf_mesh"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	stack_type = /obj/item/stack/material/resin

/datum/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/datum/material/resin/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		to_chat(M, "<span class='alien'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0

/datum/material/wood
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#9c5930"
	integrity = 50
	icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
	conductive = 0
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"

/datum/material/wood/log
	name = MAT_LOG
	icon_base = "log"
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"
	pass_stack_colors = TRUE
	supply_conversion_value = 1

/datum/material/wood/log/sif
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/wood/sif
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/cardboard
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	conductive = 0
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1
	pass_stack_colors = TRUE

/datum/material/snow
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#FFFFFF"
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1

/datum/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	name = "packed snow"
	flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1

/datum/material/cloth //todo
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	flags = MATERIAL_PADDING
	conductive = 0
	pass_stack_colors = TRUE
	supply_conversion_value = 2

/datum/material/cloth/syncloth
	name = "syncloth"
	stack_origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)
	door_icon_base = "wood"
	ignition_point = T0C+532
	melting_point = T0C+600
	integrity = 200
	protectiveness = 15 // 4%
	flags = MATERIAL_PADDING
	conductive = 0
	pass_stack_colors = TRUE
	supply_conversion_value = 3

/datum/material/cult
	name = "cult"
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0

/datum/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target, "cult")

/datum/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/datum/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/datum/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)

/datum/material/chitin
	name = MAT_CHITIN
	icon_colour = "#8d6653"
	stack_type = /obj/item/stack/material/chitin
	stack_origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	icon_base = "solid"
	icon_reinf = "reinf_mesh"
	integrity = 60
	ignition_point = T0C+400
	melting_point = T0C+500
	protectiveness = 25
	conductive = 0
	supply_conversion_value = 4

//TODO PLACEHOLDERS:
/datum/material/leather
	name = MAT_LEATHER
	display_name = "plainleather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0
	supply_conversion_value = 3

/datum/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/datum/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_yellow
	name = "yellow"
	display_name = "yellow"
	use_name = "yellow cloth"
	icon_colour = "#EEF573"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_orange
	name = "orange"
	display_name = "orange"
	use_name = "orange cloth"
	icon_colour = "#E3BF49"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/toy_foam
	name = "foam"
	display_name = "foam"
	use_name = "foam"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	icon_colour = "#ff9900"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	conductive = 0
