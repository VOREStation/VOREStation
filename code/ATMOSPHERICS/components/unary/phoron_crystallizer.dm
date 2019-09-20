#define MATERIAL_PHORON "phoron"
#define MATERIAL_PHORON_SHEET "phoron sheet"

/obj/machinery/atmospherics/unary/phoron_crystallizer
	name = "Phoron Crystallizer"
	desc = "A machine for crystallizing and siphoning phoron out of the outside atmosphere, into sheets for use or research."
	icon = 'icons/obj/machines/phoron_crystallizer_vr.dmi'
	icon_state = "phoron_crystallizer-off"
	circuit = /obj/item/weapon/circuitboard/phoron_crystallizer
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 0		// Shouldn't use any power if it's not running.
	active_power_usage = 7500	// High power needs for literally crystallizing phoron into sheets.
	//power_rating = 7500			//7500 W ~ 10 HP
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY|PIPING_ONE_PER_TURF

	var/list/stored_material =  list(MATERIAL_PHORON = 0, MATERIAL_PHORON_SHEET = 0)
	// Capacity increases with matter bin quality
	var/list/storage_capacity = list(MATERIAL_PHORON = 10000, MATERIAL_PHORON_SHEET = 0)
	// How quickly we can siphon and crystallize phoron.
	var/moles_per_tick = 1
	// Power required to crystallize phoron into sheets.  Improves with capacitors
	var/power_per_mole = 1000
	var/phoron_per_mole = 5

	var/recent_power_used = 0
	var/recent_moles_transferred = 0
	var/ui_error = null // For error messages to show up in nano ui.

	var/datum/gas_mixture/internal = new()
	var/const/input_gas = "phoron"
	var/const/output_gas = "null"

/obj/machinery/atmospherics/unary/phoron_crystallizer/filled
	stored_material = list(MATERIAL_PHORON = 10000)

/obj/machinery/atmospherics/unary/phoron_crystallizer/New()
	..()
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."
	default_apply_parts()
	update_icon()
	// TODO - Make these in actual icon states so its not silly like this
	var/image/I = image(icon = icon, icon_state = "phoron-pipe-overlay", dir = dir)
	I.color = PIPE_COLOR_BLUE
	overlays += I
	I = image(icon = icon, icon_state = "phoron-pipe-overlay", dir = reverse_dir[dir])
	I.color = PIPE_COLOR_BLACK
	overlays += I

/obj/machinery/atmospherics/unary/phoron_crystallizer/Destroy()
	. = ..()
	internal = null

/obj/machinery/atmospherics/unary/phoron_crystallizer/process()
	..()
	recent_moles_transferred = 0

	if(inoperable() || use_power < 2)
		ui_error = null
		update_icon()
		if(use_power == 1)
			last_power_draw = idle_power_usage
		else
			last_power_draw = 0
		return 0

	last_power_draw = active_power_usage

	// STEP 1 - Check material resources
	if(stored_material[MATERIAL_PHORON] < phoron_per_mole)
		ui_error = "Insufficient [material_display_name(MATERIAL_PHORON)] to process."
		update_icon()
		return
	if(stored_material[MATERIAL_PHORON_SHEET] + carbon_per_mole > storage_capacity[MATERIAL_PHORON_SHEET])
		ui_error = "[material_display_name(MATERIAL_PHORON_SHEET)] output storage is full."
		update_icon()
		return
	var/moles_to_convert = min(moles_per_tick,\
		stored_material[MATERIAL_ALGAE] * algae_per_mole,\
		storage_capacity[MATERIAL_PHORON_SHEET] - stored_material[MATERIAL_PHORON_SHEET])

	// STEP 2 - Take the CO2 out of the input!
	var/power_draw = scrub_gas(src, list(input_gas), air1, internal, moles_to_convert)
	if(network1)
		network1.update = 1
	if (power_draw > 0)
		use_power(power_draw)
		last_power_draw += power_draw

	// STEP 3 - Convert CO2 to O2  (Note: We know our internal group multipier is 1, so just be cool)
	var/co2_moles = internal.gas[input_gas]
	if(co2_moles < MINIMUM_MOLES_TO_FILTER)
		ui_error = "Insufficient [gas_data.name[input_gas]] to process."
		update_icon()
		return

	// STEP 4 - Consume the resources
	var/converted_moles = min(co2_moles, moles_per_tick)
	use_power(converted_moles * power_per_mole)
	last_power_draw += converted_moles * power_per_mole
	stored_material[MATERIAL_ALGAE] -= converted_moles * algae_per_mole
	stored_material[MATERIAL_PHORON_SHEET] += converted_moles * carbon_per_mole

	// STEP 5 - Output the converted oxygen. Fow now we output for free!
	internal.adjust_gas(input_gas, -converted_moles)
	air2.adjust_gas_temp(output_gas, converted_moles, internal.temperature)
	if(network2)
		network2.update = 1
	recent_moles_transferred = converted_moles
	ui_error = null // Success!
	update_icon()

/obj/machinery/atmospherics/unary/phoron_crystallizer/update_icon()
	if(inoperable() || !anchored || use_power < 2)
		icon_state = "algae-off"
	else if(recent_moles_transferred >= moles_per_tick)
		icon_state = "algae-full"
	else if(recent_moles_transferred > 0)
		icon_state = "algae-full"
	else
		icon_state = "algae-on"
	return 1

/obj/machinery/atmospherics/unary/phoron_crystallizer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(try_load_materials(user, W))
		return
	else
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return

/obj/machinery/atmospherics/unary/phoron_crystallizer/attack_hand(mob/user)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/atmospherics/unary/phoron_crystallizer/RefreshParts()
	..()

	var/cap_rating = 0
	var/bin_rating = 0
	var/manip_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			cap_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			manip_rating += P.rating

	power_per_mole = round(initial(power_per_mole) / cap_rating)

	var/storage = 5000 * (bin_rating**2)/2
	for(var/mat in storage_capacity)
		storage_capacity[mat] = storage

	moles_per_tick = initial(moles_per_tick) + (manip_rating**2 - 1)

/obj/machinery/atmospherics/unary/phoron_crystallizer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nano_ui/master_ui = null, var/datum/topic_state/state = default_state)
	var/data[0]
	data["panelOpen"] = panel_open

	var/materials_ui[0]
	for(var/M in stored_material)
		materials_ui[++materials_ui.len] = list(
				"name" = M,
				"display" = material_display_name(M),
				"qty" = stored_material[M],
				"max" = storage_capacity[M],
				"percent" = (stored_material[M] / storage_capacity[M] * 100))
	data["materials"] = materials_ui
	data["last_flow_rate"] = last_flow_rate
	data["last_power_draw"] = last_power_draw
	data["inputDir"] = dir2text(reverse_dir[dir])
	data["outputDir"] = dir2text(dir)
	data["usePower"] = use_power
	data["errorText"] = ui_error

	if(air1 && network1 && node1)
		data["input"] = list(
			"pressure" = air1.return_pressure(),
			"name" = gas_data.name[input_gas],
			"percent" = air1.total_moles > 0 ? round((air1.gas[input_gas] / air1.total_moles) * 100) : 0,
			"moles" = round(air1.gas[input_gas], 0.01))
	if(air2 && network2 && node2)
		data["output"] = list(
			"pressure" = air2.return_pressure(),
			"name" = gas_data.name[output_gas],
			"percent" = air2.total_moles ? round((air2.gas[output_gas] / air2.total_moles) * 100) : 0,
			"moles" = round(air2.gas[output_gas], 0.01))

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "phoron_crystallizer_vr.tmpl", "Phoron Crystallizer Control Panel", 500, 600)
		ui.set_initial_data(data)
		ui.set_auto_update(TRUE)
		ui.open()

/obj/machinery/atmospherics/unary/phoron_crystallizer/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	add_fingerprint(usr)

	// Queue management can be done even while busy
	if(href_list["activate"])
		update_use_power(2)
		update_icon()
		updateUsrDialog()
		return

	if(href_list["deactivate"])
		update_use_power(1)
		update_icon()
		updateUsrDialog()
		return

	if(href_list["ejectMaterial"])
		var/matName = href_list["ejectMaterial"]
		if(!(matName in stored_material))
			return
		eject_materials(matName, 0)
		updateUsrDialog()
		return


// TODO - These should be replaced with materials datum.

// 0 amount = 0 means ejecting a full stack; -1 means eject everything
/obj/machinery/atmospherics/unary/phoron_crystallizer/proc/eject_materials(var/material_name, var/amount)
	var/recursive = amount == -1 ? 1 : 0
	var/material/matdata = get_material_by_name(material_name)
	var/stack_type = matdata.stack_type
	var/obj/item/stack/material/S = new stack_type(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(stored_material[material_name] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	stored_material[material_name] -= ejected * S.perunit
	if(recursive && stored_material[material_name] >= S.perunit)
		eject_materials(material_name, -1)

// Attept to load materials.  Returns 0 if item wasn't a stack of materials, otherwise 1 (even if failed to load)
/obj/machinery/atmospherics/unary/phoron_crystallizer/proc/try_load_materials(var/mob/user, var/obj/item/stack/material/S)
	if(!istype(S))
		return 0
	if(!(S.material.name in stored_material))
		to_chat(user, "<span class='warning'>\The [src] doesn't accept [material_display_name(S.material)]!</span>")
		return 1
	var/max_res_amount = storage_capacity[S.material.name]
	if(stored_material[S.material.name] + S.perunit <= max_res_amount)
		var/count = 0
		while(stored_material[S.material.name] + S.perunit <= max_res_amount && S.amount >= 1)
			stored_material[S.material.name] += S.perunit
			S.use(1)
			count++
		user.visible_message("\The [user] inserts [S.name] into \the [src].", "<span class='notice'>You insert [count] [S.name] into \the [src].</span>")
		updateUsrDialog()
	else
		to_chat(user, "<span class='warning'>\The [src] cannot hold more [S.name].</span>")
	return 1

/material/algae
	name = MATERIAL_ALGAE
	stack_type = /obj/item/stack/material/algae
	icon_colour = "#557722"
	shard_type = SHARD_STONE_PIECE
	weight = 10
	hardness = 10
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/obj/item/stack/material/algae
	name = "algae sheet"
	icon_state = "sheet-uranium"
	color = "#557722"
	default_type = MATERIAL_ALGAE

/obj/item/stack/material/algae/ten
	amount = 10

/material/carbon
	name = MATERIAL_PHORON_SHEET
	stack_type = /obj/item/stack/material/carbon
	icon_colour = "#303030"
	shard_type = SHARD_SPLINTER
	weight = 5
	hardness = 20
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	door_icon_base = "stone"
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/obj/item/stack/material/carbon
	name = "carbon sheet"
	icon_state = "sheet-metal"
	color = "#303030"
	default_type = MATERIAL_PHORON_SHEET

#undef MATERIAL_ALGAE
#undef MATERIAL_PHORON_SHEET
