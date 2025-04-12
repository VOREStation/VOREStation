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
	perfect_replica = TRUE //All alien VR sleepers make perfect replicas.
	spawn_with_clothing = FALSE //alien VR sleepers do not spawn with clothing.

/obj/machinery/vr_sleeper/alien/Initialize(mapload)
	. = ..()
	if(possible_species && possible_species.len)
		produce_species = pick(possible_species)

/obj/machinery/vr_sleeper/alien/process()
	if(stat & (BROKEN))
		if(occupant)
			perform_exit()
			visible_message(span_infoplain(span_bold("\The [src]") + " emits a low droning sound, before the pod door clicks open."))
		return
	else if(eject_dead && occupant && occupant.stat == DEAD)
		visible_message(span_warning("\The [src] sounds an alarm, swinging its hatch open."))
		perform_exit()

/obj/machinery/vr_sleeper/alien/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)

	if(occupant && (istype(I, /obj/item/healthanalyzer) || istype(I, /obj/item/robotanalyzer)))
		I.attack(occupant, user)
	return

/obj/machinery/vr_sleeper/alien/eject()
	set src in view(1)
	set category = "Object"

	if(usr.incapacitated())
		return

	if(stat & (BROKEN) || (eject_dead && occupant && occupant.stat == DEAD))
		perform_exit()
	else
		go_out()
	add_fingerprint(usr)

/obj/machinery/vr_sleeper/alien/go_out()
	if(!occupant)
		return

	if(avatar)
		if(tgui_alert(avatar, "Someone wants to remove you from virtual reality. Do you want to leave?", "Leave VR?", list("Yes", "No")) != "Yes")
			return


	avatar.exit_vr() //We don't poof! We're a actual, living entity that isn't restrained by VR zones!
	if(!occupant) //This whole thing needs cleaned up later, but this works for now.
		return
	if(occupant && occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_turf(src))
	occupant.vr_link = null //The machine remembers the avatar. 1 avatar per machine. So the vr_link isn't needed anymore.
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(USE_POWER_IDLE)
	update_icon()

/obj/machinery/vr_sleeper/alien/enter_vr()

	// No mob to transfer a mind from
	if(!occupant)
		return

	// No mind to transfer
	if(!occupant.mind)
		return

	// Mob doesn't have an active consciousness to send/receive from
	if(occupant.stat == DEAD && !occupant.client)
		return

	if(QDELETED(avatar)) //This REALLY needs to be changed to weakrefs
		avatar = null

	if(avatar && !occupant.stat)
		to_chat(occupant,span_alien("\The [src] begins to [pick("whir","hum","pulse")] as a screen appears in front of you."))
		if(tgui_alert(occupant, "This pod is already linked. Are you certain you wish to engage?", "Commmit?", list("Yes", "No")) != "Yes")
			visible_message(span_alien("\The [src] pulses!"))
			perform_exit()
			return

	to_chat(occupant,span_alien("Your mind blurs as information bombards you."))

	if(!avatar)
		var/turf/T = get_turf(src)
		if(!perfect_replica)
			avatar = new(src, produce_species)
		else
			avatar = new(src, occupant.species.name)

		// If the user has a non-default (Human) bodyshape, make it match theirs.
		if(occupant.species.name != "Promethean" && occupant.species.name != "Human" && mirror_first_occupant)
			avatar.shapeshifter_change_shape(occupant.species.name)
		avatar.Sleeping(6)

		occupant.enter_vr(avatar)
		if(spawn_with_clothing)
			job_master.EquipRank(avatar,"Visitor", 1, FALSE)
		add_verb(avatar,/mob/living/carbon/human/proc/perform_exit_vr)
		avatar.virtual_reality_mob = FALSE //THIS IS THE BIG DIFFERENCE WITH ALIEN VR PODS. THEY ARE NOT VR, THEY ARE REAL.

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

		var/newname = sanitize(tgui_input_text(avatar, "Your mind feels foggy. You're certain your name is [occupant.real_name], but it could also be [avatar.name]. Would you like to change it to something else?", "Name change", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if (newname)
			avatar.real_name = newname

		avatar.forceMove(T)
		visible_message(span_alium("\The [src] [pick("gurgles", "churns", "sloshes")] before spitting out \the [avatar]!"))

	else

		// There's only one body per one of these pods, so let's be kind.
		var/newname = sanitize(tgui_input_text(avatar, "Your mind feels foggy. You're certain your name is [occupant.real_name], but it feels like it is [avatar.name]. Would you like to change it to something else?", "Name change", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if(newname)
			avatar.real_name = newname
			avatar.name = newname
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
