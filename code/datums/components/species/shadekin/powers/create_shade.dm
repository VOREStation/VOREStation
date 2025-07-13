//////////////////////
///  CREATE SHADE  ///
//////////////////////
/datum/power/shadekin/create_shade
	name = "Create Shade (25)"
	desc = "Create a field of darkness that follows you."
	verbpath = /mob/living/proc/create_shade
	ability_icon_state = "create_shade"

/mob/living/proc/create_shade()
	set name = "Create Shade (25)"
	set desc = "Create a field of darkness that follows you."
	set category = "Abilities.Shadekin"

	var/ability_cost = 25

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!istype(SK))
		to_chat(src, span_warning("Only a shadekin can use that!"))
		return FALSE
	else if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE
	else if(SK.shadekin_get_energy() < ability_cost)
		to_chat(src, span_warning("Not enough energy for that ability!"))
		return FALSE
	else if(SK.in_phase)
		to_chat(src, span_warning("You can't use that while phase shifted!"))
		return FALSE

	playsound(src, 'sound/effects/bamf.ogg', 75, 1)

	add_modifier(/datum/modifier/shadekin/create_shade,20 SECONDS)
	SK.shadekin_adjust_energy(-ability_cost)
	return TRUE

/datum/modifier/shadekin/create_shade
	name = "Shadekin Shadegen"
	desc = "Darkness envelops you."
	mob_overlay_state = ""

	on_created_text = span_notice("You drag part of The Dark into realspace, enveloping yourself.")
	on_expired_text = span_warning("You lose your grasp on The Dark and realspace reasserts itself.")
	stacks = MODIFIER_STACK_EXTEND
	var/mob/living/simple_mob/shadekin/my_kin

/datum/modifier/shadekin/create_shade/tick()
	var/datum/component/shadekin/SK = my_kin.get_shadekin_component()
	if(SK && SK.in_phase)
		expire()

/datum/modifier/shadekin/create_shade/on_applied()
	my_kin = holder
	holder.glow_toggle = TRUE
	holder.glow_range = 8
	holder.glow_intensity = -10
	holder.glow_color = "#FFFFFF"
	holder.set_light(8, -10, "#FFFFFF")

/datum/modifier/shadekin/create_shade/on_expire()
	holder.glow_toggle = initial(holder.glow_toggle)
	holder.glow_range = initial(holder.glow_range)
	holder.glow_intensity = initial(holder.glow_intensity)
	holder.glow_color = initial(holder.glow_color)
	holder.set_light(0)
	my_kin = null
