//Boop //New and improved, now a simple reagent sniffer.
/obj/item/boop_module
	name = "boop module"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "nose"
	desc = "The BOOP module, a simple reagent and atmosphere scanner."
	force = 0
	throwforce = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = ITEMSIZE_TINY

/obj/item/boop_module/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/boop_module/attack_self(mob/user)
	if (!( istype(user.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = user.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(span_notice("[user] scans the air."), span_notice("You scan the air..."))

	to_chat(user, span_boldnotice("Scan results:"))
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(user, span_notice("Pressure: [round(pressure,0.1)] kPa"))
	else
		to_chat(user, span_warning("Pressure: [round(pressure,0.1)] kPa"))
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(user, span_notice("[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%"))
		to_chat(user, span_notice("Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)"))

/obj/item/boop_module/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.stat)
		return
	if(!istype(O))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(span_notice("[user] scan at \the [O.name]."), span_notice("You scan \the [O.name]..."))

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t " + span_notice("[R]")

		if(dat)
			to_chat(user, span_notice("Your BOOP module indicates: [dat]"))
		else
			to_chat(user, span_notice("No active chemical agents detected in [O]."))
	else
		to_chat(user, span_notice("No significant chemical agents detected in [O]."))

	return


//Delivery
/*
/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "dbag"
	w_class = ITEMSIZE_HUGE
	max_w_class = ITEMSIZE_SMALL
	max_combined_w_class = ITEMSIZE_SMALL
	storage_slots = 1
	collection_mode = 0
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear)
*/

/obj/item/shockpaddles/robot/hound
	name = "paws of life"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "defibpaddles0"
	desc = "Zappy paws. For fixing cardiac arrest."
	combat = 1
	attack_verb = list("batted", "pawed", "bopped", "whapped")
	chargecost = 500

/obj/item/shockpaddles/robot/hound/jumper
	name = "jumper paws"
	desc = "Zappy paws. For rebooting a full body prostetic."
	use_on_synthetic = 1

/obj/item/reagent_containers/borghypo/hound
	name = "MediHound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves, designed for heavy-duty medical equipment."
	charge_cost = 10
	reagent_ids = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_DEXALIN, REAGENT_ID_BICARIDINE, REAGENT_ID_KELOTANE, REAGENT_ID_ANTITOXIN, REAGENT_ID_SPACEACILLIN, REAGENT_ID_PARACETAMOL)
	var/datum/matter_synth/water = null

/obj/item/reagent_containers/borghypo/hound/process() //Recharges in smaller steps and uses the water reserves as well.
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume && water.energy >= charge_cost)
					R.cell.use(charge_cost)
					water.use_charge(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 1, volume)
	return 1

/obj/item/reagent_containers/borghypo/hound/lost
	name = "Hound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves."
	reagent_ids = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_INAPROVALINE, REAGENT_ID_BICARIDINE, REAGENT_ID_DEXALIN, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_SPACEACILLIN)

/obj/item/reagent_containers/borghypo/hound/trauma
	name = "Hound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves."
	reagent_ids = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_INAPROVALINE, REAGENT_ID_OXYCODONE, REAGENT_ID_DEXALIN ,REAGENT_ID_SPACEACILLIN)


//Tongue stuff
/obj/item/robot_tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionately licking the crew members in the face."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	var/emagged = 0
	var/busy = 0 	//prevents abuse and runtimes

/obj/item/robot_tongue/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/robot_tongue/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "syndietongue"
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionately licking the crew members in the face."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "synthtongue"
		update_icon()

/obj/item/robot_tongue/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(busy)
		to_chat(user, span_warning("You are already licking something else."))
		return
	if(user.client && (target in user.client.screen))
		to_chat(user, span_warning("You need to take \the [target.name] off before cleaning it!"))
		return
	else if(istype(target,/obj/item))
		if(istype(target,/obj/item/trash))
			user.visible_message(span_filter_notice("[user] nibbles away at \the [target.name]."), span_notice("You begin to nibble away at \the [target.name]..."))
			busy = 1
			if(do_after (user, 50))
				user.visible_message(span_filter_notice("[user] finishes eating \the [target.name]."), span_notice("You finish eating \the [target.name]."))
				to_chat(user, span_notice("You finish off \the [target.name]."))
				qdel(target)
				var/mob/living/silicon/robot/R = user
				R.cell.charge += 250
			busy = 0
			return
		if(istype(target,/obj/item/cell))
			user.visible_message(span_filter_notice("[user] begins cramming \the [target.name] down its throat."), span_notice("You begin cramming \the [target.name] down your throat..."))
			busy = 1
			if(do_after (user, 50))
				user.visible_message(span_filter_notice("[user] finishes gulping down \the [target.name]."), span_notice("You finish swallowing \the [target.name]."))
				to_chat(user, span_notice("You finish off \the [target.name], and gain some charge!"))
				var/mob/living/silicon/robot/R = user
				var/obj/item/cell/C = target
				R.cell.charge += C.charge / 3
				qdel(target)
			busy = 0
			return
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot/R = user
			var/mob/living/L = target
			if(!R.use_direct_power(666, 100))
				to_chat(user, span_warning("Warning, low power detected. Aborting action."))
				return
			L.Stun(1)
			L.Weaken(1)
			L.apply_effect(STUTTER, 1)
			L.visible_message(span_danger("[user] has shocked [L] with its tongue!"), \
								span_userdanger("[user] has shocked you with its tongue! You can feel the betrayal."))
			playsound(src, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		else
			user.visible_message(span_notice("\The [user] affectionately licks all over \the [target]'s face!"), span_notice("You affectionately lick all over \the [target]'s face!"))
			playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
			var/mob/living/carbon/human/H = target
			if(H.species.lightweight == 1)
				H.Weaken(3)
	return

/obj/item/pupscrubber
	name = "floor scrubber"
	desc = "Toggles floor scrubbing."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "scrub0"
	var/enabled = FALSE

/obj/item/pupscrubber/New()
	..()
	flags |= NOBLUDGEON

/obj/item/pupscrubber/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(!enabled)
		R.scrubbing = TRUE
		enabled = TRUE
		icon_state = "scrub1"
	else
		R.scrubbing = FALSE
		enabled = FALSE
		icon_state = "scrub0"

/obj/item/gun/energy/taser/mounted/cyborg/ertgun //Not a taser, but it's being used as a base so it takes energy and actually works.
	name = "disabler"
	desc = "A small and nonlethal gun produced by NT.."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "ertgunstun"
	fire_sound = 'sound/weapons/eLuger.ogg'
	projectile_type = /obj/item/projectile/beam/disable
	charge_cost = 240 //Normal cost of a taser. It used to be 1000, but after some testing it was found that it would sap a borg's battery to quick
	recharge_time = 10 //Takes ten ticks to recharge a shot, so don't waste them all!
	//cell_type = null //Same cell as a taser until edits are made.

/obj/item/lightreplacer/dogborg
	name = "light replacer"
	desc = "A device to automatically replace lights. This version is capable to produce a few replacements using your internal matter reserves."
	max_uses = 16
	uses = 10
	var/cooldown = 0
	var/datum/matter_synth/glass = null

/obj/item/lightreplacer/dogborg/attack_self(mob/user)//Recharger refill is so last season. Now we recycle without magic!

	var/choice = tgui_alert(user, "Do you wish to check the reserves or change the color?", "Selection List", list("Reserves", "Color"))
	if(!choice)
		return
	if(choice == "Color")
		var/new_color = tgui_color_picker(user, "Choose a color to set the light to! (Default is [LIGHT_COLOR_INCANDESCENT_TUBE])", "", selected_color)
		if(new_color)
			selected_color = new_color
			to_chat(user, span_filter_notice("The light color has been changed."))
		return
	else
		if(uses >= max_uses)
			to_chat(user, span_warning("[src.name] is full."))
			return
		if(uses < max_uses && cooldown == 0)
			if(glass.energy < 125)
				to_chat(user, span_warning("Insufficient material reserves."))
				return
			to_chat(user, span_filter_notice("It has [uses] lights remaining. Attempting to fabricate a replacement. Please stand still."))
			cooldown = 1
			if(do_after(user, 50))
				glass.use_charge(125)
				add_uses(1)
				cooldown = 0
			else
				cooldown = 0
		else
			to_chat(user, span_filter_notice("It has [uses] lights remaining."))
			return

/obj/item/dogborg/stasis_clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	var/max_clamps = 3
	var/busy
	var/list/clamps = list()

/obj/item/dogborg/stasis_clamp/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/atmospherics/pipe/simple))
		if(busy)
			return
		var/C = locate(/obj/machinery/clamp) in get_turf(A)
		if(!C)
			if(length(clamps) >= max_clamps)
				to_chat(user, span_warning("You've already placed the maximum amount of [max_clamps] [src]s. Find and remove some before placing new ones."))
				return
			busy = TRUE
			to_chat(user, span_notice("You begin to attach \the [C] to \the [A]..."))
			if(do_after(user, 30))
				to_chat(user, span_notice("You have attached \the [src] to \the [A]."))
				var/obj/machinery/clamp/clamp = new/obj/machinery/clamp(A.loc, A)
				clamps.Add(clamp)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.use_direct_power(1000, 1500)
		else
			busy = TRUE
			to_chat(user, span_notice("You begin to remove \the [C] from \the [A]..."))
			if(do_after(user, 30))
				to_chat(user, span_notice("You have removed \the [src] from \the [A]."))
				clamps.Remove(C)
				qdel(C)
		busy = FALSE

/obj/item/dogborg/stasis_clamp/Destroy()
	clamps.Cut()
	. = ..()

//Pounce stuff for K-9
/obj/item/dogborg/pounce
	name = "pounce"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	force = 0
	throwforce = 0
	var/bluespace = FALSE

/obj/item/dogborg/pounce/New()
	..()
	flags |= NOBLUDGEON

/obj/item/dogborg/pounce/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	R.leap(bluespace)

/mob/living/silicon/robot/proc/leap(var/bluespace = FALSE)
	if(last_special > world.time)
		to_chat(src, span_filter_notice("Your leap actuators are still recharging."))
		return

	var/power_cost = bluespace ? 1000 : 750
	var/minimum_power = bluespace ? 2500 : 1000
	if(cell.charge < minimum_power)
		to_chat(src, span_filter_notice("Cell charge too low to continue."))
		return

	if(src.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, span_filter_notice("You cannot leap in your current state."))
		return

	var/list/choices = list()
	var/leap_distance = bluespace ? 5 : 3
	for(var/mob/living/M in view(leap_distance,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"Who do you wish to leap at?","Target Choice", choices)

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > leap_distance) return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.get_species() == SPECIES_SHADEKIN && (H.ability_flags & AB_PHASE_SHIFTED))
			power_cost *= 2

	if(!use_direct_power(power_cost, minimum_power - power_cost))
		to_chat(src, span_warning("Warning, low power detected. Aborting action."))
		return

	if(last_special > world.time)
		return

	if(src.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, span_filter_notice("You cannot leap in your current state."))
		return

	last_special = world.time + 10
	status_flags |= LEAPING
	pixel_y = pixel_y + 10

	src.visible_message(span_danger("\The [src] leaps at [T]!"))
	if(bluespace)
		src.forceMove(get_turf(T))
		T.hitby(src)
	else
		src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src, 'sound/mecha/mechstep2.ogg', 50, 1)
	pixel_y = default_pixel_y

	if(!bluespace)
		sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, span_warning("You miss!"))
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.Weaken(3)
			return

	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, HALLOSS,, armor_block, armor_soak)
	if(prob(75)) //75% chance to stun for 5 seconds, really only going to be 4 bcus click cooldown+animation.
		T.apply_effect(5, WEAKEN, armor_block)

/obj/item/reagent_containers/glass/beaker/large/borg
	var/mob/living/silicon/robot/R
	var/last_robot_loc

/obj/item/reagent_containers/glass/beaker/large/borg/Initialize(mapload)
	. = ..()
	R = loc.loc
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(check_loc))

/obj/item/reagent_containers/glass/beaker/large/borg/proc/check_loc(atom/movable/mover, atom/old_loc, atom/new_loc)
	if(old_loc == R || old_loc == R.module)
		last_robot_loc = old_loc
	if(!istype(loc, /obj/machinery) && loc != R && loc != R.module)
		if(last_robot_loc)
			forceMove(last_robot_loc)
			last_robot_loc = null
		else
			forceMove(R)
		if(loc == R)
			hud_layerise()

/obj/item/reagent_containers/glass/beaker/large/borg/Destroy()
	UnregisterSignal(src, COMSIG_OBSERVER_MOVED)
	R = null
	last_robot_loc = null
	..()

/obj/item/mining_scanner/robot
	name = "integrated deep scan device"
	description_info = "This scanner can be upgraded for mining points."
	var/upgrade_cost = 2500

/obj/item/mining_scanner/robot/attackby(obj/item/O, mob/user)
	if(exact)
		return
	if(!istype(O, /obj/item/card/id/cargo/miner/borg))
		return
	if(!(user == loc || user == loc.loc))
		return
	var/obj/item/card/id/cargo/miner/borg/id = O
	if(!id.adjust_mining_points(-upgrade_cost))
		return
	upgrade(user)

/obj/item/mining_scanner/robot/proc/upgrade(mob/user)
	desc = "An advanced device used to locate ore deep underground."
	description_info = "This scanner has variable range, you can use the Set Scanner Range verb, or alt+click the device. Drills dig in 5x5."
	scan_time = 0.5 SECONDS
	exact = TRUE
	to_chat(user, span_notice("You've upgraded the mining scanner for [upgrade_cost] points."))

/obj/item/mining_scanner/robot/AltClick(mob/user)
	change_size(user)

/obj/item/mining_scanner/robot/proc/change_size(mob/user)
	if(!exact)
		return
	var/custom_range = tgui_input_list(user, "Scanner Range","Pick a range to scan. ", list(0,1,2,3,4,5,6,7))
	if(custom_range)
		range = custom_range
		to_chat(user, span_notice("Scanner will now look up to [range] tile(s) away."))

/*
/obj/item/robot_tongue/examine(user)
	. = ..()
	if(Adjacent(user))
		if(water.energy)
			. += span_notice("[src] is wet. Just like it should be.")
		if(water.energy < 5)
			. += span_notice("[src] is dry.")
*/

/obj/item/shield_projector/line/exploborg
	name = "expirmental shield projector"
	description_info = "This creates a shield in a straight line perpendicular to the direction where the user was facing when it was activated. \
	The shield allows projectiles to leave from inside but blocks projectiles from outside.  Everything else can pass through the shield freely, \
	including other people and thrown objects.  The shield also cannot block certain effects which take place over an area, such as flashbangs or explosions."
	shield_health = 90
	max_shield_health = 90
	shield_regen_amount = 25
	line_length = 7			// How long the line is.  Recommended to be an odd number.
	offset_from_center = 2	// How far from the projector will the line's center be.

// To repair a single module
/obj/item/self_repair_system
	name = "plating repair system"
	desc = "A nanite control system to repair damaged armour plating and wiring while not moving. Destroyed armour can't be restored."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "armor"
	var/repair_time = 25
	var/repair_amount = 2.5
	var/power_tick = 25
	var/disabled_icon = "armor"
	var/active_icon = "armor_broken"
	var/list/target_components = list("armour")
	var/repairing = FALSE

/obj/item/self_repair_system/New()
	..()
	flags |= NOBLUDGEON

/obj/item/self_repair_system/attack_self(mob/user)
	if(repairing)
		return
	var/mob/living/silicon/robot/R = user
	var/destroyed_components = FALSE
	var/list/repairable_components = list()
	for(var/target_component in target_components)
		var/datum/robot_component/C = R.components[target_component]
		if(!C)
			continue
		if(istype(C.wrapped, /obj/item/broken_device))
			destroyed_components = TRUE
		else if (C.brute_damage != 0 || C.electronics_damage != 0)
			repairable_components += C
	if(!repairable_components.len && destroyed_components)
		to_chat(R, span_warning("Repair system initialization failed. Can't repair destroyed [target_components.len == 1 ? "[R.components[target_components[1]]]'s" : "component's"] plating or wiring."))
		return
	if(!repairable_components.len)
		to_chat(R, span_warning("No brute or burn damage detected [target_components.len == 1 ? "in [R.components[target_components[1]]]" : ""]."))
		return
	if(destroyed_components)
		to_chat(R, span_warning("WARNING! Destroyed modules detected. Those can not be repaired!"))
	icon_state = active_icon
	update_icon()
	repairing = TRUE
	for(var/datum/robot_component/C in repairable_components)
		to_chat(R, span_notice("Repair system initializated. Repairing plating and wiring of [C]."))
		src.self_repair(R, C, repair_time, repair_amount)
	repairing = FALSE
	icon_state = disabled_icon
	update_icon()

/obj/item/self_repair_system/proc/self_repair(mob/living/silicon/robot/R, datum/robot_component/C, var/tick_delay, var/heal_per_tick)
	if(!C || !R.cell)
		return
	if(C.brute_damage == 0 && C.electronics_damage == 0)
		to_chat(R, span_notice("Repair of [C] completed."))
		return
	if(!R.use_direct_power(power_tick,  500)) //We don't want to drain ourselves too far down during exploration
		to_chat(R, span_warning("Not enough power to initialize the repair system."))
		return
	if(do_after(R, tick_delay))
		if(!C)
			return
		C.brute_damage -= min(C.brute_damage, heal_per_tick)
		C.electronics_damage -= min(C.electronics_damage, heal_per_tick)
		R.updatehealth()
		src.self_repair(R, C, tick_delay, heal_per_tick)

// To repair multiple modules
/obj/item/self_repair_system/advanced
	name = "self repair system"
	desc = "A nanite control system to repair damaged components while not moving. Destroyed components can't be restored."
	target_components = list("actuator", "radio", "power cell", "diagnosis unit", "camera", "comms", "armour")
	power_tick = 10
	repair_time = 15
	repair_amount = 3

// Robot Weapons
/obj/item/gun/energy/robotic/flare
	name = "flare gun"
	desc = "A flare-gun"
	projectile_type = /obj/item/projectile/energy/flash/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	icon = 'icons/obj/gun.dmi'
	icon_state = "taser"
	charge_cost = 480
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_TASER

/obj/item/gun/energy/robotic/smallmedigun
	name = "borg directed restoration system"
	desc = "An adapted version of the BL-3 'Phoenix, for expiremental useage in borgs."
	projectile_type = /obj/item/projectile/beam/medical_cell/borg
	accept_cell_type = /obj/item/cell/device
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 600
	fire_delay = 6
	force = 5
	icon_state = "medbeam"
	icon = 'icons/obj/gun_vr.dmi'
	accuracy = 100
	fire_sound = 'sound/weapons/eluger.ogg'
	self_recharge = 1
	use_external_power = 1

/obj/item/projectile/beam/medical_cell/borg
	range = 4

/obj/item/projectile/beam/medical_cell/borg/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		if(target.stat != DEAD)
			target.adjustBruteLoss(-3.75)
			target.adjustFireLoss(-3.75)
	else
		return 1

/obj/item/melee/robotic/blade/explotailspear
	name = "energy tail"
	desc = "A glowing tail spear with a moderate range. It appears to be extremely sharp."
	force = 45
	armor_penetration = 25 //30 to try and make it not useless against armored mobs but not fully nullify it.
	reach = 3
	projectile_parry_chance = 15.

/obj/item/melee/robotic/jaws/big/explojaws
	name = "explo jaws"
	desc = "Highly lethal jaws for close range combat."
	force = 60
	armor_penetration = 25 //To try and make it not useless against armored mobs but not fully nullify it
	projectile_parry_chance = 15

/obj/item/gun/energy/robotic/phasegun
	name = "EW26 Artemis Mounted"
	desc = "The RayZar EW26 Artemis, also known as the 'phase carbine', is a downsized energy-based weapon specifically designed for use against wildlife. This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = "RayZar is Ward-Takahashi’s main consumer weapons brand, known for producing and licensing a wide variety of specialist energy weapons of various types and quality primarily for the civilian market."
	icon = 'icons/obj/gun.dmi'
	icon_state = "phasecarbine"
	charge_cost = 160
	recharge_time = 16
	projectile_type = /obj/item/projectile/energy/phase
	use_external_power = 1
	self_recharge = 1
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_LASER
