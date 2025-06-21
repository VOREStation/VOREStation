//////////////////////////
///  REGENERATE OTHER  ///
//////////////////////////
/datum/power/shadekin/regenerate_other
	name = "Regenerate Other (50)"
	desc = "Spend energy to heal physical wounds in another creature."
	verbpath = /mob/living/proc/regenerate_other
	ability_icon_state = "shadekin_regen"

/mob/living/proc/regenerate_other()
	set name = "Regenerate Other (50)"
	set desc = "Spend energy to heal physical wounds in another creature."
	set category = "Abilities.Shadekin"

	var/ability_cost = 50

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE
	else if(SK.shadekin_get_energy() < ability_cost)
		to_chat(src, span_warning("Not enough energy for that ability!"))
		return FALSE
	else if(SK.in_phase)
		to_chat(src, span_warning("You can't use that while phase shifted!"))
		return FALSE

	var/list/viewed = oview(1)
	var/list/targets = list()
	for(var/mob/living/L in viewed)
		targets += L
	if(!targets.len)
		to_chat(src,span_warning("Nobody nearby to mend!"))
		return FALSE

	var/mob/living/target = tgui_input_list(src,"Pick someone to mend:","Mend Other", targets)
	if(!target)
		return FALSE

	target.add_modifier(/datum/modifier/shadekin/heal_boop,1 MINUTE)
	playsound(src, 'sound/effects/EMPulse.ogg', 75, 1)
	SK.shadekin_adjust_energy(-ability_cost)
	visible_message(span_notice("\The [src] gently places a hand on \the [target]..."))
	face_atom(target)
	return TRUE

/datum/modifier/shadekin/heal_boop
	name = "Shadekin Regen"
	desc = "You feel serene and well rested."
	mob_overlay_state = "green_sparkles"

	on_created_text = span_notice("Sparkles begin to appear around you, and all your ills seem to fade away.")
	on_expired_text = span_notice("The sparkles have faded, although you feel much healthier than before.")
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/shadekin/heal_boop/tick()
	if(!holder.getBruteLoss() && !holder.getFireLoss() && !holder.getToxLoss() && !holder.getOxyLoss() && !holder.getCloneLoss()) // No point existing if the spell can't heal.
		expire()
		return
	holder.adjustBruteLoss(-2)
	holder.adjustFireLoss(-2)
	holder.adjustToxLoss(-2)
	holder.adjustOxyLoss(-2)
	holder.adjustCloneLoss(-2)
