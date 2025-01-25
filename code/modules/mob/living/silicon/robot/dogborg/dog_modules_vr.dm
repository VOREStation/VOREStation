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

/obj/item/reagent_containers/glass/beaker/large/borg/Initialize()
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
