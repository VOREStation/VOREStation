/mob/living/proc/reveal(var/silent, var/message = span_warning("You have been revealed! You are no longer hidden."))
	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		if(!silent && message)
			to_chat(src, message)

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities.General"

	if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs()) //VORE EDIT: Check for has_buckled_mobs() (taur riding)
		return

	if(status_flags & HIDING)
		reveal(FALSE, span_notice("You have stopped hiding."))
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,span_notice("You are now hiding."))

/mob/living/proc/toggle_selfsurgery()
	set name = "Allow Self Surgery"
	set desc = "Toggles the 'safeties' on self-surgery, allowing you to do so."
	set category = "Object"

	allow_self_surgery = !allow_self_surgery

	to_chat(src, span_notice("You will [allow_self_surgery ? "now" : "no longer"] attempt to operate upon yourself."))
	log_admin("DEBUG \[[world.timeofday]\]: [src.ckey ? "[src.name]:([src.ckey])" : "[src.name]"] has [allow_self_surgery ? "Enabled" : "Disabled"] self surgery.")

/mob/living/proc/toggle_patting_defence()
	set name = "Toggle Reflexive Biting"
	set desc = "Toggles the automatic biting for if someone pats you on the head or boops your nose."
	set category = "Abilities.General"

	if(touch_reaction_flags & SPECIES_TRAIT_PATTING_DEFENCE)
		touch_reaction_flags &= ~(SPECIES_TRAIT_PATTING_DEFENCE)
		to_chat(src,span_notice("You will no longer bite hands who pat or boop you."))
	else
		touch_reaction_flags |= SPECIES_TRAIT_PATTING_DEFENCE
		to_chat(src,span_notice("You will now longer bite hands who pat or boop you."))

/mob/living/proc/toggle_personal_space()
	set name = "Toggle Personal Space"
	set desc = "Toggles dodging any attempts to hug or pat you."
	set category = "Abilities.General"

	if(touch_reaction_flags & SPECIES_TRAIT_PERSONAL_BUBBLE)
		touch_reaction_flags &= ~(SPECIES_TRAIT_PERSONAL_BUBBLE)
		to_chat(src,span_notice("You will no longer dodge all attempts at hugging, patting, booping, licking, smelling and hand shaking."))
	else
		touch_reaction_flags |= SPECIES_TRAIT_PERSONAL_BUBBLE
		to_chat(src,span_notice("You will now dodge all attempts at hugging, patting, booping, licking, smelling and hand shaking."))

/mob/living/proc/toggle_sparkles()
	set name = "Toggle Sparkles"
	set desc = "Toggle fancy glowing sparkles!"
	set category = "Abilities.Sparkledog"

	if(!glow_toggle)
		glow_range = 3
		glow_intensity = 2
		glow_color = "#FFFFFF"
		glow_toggle = TRUE
		add_modifier(/datum/modifier/sparkle, null, src)
	else
		glow_toggle = FALSE

/datum/modifier/sparkle
	name = "sparkling"
	desc = "You are sparkling, woo!"
	mob_overlay_state = "cyan_sparkles"
	on_created_text = span_notice("You begin to sparkle!")
	on_expired_text = span_notice("Your sparkling fades away...")

/datum/modifier/sparkle/tick()
	if(!holder.glow_toggle || holder.stat)
		expire()

/mob/living/proc/healing_rainbows()
	set name = "Firin Mah Lazor"
	set desc = "Fire a glowing beam of rainbows at another person to heal them!"
	set category = "Abilities.Sparkledog"

	if(src.stat)
		to_chat(src, span_warning("You can't vomit rainbows in this condition!"))

	var/list/targets = list()
	for(var/mob/living/carbon/human/M in oview(7,src))
		if(M.z != src.z || get_dist(src,M) > 7)
			continue
		if(src == M)
			continue
		targets |= M

	if(!targets)
		to_chat(src, span_warning("There is nobody next to you."))
		return

	var/mob/living/carbon/human/chosen_target = tgui_input_list(src, "Who do you wish to shoot rainbows at?", "Rainbow", targets)
	if(!chosen_target)
		return

	visible_message(span_warning("[src] begins chargin' their lazor!"))
	if(!do_after(src, 5 SECONDS, chosen_target, exclusive = TASK_USER_EXCLUSIVE))
		return
	if(chosen_target.z != src.z || get_dist(src,chosen_target) > 7)
		return
	visible_message(span_warning("[src] fires their lazor at [chosen_target]!"))
	var/obj/item/projectile/P = new /obj/item/projectile/beam/sparkledog(get_turf(src))
	playsound(src, "'sound/weapons/sparkle.ogg'", 50, 1)
	P.launch_projectile(chosen_target, BP_TORSO, src)
