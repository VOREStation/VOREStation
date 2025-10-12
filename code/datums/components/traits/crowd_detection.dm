/**
 * Component that serves as a base type for detecting groups of mobs or players around us.
 * It functions as a framework for lonely and agoraphobia to share large sections of code.
 * Can be extended for other situations in the future.
 *  */
/datum/component/crowd_detection
	VAR_PROTECTED/mob/living/carbon/human/human_parent
	VAR_PROTECTED/loneliness_stage = 0
	VAR_PROTECTED/hallucination_cap = 25
	VAR_PROTECTED/warning_cap = 400
	VAR_PROTECTED/escalation_speed = 0.8
	VAR_PROTECTED/only_people = FALSE
	VAR_PROTECTED/next_loneliness_time = 0

/datum/component/crowd_detection/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(handle_life))
	human_parent = parent

/datum/component/crowd_detection/Destroy(force = FALSE)
	UnregisterSignal(parent, COMSIG_LIVING_LIFE)
	human_parent = null
	. = ..()

/datum/component/crowd_detection/proc/handle_life()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER
	// If they're dead or unconcious they're a bit beyond this kind of thing.
	if(human_parent.stat)
		loneliness_stage = 0
		return TRUE

	// No point processing if we're already stressing the hell out.
	if(human_parent.hallucination >= hallucination_cap && loneliness_stage >= warning_cap)
		return TRUE

	var/datum/component/antag/changeling/comp = human_parent.GetComponent(/datum/component/antag/changeling)
	if(comp) // We are never alone~
		loneliness_stage = 0
		return TRUE

	return FALSE

/datum/component/crowd_detection/proc/process_discomfort_stages()
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	// No company? Suffer :(
	if(loneliness_stage < warning_cap)
		loneliness_stage = min(warning_cap,loneliness_stage+escalation_speed)
	// Handle message delay
	if(world.time >= next_loneliness_time)
		var/ms = handle_loneliness_message()
		if(ms)
			to_chat(human_parent, ms)
		next_loneliness_time = world.time+500
		human_parent.fear = min((human_parent.fear + 3), 102)
	// Hallucinations
	if(loneliness_stage >= warning_cap && human_parent.hallucination < hallucination_cap)
		human_parent.hallucination = min(hallucination_cap,human_parent.hallucination+2.5*escalation_speed)

/datum/component/crowd_detection/proc/check_contents(var/atom/item,var/max_layer = 3,var/current_layer = 1)
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

/datum/component/crowd_detection/proc/check_mob_company(var/mob/living/M,var/invis_matters = TRUE)
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

/datum/component/crowd_detection/proc/handle_loneliness_message()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	return null

/datum/component/crowd_detection/proc/sub_loneliness(var/amount = 4, var/message)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	loneliness_stage = max(loneliness_stage - amount, 0)
	if(world.time >= next_loneliness_time && loneliness_stage > 0)
		if(message)
			to_chat(human_parent, message)
		next_loneliness_time = world.time+500

/datum/component/crowd_detection/proc/find_held_by(var/atom/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/atom)
	if(!item || !istype(item))
		return null
	else if(istype(item,/mob/living))
		return item
	else
		return find_held_by(item.loc)



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
		sub_loneliness()
		return
	// Vored? Not gonna get frightened.
	if(isbelly(human_parent.loc))
		sub_loneliness()
		return
	if(istype(human_parent.loc, /obj/item/holder))
		sub_loneliness()
		return
	// Check for company.
	if(length(check_contents(human_parent))) //Check our item slots and storage for any micros.
		sub_loneliness()
		return
	for(var/mob/living/M in viewers(get_turf(human_parent)))
		if(length(check_mob_company(M)))
			return

	//Check to see if there's anyone in our belly
	if(human_parent.vore_organs)
		for(var/obj/belly/B in human_parent.vore_organs)
			for(var/mob/living/content in B.contents)
				if(istype(content))
					if(length(check_mob_company(content)))
						return

	for(var/obj/item/holder/micro/M in human_parent)
		sub_loneliness()
	for(var/obj/effect/overlay/aiholo/A in range(5, human_parent))
		sub_loneliness()
	for(var/obj/item/toy/plushie/teshari/P in range(5, human_parent))
		sub_loneliness()

	process_discomfort_stages()

/datum/component/crowd_detection/agoraphobia/handle_loneliness_message()
	if(loneliness_stage == escalation_speed)
		return "[pick("Well.. No one is around you anymore...","Well.. You're alone now...","You suddenly feel alone...")]"
	if(loneliness_stage >= 50)
		return "[pick("You begin to feel alone...","You feel isolated...","You need company...","Where is everyone?...","You need to find someone...")]"
	if(loneliness_stage >= 250)
		if(human_parent.stuttering < hallucination_cap)
			human_parent.stuttering += 5
		return "[pick("You don't think you can last much longer without some visible company!", "You should go find someone to be with!","You need to find company!","Find someone to be with!")]"
	if(loneliness_stage >= warning_cap)
		return span_danger(span_bold("[pick("Where are the others?", "Please, there has to be someone nearby!", "I don't want to be alone!","Please, anyone! I don't want to be alone!")]"))
	. = ..()

/datum/component/crowd_detection/lonely/sub_loneliness(var/amount = 4, var/message)
	if(!message)
		message = span_infoplain("The nearby company calms you down...")
	. = ..(amount, message)



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Agoraphobia
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/crowd_detection/agoraphobia

/datum/component/crowd_detection/agoraphobia/handle_life()
	if(..())
		return

	if(isbelly(human_parent.loc)) //I don't need to be told every 2 seconds I'm freaking out when I'm in a belly trying to WRITE!!! We can handle all the stress of it when (IF) we are let out of the gut.
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
		sub_loneliness()
		return

	process_discomfort_stages()

/datum/component/crowd_detection/agoraphobia/handle_loneliness_message()
	if(loneliness_stage == escalation_speed)
		return "You notice there's more people than you feel comfortable with around you..."
	if(loneliness_stage >= 50 && loneliness_stage < 250)
		return "You start to feel anxious from the number of people around you."
	if(loneliness_stage >= 250 && loneliness_stage < warning_cap)
		if(human_parent.stuttering < hallucination_cap)
			human_parent.stuttering += 5
		return "[pick("You don't think you can last much longer with this much company!", "You should go find some space!")]" //if we add more here make it a list for readability
	if(loneliness_stage >= warning_cap)
		var/list/panicmessages = list(	"Why am I still here? I have to leave and get some space!",
						"Please, just let me be alone!",
						"I need to be alone!")
		return span_bolddanger("[pick(panicmessages)]")
	. = ..()

/datum/component/crowd_detection/agoraphobia/proc/holder_check(var/obj/item/holder/H_holder)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(istype(H_holder))
		var/mob/living/held_by = find_held_by(H_holder)
		if(held_by)
			in_range |= check_mob_company(held_by,FALSE)
		in_range |= holder_check(human_parent,held_by)
	return in_range

/datum/component/crowd_detection/agoraphobia/proc/belly_check(var/obj/belly/B)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/in_range = list()
	if(istype(B))
		in_range |= check_mob_company(B.owner,FALSE)
		if(isbelly(B.owner.loc))
			in_range |= belly_check(human_parent,B.owner.loc)
	return in_range
