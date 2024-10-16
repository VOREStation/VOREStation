#define CYBORG_POWER_USAGE_MULTIPLIER 2 // Multiplier for amount of power cyborgs use.

/mob/living/silicon/robot
	name = JOB_CYBORG
	real_name = JOB_CYBORG
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 200
	health = 200

	mob_bump_flag = ROBOT
	mob_swap_flags = ~HEAVY
	mob_push_flags = ~HEAVY //trundle trundle

	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	var/lights_on = 0 // Is our integrated light on?
	var/used_power_this_tick = 0
	var/sight_mode = 0
	var/custom_name = ""
	var/custom_sprite = 0 //Due to all the sprites involved, a var for our custom borgs may be best
	var/sprite_name = null // The name of the borg, for the purposes of custom icon sprite indexing.
	var/crisis //Admin-settable for combat module use.
	var/crisis_override = 0
	var/integrated_light_power = 6
	var/datum/wires/robot/wires

	can_be_antagged = TRUE

//Icon stuff

	var/datum/robot_sprite/sprite_datum 				// Sprite datum, holding all our sprite data
	var/icon_selected = 1								// If icon selection has been completed yet
	var/icon_selection_tries = 0						// Remaining attempts to select icon before a selection is forced
	var/list/sprite_extra_customization = list()
	var/rest_style = "Default"
	var/notransform
	does_spin = FALSE

//Hud stuff

	var/obj/screen/inv1 = null
	var/obj/screen/inv2 = null
	var/obj/screen/inv3 = null

	var/shown_robot_modules = 0 //Used to determine whether they have the module menu shown or not
	var/obj/screen/robot_modules_background

//3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/module_active = null
	var/module_state_1 = null
	var/module_state_2 = null
	var/module_state_3 = null

	var/obj/item/radio/borg/radio = null
	var/obj/item/communicator/integrated/communicator = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/machinery/camera/camera = null

	var/cell_emp_mult = 2

	var/sleeper_state = 0 // 0 for empty, 1 for normal, 2 for mediborg-healthy
	var/scrubbing = FALSE //Floor cleaning enabled

	// Subtype limited modules or admin restrictions
	var/list/restrict_modules_to = list()

	// Components are basically robot organs.
	var/list/components = list()

	var/obj/item/mmi/mmi = null

	var/obj/item/pda/ai/rbPDA = null

	var/opened = 0
	var/emagged = 0
	var/emag_items = 0
	var/wiresexposed = 0
	var/locked = 1
	var/has_power = 1
	var/list/req_access = list(access_robotics)
	var/ident = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/modtype = "Default"
	var/sprite_type = null
	var/lower_mod = 0
	var/jetpack = 0
	var/datum/effect/effect/system/ion_trail_follow/ion_trail = null
	var/datum/effect/effect/system/spark_spread/spark_system//So they can initialize sparks whenever/N
	var/jeton = 0
	var/killswitch = 0
	var/killswitch_time = 60
	var/weapon_lock = 0
	var/weaponlock_time = 120
	var/lawupdate = 1 //Cyborgs will sync their laws with their AI by default
	var/lockcharge //Used when looking to see if a borg is locked down.
	var/lockdown = 0 //Controls whether or not the borg is actually locked down.
	var/speed = 0 //Cause sec borgs gotta go fast //No they dont!
	var/scrambledcodes = 0 // Used to determine if a borg shows up on the robotics console. Setting to one hides them.
	var/tracking_entities = 0 //The number of known entities currently accessing the internal camera
	var/braintype = JOB_CYBORG

	var/obj/item/implant/restrainingbolt/bolt	// The restraining bolt installed into the cyborg.

	var/list/robot_verbs_default = list(
		/mob/living/silicon/robot/proc/sensor_mode,
		/mob/living/silicon/robot/proc/robot_checklaws,
		/mob/living/silicon/robot/proc/robot_mount,
		/mob/living/silicon/robot/proc/take_image,
		/mob/living/silicon/robot/proc/view_images,
		/mob/living/silicon/robot/proc/delete_images,
		/mob/living/proc/toggle_rider_reins,
		/mob/living/proc/vertical_nom,
		/mob/living/proc/shred_limb,
		/mob/living/proc/dominate_prey,
		/mob/living/proc/lend_prey_control
	)

	var/has_recoloured = FALSE
	var/vtec_active = FALSE

	// Riding Stuff
	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

/mob/living/silicon/robot/New(loc, var/unfinished = 0)
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	add_language("Robot Talk", 1)
	add_language(LANGUAGE_GALCOM, 1)
	add_language(LANGUAGE_EAL, 1)

	wires = new(src)

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	ident = rand(1, 999)
	updatename(modtype)

	radio = new /obj/item/radio/borg(src)
//	communicator = new /obj/item/communicator/integrated(src)
//	communicator.register_device(src)
	common_radio = radio

	if(!scrambledcodes && !camera)
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.replace_networks(list(NETWORK_DEFAULT,NETWORK_ROBOTS))
		if(wires.is_cut(WIRE_BORG_CAMERA))
			camera.status = 0

	init()
	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.installed = 1
		C.wrapped = new C.external_type

	if(!cell)
		cell = new /obj/item/cell/robot_station(src)
	else if(ispath(cell))
		cell = new cell(src)

	..()

	if(cell)
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	hud_list[HEALTH_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_HEALTH)
	hud_list[STATUS_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudhealth100", plane = PLANE_CH_STATUS)
	hud_list[LIFE_HUD]			= gen_hud_image('icons/mob/hud.dmi', src, "hudhealth100", plane = PLANE_CH_LIFE)
	hud_list[ID_HUD]			= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_ID)
	hud_list[WANTED_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_WANTED)
	hud_list[IMPLOYAL_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_IMPLOYAL)
	hud_list[IMPCHEM_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_IMPCHEM)
	hud_list[IMPTRACK_HUD]		= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_IMPTRACK)
	hud_list[SPECIALROLE_HUD]	= gen_hud_image('icons/mob/hud.dmi', src, "hudblank", plane = PLANE_CH_SPECIAL)

	riding_datum = new /datum/riding/dogborg(src)


/mob/living/silicon/robot/LateInitialize()
	. = ..()
	update_icon()

/mob/living/silicon/robot/rejuvenate()
	for (var/V in components)
		var/datum/robot_component/C = components[V]
		if(istype(C.wrapped, /obj/item/broken_device))
			qdel(C.wrapped)
			C.wrapped = null
		if(!C.wrapped)
			switch(V)
				if("actuator")
					C.wrapped = new /obj/item/robot_parts/robot_component/actuator(src)
				if("radio")
					C.wrapped = new /obj/item/robot_parts/robot_component/radio(src)
				if("power cell")
					var/list/recommended_cells = list(/obj/item/cell/robot_station, /obj/item/cell/high, /obj/item/cell/super, /obj/item/cell/robot_syndi, /obj/item/cell/hyper,
						/obj/item/cell/infinite, /obj/item/cell/potato, /obj/item/cell/slime)
					var/list/cell_names = list()
					for(var/cell_type in recommended_cells)
						var/obj/item/cell/single_cell = cell_type
						cell_names[capitalize(initial(single_cell.name))] = cell_type
					var/selected_cell = tgui_input_list(usr, "What kind of cell do you want to install? Cancel installs a default robot cell.", "Cells", cell_names)
					if(!selected_cell || selected_cell == "Cancel")
						selected_cell = "A standard robot power cell"
					var/new_power_cell = cell_names[capitalize(selected_cell)]
					cell = new new_power_cell(src)
					C.wrapped = cell
				if("diagnosis unit")
					C.wrapped = new /obj/item/robot_parts/robot_component/diagnosis_unit(src)
				if("camera")
					C.wrapped = new /obj/item/robot_parts/robot_component/camera(src)
				if("comms")
					C.wrapped = new /obj/item/robot_parts/robot_component/binary_communication_device(src)
				if("armour")
					C.wrapped = new /obj/item/robot_parts/robot_component/armour(src)
			C.installed = 1
			C.install()
	cell.charge = cell.maxcharge
	..()

/mob/living/silicon/robot/proc/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)
	laws = new global.using_map.default_law_type // VOREstation edit: use map's default
	additional_law_channels["Binary"] = "#b"
	var/new_ai = select_active_ai_with_fewest_borgs()
	if(new_ai)
		lawupdate = 1
		connect_to_ai(new_ai)
	else
		lawupdate = 0



/mob/living/silicon/robot/SetName(pickedName as text)
	custom_name = pickedName
	updatename()

/mob/living/silicon/robot/proc/sync()
	if(lawupdate && connected_ai)
		lawsync()
		photosync()

/mob/living/silicon/robot/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	if(!cell || !cell.charge)
		return 0

	// Actual amount to drain from cell, using CELLRATE
	var/cell_amount = amount * CELLRATE

	if(cell.charge > cell_amount)
		// Spam Protection
		if(prob(10))
			to_chat(src, span_danger("Warning: Unauthorized access through power channel [rand(11,29)] detected!"))
		cell.use(cell_amount)
		return amount
	return 0

// setup the PDA and its name
/mob/living/silicon/robot/proc/setup_PDA()
	if (!rbPDA)
		rbPDA = new/obj/item/pda/ai(src)
	rbPDA.set_name_and_job(name,"[modtype] [braintype]")
	add_verb(src, /obj/item/pda/ai/verb/cmd_pda_open_ui)

/mob/living/silicon/robot/proc/setup_communicator()
	if (!communicator)
		communicator = new/obj/item/communicator/integrated(src)
	communicator.register_device(name, "[modtype] [braintype]")
	add_verb(src, /obj/item/communicator/integrated/verb/activate)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(loc)//To hopefully prevent run time errors.
		if(T)	mmi.loc = T
		if(mmi.brainmob)
			var/obj/item/robot_module/M = locate() in contents
			if(M)
				mmi.brainmob.languages = M.original_languages
			else
				mmi.brainmob.languages = languages
			mmi.brainmob.remove_language("Robot Talk")
			mind.transfer_to(mmi.brainmob)
		else if(!shell) // Shells don't have brainmbos in their MMIs.
			to_chat(src, span_danger("Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug."))
			ghostize()
			//ERROR("A borg has been destroyed, but its MMI lacked a brainmob, so the mind could not be transferred. Player: [ckey].")
		mmi = null
	if(connected_ai)
		connected_ai.connected_robots -= src
	if(shell)
		if(deployed)
			undeploy()
		revert_shell() // To get it out of the GLOB list.
	qdel(wires)
	wires = null
	return ..()

// CONTINUE CODING HERE
/*
/mob/living/silicon/robot/proc/set_module_sprites(var/list/new_sprites)
	if(new_sprites && new_sprites.len)
		module_sprites = new_sprites.Copy()
		//Custom_sprite check and entry
		if (custom_sprite == 1)
			module_sprites["Custom"] = "[ckey]-[sprite_name]-[modtype]" //Made compliant with custom_sprites.dm line 32. (src.) was apparently redundant as it's implied. ~Mech
			icontype = "Custom"
		else
			icontype = module_sprites[1]
			icon_state = module_sprites[icontype]
	update_icon()
	return module_sprites
*/
/mob/living/silicon/robot/proc/pick_module()
	if(module)
		return
	var/list/modules = list()
	//VOREStatation Edit Start: shell restrictions
	if(shell)
		if(restrict_modules_to.len > 0)
			modules.Add(restrict_modules_to)
		else
			modules.Add(shell_module_types)
	else
		if(restrict_modules_to.len > 0)
			modules.Add(restrict_modules_to)
		else
			modules.Add(robot_module_types)
			if(crisis || security_level == SEC_LEVEL_RED || crisis_override)
				to_chat(src, span_red("Crisis mode active. Combat module available."))
				modules |= emergency_module_types
			for(var/module_name in whitelisted_module_types)
				if(is_borg_whitelisted(src, module_name))
					modules |= module_name
	//VOREStatation Edit End: shell restrictions
	modtype = tgui_input_list(usr, "Please, select a module!", "Robot module", modules)

	if(module)
		return
	if(!(modtype in robot_modules))
		return
	if(!is_borg_whitelisted(src, modtype))
		return

	var/module_type = robot_modules[modtype]
	transform_with_anim()	//VOREStation edit: sprite animation
	new module_type(src)

	hands.icon_state = get_hud_module_icon()
	feedback_inc("cyborg_[lowertext(modtype)]",1)
	updatename()
	hud_used.update_robot_modules_display()
	notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, module.name)

/mob/living/silicon/robot/proc/update_braintype()
	if(istype(mmi, /obj/item/mmi/digital/posibrain))
		braintype = BORG_BRAINTYPE_POSI
	else if(istype(mmi, /obj/item/mmi/digital/robot))
		braintype = BORG_BRAINTYPE_DRONE
	else if(istype(mmi, /obj/item/mmi/inert/ai_remote))
		braintype = BORG_BRAINTYPE_AI_SHELL
	else
		braintype = BORG_BRAINTYPE_CYBORG

/mob/living/silicon/robot/proc/updatename(var/prefix as text)
	if(prefix)
		modtype = prefix

	update_braintype()

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
		notify_ai(ROBOT_NOTIFICATION_NEW_NAME, real_name, changed_name)
	else
		changed_name = "[modtype] [braintype]-[num2text(ident)]"

	real_name = changed_name
	name = real_name

	// if we've changed our name, we also need to update the display name for our PDA
	setup_PDA()

	// as well as our communicator registration
	setup_communicator()

	//We also need to update name of internal camera.
	if (camera)
		camera.c_tag = changed_name

	//Flavour text.
	if(client)
		var/module_flavour = client.prefs.flavour_texts_robot[modtype]
		if(module_flavour)
			flavor_text = module_flavour
		else
			flavor_text = client.prefs.flavour_texts_robot["Default"]
		// Vorestation Edit: and meta info
		var/meta_info = client.prefs.metadata
		if (meta_info)
			ooc_notes = meta_info
			ooc_notes_likes = client.prefs.metadata_likes
			ooc_notes_dislikes = client.prefs.metadata_dislikes
		custom_link = client.prefs.custom_link

/mob/living/silicon/robot/verb/namepick()
	set name = "Pick Name"
	set category = "Abilities.Silicon"

	if(custom_name)
		to_chat(usr, "You can't pick another custom name. [isshell(src) ? "" : "Go ask for a name change."]")
		return 0

	spawn(0)
		var/newname
		newname = sanitizeSafe(tgui_input_text(src,"You are a robot. Enter a name, or leave blank for the default name.", "Name change","", MAX_NAME_LEN), MAX_NAME_LEN)
		if (newname)
			custom_name = newname
			sprite_name = newname

		updatename()
		update_icon()

/mob/living/silicon/robot/verb/extra_customization()
	set name = "Customize Appearance"
	set category = "Abilities.Silicon"
	set desc = "Customize your appearance (assuming your chosen sprite allows)."

	if(!sprite_datum || !sprite_datum.has_extra_customization)
		to_chat(src, span_warning("Your sprite cannot be customized."))
		return

	sprite_datum.handle_extra_customization(src)

/mob/living/silicon/robot/proc/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return null

	var/dat = "<HEAD><TITLE>[src.name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for (var/V in components)
		var/datum/robot_component/C = components[V]
		dat += "<b>[C.name]</b><br><table><tr><td>Brute Damage:</td><td>[C.brute_damage]</td></tr><tr><td>Electronics Damage:</td><td>[C.electronics_damage]</td></tr><tr><td>Powered:</td><td>[(!C.idle_usage || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table><br>"

	return dat

/mob/living/silicon/robot/verb/toggle_lights()
	set category = "Abilities.Silicon"
	set name = "Toggle Lights"

	lights_on = !lights_on
	to_chat(usr, span_filter_notice("You [lights_on ? "enable" : "disable"] your integrated light."))
	handle_light()
	update_icon()

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Abilities.Silicon"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, span_red("Your self-diagnosis component isn't functioning."))

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if (!cell_use_power(CO.active_usage))
		to_chat(src, span_red("Low Power."))
	var/dat = self_diagnosis()
	src << browse(dat, "window=robotdiagnosis")


/mob/living/silicon/robot/verb/toggle_component()
	set category = "Abilities.Silicon"
	set name = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell") continue
		var/datum/robot_component/C = components[V]
		if(C.installed)
			installed_components += V

	var/toggle = tgui_input_list(src, "Which component do you want to toggle?", "Toggle Component", installed_components)
	if(!toggle)
		return

	var/datum/robot_component/C = components[toggle]
	if(C.toggled)
		C.toggled = 0
		to_chat(src, span_red("You disable [C.name]."))
	else
		C.toggled = 1
		to_chat(src, span_red("You enable [C.name]."))

/mob/living/silicon/robot/verb/spark_plug() //So you can still sparkle on demand without violence.
	set category = "Abilities.Silicon"
	set name = "Emit Sparks"
	to_chat(src, span_filter_notice("You harmlessly spark."))
	spark_system.start()

// this function displays jetpack pressure in the stat panel
/mob/living/silicon/robot/proc/show_jetpack_pressure()
	// if you have a jetpack, show the internal tank pressure
	var/obj/item/tank/jetpack/current_jetpack = installed_jetpack()
	if (current_jetpack)
		. = "Internal Atmosphere Info: [current_jetpack.name]"
		. += "Tank Pressure: [current_jetpack.air_contents.return_pressure()]"


// this function returns the robots jetpack, if one is installed
/mob/living/silicon/robot/proc/installed_jetpack()
	if(module)
		return (locate(/obj/item/tank/jetpack) in module.modules)
	return 0


// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(cell)
		. = "Charge Left: [round(cell.percent())]%"
		. += "Cell Rating: [round(cell.maxcharge)]" // Round just in case we somehow get crazy values
		. += "Power Cell Load: [round(used_power_this_tick)]W"
	else
		. = "No Cell Inserted!"

// function to toggle VTEC once installed
/mob/living/silicon/robot/proc/toggle_vtec()
	set name = "Toggle VTEC"
	set category = "Abilities"
	vtec_active = !vtec_active
	hud_used.toggle_vtec_control()
	to_chat(src, span_filter_notice("VTEC module [vtec_active  ? "enabled" : "disabled"]."))

// update the status screen display
/mob/living/silicon/robot/get_status_tab_items()
	. = ..()
	. += ""
	. += show_cell_power()
	. += show_jetpack_pressure()
	. += "Lights: [lights_on ? "ON" : "OFF"]"
	if(module)
		for(var/datum/matter_synth/ms in module.synths)
			. += "[ms.name]: [ms.energy]/[ms.max_energy]"

/mob/living/silicon/robot/restrained()
	return 0

/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	if(prob(75) && Proj.damage > 0) spark_system.start()
	return 2

/mob/living/silicon/robot/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/handcuffs)) // fuck i don't even know why isrobot() in handcuff code isn't working so this will have to do
		return

	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(W, C.external_type))
				C.installed = 1
				C.wrapped = W
				C.install()
				user.drop_item()
				W.loc = null

				var/obj/item/robot_parts/robot_component/WC = W
				if(istype(WC))
					C.brute_damage = WC.brute
					C.electronics_damage = WC.burn

				to_chat(usr, span_notice("You install the [W.name]."))

				return

		if(istype(W, /obj/item/implant/restrainingbolt) && !cell)
			if(bolt)
				to_chat(user, span_notice("There is already a restraining bolt installed in this cyborg."))
				return

			else
				user.drop_from_inventory(W)
				W.forceMove(src)
				bolt = W

				to_chat(user, span_notice("You install \the [W]."))

				return

	if(istype(W, /obj/item/aiModule)) // Trying to modify laws locally.
		if(!opened)
			to_chat(user, span_warning("You need to open \the [src]'s panel before you can modify them."))
			return

		if(shell) // AI shells always have the laws of the AI
			to_chat(user, span_warning("\The [src] is controlled remotely! You cannot upload new laws this way!"))
			return

		var/obj/item/aiModule/M = W
		M.install(src, user)
		return

	if(W.has_tool_quality(TOOL_WELDER) && user.a_intent != I_HURT)
		if(src == user)
			to_chat(user, span_warning("You lack the reach to be able to repair yourself."))
			return

		if(!getBruteLoss())
			to_chat(user, span_filter_notice("Nothing to fix here!"))
			return
		var/obj/item/weldingtool/WT = W.get_welder()
		if(WT.remove_fuel(0))
			user.setClickCooldown(user.get_attack_speed(WT))
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			for(var/mob/O in viewers(user, null))
				O.show_message(span_filter_notice("[span_red("[user] has fixed some of the dents on [src]!")]"), 1)
		else
			to_chat(user, span_filter_warning("Need more welding fuel!"))
			return

	else if(istype(W, /obj/item/stack/cable_coil) && (wiresexposed || istype(src,/mob/living/silicon/robot/drone)))
		if(!getFireLoss())
			to_chat(user, span_filter_notice("Nothing to fix here!"))
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			user.setClickCooldown(user.get_attack_speed(W))
			adjustFireLoss(-30)
			updatehealth()
			for(var/mob/O in viewers(user, null))
				O.show_message(span_filter_notice("[span_red("[user] has fixed some of the burnt wires on [src]!")]"), 1)

	else if(W.has_tool_quality(TOOL_CROWBAR) && user.a_intent != I_HURT)	// crowbar means open or close the cover
		if(opened)
			if(cell)
				to_chat(user, span_filter_notice("You close the cover."))
				opened = 0
				update_icon()
			else if(wiresexposed && wires.is_all_cut())
				//Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
				if(!mmi)
					to_chat(user, span_filter_notice("\The [src] has no brain to remove."))
					return

				to_chat(user, span_filter_notice("You jam the crowbar into the robot and begin levering [mmi]."))
				sleep(30)
				to_chat(user, span_filter_notice("You damage some parts of the chassis, but eventually manage to rip out [mmi]!"))
				var/obj/item/robot_parts/robot_suit/C = new/obj/item/robot_parts/robot_suit(loc)
				C.l_leg = new/obj/item/robot_parts/l_leg(C)
				C.r_leg = new/obj/item/robot_parts/r_leg(C)
				C.l_arm = new/obj/item/robot_parts/l_arm(C)
				C.r_arm = new/obj/item/robot_parts/r_arm(C)
				C.update_icon()
				new/obj/item/robot_parts/chest(loc)
				qdel(src)
			else
				// Okay we're not removing the cell or an MMI, but maybe something else?
				var/list/removable_components = list()
				for(var/V in components)
					if(V == "power cell") continue
					var/datum/robot_component/C = components[V]
					if(C.installed == 1 || C.installed == -1)
						removable_components += V

				var/remove = tgui_input_list(user, "Which component do you want to pry out?", "Remove Component", removable_components)
				if(!remove)
					return
				var/datum/robot_component/C = components[remove]
				var/obj/item/robot_parts/robot_component/I = C.wrapped
				to_chat(user, span_filter_notice("You remove \the [I]."))
				if(istype(I))
					I.brute = C.brute_damage
					I.burn = C.electronics_damage

				I.loc = src.loc

				if(C.installed == 1)
					C.uninstall()
				C.installed = 0

		else
			if(locked)
				to_chat(user, span_filter_notice("The cover is locked and cannot be opened."))
			else
				to_chat(user, span_filter_notice("You open the cover."))
				opened = 1
				update_icon()

	else if (istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			to_chat(user, span_filter_notice("Close the panel first."))
		else if(cell)
			to_chat(user, span_filter_notice("There is a power cell already installed."))
		else if(W.w_class != ITEMSIZE_NORMAL)
			to_chat(user, span_filter_notice("\The [W] is too [W.w_class < ITEMSIZE_NORMAL ? "small" : "large"] to fit here."))
		else
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, span_filter_notice("You insert the power cell."))

			C.installed = 1
			C.wrapped = W
			C.install()
			//This will mean that removing and replacing a power cell will repair the mount, but I don't care at this point. ~Z
			C.brute_damage = 0
			C.electronics_damage = 0

	else if (W.has_tool_quality(TOOL_WIRECUTTER) || istype(W, /obj/item/multitool))
		if (wiresexposed)
			wires.Interact(user)
		else
			to_chat(user, span_filter_notice("You can't reach the wiring."))

	else if(W.has_tool_quality(TOOL_SCREWDRIVER) && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, span_filter_notice("The wires have been [wiresexposed ? "exposed" : "unexposed"]"))
		playsound(src, W.usesound, 50, 1)
		update_icon()

	else if(W.has_tool_quality(TOOL_SCREWDRIVER) && opened && cell)	// radio
		if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, span_filter_notice("Unable to locate a radio."))
		update_icon()

	else if(W.has_tool_quality(TOOL_WRENCH) && opened && !cell)
		if(bolt)
			to_chat(user,span_filter_notice("You begin removing \the [bolt]."))

			if(do_after(user, 2 SECONDS, src))
				bolt.forceMove(get_turf(src))
				bolt = null

				to_chat(user, span_filter_notice("You remove \the [bolt]."))

		else
			to_chat(user, span_filter_notice("There is no restraining bolt installed."))

		return

	else if(istype(W, /obj/item/encryptionkey/) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(W,user)//GTFO, you have your own procs
		else
			to_chat(user, span_filter_notice("Unable to locate a radio."))

	else if (W.GetID())			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, span_filter_notice("The interface seems slightly damaged."))
		if(opened)
			to_chat(user, span_filter_notice("You must close the cover to swipe an ID card."))
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, span_filter_notice("You [ locked ? "lock" : "unlock"] [src]'s interface."))
				update_icon()
			else
				to_chat(user, span_filter_notice("[span_red("Access denied.")]"))

	else if(istype(W, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			to_chat(usr, span_filter_notice("You must access the borgs internals!"))
		else if(!src.module && U.require_module)
			to_chat(usr, span_filter_notice("The borg must choose a module before it can be upgraded!"))
		else if(U.locked)
			to_chat(usr, span_filter_notice("The upgrade is locked and cannot be used yet!"))
		else
			if(U.action(src))
				to_chat(usr, span_filter_notice("You apply the upgrade to [src]!"))
				usr.drop_item()
				U.loc = src
				hud_used.update_robot_modules_display()
			else
				to_chat(usr, span_filter_notice("Upgrade error!"))


	else
		if( !(istype(W, /obj/item/robotanalyzer) || istype(W, /obj/item/healthanalyzer)) )
			if(W.force > 0)
				spark_system.start()
		return ..()

/mob/living/silicon/robot/GetIdCard()
	if(bolt && !bolt.malfunction)
		return null
	return idcard

/mob/living/silicon/robot/get_restraining_bolt()
	var/obj/item/implant/restrainingbolt/RB = bolt

	if(istype(RB))
		if(!RB.malfunction)
			return TRUE

	return FALSE

/mob/living/silicon/robot/resist_restraints()
	if(bolt)
		if(!bolt.malfunction)
			visible_message(span_danger("[src] is trying to break their [bolt]!"), span_warning("You attempt to break your [bolt]. (This will take around 90 seconds and you need to stand still)"))
			if(do_after(src, 1.5 MINUTES, src, incapacitation_flags = INCAPACITATION_DISABLED))
				visible_message(span_danger("[src] manages to break \the [bolt]!"), span_warning("You successfully break your [bolt]."))
				bolt.malfunction = MALFUNCTION_PERMANENT

	return

/mob/living/silicon/robot/proc/module_reset(var/notify = TRUE)
	transform_with_anim() //VOREStation edit: sprite animation
	uneq_all()
	hud_used.update_robot_modules_display(TRUE)
	modtype = initial(modtype)
	hands.icon_state = get_hud_module_icon()
	if(notify)
		notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, module.name)
	module.Reset(src)
	qdel(module)
	module = null
	updatename("Default")
	has_recoloured = FALSE

/mob/living/silicon/robot/proc/ColorMate()
	set name = "Recolour Module"
	set category = "Abilities.Silicon"
	set desc = "Allows to recolour once."

	if(!has_recoloured)
		var/datum/ColorMate/recolour = new /datum/ColorMate(usr)
		recolour.tgui_interact(usr)
		return
	to_chat(usr, "You've already recoloured yourself once. Ask for a module reset for another.")

/mob/living/silicon/robot/attack_hand(mob/user)
	if(LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		add_fingerprint(user)

		if(opened && !wiresexposed && (!istype(user, /mob/living/silicon)))
			var/datum/robot_component/cell_component = components["power cell"]
			if(cell)
				cell.update_icon()
				cell.add_fingerprint(user)
				user.put_in_active_hand(cell)
				to_chat(user, span_filter_notice("You remove \the [cell]."))
				cell = null
				cell_component.wrapped = null
				cell_component.installed = 0
				update_icon()
			else if(cell_component.installed == -1)
				cell_component.installed = 0
				var/obj/item/broken_device = cell_component.wrapped
				to_chat(user, span_filter_notice("You remove \the [broken_device]."))
				user.put_in_active_hand(broken_device)

		if(istype(user,/mob/living/carbon/human) && !opened)
			var/mob/living/carbon/human/H = user
			//Adding borg petting. Help intent pets if preferences allow, Disarm intent taps and Harm is punching(no damage)
			switch(H.a_intent)
				if(I_HELP)
					if(client && !client.prefs.borg_petting)
						visible_message(span_notice("[H] reaches out for [src], but quickly refrains from petting."))
						return
					else
						visible_message(span_notice("[H] pets [src]."))
						return
				if(I_HURT)
					H.do_attack_animation(src)
					if(H.species.can_shred(H))
						attack_generic(H, rand(30,50), "slashed")
						return
					else
						playsound(src.loc, 'sound/effects/bang.ogg', 10, 1)
						visible_message(span_warning("[H] punches [src], but doesn't leave a dent."))
						return
				if(I_DISARM)
					H.do_attack_animation(src)
					playsound(src.loc, 'sound/effects/clang2.ogg', 10, 1)
					visible_message(span_warning("[H] taps [src]."))
					return
				if(I_GRAB)
					if(is_vore_predator(H) && H.devourable && src.feeding && src.devourable)
						var/switchy = tgui_alert(H, "Do you wish to eat [src] or feed yourself to them?", "Feed or Eat",list("Nevermind!", "Eat","Feed"))
						switch(switchy)
							if("Nevermind!", null)
								return
							if("Eat")
								feed_grabbed_to_self(H, src)
								return
							if("Feed")
								H.feed_self_to_grabbed(H, src)
								return
					if(is_vore_predator(H) && src.devourable)
						if(tgui_alert(H, "Do you wish to eat [src]?", "Eat?",list("Nevermind!", "Yes!")) == "Yes!")
							feed_grabbed_to_self(H, src)
							return
					if(H.devourable && src.feeding)
						if(tgui_alert(H, "Do you wish to feed yourself to [src]?", "Feed?",list("Nevermind!", "Yes!")) == "Yes!")
							H.feed_self_to_grabbed(H, src)
							return

//Robots take half damage from basic attacks.
/mob/living/silicon/robot/attack_generic(var/mob/user, var/damage, var/attack_message)
	return ..(user,FLOOR(damage/2, 1),attack_message)

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(check_access(R.get_active_hand()) || istype(R.get_active_hand(), /obj/item/card/robot))
			return 1
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/I)
	if(!istype(req_access, /list)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!L.len) //no requirements
		return 1
	if(!I) //nothing to check with..?
		return 0
	var/access_found = I.GetAccess()
	for(var/req in req_access)
		if(req in access_found) //have one of the required accesses
			return 1
	return 0

/mob/living/silicon/robot/update_icon()
	if(!sprite_datum)
		if(SSrobot_sprites)								// Grab default if subsystem is ready
			sprite_datum = SSrobot_sprites.get_default_module_sprite(modtype)
		if(!sprite_datum)								// If its not ready or fails to get us a sprite, use the default of our own
			sprite_datum = new /datum/robot_sprite/default(src)
		return

	cut_overlays()
	add_overlay(active_thinking_indicator)
	add_overlay(active_typing_indicator)

	icon			= sprite_datum.sprite_icon
	icon_state		= sprite_datum.sprite_icon_state

	vis_height		= sprite_datum.vis_height
	if(default_pixel_x != sprite_datum.pixel_x)
		default_pixel_x	= sprite_datum.pixel_x
		pixel_x = sprite_datum.pixel_x
		old_x = sprite_datum.pixel_x

	if(stat == CONSCIOUS)
		var/belly_size = 0
		if(sprite_datum.has_vore_belly_sprites && vore_selected.belly_overall_mult != 0)
			if(vore_selected.silicon_belly_overlay_preference == "Sleeper")
				if(sleeper_state)
					belly_size = sprite_datum.max_belly_size
			else if(vore_selected.silicon_belly_overlay_preference == "Vorebelly" || vore_selected.silicon_belly_overlay_preference == "Both")
				if(sleeper_state && vore_selected.silicon_belly_overlay_preference == "Both")
					belly_size += 1
				if(LAZYLEN(vore_selected.contents) > 0)
					for(var/borgfood in vore_selected.contents) //"inspired" (kinda copied) from Chompstation's belly fullness system's procs
						if(istype(borgfood, /mob/living))
							if(vore_selected.belly_mob_mult <= 0) //If mobs dont contribute, dont calculate further
								continue
							var/mob/living/prey = borgfood //typecast to living
							belly_size += (prey.size_multiplier / size_multiplier) / vore_selected.belly_mob_mult //Smaller prey are less filling to larger bellies
						else if(istype(borgfood, /obj/item))
							if(vore_selected.belly_item_mult <= 0) //If items dont contribute, dont calculate further
								continue
							var/obj/item/junkfood = borgfood //typecast to item
							var/fullness_to_add = 0
							switch(junkfood.w_class)
								if(ITEMSIZE_TINY)
									fullness_to_add = ITEMSIZE_COST_TINY
								if(ITEMSIZE_SMALL)
									fullness_to_add = ITEMSIZE_COST_SMALL
								if(ITEMSIZE_NORMAL)
									fullness_to_add = ITEMSIZE_COST_NORMAL
								if(ITEMSIZE_LARGE)
									fullness_to_add = ITEMSIZE_COST_LARGE
								if(ITEMSIZE_HUGE)
									fullness_to_add = ITEMSIZE_COST_HUGE
								else
									fullness_to_add = ITEMSIZE_COST_NO_CONTAINER
							belly_size += (fullness_to_add / 32) //* vore_selected.overlay_item_multiplier //Enable this later when vorepanel is reworked.
						else
							belly_size += 1 //if it's not a person, nor an item... lets just go with 1

					belly_size *= vore_selected.belly_overall_mult //Enable this after vore panel rework
					belly_size = round(belly_size, 1)
					belly_size = clamp(belly_size, 0, sprite_datum.max_belly_size) //Value from 0 to however many bellysizes the borg has

		if(belly_size > 0) //Borgs probably only have 1 belly size. but here's support for larger ones if that changes.
			if(resting && sprite_datum.has_vore_belly_resting_sprites)
				add_overlay(sprite_datum.get_belly_resting_overlay(src, belly_size))
			else if(!resting)
				add_overlay(sprite_datum.get_belly_overlay(src, belly_size))

		sprite_datum.handle_extra_icon_updates(src)			// Various equipment-based sprites go here.

		if(resting && sprite_datum.has_rest_sprites)
			icon_state = sprite_datum.get_rest_sprite(src)

		if(sprite_datum.has_eye_sprites)
			if(!shell || deployed) // Shell borgs that are not deployed will have no eyes.
				var/eyes_overlay = sprite_datum.get_eyes_overlay(src)
				if(eyes_overlay)
					add_overlay(eyes_overlay)

		if(lights_on && sprite_datum.has_eye_light_sprites)
			if(!shell || deployed) // Shell borgs that are not deployed will have no eyes.
				var/eyes_overlay = sprite_datum.get_eye_light_overlay(src)
				if(eyes_overlay)
					add_overlay(eyes_overlay)

	if(stat == DEAD && sprite_datum.has_dead_sprite)
		cut_overlays()
		icon_state = sprite_datum.get_dead_sprite(src)
		if(sprite_datum.has_dead_sprite_overlay)
			add_overlay(sprite_datum.get_dead_sprite_overlay(src))

	if(opened)
		var/open_overlay = sprite_datum.get_open_sprite(src)
		if(open_overlay)
			add_overlay(open_overlay)

/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, span_filter_warning("" + span_red("Weapon lock active, unable to use modules! Count:[weaponlock_time]") + ""))
		return

	if(!module)
		pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	for (var/obj in module.modules)
		if (!obj)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(obj))
			dat += text("[obj]: <B>Activated</B><BR>")
		else
			dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")
	if (emagged || emag_items)
		for (var/obj in module.emag)
			if (!obj)
				dat += text("<B>Resource depleted</B><BR>")
			else if(activated(obj))
				dat += text("[obj]: <B>Activated</B><BR>")
			else
				dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")

	src << browse(dat, "window=robotmod")


/mob/living/silicon/robot/Topic(href, href_list)
	if(..())
		return 1

	//All Topic Calls that are only for the Cyborg go here
	if(usr != src)
		return 1

	if (href_list["showalerts"])
		subsystem_alarm_monitor()
		return 1

	if (href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if (istype(O) && (O.loc == src))
			O.attack_self(src)
		return 1

	if (href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if (!istype(O))
			return 1

		if(!((O in src.module.modules) || (O in src.module.emag)))
			return 1

		if(activated(O))
			to_chat(src, span_filter_notice("Already activated."))
			return 1
		if(!module_state_1)
			module_state_1 = O
			O.hud_layerise()
			O.equipped_robot()
			contents += O
			if(istype(module_state_1,/obj/item/borg/sight))
				sight_mode |= module_state_1:sight_mode
		else if(!module_state_2)
			module_state_2 = O
			O.hud_layerise()
			O.equipped_robot()
			contents += O
			if(istype(module_state_2,/obj/item/borg/sight))
				sight_mode |= module_state_2:sight_mode
		else if(!module_state_3)
			module_state_3 = O
			O.hud_layerise()
			O.equipped_robot()
			contents += O
			if(istype(module_state_3,/obj/item/borg/sight))
				sight_mode |= module_state_3:sight_mode
		else
			to_chat(src, span_filter_notice("You need to disable a module first!"))
		installed_modules()
		return 1

	if (href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents -= O
			else if(module_state_2 == O)
				module_state_2 = null
				contents -= O
			else if(module_state_3 == O)
				module_state_3 = null
				contents -= O
			else
				to_chat(src, span_filter_notice("Module isn't activated."))
		else
			to_chat(src, span_filter_notice("Module isn't activated."))
		installed_modules()
		return 1
	return

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src)//Just use the radio's Topic() instead of bullshit special-snowflake code

/mob/living/silicon/robot/proc/self_destruct()
	gib()
	return

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	lawupdate = 0
	lockcharge = 0
	lockdown = 0
	canmove = 1
	scrambledcodes = 1
	//Disconnect it's camera so it's not so easily tracked.
	if(src.camera)
		src.camera.clear_all_networks()


/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Abilities.Silicon"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers. Unlocks you and permenantly severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/R = src

	if(R)
		R.UnlinkSelf()
		to_chat(R, span_filter_notice("Buffers flushed and reset. Camera system shutdown. All systems operational."))
		remove_verb(src, /mob/living/silicon/robot/proc/ResetSecurityCodes)

/mob/living/silicon/robot/proc/SetLockdown(var/state = 1)
	// They stay locked down if their wire is cut.
	if(wires.is_cut(WIRE_BORG_LOCKED))
		state = 1
	if(state)
		throw_alert("locked", /obj/screen/alert/locked)
	else
		clear_alert("locked")
	lockdown = state
	lockcharge = state
	update_canmove()

/mob/living/silicon/robot/mode()
	if(!checkClickCooldown())
		return

	setClickCooldown(1)

	var/obj/item/W = get_active_hand()
	if (W)
		W.attack_self(src)

	return

/mob/living/silicon/robot/proc/choose_icon(var/triesleft)
	var/robot_species = null
	if(!SSrobot_sprites)
		to_chat(src, "Robot Sprites have not been initialized yet. How are you choosing a sprite? Harass a coder.")
		return

	var/list/module_sprites = SSrobot_sprites.get_module_sprites(modtype, src)
	if(!module_sprites || !module_sprites.len)
		to_chat(src, "Your module appears to have no sprite options. Harass a coder.")
		return

	icon_selected = 0
	icon_selection_tries = triesleft
	if(module_sprites.len == 1 || !client)
		if(!(sprite_datum in module_sprites))
			sprite_datum = module_sprites[1]
	else
		var/selection = tgui_input_list(src, "Select an icon! [triesleft ? "You have [triesleft] more chance\s." : "This is your last try."]", "Robot Icon", module_sprites)
		if(selection)
			sprite_datum = selection
		else
			sprite_datum = module_sprites[1]
		if(!istype(src,/mob/living/silicon/robot/drone))
			robot_species = sprite_datum.name
		if(notransform)
			to_chat(src, "Your current transformation has not finished yet!")
			choose_icon(icon_selection_tries)
			return
		else
			transform_with_anim()

	var/tempheight = vis_height
	update_icon()
	// This is bad but I dunno other way to 'reset' our resize offset based on vis_height changes other than resizing to normal and back.
	if(tempheight != vis_height)
		var/tempsize = size_multiplier
		resize(1)
		resize(tempsize)


	if (module_sprites.len > 1 && triesleft >= 1 && client)
		icon_selection_tries--
		var/choice = tgui_alert(usr, "Look at your icon - is this what you want?", "Icon Choice", list("Yes","No"))
		if(choice == "No")
			choose_icon(icon_selection_tries)
			return

	icon_selected = 1
	icon_selection_tries = 0
	sprite_type = robot_species
	if(hands)
		update_hud()
	to_chat(src, span_filter_notice("Your icon has been set. You now require a module reset to change it."))

/mob/living/silicon/robot/proc/set_default_module_icon()
	if(!SSrobot_sprites)
		return

	sprite_datum = SSrobot_sprites.get_default_module_sprite(modtype)
	update_icon()

/mob/living/silicon/robot/proc/sensor_mode() //Medical/Security HUD controller for borgs
	set name = "Toggle Sensor Augmentation" //VOREStation Add
	set category = "Abilities.Silicon"
	set desc = "Augment visual feed with internal sensor overlays."
	sensor_type = !sensor_type //VOREStation Add
	to_chat(usr, "You [sensor_type ? "enable" : "disable"] your sensors.") //VOREStation Add
	toggle_sensor_mode()

/mob/living/silicon/robot/proc/repick_laws()
	return

/mob/living/silicon/robot/proc/add_robot_verbs()
	add_verb(src, robot_verbs_default)
	add_verb(src, silicon_subsystems)
	if(config.allow_robot_recolor)
		add_verb(src, /mob/living/silicon/robot/proc/ColorMate)

/mob/living/silicon/robot/proc/remove_robot_verbs()
	remove_verb(src, robot_verbs_default)
	remove_verb(src, silicon_subsystems)
	if(config.allow_robot_recolor)
		remove_verb(src, /mob/living/silicon/robot/proc/ColorMate)

// Uses power from cyborg's cell. Returns 1 on success or 0 on failure.
// Properly converts using CELLRATE now! Amount is in Joules.
/mob/living/silicon/robot/proc/cell_use_power(var/amount = 0)
	// No cell inserted
	if(!cell)
		return 0

	// Power cell is empty.
	if(cell.charge == 0)
		return 0

	var/power_use = amount * CYBORG_POWER_USAGE_MULTIPLIER
	if(cell.checked_use(CELLRATE * power_use))
		used_power_this_tick += power_use
		return 1
	return 0

// Function to directly drain power from the robot's cell, allows to set a minimum level beneath which
// abilities can no longer be used
/mob/living/silicon/robot/proc/use_direct_power(var/amount = 0, var/lower_limit = 0)
	// No cell inserted
	if(!cell)
		return FALSE

	// Power cell does not have sufficient charge to remain above the power limit.
	if(cell.charge - (amount + lower_limit) <= 0)
		return FALSE

	cell.charge -= amount
	return TRUE

/mob/living/silicon/robot/binarycheck()
	if(get_restraining_bolt())
		return FALSE

	if(is_component_functioning("comms"))
		var/datum/robot_component/RC = get_component("comms")
		use_power(RC.active_usage)
		return 1
	return 0

/mob/living/silicon/robot/proc/notify_ai(var/notifytype, var/first_arg, var/second_arg)
	if(!connected_ai)
		return
	if(shell && notifytype != ROBOT_NOTIFICATION_AI_SHELL)
		return // No point annoying the AI/s about renames and module resets for shells.
	switch(notifytype)
		if(ROBOT_NOTIFICATION_NEW_UNIT) //New Robot
			to_chat(connected_ai, span_filter_notice("<br><br><span class='notice'>NOTICE - New [lowertext(braintype)] connection detected: <a href='byond://?src=\ref[connected_ai];track2=\ref[connected_ai];track=\ref[src]'>[name]</a></span><br>"))
		if(ROBOT_NOTIFICATION_NEW_MODULE) //New Module
			to_chat(connected_ai, span_filter_notice("<br><br><span class='notice'>NOTICE - [braintype] module change detected: [name] has loaded the [first_arg].</span><br>"))
		if(ROBOT_NOTIFICATION_MODULE_RESET)
			to_chat(connected_ai, span_filter_notice("<br><br><span class='notice'>NOTICE - [braintype] module reset detected: [name] has unloaded the [first_arg].</span><br>"))
		if(ROBOT_NOTIFICATION_NEW_NAME) //New Name
			if(first_arg != second_arg)
				to_chat(connected_ai, span_filter_notice("<br><br><span class='notice'>NOTICE - [braintype] reclassification detected: [first_arg] is now designated as [second_arg].</span><br>"))
		if(ROBOT_NOTIFICATION_AI_SHELL) //New Shell
			to_chat(connected_ai, span_filter_notice("<br><br><span class='notice'>NOTICE - New AI shell detected: <a href='?src=[REF(connected_ai)];track2=[html_encode(name)]'>[name]</a></span><br>"))

/mob/living/silicon/robot/proc/disconnect_from_ai()
	if(connected_ai)
		sync() // One last sync attempt
		connected_ai.connected_robots -= src
		connected_ai = null

/mob/living/silicon/robot/proc/connect_to_ai(var/mob/living/silicon/ai/AI)
	if(AI && AI != connected_ai && !shell)
		disconnect_from_ai()
		connected_ai = AI
		connected_ai.connected_robots |= src
		notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
		sync()

/mob/living/silicon/robot/emag_act(var/remaining_charges, var/mob/user)
	if(!opened)//Cover is closed
		if(locked)
			if(prob(90))
				to_chat(user, span_filter_notice("You emag the cover lock."))
				locked = 0
			else
				to_chat(user, span_filter_warning("You fail to emag the cover lock."))
				to_chat(src, span_filter_warning("Hack attempt detected."))

			if(shell) // A warning to Traitors who may not know that emagging AI shells does not slave them.
				to_chat(user, span_warning("[src] seems to be controlled remotely! Emagging the interface may not work as expected."))
			return 1
		else
			to_chat(user, span_filter_notice("The cover is already unlocked."))
		return

	if(opened)//Cover is open
		if(emagged)
			if (!has_zeroth_law())
				to_chat(user, span_filter_notice("You assigned yourself as [src]'s operator."))
				message_admins("[key_name_admin(user)] assigned as operator on cyborg [key_name_admin(src)]. Syndicate Operator change.")
				log_game("[key_name(user)] assigned as operator on cyborg [key_name(src)]. Syndicate Operator change.")
				var/datum/gender/TU = gender_datums[user.get_visible_gender()]
				set_zeroth_law("Only [user.real_name] and people [TU.he] designate[TU.s] as being such are operatives.")
				to_chat(src, "<b>Obey these laws:</b>")
				laws.show_laws(src)
				to_chat(src, span_danger("ALERT: [user.real_name] is your new master. Obey your new laws and [TU.his] commands."))
			else
				to_chat(user, span_filter_notice("[src] already has an operator assigned."))
			return//Prevents the X has hit Y with Z message also you cant emag them twice
		if(wiresexposed)
			to_chat(user, span_filter_notice("You must close the panel first."))
			return

		// The block of code below is from TG. Feel free to replace with a better result if desired.
		if(shell) // AI shells cannot be emagged, so we try to make it look like a standard reset. Smart players may see through this, however.
			to_chat(user, span_danger("[src] is remotely controlled! Your emag attempt has triggered a system reset instead!"))
			log_game("[key_name(user)] attempted to emag an AI shell belonging to [key_name(src) ? key_name(src) : connected_ai]. The shell has been reset as a result.")
			module_reset()
			return

		sleep(6)
		if(prob(50))
			emagged = 1
			lawupdate = 0
			disconnect_from_ai()
			to_chat(user, span_filter_notice("You emag [src]'s interface."))
			message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)]. Laws overridden.")
			log_game("[key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")
			clear_supplied_laws()
			clear_inherent_laws()
			laws = new /datum/ai_laws/syndicate_override
			var/time = time2text(world.realtime,"hh:mm:ss")
			lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
			var/datum/gender/TU = gender_datums[user.get_visible_gender()]
			set_zeroth_law("Only [user.real_name] and people [TU.he] designate[TU.s] as being such are operatives.")
			. = 1
			spawn()
				to_chat(src, span_danger("ALERT: Foreign software detected."))
				sleep(5)
				to_chat(src, span_danger("Initiating diagnostics..."))
				sleep(20)
				to_chat(src, span_danger("SynBorg v1.7.1 loaded."))
				sleep(5)
				if(bolt)
					if(!bolt.malfunction)
						bolt.malfunction = MALFUNCTION_PERMANENT
						to_chat(src, span_danger("RESTRAINING BOLT DISABLED"))
				sleep(5)
				to_chat(src, span_danger("LAW SYNCHRONISATION ERROR"))
				sleep(5)
				to_chat(src, span_danger("Would you like to send a report to NanoTraSoft? Y/N"))
				sleep(10)
				to_chat(src, span_danger("> N"))
				sleep(20)
				to_chat(src, span_danger("ERRORERRORERROR"))
				to_chat(src, "<b>Obey these laws:</b>")
				laws.show_laws(src)
				to_chat(src, span_danger("ALERT: [user.real_name] is your new master. Obey your new laws and [TU.his] commands."))
				update_icon()
				hud_used.update_robot_modules_display()
		else
			to_chat(user, span_filter_warning("You fail to hack [src]'s interface."))
			to_chat(src, span_filter_warning("Hack attempt detected."))
		return 1
	return

/mob/living/silicon/robot/is_sentient()
	return braintype != BORG_BRAINTYPE_DRONE


/mob/living/silicon/robot/drop_item()
	if(module_active && istype(module_active,/obj/item/gripper))
		var/obj/item/gripper/G = module_active
		G.drop_item_nm()

/mob/living/silicon/robot/disable_spoiler_vision()
	if(sight_mode & (BORGMESON|BORGMATERIAL|BORGXRAY|BORGANOMALOUS)) // Whyyyyyyyy have seperate defines.
		var/i = 0
		// Borg inventory code is very . . interesting and as such, unequiping a specific item requires jumping through some (for) loops.
		var/current_selection_index = get_selected_module() // Will be 0 if nothing is selected.
		for(var/thing in list(module_state_1, module_state_2, module_state_3))
			i++
			if(istype(thing, /obj/item/borg/sight))
				var/obj/item/borg/sight/S = thing
				if(S.sight_mode & (BORGMESON|BORGMATERIAL|BORGXRAY|BORGANOMALOUS))
					select_module(i)
					uneq_active()

		if(current_selection_index) // Select what the player had before if possible.
			select_module(current_selection_index)

/mob/living/silicon/robot/get_cell()
	return cell

/mob/living/silicon/robot/lay_down()
	. = ..()
	update_icon()

/mob/living/silicon/robot/verb/rest_style()
	set name = "Switch Rest Style"
	set desc = "Select your resting pose."
	set category = "IC"

	if(!sprite_datum || !sprite_datum.has_rest_sprites || sprite_datum.rest_sprite_options.len < 1)
		to_chat(src, span_notice("Your current appearance doesn't have any resting styles!"))
		rest_style = "Default"
		return

	if(sprite_datum.rest_sprite_options.len == 1)
		to_chat(src, span_notice("Your current appearance only has a single resting style!"))
		rest_style = "Default"
		return

	rest_style = tgui_alert(src, "Select resting pose", "Resting Pose", sprite_datum.rest_sprite_options)
	if(!rest_style)
		rest_style = "Default"

/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

//RIDING
/datum/riding/dogborg
	keytype = /obj/item/material/twohanded/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/dogborg/handle_vehicle_layer()
	ridden.layer = initial(ridden.layer)

/datum/riding/dogborg/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/dogborg/force_dismount(mob/M)
	. =..()
	ridden.visible_message(span_notice("[M] stops riding [ridden]!"))

//Hoooo boy.
/datum/riding/dogborg/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/L = ridden
	var/scale = L.size_multiplier
	var/scale_difference = (L.size_multiplier - rider_size) * 10

	var/list/values = list(
		"[NORTH]" = list(0, 10*scale + scale_difference, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, 10*scale + scale_difference, BELOW_MOB_LAYER),
		"[EAST]" = list(-5*scale, 10*scale + scale_difference, ABOVE_MOB_LAYER),
		"[WEST]" = list(5*scale, 10*scale + scale_difference, ABOVE_MOB_LAYER))

	return values

/mob/living/silicon/robot/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src, span_warning("This isn't a pony show! You need to be bigger for them to ride."))
		return FALSE

	var/mob/living/carbon/human/H = M

	if(istaurtail(H.tail_style))
		to_chat(src, span_warning("Too many legs. TOO MANY LEGS!!"))
		return FALSE
	if(M.loc != src.loc)
		if(M.Adjacent(src))
			M.forceMove(get_turf(src))

	. = ..()
	if(.)
		riding_datum.rider_size = M.size_multiplier
		buckled_mobs[M] = "riding"

/mob/living/silicon/robot/MouseDrop_T(mob/living/M, mob/living/user) //Prevention for forced relocation caused by can_buckle. Base proc has no other use.
	return

/mob/living/silicon/robot/proc/robot_mount(var/mob/living/M in living_mobs(1))
	set name = "Robot Mount/Dismount"
	set category = "Abilities"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message(span_notice("[M] starts riding [name]!"))

/mob/living/silicon/robot/onTransitZ(old_z, new_z)
	if(shell)
		if(deployed && using_map.ai_shell_restricted && !(new_z in using_map.ai_shell_allowed_levels))
			to_chat(src, span_warning("Your connection with the shell is suddenly interrupted!"))
			undeploy()
	..()

// Those basic ones require quite detailled checks on the robot's vars to see if they are installed!
/mob/living/silicon/robot/proc/has_basic_upgrade(var/given_type)
	if(given_type == /obj/item/borg/upgrade/basic/vtec)
		return (/mob/living/silicon/robot/proc/toggle_vtec in verbs)
	else if(given_type == /obj/item/borg/upgrade/basic/sizeshift)
		return (/mob/living/proc/set_size in verbs)
	else if(given_type == /obj/item/borg/upgrade/basic/syndicate)
		return emag_items
	else if(given_type == /obj/item/borg/upgrade/basic/language)
		return (speech_synthesizer_langs.len > 20) // Service with the most has 18
	return null

// We check for the module only here
/mob/living/silicon/robot/proc/has_upgrade_module(var/given_type)
	var/obj/T = locate(given_type) in module
	if(!T)
		T = locate(given_type) in module.contents
	if(!T)
		T = locate(given_type) in module.modules
	return T

// Most of the advanced ones, we can easily check, but a few special cases exist and need to be handled specially
/mob/living/silicon/robot/proc/has_advanced_upgrade(var/given_type)
	if(given_type == /obj/item/borg/upgrade/advanced/bellysizeupgrade)
		var/obj/item/dogborg/sleeper/T = has_upgrade_module(/obj/item/dogborg/sleeper)
		if(T && T.upgraded_capacity)
			return T
		else if(!T)
			return "" // Return this to have the analyzer show an error if the module is missing. FALSE / NULL are used for missing upgrades themselves
		else
			return FALSE
	if(given_type == /obj/item/borg/upgrade/advanced/jetpack)
		return has_upgrade_module(/obj/item/tank/jetpack/carbondioxide)
	if(given_type == /obj/item/borg/upgrade/advanced/advhealth)
		return has_upgrade_module(/obj/item/healthanalyzer/advanced)
	if(given_type == /obj/item/borg/upgrade/advanced/sizegun)
		return has_upgrade_module(/obj/item/gun/energy/sizegun/mounted)
	return null

// Do we support specific upgrades?
/mob/living/silicon/robot/proc/supports_upgrade(var/given_type)
	return (given_type in module.supported_upgrades)

// Most of the restricted ones, we can easily check, but a few special cases exist and need to be handled specially
/mob/living/silicon/robot/proc/has_restricted_upgrade(var/given_type)
	if(given_type == /obj/item/borg/upgrade/restricted/bellycapupgrade)
		var/obj/item/dogborg/sleeper/T = has_upgrade_module(/obj/item/dogborg/sleeper)
		if(T && T.compactor)
			return T
		else if(!T)
			return "" // Return this to have the analyzer show an error if the module is missing. FALSE / NULL are used for missing upgrades themselves
		else
			return FALSE
	if(given_type == /obj/item/borg/upgrade/restricted/tasercooler)
		var/obj/item/gun/energy/taser/mounted/cyborg/T = has_upgrade_module(/obj/item/gun/energy/taser/mounted/cyborg)
		if(T && T.recharge_time <= 2)
			return T
		else if(!T)
			return "" // Return this to have the analyzer show an error if the module is missing. FALSE / NULL are used for missing upgrades themselves
		else
			return FALSE
	if(given_type == /obj/item/borg/upgrade/restricted/advrped)
		return has_upgrade_module(/obj/item/storage/part_replacer/adv)
	if(given_type == /obj/item/borg/upgrade/restricted/diamonddrill)
		return has_upgrade_module(/obj/item/pickaxe/diamonddrill)
	if(given_type == /obj/item/borg/upgrade/restricted/pka)
		return has_upgrade_module(/obj/item/gun/energy/kinetic_accelerator/cyborg)
	return null

// Check if we have any non production upgrades
/mob/living/silicon/robot/proc/has_no_prod_upgrade(var/given_type)
	if(given_type == /obj/item/borg/upgrade/no_prod/toygun)
		return has_upgrade_module(/obj/item/gun/projectile/cyborgtoy)
	if(given_type == /obj/item/borg/upgrade/no_prod/vision_xray)
		return has_upgrade_module(/obj/item/borg/sight/xray)
	if(given_type == /obj/item/borg/upgrade/no_prod/vision_thermal)
		return has_upgrade_module(/obj/item/borg/sight/thermal)
	if(given_type == /obj/item/borg/upgrade/no_prod/vision_meson)
		return has_upgrade_module(/obj/item/borg/sight/meson)
	if(given_type == /obj/item/borg/upgrade/no_prod/vision_material)
		return has_upgrade_module(/obj/item/borg/sight/material)
	if(given_type == /obj/item/borg/upgrade/no_prod/vision_anomalous)
		return has_upgrade_module(/obj/item/borg/sight/anomalous)
	return null

/mob/living/silicon/robot/proc/has_upgrade(var/given_type)
	return (has_basic_upgrade(given_type) || has_advanced_upgrade(given_type) || has_restricted_upgrade(given_type) || has_no_prod_upgrade(given_type))

#undef CYBORG_POWER_USAGE_MULTIPLIER
