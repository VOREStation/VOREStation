#define MIN_DISCOMFORT_MESSAGE 50

/**
 * Component that serves as a base type for detecting groups of mobs or players around us.
 * It functions as a framework for lonely and agoraphobia to share large sections of code.
 * Can be extended for other situations in the future.
 *  */
/datum/component/crowd_detection
	VAR_PROTECTED/mob/living/carbon/human/human_parent
	VAR_PROTECTED/discomfort = 0
	VAR_PROTECTED/hallucination_cap = 25
	VAR_PROTECTED/warning_cap = 400
	VAR_PROTECTED/escalation_speed = 0.8
	VAR_PROTECTED/only_people = FALSE
	VAR_PROTECTED/invis_matters = TRUE
	VAR_PROTECTED/belly_is_calming = TRUE

	VAR_PRIVATE/is_calm = TRUE
	VAR_PRIVATE/next_message_time = 0

/datum/component/crowd_detection/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	human_parent = parent

/datum/component/crowd_detection/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(handle_life))

/datum/component/crowd_detection/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE))

/datum/component/crowd_detection/Destroy(force = FALSE)
	human_parent = null
	. = ..()

/datum/component/crowd_detection/proc/handle_life()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER
	// If they're dead or unconcious they're a bit beyond this kind of thing.
	if(human_parent.stat)
		discomfort = 0
		return TRUE
	// No point processing if we're already stressing the hell out.
	if(human_parent.hallucination >= hallucination_cap && discomfort >= warning_cap)
		discomfort = warning_cap
		return TRUE
	// I don't need to be told every 2 seconds I'm freaking out when I'm in a belly trying to WRITE!!! We can't be reasonably crowded in a belly, and won't be alone in one, so lets just handle it here.
	if(isbelly(human_parent.loc))
		if(belly_is_calming)
			calm_discomfort()
		return TRUE
	// Changelings are immune to these, so we may as well stop handling it... It's unlikely you will turn back from a changeling as well.
	if(human_parent.GetComponent(/datum/component/antag/changeling)) // We are never alone~
		qdel(src)
		return TRUE
	return FALSE

/datum/component/crowd_detection/proc/increase_discomfort()
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	// No company? Suffer :(
	if(discomfort < warning_cap)
		discomfort = min(warning_cap,discomfort+escalation_speed)
	// Handle message delay
	if(world.time >= next_message_time)
		var/ms = get_discomfort_message(discomfort)
		if(ms)
			to_chat(human_parent, ms)
		next_message_time = world.time + 50 SECONDS
		human_parent.fear = min((human_parent.fear + 3), 102)
		is_calm = FALSE // We'll only get one message early
	// Hallucinations
	if(discomfort >= warning_cap && human_parent.hallucination < hallucination_cap)
		human_parent.hallucination = min(hallucination_cap,human_parent.hallucination+2.5*escalation_speed)

/datum/component/crowd_detection/proc/check_contents(atom/item, max_layer = 3, current_layer = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(!item || !istype(item) || current_layer > max_layer)
		return in_range
	for(var/datum/content in item.contents)
		if(istype(content,/obj/item/holder))
			var/obj/item/holder/contentholder = content
			in_range |= check_mob_company(contentholder.held_mob)
		else
			in_range |= check_contents(content,max_layer,current_layer+1)
	return in_range

/datum/component/crowd_detection/proc/check_mob_company(mob/living/M)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(!istype(M))
		return in_range
	var/social_check = only_people && !istype(M, /mob/living/carbon) && !istype(M, /mob/living/silicon/robot)
	var/self_invisible_check = M == human_parent || M.invisibility > human_parent.see_invisible
	var/ckey_check = only_people && !M.ckey
	var/overall_checks = M == human_parent || M.stat == DEAD || social_check || ckey_check
	if(invis_matters && self_invisible_check)
		return in_range
	if((M.faction == FACTION_NEUTRAL || M.faction == human_parent.faction) && !overall_checks)
		in_range |= M
	else
		in_range |= check_contents(M)
		if(M.vore_organs)
			for(var/obj/belly/B in M.vore_organs)
				for(var/mob/living/content in B.contents)
					if(istype(content))
						in_range |= check_mob_company(content)
	return in_range

/datum/component/crowd_detection/proc/get_discomfort_message(current_discomfort)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	return null

/datum/component/crowd_detection/proc/calm_discomfort(amount = 4, message = null)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	discomfort = max(discomfort - amount, 0)
	if(world.time >= next_message_time && (discomfort > 0 || !is_calm))
		if(message)
			to_chat(human_parent, message)
		if(discomfort < MIN_DISCOMFORT_MESSAGE)
			is_calm = TRUE
		next_message_time = world.time + 50 SECONDS

/datum/component/crowd_detection/proc/find_held_by(atom/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/atom)
	if(!item || !istype(item))
		return null
	else if(istype(item,/mob/living))
		return item
	else
		return find_held_by(item.loc)

/datum/component/crowd_detection/proc/get_calm()
	SHOULD_NOT_OVERRIDE(TRUE)
	return is_calm

/datum/component/crowd_detection/proc/get_discomfort()
	SHOULD_NOT_OVERRIDE(TRUE)
	return discomfort


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Lonelyness
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/crowd_detection/lonely

/datum/component/crowd_detection/lonely/major
	only_people = TRUE
	warning_cap = 300
	hallucination_cap = 50
	escalation_speed = 1.3

/datum/component/crowd_detection/lonely/handle_life()
	if(..())
		return

	// Brain friends!
	if(human_parent.has_brain_worms())
		calm_discomfort()
		return

	// Grabbed by a mob
	if(istype(human_parent.loc, /obj/item/holder))
		calm_discomfort()
		return

	// Check for company.
	if(length(check_contents(human_parent))) //Check our item slots and storage for any micros.
		calm_discomfort()
		return
	for(var/mob/living/M in viewers(get_turf(human_parent)))
		if(length(check_mob_company(M)))
			calm_discomfort()
			return

	//Check to see if there's anyone in our belly
	if(human_parent.vore_organs)
		for(var/obj/belly/B in human_parent.vore_organs)
			for(var/mob/living/content in B.contents)
				if(istype(content))
					if(length(check_mob_company(content)))
						calm_discomfort()
						return

	//Things that are not mobs, but will calm lonelyness
	for(var/obj/effect/overlay/aiholo/A in range(5, human_parent))
		calm_discomfort()
		return
	for(var/obj/item/toy/plushie/teshari/P in range(5, human_parent))
		calm_discomfort()
		return

	increase_discomfort()

/datum/component/crowd_detection/lonely/get_discomfort_message(var/current_discomfort)
	if(current_discomfort >= warning_cap)
		human_parent.stuttering += 25
		return span_danger(span_bold(pick("Where are the others?", "Please, there has to be someone nearby!", "I don't want to be alone!","Please, anyone! I don't want to be alone!")))
	if(current_discomfort >= 250)
		if(human_parent.stuttering < hallucination_cap)
			human_parent.stuttering += 5
		return pick("You don't think you can last much longer without some visible company!", "You should go find someone to be with!","You need to find company!","Find someone to be with!")
	if(current_discomfort >= MIN_DISCOMFORT_MESSAGE)
		return pick("You begin to feel alone...","You feel isolated...","You need company...","Where is everyone?...","You need to find someone...")
	if(get_calm())
		return pick("Well.. No one is around you anymore...","Well.. You're alone now...","You suddenly feel alone...")
	. = ..()

/datum/component/crowd_detection/lonely/calm_discomfort(var/amount = 4, var/message)
	if(!message && !get_calm())
		message = span_infoplain("The nearby company calms you down...")
	. = ..(amount, message)



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Agoraphobia
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/crowd_detection/agoraphobia
	belly_is_calming = FALSE // Stops message spam, but doesn't decrease discomfort

/datum/component/crowd_detection/agoraphobia/handle_life()
	if(..())
		return

	var/list/in_range = list()
	in_range |= check_mob_company(human_parent)	//Checks our item slots and bellies for any people.
	in_range |= belly_check(human_parent.loc)	//Recursive check if we're in anyones bellies, are they in anyone's belly, etc.
	in_range |= holder_check(human_parent.loc)	//Recursive check if someone's holding us, is anyone holding them, etc.

	// Check for company.
	for(var/mob/living/M in viewers(get_turf(human_parent)))
		in_range |= check_mob_company(M)
	for(var/obj/effect/overlay/aiholo/A in range(5, human_parent))
		in_range |= A
	if(length(in_range) <= 2)
		calm_discomfort()
		return

	increase_discomfort()

/datum/component/crowd_detection/agoraphobia/get_discomfort_message( current_discomfort)
	if(current_discomfort >= warning_cap)
		human_parent.stuttering += 25
		return span_bolddanger(pick("Why am I still here? I have to leave and get some space!",
									"Please, just let me be alone!",
									"I need to be alone!"))
	if(current_discomfort >= 250)
		if(human_parent.stuttering < hallucination_cap)
			human_parent.stuttering += 5
		return pick("You don't think you can last much longer with this much company!", "You should go find some space!")
	if(current_discomfort >= MIN_DISCOMFORT_MESSAGE)
		return "You start to feel anxious from the number of people around you."
	if(get_calm())
		return "You notice there's more people than you feel comfortable with around you..."
	. = ..()

/datum/component/crowd_detection/agoraphobia/calm_discomfort(amount = 4, message)
	if(!message && !get_calm())
		message = span_infoplain("You feel calmer with noone around...")
	. = ..(amount, message)

/datum/component/crowd_detection/agoraphobia/proc/holder_check(obj/item/holder/H_holder)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(istype(H_holder))
		var/mob/living/held_by = find_held_by(H_holder)
		if(held_by)
			in_range |= check_mob_company(held_by)
		in_range |= holder_check(human_parent,held_by)
	return in_range

/datum/component/crowd_detection/agoraphobia/proc/belly_check(obj/belly/B)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(istype(B))
		in_range |= check_mob_company(B.owner)
		if(isbelly(B.owner.loc))
			in_range |= belly_check(human_parent,B.owner.loc)
	return in_range

#undef MIN_DISCOMFORT_MESSAGE
