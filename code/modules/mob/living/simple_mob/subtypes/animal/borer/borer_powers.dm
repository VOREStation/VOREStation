/**
 * Put a nearby target to sleep to allow for infestation.
 */
/mob/living/simple_mob/animal/borer/verb/knockout_victim()
	set category = "Abilities.Borer"
	set name = "Knockout Victim"
	set desc = "Use your psychic influence to put a target into a temporary catatonic state."

	if(world.time - used_dominate < 150)
		to_chat(src, span_warning("You cannot use that ability again so soon."))
		return
	if(host)
		to_chat(src, span_warning("You cannot do that from within a host body."))
		return
	if(stat)
		to_chat(src, span_warning("You cannot do that in your current state."))
		return

	var/attack_range = 5
	var/list/choices = list()
	for(var/mob/living/carbon/human/attackable in view(attack_range,src))
		if(attackable.stat != DEAD && !attackable.has_brain_worms())
			choices += attackable
	if(world.time - used_dominate < 150)
		to_chat(src, span_warning("You cannot use that ability again so soon."))
		return

	if(!choices.len)
		to_chat(src, span_notice("There are no viable targets within range..."))
		return
	var/mob/living/carbon/human/attack_target = choices[1]
	if(choices.len > 1)
		tgui_input_list(src, "Who do you wish to dominate?", "Target Choice", choices)

	if(!attack_target || QDELETED(src))
		return
	if(!(attack_target in view(attack_range,src)))
		to_chat(src, span_warning("\The [attack_target] escaped your influence..."))
		return
	if(attack_target.has_brain_worms())
		to_chat(src, span_warning("You cannot influence someone who is already infested!"))
		return

	to_chat(src, span_alien("You focus your psychic lance on [attack_target] and freeze their limbs with a wave of terrible dread."))
	to_chat(attack_target, span_vdanger("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	attack_target.Sleeping(10) // This was paralyze, but it resulted in players instantly screaming over radio. So get slept nerds.
	used_dominate = world.time
	add_attack_logs(src, attack_target, "psychic knockout (borer)")

/**
 * Crawls inside of a target mob, and adds the borer as an implant to the mob's brain. If no brain exists the body will become a borer husk zombie.
 */
/mob/living/simple_mob/animal/borer/verb/infest()
	set category = "Abilities.Borer"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		to_chat(src, span_warning("You are already within a host."))
		return
	if(stat)
		to_chat(src, span_warning("You cannot infest a target in your current state."))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/check_target in view(1,src))
		if(Adjacent(check_target) && !check_target.has_brain_worms())
			choices += check_target
	if(!choices.len)
		to_chat(src, span_warning("There are no viable hosts within range..."))
		return

	var/mob/living/carbon/human/infest_target = choices[1]
	if(choices.len > 1)
		infest_target = tgui_input_list(src, "Who do you wish to infest?", "Target Choice", choices)
	if(QDELETED(infest_target) || QDELETED(src))
		return
	infest_target(infest_target)

/// Infests mob with borer.
/mob/living/simple_mob/animal/borer/proc/infest_target(mob/living/carbon/human/infest_target)
	if(!istype(infest_target))
		to_chat(src, span_warning("\The [infest_target] is not suitable for infestation..."))
		return
	if(!(Adjacent(infest_target)))
		to_chat(src, span_warning("\The [infest_target] has escaped your range..."))
		return
	if(infest_target.has_brain_worms())
		to_chat(src, span_warning("You cannot infest someone who is already infested!"))
		return

	var/entering_timer = 30
	var/protected = FALSE
	var/obj/item/organ/external/E = infest_target.organs_by_name[BP_HEAD]
	if(!E || E.is_stump())
		to_chat(src, span_warning("\The [infest_target] does not have a head!"))

	if(!infest_target.should_have_organ(O_BRAIN))
		to_chat(src, span_warning("\The [infest_target] does not seem to have an ear canal to breach."))
		return
	if(infest_target.check_head_coverage())
		to_chat(src, span_alien("You begin to flatten and squirm into \the [infest_target]'s helmet to find a way inside them."))
		entering_timer = 55
		protected = TRUE

	if(!protected)
		to_chat(infest_target, span_vdanger("Something slimy begins probing at the opening of your ear canal..."))
	else
		to_chat(infest_target, span_vdanger("Something slimy begins trying to find a way past your helmet..."))
	to_chat(src, span_alien("You slither up to \the [infest_target] and begin probing at their ear canal..."))

	if(!do_after(src, entering_timer, target = infest_target))
		to_chat(src, span_danger("As [infest_target] moves away, you are dislodged and fall to the ground."))
		return
	if(!infest_target || QDELETED(src))
		return
	if(stat)
		to_chat(src, span_warning("You cannot infest \the [infest_target] in your current state."))
		return
	if(!(Adjacent(infest_target)))
		to_chat(src, span_warning("They are no longer in range!"))
		return
	if(!infest_target.internal_organs_by_name[O_BRAIN]) // See section below about replace_brain() being disabled
		to_chat(src, span_danger("\The [infest_target] has no brain to bond to!"))
		return

	to_chat(src, span_alien("You wiggle into [infest_target]'s ear."))
	if(!infest_target.stat)
		to_chat(infest_target, span_vdanger("Something disgusting and slimy wiggles into your ear!"))
	host = infest_target
	forceMove(host)

	//Update their traitor status.
	if(host.mind)
		borers.add_antagonist_mind(host.mind, 1, borers.faction_role_text, borers.faction_welcome)

	/* This is likely not desired, and has some major issues with ghost behavior. Disabling for now
	// No brain organ, so the borer moves in and replaces it permanently.
	if(!host.internal_organs_by_name[O_BRAIN])
		add_attack_logs(src, host, "merged with brainless body (borer)")
		replace_brain()
		return
	*/

	// If they're in normally, implant removal can get them out.
	var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
	head.implants += src
	add_attack_logs(src, host, "infested target (borer)")

/**
 * Releases chemicals from the borer into their host. Can be used as a standalone chemist in your head for an antag cooperating with their borer.
 */
/mob/living/simple_mob/animal/borer/verb/secrete_chemicals()
	set category = "Abilities.Borer"
	set name = "Secrete Chemicals"
	set desc = "Drain some chemicals into your host's bloodstream."

	if(!can_use_power_in_host())
		return
	if(!can_use_power_docile())
		return
	if(controlling)
		to_chat(src, span_warning("You cannot do that while in full control of a host."))
		return

	var/injection_choice = tgui_input_list(src, "Select a chemical to secrete.", "Chemicals", borer_chem_list)
	if(injection_choice == "Revive Dead Host")
		if(!can_use_power_in_host())
			return
		if(controlling)
			to_chat(src, span_warning("You cannot do that while in full control of a host."))
			return
		if(!can_use_power_docile())
			return
		if(host.stat != DEAD)
			to_chat(src, span_danger("Your host must be dead!"))
			return
		if(HUSK in host.mutations)
			to_chat(src, span_danger("Your host is too destroyed to revive."))
			return
		if(!host.can_defib)
			to_chat(src, span_vdanger("Your host's brain is not connected to its body!"))
			return
		if(!use_chems(BORER_POWER_COST_SECRETE))
			return
		to_chat(src, span_alien("You squirt an intense mix of chemicals from your reservoirs into [host]'s bloodstream."))
		add_attack_logs(src, host, "jumpstart host (borer)")
		host.jumpstart()
		return

	// Is this even legal to do still? We had to wait for a selection...
	if(!can_use_power_in_host())
		return
	if(!can_use_power_docile())
		return
	if(controlling)
		to_chat(src, span_warning("You cannot do that while in full control of a host."))
		return

	// Get the chem we're injecting
	var/list/injection_data = borer_chem_list[injection_choice]
	if(!injection_data) //Sanity check.
		return
	var/injecting_chem = injection_data[1]
	var/injectsize = injection_data[2]
	if(!injecting_chem || !injectsize)
		return

	// Finally get to injecting
	if(!use_chems(BORER_POWER_COST_SECRETE))
		return
	var/datum/reagent/inject_reagent = SSchemistry.chemical_reagents[injecting_chem]
	if(!inject_reagent)
		CRASH("Invalid chem reagent [injecting_chem], in borer chemical injection.")

	add_attack_logs(src, host, "chemical injection [inject_reagent] (borer)")
	to_chat(src, span_alien("You squirt a measure of [inject_reagent] from your reservoirs into [host]'s bloodstream."))
	host.bloodstr.add_reagent(injecting_chem, injectsize)

/// Does some basic regeneration on a host
/mob/living/carbon/human/proc/jumpstart()
	set category = "Abilities.Borer"
	set name = "Revive Host"
	set desc = "Send a jolt of electricity through your host, reviving them."

	// This is meant to be a bit silly, cause borers don't have much options otherwise
	remove_verb(src, /mob/living/carbon/human/proc/jumpstart)
	visible_message(span_danger("With a hideous, rattling moan, [src] shudders back to life!"))

	// Dump damage or we won't be able to revive properly
	setHalLoss(0)
	setOxyLoss(0)
	adjustBruteLoss(-20)
	adjustFireLoss(-20)
	adjust_nutrition(-200)

	// Boilerplate revivial
	rejuvenate()
	restore_blood()
	fixblood()
	update_canmove()

	// Get some healing in us
	bloodstr.add_reagent(REAGENT_BICARIDINE, 5)
	bloodstr.add_reagent(REAGENT_KELOTANE, 5)
	bloodstr.add_reagent(REAGENT_ID_TRAMADOL, 5)
	bloodstr.add_reagent(REAGENT_ID_ALKYSINE, 5)
