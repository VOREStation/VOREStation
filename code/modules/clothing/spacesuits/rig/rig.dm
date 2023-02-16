#define ONLY_DEPLOY 1
#define ONLY_RETRACT 2
#define SEAL_DELAY 30

/*
 * Defines the behavior of hardsuits/rigs/power armour.
 */

/obj/item/weapon/rig
	name = "hardsuit control module"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "A back-mounted hardsuit deployment and control mechanism."
	flags = PHORONGUARD
	slot_flags = SLOT_BACK
	req_one_access = list()
	req_access = list()
	w_class = ITEMSIZE_HUGE
	action_button_name = "Toggle Heatsink"

	// These values are passed on to all component pieces.
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.2
	permeability_coefficient = 0.1
	unacidable = TRUE
	preserve_item = 1

	var/default_mob_icon = 'icons/mob/rig_back.dmi'

	var/suit_state //The string used for the suit's icon_state.

	var/interface_path = "RIGSuit"
	var/ai_interface_path = "RIGSuit"
	var/interface_title = "Hardsuit Controller"
	var/wearer_move_delay //Used for AI moving.
	var/ai_controlled_move_delay = 10

	// Keeps track of what this rig should spawn with.
	var/suit_type = "hardsuit"
	var/list/initial_modules
	var/chest_type = /obj/item/clothing/suit/space/rig
	var/helm_type =  /obj/item/clothing/head/helmet/space/rig
	var/boot_type =  /obj/item/clothing/shoes/magboots/rig
	var/glove_type = /obj/item/clothing/gloves/gauntlets/rig
	var/cell_type =  /obj/item/weapon/cell/high
	var/air_type =   /obj/item/weapon/tank/oxygen

	//Component/device holders.
	var/obj/item/weapon/tank/air_supply                       // Air tank, if any.
	var/obj/item/clothing/shoes/boots = null                  // Deployable boots, if any.
	var/obj/item/clothing/suit/space/rig/chest                // Deployable chestpiece, if any.
	var/obj/item/clothing/head/helmet/space/rig/helmet = null // Deployable helmet, if any.
	var/obj/item/clothing/gloves/gauntlets/rig/gloves = null  // Deployable gauntlets, if any.
	var/obj/item/weapon/cell/cell                             // Power supply, if any.
	var/obj/item/rig_module/selected_module = null            // Primary system (used with middle-click)
	var/obj/item/rig_module/vision/visor                      // Kinda shitty to have a var for a module, but saves time.
	var/obj/item/rig_module/voice/speech                      // As above.
	var/mob/living/carbon/human/wearer                        // The person currently wearing the rig.
	var/image/mob_icon                                        // Holder for on-mob icon.
	var/list/installed_modules = list()                       // Power consumption/use bookkeeping.

	// Cooling system vars.
	var/cooling_on = 0					//is it turned on?
	var/max_cooling = 15				// in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 2			// charge per second at max_cooling		//more effective on a rig, because it's all built in already
	var/thermostat = T20C

	// Rig status vars.
	var/open = 0                                              // Access panel status.
	var/locked = 1                                            // Lock status.
	var/subverted = 0
	var/interface_locked = 0
	var/control_overridden = 0
	var/ai_override_enabled = 0
	var/security_check_enabled = 1
	var/malfunctioning = 0
	var/malfunction_delay = 0
	var/electrified = 0
	var/locked_down = 0

	var/seal_delay = SEAL_DELAY
	var/sealing                                               // Keeps track of seal status independantly of canremove.
	var/offline = 1                                           // Should we be applying suit maluses?
	var/offline_slowdown = 1.5                                  // If the suit is deployed and unpowered, it sets slowdown to this.
	var/vision_restriction
	var/offline_vision_restriction = 1                        // 0 - none, 1 - welder vision, 2 - blind. Maybe move this to helmets.
	var/airtight = 1 //If set, will adjust AIRTIGHT flag and pressure protections on components. Otherwise it should leave them untouched.
	var/rigsuit_max_pressure = 10 * ONE_ATMOSPHERE			  // Max pressure the rig protects against when sealed
	var/rigsuit_min_pressure = 0							  // Min pressure the rig protects against when sealed

	var/emp_protection = 0
	item_flags = PHORONGUARD //VOREStation add

	// Wiring! How exciting.
	var/datum/wires/rig/wires
	var/datum/effect/effect/system/spark_spread/spark_system
	var/datum/mini_hud/rig/minihud

	// Action button
	action_button_name = "Hardsuit Interface"

/obj/item/weapon/rig/New()
	..()

	suit_state = icon_state
	item_state = icon_state
	wires = new(src)

	if(!LAZYLEN(req_access) && !LAZYLEN(req_one_access))
		locked = 0

	spark_system = new()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	if(initial_modules && initial_modules.len)
		for(var/path in initial_modules)
			var/obj/item/rig_module/module = new path(src)
			installed_modules += module
			module.installed(src)

	// Create and initialize our various segments.
	if(cell_type)
		cell = new cell_type(src)
	if(air_type)
		air_supply = new air_type(src)
	if(glove_type)
		gloves = new glove_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_gauntlets
	if(helm_type)
		helmet = new helm_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_helmet
	if(boot_type)
		boots = new boot_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_boots
	if(chest_type)
		chest = new chest_type(src)
		if(allowed)
			chest.allowed = allowed
		verbs |= /obj/item/weapon/rig/proc/toggle_chest

	for(var/obj/item/piece in list(gloves,helmet,boots,chest))
		if(!istype(piece))
			continue
		piece.canremove = FALSE
		piece.name = "[suit_type] [initial(piece.name)]"
		piece.desc = "It seems to be part of a [src.name]."
		piece.icon_state = "[suit_state]"
		piece.min_cold_protection_temperature = min_cold_protection_temperature
		piece.max_heat_protection_temperature = max_heat_protection_temperature
		if(piece.siemens_coefficient > siemens_coefficient) //So that insulated gloves keep their insulation.
			piece.siemens_coefficient = siemens_coefficient
		piece.permeability_coefficient = permeability_coefficient
		piece.unacidable = unacidable
		if(islist(armor)) piece.armor = armor.Copy()
		if(islist(armorsoak)) piece.armorsoak = armorsoak.Copy()

	update_icon(1)

/obj/item/weapon/rig/Destroy()
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		var/mob/living/M = piece.loc
		if(istype(M))
			M.drop_from_inventory(piece)
		qdel(piece)
	STOP_PROCESSING(SSobj, src)
	qdel(wires)
	wires = null
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/weapon/rig/examine()
	. = ..()
	if(wearer)
		for(var/obj/item/piece in list(helmet,gloves,chest,boots))
			if(!piece || piece.loc != wearer)
				continue
			. += "\icon[piece][bicon(piece)] \The [piece] [piece.gender == PLURAL ? "are" : "is"] deployed."

	if(src.loc == usr)
		. += "The access panel is [locked? "locked" : "unlocked"]."
		. += "The maintenance panel is [open ? "open" : "closed"]."
		. += "Hardsuit systems are [offline ? "<span class='warning'>offline</span>" : "<span class='notice'>online</span>"]."
		. += "The cooling system is [cooling_on ? "active" : "inactive"]."

		if(open)
			. += "It's equipped with [english_list(installed_modules)]."

// We only care about processing when we're on a mob
/obj/item/weapon/rig/Moved(old_loc, direction, forced)
	if(ismob(loc))
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
		QDEL_NULL(minihud) // Just in case we get removed some other way

	// If we've lost any parts, grab them back.
	var/mob/living/M
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		if(piece.loc != src && !(wearer && piece.loc == wearer))
			if(istype(piece.loc, /mob/living))
				M = piece.loc
				M.unEquip(piece)
			piece.forceMove(src)

<<<<<<< HEAD
/obj/item/weapon/rig/get_worn_icon_file(var/body_type,var/slot_name,var/default_icon,var/inhands)
=======
/obj/item/rig/get_worn_icon_file(var/body_type, var/slot_name, var/default_icon, var/inhands, var/check_state)
>>>>>>> 9a846673232... Reworks on-mob overlay icon generation. (#8920)
	if(!inhands && (slot_name == slot_back_str || slot_name == slot_belt_str))
		if(icon_override)
			return icon_override
		else if(mob_icon)
			return mob_icon

	return ..()

/obj/item/weapon/rig/proc/suit_is_deployed()
	if(!istype(wearer) || src.loc != wearer || (wearer.back != src && wearer.belt != src))
		return 0
	if(helm_type && !(helmet && wearer.head == helmet))
		return 0
	if(glove_type && !(gloves && wearer.gloves == gloves))
		return 0
	if(boot_type && !(boots && wearer.shoes == boots))
		return 0
	if(chest_type && !(chest && wearer.wear_suit == chest))
		return 0
	return 1

// Updates pressure protection
// Seal = 1 sets protection
// Seal = 0 unsets protection
/obj/item/weapon/rig/proc/update_airtight(var/obj/item/piece, var/seal = 0)
	if(seal == 1)
		piece.min_pressure_protection = rigsuit_min_pressure
		piece.max_pressure_protection = rigsuit_max_pressure
		piece.item_flags |= AIRTIGHT
	else
		piece.min_pressure_protection = null
		piece.max_pressure_protection = null
		piece.item_flags &= ~AIRTIGHT
	return


/obj/item/weapon/rig/proc/reset()
	offline = 2
	canremove = TRUE
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(!piece) continue
		piece.icon_state = "[suit_state]"
		if(airtight)
			update_airtight(piece, 0) // Unseal
	update_icon(1)

/obj/item/weapon/rig/proc/cut_suit()
	offline = 2
	canremove = TRUE
	toggle_piece("helmet", loc, ONLY_RETRACT, TRUE)
	toggle_piece("gauntlets", loc, ONLY_RETRACT, TRUE)
	toggle_piece("boots", loc, ONLY_RETRACT, TRUE)
	toggle_piece("chest", loc, ONLY_RETRACT, TRUE)
	update_icon(1)

/obj/item/weapon/rig/proc/toggle_seals(var/mob/living/carbon/human/M,var/instant)

	if(sealing) return

	if(!check_power_cost(M))
		return 0

	deploy(M,instant)

	var/seal_target = !canremove
	var/failed_to_seal

	var/obj/screen/rig_booting/booting_L = new
	var/obj/screen/rig_booting/booting_R = new

	if(!seal_target)
		booting_L.icon_state = "boot_left"
		booting_R.icon_state = "boot_load"
		animate(booting_L, alpha=230, time=30, easing=SINE_EASING)
		animate(booting_R, alpha=200, time=20, easing=SINE_EASING)
		M.client?.screen += booting_L
		M.client?.screen += booting_R

	canremove = FALSE // No removing the suit while unsealing.
	sealing = 1

	if(!seal_target && !suit_is_deployed())
		M.visible_message("<span class='danger'>[M]'s suit flashes an error light.</span>","<span class='danger'>Your suit flashes an error light. It can't function properly without being fully deployed.</span>")
		playsound(src, 'sound/machines/rig/rigerror.ogg', 20, FALSE)
		failed_to_seal = 1

	if(!failed_to_seal)

		if(!instant)
			M.visible_message("<span class='notice'>[M]'s suit emits a quiet hum as it begins to adjust its seals.</span>","<span class='notice'>With a quiet hum, the suit begins running checks and adjusting components.</span>")
			if(seal_delay && !do_after(M,seal_delay))
				if(M)
					to_chat(M, "<span class='warning'>You must remain still while the suit is adjusting the components.</span>")
					playsound(src, 'sound/machines/rig/rigerror.ogg', 20, FALSE)
				failed_to_seal = 1
		if(!M)
			failed_to_seal = 1
		else
			for(var/list/piece_data in list(list(M.shoes,boots,"boots",boot_type),list(M.gloves,gloves,"gloves",glove_type),list(M.head,helmet,"helmet",helm_type),list(M.wear_suit,chest,"chest",chest_type)))

				var/obj/item/piece = piece_data[1]
				var/obj/item/compare_piece = piece_data[2]
				var/msg_type = piece_data[3]
				var/piece_type = piece_data[4]

				if(!piece || !piece_type)
					continue

				if(!istype(M) || !istype(piece) || !istype(compare_piece) || !msg_type)
					if(M)
						to_chat(M, "<span class='warning'>You must remain still while the suit is adjusting the components.</span>")
					failed_to_seal = 1
					break

				if(!failed_to_seal && (M.back == src || M.belt == src) && piece == compare_piece)

					if(seal_delay && !instant && !do_after(M,seal_delay,needhand=0))
						failed_to_seal = 1

					piece.icon_state = "[suit_state][!seal_target ? "_sealed" : ""]"
					switch(msg_type)
						if("boots")
							to_chat(M, "<span class='notice'>\The [piece] [!seal_target ? "seal around your feet" : "relax their grip on your legs"].</span>")
							M.update_inv_shoes()
						if("gloves")
							to_chat(M, "<span class='notice'>\The [piece] [!seal_target ? "tighten around your fingers and wrists" : "become loose around your fingers"].</span>")
							M.update_inv_gloves()
						if("chest")
							to_chat(M, "<span class='notice'>\The [piece] [!seal_target ? "cinches tight again your chest" : "releases your chest"].</span>")
							M.update_inv_wear_suit()
						if("helmet")
							to_chat(M, "<span class='notice'>\The [piece] hisses [!seal_target ? "closed" : "open"].</span>")
							M.update_inv_head()
							if(helmet?.light_system == STATIC_LIGHT)
								helmet.update_light(wearer)

					//sealed pieces become airtight, protecting against diseases
					if (!seal_target)
						piece.armor["bio"] = 100
					else
						piece.armor["bio"] = src.armor["bio"]
					playsound(src,'sound/machines/rig/rigservo.ogg', 10, FALSE)

				else
					failed_to_seal = 1

		if((M && !(istype(M) && (M.back == src || M.belt == src)) && !istype(M,/mob/living/silicon)) || (!seal_target && !suit_is_deployed()))
			failed_to_seal = 1

	sealing = null

	if(failed_to_seal)
		M.client?.screen -= booting_L
		M.client?.screen -= booting_R
		qdel(booting_L)
		qdel(booting_R)
		for(var/obj/item/piece in list(helmet,boots,gloves,chest))
			if(!piece) continue
			piece.icon_state = "[suit_state][!seal_target ? "" : "_sealed"]"
		canremove = !seal_target
		if(airtight)
			update_component_sealed()
		update_icon(1)
		return 0

	// Success!
	canremove = seal_target
	if(M.hud_used)
		if(canremove)
			QDEL_NULL(minihud)
		else
			minihud = new (M.hud_used, src)
	to_chat(M, "<span class='notice'><b>Your entire suit [canremove ? "loosens as the components relax" : "tightens around you as the components lock into place"].</b></span>")
	playsound(src, 'sound/machines/rig/rigstarted.ogg', 10, FALSE)
	M.client?.screen -= booting_L
	qdel(booting_L)
	booting_R.icon_state = "boot_done"
	spawn(40)
		M.client?.screen -= booting_R
		qdel(booting_R)

	if(canremove)
		for(var/obj/item/rig_module/module in installed_modules)
			module.deactivate()
	if(airtight)
		update_component_sealed()
	update_icon(1)

/obj/item/weapon/rig/proc/update_component_sealed()
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(canremove)
			update_airtight(piece, 0) // Unseal
		else
			update_airtight(piece, 1) // Seal

/obj/item/weapon/rig/ui_action_click()
	toggle_cooling(usr)

/obj/item/weapon/rig/proc/toggle_cooling(var/mob/user)
	if(cooling_on)
		turn_cooling_off(user)
	else
		turn_cooling_on(user)

/obj/item/weapon/rig/proc/turn_cooling_on(var/mob/user)
	if(!cell)
		return
	if(cell.charge <= 0)
		to_chat(user, "<span class='notice'>\The [src] has no power!</span>")
		return
	if(!suit_is_deployed())
		to_chat(user, "<span class='notice'>The hardsuit needs to be deployed first!</span>")
		return

	cooling_on = 1
	to_chat(usr, "<span class='notice'>You switch \the [src]'s cooling system on.</span>")


/obj/item/weapon/rig/proc/turn_cooling_off(var/mob/user, var/failed)
	if(failed)
		visible_message("\The [src]'s cooling system clicks and whines as it powers down.")
	else
		to_chat(usr, "<span class='notice'>You switch \the [src]'s cooling system off.</span>")
	cooling_on = 0

/obj/item/weapon/rig/proc/get_environment_temperature()
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(istype(H.loc, /obj/mecha))
			var/obj/mecha/M = H.loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/cryo = H.loc
			return cryo.air_contents.temperature

	var/turf/T = get_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment)
		return 0

	return environment.temperature

/obj/item/weapon/rig/proc/attached_to_user(mob/M)
	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if (!H.wear_suit || (H.back != src && H.belt != src))
		return 0

	return 1

/obj/item/weapon/rig/proc/coolingProcess()
	if (!cooling_on || !cell)
		return

	if (!ismob(loc))
		return

	if (!attached_to_user(loc))		//make sure the rig's not just in their hands
		return

	if (!suit_is_deployed())		//inbuilt systems only work on the suit they're designed to work on
		return

	var/mob/living/carbon/human/H = loc

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	var/efficiency = 1 - H.get_pressure_weakness(environment.return_pressure())	// You need to have a good seal for effective cooling
	var/env_temp = get_environment_temperature()						//wont save you from a fire
	var/temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)
	var/thermal_protection = H.get_heat_protection(env_temp)	// ... unless you've got a good suit.

	if(thermal_protection < 0.99)		//For some reason, < 1 returns false if the value is 1.
		temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)
	else
		temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj*efficiency

	cell.use(charge_usage)

	if(cell.charge <= 0)
		turn_cooling_off(H, 1)

/obj/item/weapon/rig/process()
	// Not on a mob...?
	if(!ismob(loc))
		if(wearer?.wearing_rig == src)
			wearer.wearing_rig = null
		wearer = null
		return PROCESS_KILL

	// Run through cooling
	coolingProcess()

	if(!istype(wearer) || loc != wearer || (wearer.back != src && wearer.belt != src) || canremove || !cell || cell.charge <= 0)
		if(!cell || cell.charge <= 0)
			if(electrified > 0)
				electrified = 0
			if(!offline)
				if(istype(wearer))
					if(!canremove)
						if (offline_slowdown < 1.5)
							to_chat(wearer, "<span class='danger'>Your suit beeps stridently, and suddenly goes dead.</span>")
						else
							to_chat(wearer, "<span class='danger'>Your suit beeps stridently, and suddenly you're wearing a leaden mass of metal and plastic composites instead of a powered suit.</span>")
						playsound(src, 'sound/machines/rig/rigdown.ogg', 60, FALSE)
					if(offline_vision_restriction == 1)
						to_chat(wearer, "<span class='danger'>The suit optics flicker and die, leaving you with restricted vision.</span>")
					else if(offline_vision_restriction == 2)
						to_chat(wearer, "<span class='danger'>The suit optics drop out completely, drowning you in darkness.</span>")
		if(!offline)
			offline = 1
	else
		if(offline)
			offline = 0
			if(istype(wearer) && !wearer.wearing_rig)
				wearer.wearing_rig = src
			slowdown = initial(slowdown)

	if(offline)
		if(offline == 1)
			for(var/obj/item/rig_module/module in installed_modules)
				module.deactivate()
			offline = 2
			slowdown = offline_slowdown
		return

	if(cell && cell.charge > 0 && electrified > 0)
		electrified--

	if(malfunction_delay > 0)
		malfunction_delay--
	else if(malfunctioning)
		malfunctioning--
		malfunction()

	for(var/obj/item/rig_module/module in installed_modules)
		cell.use(module.process()*10)

/obj/item/weapon/rig/proc/check_power_cost(var/mob/living/user, var/cost, var/use_unconcious, var/obj/item/rig_module/mod, var/user_is_ai)

	if(!istype(user))
		return 0

	var/fail_msg

	if(!user_is_ai)
		var/mob/living/carbon/human/H = user
		if(istype(H) && (H.back != src && H.belt != src))
			fail_msg = "<span class='warning'>You must be wearing \the [src] to do this.</span>"
		else if(user.incorporeal_move)
			fail_msg = "<span class='warning'>You must be solid to do this.</span>"
	if(sealing)
		fail_msg = "<span class='warning'>The hardsuit is in the process of adjusting seals and cannot be activated.</span>"
	else if(!fail_msg && ((use_unconcious && user.stat > 1) || (!use_unconcious && user.stat)))
		fail_msg = "<span class='warning'>You are in no fit state to do that.</span>"
	else if(!cell)
		fail_msg = "<span class='warning'>There is no cell installed in the suit.</span>"
	else if(cost && cell.charge < cost * 10) //TODO: Cellrate?
		fail_msg = "<span class='warning'>Not enough stored power.</span>"

	if(fail_msg)
		to_chat(user, fail_msg)
		playsound(src, 'sound/machines/rig/rigerror.ogg', 20, FALSE)
		return 0

	// This is largely for cancelling stealth and whatever.
	if(mod && mod.disruptive)
		for(var/obj/item/rig_module/module in (installed_modules - mod))
			if(module.active && module.disruptable)
				module.deactivate()

	cell.use(cost*10)
	return 1

/obj/item/weapon/rig/update_icon(var/update_mob_icon)

	cut_overlays()
	if(!mob_icon || update_mob_icon)
		var/species_icon = default_mob_icon
		// Since setting mob_icon will override the species checks in
		// update_inv_wear_suit(), handle species checks here.
<<<<<<< HEAD
		if(wearer && LAZYACCESS(sprite_sheets, wearer.species.get_bodytype(wearer)))
			species_icon = sprite_sheets[wearer.species.get_bodytype(wearer)]
=======
		var/body_type = wearer?.species.get_bodytype(wearer)
		if(wearer && LAZYACCESS(sprite_sheets, body_type))
			species_icon = LAZYACCESS(sprite_sheets, body_type)
>>>>>>> 9a846673232... Reworks on-mob overlay icon generation. (#8920)
		mob_icon = icon(icon = species_icon, icon_state = "[icon_state]")

	if(installed_modules.len)
		for(var/obj/item/rig_module/module in installed_modules)
			if(module.suit_overlay)
				chest.add_overlay(image(module.suit_overlay_icon, icon_state = "[module.suit_overlay]", dir = SOUTH))

	if(wearer)
		wearer.update_inv_shoes()
		wearer.update_inv_gloves()
		wearer.update_inv_head()
		wearer.update_inv_wear_suit()
		wearer.update_inv_back()
	return

/obj/item/weapon/rig/proc/check_suit_access(var/mob/living/carbon/human/user, var/do_message = TRUE)

	if(!security_check_enabled)
		return 1

	if(istype(user))
		if(!canremove)
			return 1
		if(malfunction_check(user))
			return 0
		if(user.back != src && user.belt != src)
			return 0
		else if(!src.allowed(user))
			if(do_message)
				to_chat(user, "<span class='danger'>Unauthorized user. Access denied.</span>")
			return 0

	else if(!ai_override_enabled)
		if(do_message)
			to_chat(user, "<span class='danger'>Synthetic access disabled. Please consult hardware provider.</span>")
		return 0

	return 1

/obj/item/weapon/rig/proc/notify_ai(var/message)
	for(var/obj/item/rig_module/ai_container/module in installed_modules)
		if(module.integrated_ai && module.integrated_ai.client && !module.integrated_ai.stat)
			to_chat(module.integrated_ai, "[message]")
			. = 1

/obj/item/weapon/rig/equipped(mob/living/carbon/human/M)
	..()

	if(istype(M.back, /obj/item/weapon/rig) && istype(M.belt, /obj/item/weapon/rig))
		to_chat(M, "<span class='notice'>You try to put on the [src], but it won't fit.</span>")
		if(M && (M.back == src || M.belt == src))
			if(!M.unEquip(src))
				return
		src.forceMove(get_turf(src))
		return

	if(seal_delay > 0 && istype(M) && (M.back == src || M.belt == src))
		M.visible_message("<span class='notice'>[M] starts putting on \the [src]...</span>", "<span class='notice'>You start putting on \the [src]...</span>")
		if(!do_after(M,seal_delay))
			if(M && (M.back == src || M.belt == src))
				if(!M.unEquip(src))
					return
			src.forceMove(get_turf(src))
			return

	if(istype(M) && (M.back == src || M.belt == src))
		M.visible_message("<span class='notice'><b>[M] struggles into \the [src].</b></span>", "<span class='notice'><b>You struggle into \the [src].</b></span>")
		wearer = M
		wearer.wearing_rig = src
		update_icon()

/obj/item/weapon/rig/proc/toggle_piece(var/piece, var/mob/living/carbon/human/H, var/deploy_mode, var/forced = FALSE)

	if((sealing || !cell || !cell.charge) && !forced)
		return

	if((!istype(wearer) || (!wearer.back == src && !wearer.belt == src)) && !forced)
		return

	if((usr == wearer && (usr.stat||usr.paralysis||usr.stunned)) && !forced) // If the usr isn't wearing the suit it's probably an AI.
		return

	var/obj/item/check_slot
	var/equip_to
	var/obj/item/use_obj

	if(!H)
		return

	switch(piece)
		if("helmet")
			equip_to = slot_head
			use_obj = helmet
			check_slot = H.head
		if("gauntlets")
			equip_to = slot_gloves
			use_obj = gloves
			check_slot = H.gloves
		if("boots")
			equip_to = slot_shoes
			use_obj = boots
			check_slot = H.shoes
		if("chest")
			equip_to = slot_wear_suit
			use_obj = chest
			check_slot = H.wear_suit

	if(use_obj)
		if(check_slot == use_obj && deploy_mode != ONLY_DEPLOY)

			var/mob/living/carbon/human/holder

			if(use_obj)
				holder = use_obj.loc
				if(istype(holder))
					if(use_obj && check_slot == use_obj)
						to_chat(H, "<span class='notice'><b>Your [use_obj.name] [use_obj.gender == PLURAL ? "retract" : "retracts"] swiftly.</b></span>")
						playsound(src, 'sound/machines/rig/rigservo.ogg', 10, FALSE)
						use_obj.canremove = TRUE
						holder.drop_from_inventory(use_obj)
						use_obj.forceMove(get_turf(src))
						use_obj.dropped()
						use_obj.canremove = FALSE
						use_obj.forceMove(src)

		else if (deploy_mode != ONLY_RETRACT)
			if(check_slot && check_slot == use_obj)
				return
			use_obj.forceMove(H)
			if(!H.equip_to_slot_if_possible(use_obj, equip_to, 0, 1))
				use_obj.forceMove(src)
				if(check_slot)
					to_chat(H, "<span class='danger'>You are unable to deploy \the [piece] as \the [check_slot] [check_slot.gender == PLURAL ? "are" : "is"] in the way.</span>")
					return
			else
				to_chat(H, "<span class='notice'>Your [use_obj.name] [use_obj.gender == PLURAL ? "deploy" : "deploys"] swiftly.</span>")
				playsound(src, 'sound/machines/rig/rigservo.ogg', 10, FALSE)

	if(piece == "helmet" && helmet?.light_system == STATIC_LIGHT)
		helmet.update_light()

/obj/item/weapon/rig/proc/deploy(mob/M,var/sealed)

	var/mob/living/carbon/human/H = M

	if(!H || !istype(H)) return

	if(H.back != src && H.belt != src)
		return

	if(sealed)
		if(H.head)
			var/obj/item/garbage = H.head
			H.drop_from_inventory(garbage)
			H.head = null
			qdel(garbage)

		if(H.gloves)
			var/obj/item/garbage = H.gloves
			H.drop_from_inventory(garbage)
			H.gloves = null
			qdel(garbage)

		if(H.shoes)
			var/obj/item/garbage = H.shoes
			H.drop_from_inventory(garbage)
			H.shoes = null
			qdel(garbage)

		if(H.wear_suit)
			var/obj/item/garbage = H.wear_suit
			H.drop_from_inventory(garbage)
			H.wear_suit = null
			qdel(garbage)

	for(var/piece in list("helmet","gauntlets","chest","boots"))
		toggle_piece(piece, H, ONLY_DEPLOY)

/obj/item/weapon/rig/dropped(var/mob/user)
	..()
	for(var/piece in list("helmet","gauntlets","chest","boots"))
		toggle_piece(piece, user, ONLY_RETRACT)
	if(wearer && wearer.wearing_rig == src)
		wearer.wearing_rig = null
	wearer = null

//Todo
/obj/item/weapon/rig/proc/malfunction()
	return 0

/obj/item/weapon/rig/emp_act(severity_class)
	//set malfunctioning
	if(emp_protection < 30) //for ninjas, really.
		malfunctioning += 10
		if(malfunction_delay <= 0)
			malfunction_delay = max(malfunction_delay, round(30/severity_class))

	//drain some charge
	if(cell) cell.emp_act(severity_class + 15)

	//possibly damage some modules
	take_hit((100/severity_class), "electrical pulse", 1)

/obj/item/weapon/rig/proc/shock(mob/user)
	if (electrocute_mob(user, cell, src)) //electrocute_mob() handles removing charge from the cell, no need to do that here.
		spark_system.start()
		if(user.stunned)
			return 1
	return 0

/obj/item/weapon/rig/proc/take_hit(damage, source, is_emp=0)

	if(!installed_modules.len)
		return

	var/chance
	if(!is_emp)
		chance = 2*max(0, damage - (chest? chest.breach_threshold : 0))
	else
		//Want this to be roughly independant of the number of modules, meaning that X emp hits will disable Y% of the suit's modules on average.
		//that way people designing hardsuits don't have to worry (as much) about how adding that extra module will affect emp resiliance by 'soaking' hits for other modules
		chance = 2*max(0, damage - emp_protection)*min(installed_modules.len/15, 1)

	if(!prob(chance))
		return

	//deal addition damage to already damaged module first.
	//This way the chances of a module being disabled aren't so remote.
	var/list/valid_modules = list()
	var/list/damaged_modules = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.damage < 2)
			valid_modules |= module
			if(module.damage > 0)
				damaged_modules |= module

	var/obj/item/rig_module/dam_module = null
	if(damaged_modules.len)
		dam_module = pick(damaged_modules)
	else if(valid_modules.len)
		dam_module = pick(valid_modules)

	if(!dam_module) return

	dam_module.damage++

	if(!source)
		source = "hit"

	if(wearer)
		if(dam_module.damage >= 2)
			to_chat(wearer, "<span class='danger'>The [source] has disabled your [dam_module.interface_name]!</span>")
		else
			to_chat(wearer, "<span class='warning'>The [source] has damaged your [dam_module.interface_name]!</span>")
	dam_module.deactivate()

/obj/item/weapon/rig/proc/malfunction_check(var/mob/living/carbon/human/user)
	if(malfunction_delay)
		if(offline)
			to_chat(user, "<span class='danger'>The suit is completely unresponsive.</span>")
		else
			to_chat(user, "<span class='danger'>ERROR: Hardware fault. Rebooting interface...</span>")
		return 1
	return 0

/obj/item/weapon/rig/proc/ai_can_move_suit(var/mob/user, var/check_user_module = 0, var/check_for_ai = 0)

	if(check_for_ai)
		if(!(locate(/obj/item/rig_module/ai_container) in contents))
			return 0
		var/found_ai
		for(var/obj/item/rig_module/ai_container/module in contents)
			if(module.damage >= 2)
				continue
			if(module.integrated_ai && module.integrated_ai.client && !module.integrated_ai.stat)
				found_ai = 1
				break
		if(!found_ai)
			return 0

	if(check_user_module)
		if(!user || !user.loc || !user.loc.loc)
			return 0
		var/obj/item/rig_module/ai_container/module = user.loc.loc
		if(!istype(module) || module.damage >= 2)
			to_chat(user, "<span class='warning'>Your host module is unable to interface with the suit.</span>")
			return 0

	if(offline || !cell || !cell.charge || locked_down)
		if(user)
			to_chat(user, "<span class='warning'>Your host rig is unpowered and unresponsive.</span>")
		return 0
	if(!wearer || (wearer.back != src && wearer.belt != src))
		if(user)
			to_chat(user, "<span class='warning'>Your host rig is not being worn.</span>")
		return 0
	if(!wearer.stat && !control_overridden && !ai_override_enabled)
		if(user)
			to_chat(user, "<span class='warning'>You are locked out of the suit servo controller.</span>")
		return 0
	return 1

/obj/item/weapon/rig/proc/force_rest(var/mob/user)
	if(!ai_can_move_suit(user, check_user_module = 1))
		return
	wearer.lay_down()
	to_chat(user, "<span class='notice'>\The [wearer] is now [wearer.resting ? "resting" : "getting up"].</span>")

/obj/item/weapon/rig/proc/forced_move(var/direction, var/mob/user)

	// Why is all this shit in client/Move()? Who knows?
	if(world.time < wearer_move_delay)
		return

	if(!wearer || !wearer.loc || !ai_can_move_suit(user, check_user_module = 1))
		return

	//This is sota the goto stop mobs from moving var
	if(wearer.transforming || !wearer.canmove)
		return

	if((istype(wearer.loc, /turf/space)) || (wearer.lastarea.has_gravity == 0))
		if(!wearer.Process_Spacemove(0))
			return 0

	if(malfunctioning)
		direction = pick(cardinal)

	// Inside an object, tell it we moved.
	if(isobj(wearer.loc) || ismob(wearer.loc))
		var/atom/O = wearer.loc
		return O.relaymove(wearer, direction)

	if(isturf(wearer.loc))
		if(wearer.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(wearer, 1))
				if(M.pulling == wearer)
					if(!M.restrained() && M.stat == 0 && M.canmove && wearer.Adjacent(M))
						to_chat(user, "<span class='notice'>Your host is restrained! They can't move!</span>")
						return 0
					else
						M.stop_pulling()

	if(wearer.pinned.len)
		to_chat(src, "<span class='notice'>Your host is pinned to a wall by [wearer.pinned[1]]</span>!")
		return 0

	// AIs are a bit slower than regular and ignore move intent.
	wearer_move_delay = world.time + ai_controlled_move_delay

	if(istype(wearer.buckled, /obj/vehicle))
		//manually set move_delay for vehicles so we don't inherit any mob movement penalties
		//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
		wearer_move_delay = world.time
		return wearer.buckled.relaymove(wearer, direction)

	if(istype(wearer.machine, /obj/machinery))
		if(wearer.machine.relaymove(wearer, direction))
			return

	if(wearer.pulledby || wearer.buckled) // Wheelchair driving!
		if(istype(wearer.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(wearer.pulledby, /obj/structure/bed/chair/wheelchair))
			return wearer.pulledby.relaymove(wearer, direction)
		else if(istype(wearer.buckled, /obj/structure/bed/chair/wheelchair))
			if(ishuman(wearer.buckled))
				var/obj/item/organ/external/l_hand = wearer.get_organ("l_hand")
				var/obj/item/organ/external/r_hand = wearer.get_organ("r_hand")
				if((!l_hand || (l_hand.status & ORGAN_DESTROYED)) && (!r_hand || (r_hand.status & ORGAN_DESTROYED)))
					return // No hands to drive your chair? Tough luck!
			wearer_move_delay += 2
			return wearer.buckled.relaymove(wearer,direction)

	cell.use(200) //Arbitrary, TODO
	wearer.Move(get_step(get_turf(wearer),direction),direction)

// This returns the rig if you are contained inside one, but not if you are wearing it
/atom/proc/get_rig()
	if(loc)
		return loc.get_rig()
	return null

/obj/item/weapon/rig/get_rig()
	return src

/mob/living/carbon/human/get_rig()
	if(istype(back, /obj/item/weapon/rig))
		return back
	else if(istype(belt, /obj/item/weapon/rig))
		return belt
	else
		return null

//Boot animation screen objects
/obj/screen/rig_booting
	screen_loc = "1,1"
	icon = 'icons/obj/rig_boot.dmi'
	icon_state = ""
	layer = SCREEN_LAYER
	plane = PLANE_FULLSCREEN
	mouse_opacity = 0
	alpha = 20 //Animated up when loading

#undef ONLY_DEPLOY
#undef ONLY_RETRACT
#undef SEAL_DELAY
