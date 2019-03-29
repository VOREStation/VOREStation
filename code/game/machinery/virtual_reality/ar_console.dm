/*
 * This file contains the alien mind-transfer pod, or 'Alien Reality' pod.
 */


/obj/machinery/vr_sleeper/alien
	name = "strange pod"
	desc = "A strange machine with what appears to be a comfortable, if quite vertical, bed. Numerous mechanical cylinders dot the ceiling, their purpose uncertain."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "alienpod_0"
	base_state = "alienpod_"

	eject_dead = FALSE

	var/produce_species = SPECIES_REPLICANT	// The default species produced. Will be overridden if randomize_species is true.
	var/randomize_species = FALSE
	var/list/possible_species	// Do we make the newly produced body a random species?

/obj/machinery/vr_sleeper/alien/Initialize()
	. = ..()
	if(possible_species && possible_species.len)
		produce_species = pick(possible_species)

/obj/machinery/vr_sleeper/alien/process()
	if(stat & (BROKEN))
		if(occupant)
			go_out()
			visible_message("<span class='notice'>\The [src] emits a low droning sound, before the pod door clicks open.</span>")
		return
	else if(eject_dead && occupant && occupant.stat == DEAD)
		visible_message("<span class='warning'>\The [src] sounds an alarm, swinging its hatch open.</span>")
		go_out()

/obj/machinery/vr_sleeper/alien/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)

	if(occupant && (istype(I, /obj/item/device/healthanalyzer) || istype(I, /obj/item/device/robotanalyzer)))
		I.attack(occupant, user)
	return

/obj/machinery/vr_sleeper/alien/eject()
	set src in view(1)
	set category = "Object"

	if(usr.incapacitated())
		return

	var/forced = FALSE

	if(stat & (BROKEN) || (eject_dead && occupant && occupant.stat == DEAD))
		forced = TRUE

	go_out(forced)
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/alien/go_out(var/forced = TRUE)
	if(!occupant)
		return

	if(!forced && avatar && avatar.stat != DEAD && alert(avatar, "Someone wants to remove you from virtual reality. Do you want to leave?", "Leave VR?", "Yes", "No") == "No")
		return

	avatar.exit_vr()

	if(occupant && occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = src.loc
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(1)
	update_icon()

/obj/machinery/vr_sleeper/alien/enter_vr()

	if(!occupant)
		return

	if(!occupant.mind)
		return

	if(occupant.stat == DEAD && !occupant.client)
		return

	if(avatar && !occupant.stat)
		to_chat(occupant,"<span class='alien'>\The [src] begins to [pick("whir","hum","pulse")] as a screen appears in front of you.</span>")
		if(alert(occupant, "This pod is already linked. Are you certain you wish to engage?", "Commmit?", "Yes", "No") == "No")
			visible_message("<span class='alien'>\The [src] pulses!</span>")

	to_chat(occupant,"<span class='alien'>Your mind blurs as information bombards you.</span>")

	if(!avatar)
		var/turf/T = get_turf(src)
		avatar = new(src, produce_species)
		if(occupant.species.name != "Promethean" && occupant.species.name != "Human" && mirror_first_occupant)
			avatar.shapeshifter_change_shape(occupant.species.name)
		avatar.Sleeping(6)

		occupant.enter_vr(avatar)

		var/newname = sanitize(input(avatar, "Your mind feels foggy. You're certain your name is [occupant.real_name], but it could also be [avatar.name]. Would you like to change it to something else?", "Name change") as null|text, MAX_NAME_LEN)
		if (newname)
			avatar.real_name = newname

		avatar.forceMove(T)
		visible_message("<span class='alium'>\The [src] [pick("gurgles", "churns", "sloshes")] before spitting out \the [avatar]!</span>")

	else

		// There's only one body per one of these pods, so let's be kind.
		var/newname = sanitize(input(avatar, "Your mind feels foggy. You're certain your name is [occupant.real_name], but it feels like it is [avatar.name]. Would you like to change it to something else?", "Name change") as null|text, MAX_NAME_LEN)
		if(newname)
			avatar.real_name = newname

		occupant.enter_vr(avatar)


/*
 * Subtypes
 */

/obj/machinery/vr_sleeper/alien/random_replicant
	possible_species = list(SPECIES_REPLICANT, SPECIES_REPLICANT_ALPHA, SPECIES_REPLICANT_BETA)

/obj/machinery/vr_sleeper/alien/alpha_replicant
	produce_species = SPECIES_REPLICANT_ALPHA

/obj/machinery/vr_sleeper/alien/beta_replicant
	produce_species = SPECIES_REPLICANT_BETA
