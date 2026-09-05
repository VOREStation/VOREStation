
/*
 * The special recipe datums used for the particle smasher.
 */

/datum/particle_smasher_recipe
	var/display_name = ""
	var/list/reagents	// example: = list(REAGENT_ID_PACID = 5)
	var/list/items		// example: = list(/obj/item/tool/crowbar, /obj/item/welder) Place /foo/bar before /foo. Do not include fruit. Maximum of 3 items.
	var/recipe_type = PS_RESULT_STACK			// Are we producing a stack or an item?

	var/result = /obj/item/stack/material/iron		// The sheet this will produce.
	var/required_material = /obj/item/stack/material/iron	// The required material sheet.
	var/required_energy_min = 0			// The minimum energy this recipe can process at.
	var/required_energy_max = 600		// The maximum energy this recipe can process at.
	var/required_atmos_temp_min = 0		// The minimum ambient atmospheric temperature required, in kelvin.
	var/required_atmos_temp_max = 600	// The maximum ambient atmospheric temperature required, in kelvin.
	var/probability = 0					// The probability for the recipe to be produced. 0 will make it impossible.
	var/item_consume_chance = 100		// The probability for the items (not materials) used in the recipe to be consume.
	var/wiki_flag = NONE

/datum/particle_smasher_recipe/proc/check_items(obj/container as obj)
	. = 1
	if (items && items.len)
		var/list/checklist = list()
		checklist = items.Copy() // You should really trust Copy
		if(istype(container, /obj/machinery/particle_smasher))
			var/obj/machinery/particle_smasher/machine = container
			for(var/obj/O in machine.storage)
				if(istype(O,/obj/item/reagent_containers/food/snacks/grown))
					continue // Fruit is handled in check_fruit().
				var/found = 0
				for(var/i = 1; i < checklist.len+1; i++)
					var/item_type = checklist[i]
					if (istype(O,item_type))
						checklist.Cut(i, i+1)
						found = 1
						break
				if (!found)
					. = 0
		if (checklist.len)
			. = -1
	return .

/datum/particle_smasher_recipe/proc/check_reagents(datum/reagents/avail_reagents)
	. = 1
	for (var/r_r in reagents)
		var/aval_r_amnt = avail_reagents.get_reagent_amount(r_r)
		if (!(abs(aval_r_amnt - reagents[r_r])<0.5)) //if NOT equals
			if (aval_r_amnt>reagents[r_r])
				. = 0
			else
				return -1
	if ((reagents?(reagents.len):(0)) < avail_reagents.reagent_list.len)
		return 0
	return .

/datum/particle_smasher_recipe/deuterium_tritium
	display_name = MAT_TRITIUM + " from " + MAT_DEUTERIUM
	reagents = list(REAGENT_ID_HYDROGEN = 15)

	result = /obj/item/stack/material/tritium
	required_material = /obj/item/stack/material/deuterium

	required_energy_min = 200
	required_energy_max = 400

	required_atmos_temp_max = 200
	probability = 30

/datum/particle_smasher_recipe/verdantium_morphium
	display_name = MAT_MORPHIUM + " from " + MAT_VERDANTIUM
	result = /obj/item/stack/material/morphium
	required_material = /obj/item/stack/material/verdantium

	required_energy_min = 400
	required_energy_max = 500
	probability = 20

/datum/particle_smasher_recipe/plasteel_morphium
	display_name = MAT_MORPHIUM + " from Alien Junk"
	items = list(/obj/item/prop/alien/junk)

	result = /obj/item/stack/material/morphium
	required_material = /obj/item/stack/material/plasteel

	required_energy_min = 100
	required_energy_max = 300
	probability = 10

/datum/particle_smasher_recipe/osmium_lead
	display_name = MAT_OSMIUM + " from " + MAT_LEAD
	reagents = list(REAGENT_ID_TUNGSTEN = 10)

	result = /obj/item/stack/material/lead
	required_material = /obj/item/stack/material/osmium

	required_energy_min = 200
	required_energy_max = 400

	required_atmos_temp_min = 1000
	required_atmos_temp_max = 8000
	probability = 50

/datum/particle_smasher_recipe/phoron_valhollide
	display_name = MAT_VALHOLLIDE + " from " + MAT_PHORON
	reagents = list(REAGENT_ID_PACID = 10)

	result = /obj/item/stack/material/valhollide
	required_material = /obj/item/stack/material/phoron

	required_energy_min = 300
	required_energy_max = 500

	required_atmos_temp_min = 1
	required_atmos_temp_max = 100
	probability = 10

/datum/particle_smasher_recipe/valhollide_supermatter
	display_name = MAT_SUPERMATTER + " from " + MAT_VALHOLLIDE
	reagents = list(REAGENT_ID_PHORON = 300) //Requires BS Beaker

	result = /obj/item/stack/material/supermatter
	required_material = /obj/item/stack/material/valhollide

	required_energy_min = 575
	required_energy_max = 600

	required_atmos_temp_min = 3000
	required_atmos_temp_max = 10000
	probability = 1

/datum/particle_smasher_recipe/donkpockets_coal
	display_name = "Ruined Donkpocket"
	items = list(/obj/item/reagent_containers/food/snacks/donkpocket)

	recipe_type = PS_RESULT_ITEM

	result = /obj/item/ore/coal
	required_material = null

	required_energy_min = 1
	required_energy_max = 500

	required_atmos_temp_min = 400
	required_atmos_temp_max = 20000
	probability = 90

/datum/particle_smasher_recipe/donkpockets_ascend
	display_name = "Ascended Donkpocket"
	items = list(/obj/item/reagent_containers/food/snacks/donkpocket)
	reagents = list(REAGENT_ID_PHORON = 120)

	recipe_type = PS_RESULT_ITEM

	result = /obj/item/reagent_containers/food/snacks/donkpocket/ascended
	required_material = /obj/item/stack/material/uranium

	required_energy_min = 501
	required_energy_max = 700

	required_atmos_temp_min = 400
	required_atmos_temp_max = 20000
	probability = 20

/datum/particle_smasher_recipe/glamour
	display_name = "Synthesize " + MAT_GLAMOUR
	items = list(/obj/item/glamour_unstable)

	result = /obj/item/stack/material/glamour
	required_material = /obj/item/stack/material/phoron

	required_energy_min = 500
	required_energy_max = 600

	required_atmos_temp_min = 0
	required_atmos_temp_max = 50
	probability = 100
	item_consume_chance = 10 //Allows only a few unstable glamour to be given out to get lots of stable ones.

/datum/particle_smasher_recipe/platinum_lead
	display_name = MAT_LEAD + " from " + MAT_PLATINUM
	reagents = list(REAGENT_ID_TUNGSTEN = 10)

	result = /obj/item/stack/material/lead
	required_material = /obj/item/stack/material/platinum

	required_energy_min = 100
	required_energy_max = 300

	required_atmos_temp_min = 2000
	required_atmos_temp_max = 6000
	probability = 50

/datum/particle_smasher_recipe/uranium_lead
	display_name = MAT_LEAD + " from " + MAT_URANIUM
	reagents = list(REAGENT_ID_TUNGSTEN = 10)

	result = /obj/item/stack/material/lead
	required_material = /obj/item/stack/material/uranium

	required_energy_min = 50
	required_energy_max = 600

	required_atmos_temp_min = 1000
	required_atmos_temp_max = 10000
	probability = 70

/datum/particle_smasher_recipe/uranium_platinum
	display_name = MAT_PLATINUM + " from " + MAT_URANIUM
	reagents = list(REAGENT_ID_TUNGSTEN = 10)

	result = /obj/item/stack/material/platinum
	required_material = /obj/item/stack/material/uranium

	required_energy_min = 600
	required_energy_max = 650

	required_atmos_temp_min = 6000
	required_atmos_temp_max = 10000
	probability = 30

/datum/particle_smasher_recipe/platinum_uranium
	display_name = MAT_URANIUM + " from " + MAT_PLATINUM
	reagents = list(REAGENT_ID_SILICON = 10)

	result = /obj/item/stack/material/uranium
	required_material = /obj/item/stack/material/platinum

	required_energy_min = 600
	required_energy_max = 700

	required_atmos_temp_min = 8000
	required_atmos_temp_max = 12000
	probability = 40

/datum/particle_smasher_recipe/iron_copper
	display_name = MAT_COPPER + " from " + MAT_IRON
	reagents = list(REAGENT_ID_LITHIUM = 10)

	result = /obj/item/stack/material/copper
	required_material = /obj/item/stack/material/iron

	required_energy_min = 100
	required_energy_max = 300

	required_atmos_temp_min = 2000
	required_atmos_temp_max = 6000
	probability = 40

/datum/particle_smasher_recipe/copper_gold
	display_name = MAT_GOLD + " from " + MAT_COPPER
	reagents = list(REAGENT_ID_TIN = 10)

	result = /obj/item/stack/material/gold
	required_material = /obj/item/stack/material/copper

	required_energy_min = 200
	required_energy_max = 400

	required_atmos_temp_min = 5000
	required_atmos_temp_max = 8000
	probability = 40

/datum/particle_smasher_recipe/hydrogen_deuterium
	display_name = MAT_DEUTERIUM + " from " + MAT_GRAPHITE
	reagents = list(REAGENT_ID_HYDROGEN = 10)

	result = /obj/item/stack/material/deuterium
	required_material = /obj/item/stack/material/graphite

	required_energy_min = 0
	required_energy_max = 100

	required_atmos_temp_min = 1000
	required_atmos_temp_max = 3000
	probability = 20

/datum/particle_smasher_recipe/carbon_titanium
	display_name = MAT_TITANIUM + " from " + MAT_GRAPHITE
	reagents = list(REAGENT_ID_SULFUR = 10)

	result = /obj/item/stack/material/titanium
	required_material = /obj/item/stack/material/graphite

	required_energy_min = 300
	required_energy_max = 600

	required_atmos_temp_min = 3000
	required_atmos_temp_max = 8000
	probability = 40

/datum/particle_smasher_recipe/tritium_mhydrogen
	display_name = MAT_METALHYDROGEN + " from " + MAT_TRITIUM
	reagents = list(REAGENT_ID_RADIUM = 30)

	result = /obj/item/stack/material/mhydrogen
	required_material = /obj/item/stack/material/tritium

	required_energy_min = 500
	required_energy_max = 550

	required_atmos_temp_min = 7000
	required_atmos_temp_max = 12000
	probability = 20

/datum/particle_smasher_recipe/osmium_platinum
	display_name = MAT_PLATINUM + " from " + MAT_OSMIUM
	reagents = list(REAGENT_ID_TUNGSTEN = 10)

	result = /obj/item/stack/material/platinum
	required_material = /obj/item/stack/material/osmium

	required_energy_min = 400
	required_energy_max = 500

	required_atmos_temp_min = 8000
	required_atmos_temp_max = 10000
	probability = 20

/datum/particle_smasher_recipe/aluminium_iron
	display_name = MAT_IRON + " from " + MAT_ALUMINIUM
	reagents = list(REAGENT_ID_ALUMINIUM = 30)

	result = /obj/item/stack/material/iron
	required_material = /obj/item/stack/material/aluminium

	required_energy_min = 200
	required_energy_max = 300

	required_atmos_temp_min = 1000
	required_atmos_temp_max = 5000
	probability = 30

/datum/particle_smasher_recipe/lead_silver
	display_name = MAT_SILVER + " from " + MAT_LEAD
	reagents = list(REAGENT_ID_RADIUM = 30)

	result = /obj/item/stack/material/silver
	required_material = /obj/item/stack/material/lead

	required_energy_min = 600
	required_energy_max = 700

	required_atmos_temp_min = 8000
	required_atmos_temp_max = 10000
	probability = 30
