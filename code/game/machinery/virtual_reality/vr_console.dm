/obj/machinery/vr_sleeper
	name = "virtual reality sleeper"
	desc = "A fancy bed with built-in sensory I/O ports and connectors to interface users' minds with their bodies in virtual reality."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"

	var/base_state = "body_scanner_"

	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/vr_sleeper
	var/mob/living/carbon/human/occupant = null
	var/mob/living/carbon/human/avatar = null
	var/datum/mind/vr_mind = null
	var/datum/effect/effect/system/smoke_spread/bad/smoke

	var/eject_dead = TRUE

	var/mirror_first_occupant = TRUE	// Do we force the newly produced body to look like the occupant?

	var/spawn_with_clothing = TRUE		// Do we spawn the avatar with clothing?

	/// If we have a perfect replica of the mob's species that is entering us!
	/// Because of our player population, I have defaulted this to TRUE.
	/// If you are a downstream and want to have people spawn as VR prometheans by default, change this to FALSE
	var/perfect_replica = TRUE

	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 200
	light_color = "#FF0000"
	//var/global/list/vr_mob_tf_options // Global var located in global_lists.dm

/obj/machinery/vr_sleeper/perfect
	perfect_replica = TRUE

/obj/machinery/vr_sleeper/Initialize(mapload)
	. = ..()
	default_apply_parts()
	smoke = new
	update_icon()

/obj/machinery/vr_sleeper/Destroy()
	if(occupant && occupant.vr_link)
		occupant.vr_link.exit_vr()
	//The below deals with the edge case of there being no occupant but there IS things inside, somehow.
	//Just in case some weirdness happened.
	for(var/atom/movable/A in src)
		if(A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	. = ..()

/obj/machinery/vr_sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		if(occupant)
			occupant.exit_vr(FALSE)
			visible_message(span_infoplain(span_bold("\The [src]") + " emits a low droning sound, before the pod door clicks open."))
		return
	else if(eject_dead && occupant && occupant.stat == DEAD) // If someone dies somehow while inside, spit them out.
		visible_message(span_warning("\The [src] sounds an alarm, swinging its hatch open."))
		occupant.exit_vr(FALSE)

/obj/machinery/vr_sleeper/update_icon()
	icon_state = "[base_state][occupant ? "1" : "0"]"

/obj/machinery/vr_sleeper/examine(mob/user)
	. = ..()
	if(occupant)
		. += span_notice("[occupant] is inside.")

/obj/machinery/vr_sleeper/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		to_chat(usr, span_warning("You can't reach the controls from the inside."))
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()

	return 1

/obj/machinery/vr_sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)

	if(occupant && (istype(I, /obj/item/healthanalyzer) || istype(I, /obj/item/robotanalyzer)))
		I.attack(occupant, user)
		return

	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		if(occupant && avatar)
			avatar.exit_vr()
			avatar = null
			perform_exit()
		return


/obj/machinery/vr_sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !isliving(target))
		return
	go_in(target, user)



/obj/machinery/vr_sleeper/relaymove(var/mob/user)
	..()
	if(user.incapacitated())
		return
	go_out()



/obj/machinery/vr_sleeper/emp_act(var/severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		// This will eject the user from VR
		// ### Fry the brain? Yes. Maybe.
		if(prob(15 / ( severity / 4 )) && occupant.species.has_organ[O_BRAIN] && occupant.internal_organs_by_name[O_BRAIN])
			var/obj/item/organ/O = occupant.internal_organs_by_name[O_BRAIN]
			O.take_damage(severity * 2)
			visible_message(span_danger("\The [src]'s internal lighting flashes rapidly, before the hatch swings open with a cloud of smoke."))
			smoke.set_up(severity, 0, src)
			smoke.start("#202020")
		perform_exit()

	..(severity)

/obj/machinery/vr_sleeper/verb/eject()
	set src in view(1)
	set category = "Object"
	set name = "Eject VR Capsule"

	if(usr.incapacitated())
		return

	if(stat & (BROKEN|NOPOWER) || occupant && occupant.stat == DEAD)
		perform_exit()
	else
		go_out()
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/verb/climb_in()
	set src in oview(1)
	set category = "Object"
	set name = "Enter VR Capsule"

	if(usr.incapacitated())
		return
	go_in(usr, usr)
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/relaymove(mob/user as mob)
	if(user.incapacitated())
		return 0 //maybe they should be able to get out with cuffs, but whatever
	perform_exit()

/obj/machinery/vr_sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(!ishuman(M))
		to_chat(user, span_warning("\The [src] rejects [M] with a sharp beep."))
		return
	if(occupant)
		to_chat(user, span_warning("\The [src] is already occupied."))
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			to_chat(user, span_warning("\The [src] is already occupied."))
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		occupant = M

		update_icon()

		if(!M.has_brain_worms())
			update_use_power(USE_POWER_ACTIVE)
			enter_vr()
		else
			to_chat(user, span_warning("\The [src] rejects [M] with a sharp beep."))
	return

/obj/machinery/vr_sleeper/proc/go_out()
	if(!occupant)
		return

	if(avatar)
		if(tgui_alert(avatar, "Someone wants to remove you from virtual reality. Do you want to leave?", "Leave VR?", list("Yes", "No")) != "Yes")
			return

	perform_exit()

//The actual bulk of the exit code.
/obj/machinery/vr_sleeper/proc/perform_exit()
	if(!occupant)
		return

	avatar = null

	if(occupant.vr_link)
		occupant.vr_link.exit_vr(FALSE)

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_turf(src))
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(USE_POWER_IDLE)
	update_icon()

/obj/machinery/vr_sleeper/proc/enter_vr()

	// No mob to transfer a mind from
	if(!occupant)
		return

	// No mind to transfer
	if(!occupant.mind)
		return

	// Mob doesn't have an active consciousness to send/receive from
	if(occupant.stat == DEAD)
		return

	if(QDELETED(occupant.vr_link)) //Hardrefs...
		occupant.vr_link = null

	avatar = occupant.vr_link
	// If they've already enterred VR, and are reconnecting, prompt if they want a new body
	if(avatar && tgui_alert(occupant, "You already have a [avatar.stat == DEAD ? "" : "deceased "]Virtual Reality avatar. Would you like to use it?", "New avatar", list("Yes", "No")) != "Yes")
		// Delink the mob
		if(!occupant) //We can walk out of this before we give a prompt...A TGUI state won't help here sadly.
			return
		occupant.vr_link = null
		avatar = null

	if(!avatar)
		// Get the desired spawn location to put the body
		var/S = null
		var/list/vr_landmarks = list()
		for(var/obj/effect/landmark/virtual_reality/sloc in landmarks_list)
			vr_landmarks += sloc.name

		S = tgui_input_list(occupant, "Please select a location to spawn your avatar at:", "Spawn location", vr_landmarks)
		if(!S)
			return 0

		var/tf = null
		if(tgui_alert(occupant, "Would you like to play as a different creature?", "Join as a mob?", list("Yes", "No")) == "Yes")
			var/k = tgui_input_list(occupant, "Please select a creature:", "Mob list", vr_mob_tf_options)
			if(!k || !occupant) //Our occupant can walk out.
				return 0
			tf = vr_mob_tf_options[k]

		for(var/obj/effect/landmark/virtual_reality/i in landmarks_list)
			if(i.name == S)
				S = i
				break

		if(!perfect_replica)
			avatar = new(S, "Virtual Reality Avatar")
		else
			avatar = new(src, occupant.species.name)

		// If the user has a non-default (Human) bodyshape, make it match theirs.
		if(occupant.species.name != "Promethean" && occupant.species.name != "Human" && mirror_first_occupant)
			avatar.shapeshifter_change_shape(occupant.species.name)
		avatar.forceMove(get_turf(S))			// Put the mob on the landmark, instead of inside it

		occupant.enter_vr(avatar)
		if(spawn_with_clothing)
			job_master.EquipRank(avatar,"Visitor", 1, FALSE)
		add_verb(avatar,/mob/living/carbon/human/proc/perform_exit_vr)
		add_verb(avatar,/mob/living/carbon/human/proc/vr_transform_into_mob)
		add_verb(avatar,/mob/living/proc/set_size)
		avatar.virtual_reality_mob = TRUE

		//This handles all the 'We make it look like ourself' code.
		//We do this BEFORE any mob tf so prefs  carry over properly!
		if(perfect_replica)
			avatar.species.create_organs(avatar) // Reset our organs/limbs.
			avatar.restore_all_organs()
			avatar.client.prefs.copy_to(avatar)
			avatar.dna.ResetUIFrom(avatar)
			avatar.sync_dna_traits(TRUE) // Traitgenes Sync traits to genetics if needed
			avatar.sync_organ_dna()
			avatar.initialize_vessel()

		if(tf)
			var/mob/living/new_form = avatar.transform_into_mob(tf, TRUE) // No need to check prefs when the occupant already chose to transform.
			if(isliving(new_form)) // Make sure the mob spawned properly.
				add_verb(new_form,/mob/living/proc/vr_revert_mob_tf)
				new_form.virtual_reality_mob = TRUE

		add_verb(avatar, /mob/living/carbon/human/proc/perform_exit_vr) //ahealing removes the prommie verbs and the VR verbs, giving it back
		avatar.Sleeping(1)

		// Prompt for username after they've enterred the body.
		var/newname = sanitize(tgui_input_text(avatar, "You are entering virtual reality. Your username is currently [src.name]. Would you like to change it to something else?", "Name change", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if(newname)
			avatar.real_name = newname
			avatar.name = newname

	else
		// If TFed, revert TF. Easier than coding mind transfer stuff for edge cases.
		if(avatar.tfed_into_mob_check())
			var/mob/living/M = loc
			if(istype(M)) // Sanity check, though shouldn't be needed since this is already checked by the proc.
				M.revert_mob_tf()
		occupant.enter_vr(avatar)
