/obj/effect/shadekin_ability
	name = ""
	desc = ""
	icon = 'icons/mob/screen_spells.dmi'
	var/ability_name = "FIX ME"
	var/cost = 50
	var/mob/living/simple_mob/shadekin/my_kin
	var/shift_mode = NOT_WHILE_SHIFTED
	var/ab_sound

/obj/effect/shadekin_ability/New(var/new_kin)
	..()
	my_kin = new_kin
	loc = null

/obj/effect/shadekin_ability/Destroy()
	my_kin = null
	return ..()

/obj/effect/shadekin_ability/proc/atom_button_text()
	var/shift_denial

	if(shift_mode == NOT_WHILE_SHIFTED && (my_kin.ability_flags & AB_PHASE_SHIFTED))
		shift_denial = "Physical Only"
	else if(shift_mode == ONLY_WHILE_SHIFTED && !(my_kin.ability_flags & AB_PHASE_SHIFTED))
		shift_denial = "Shifted Only"

	if(shift_denial)
		name = shift_denial
	else
		name = my_kin.energy >= cost ? "Activate" : "No Energy"
	return src

/obj/effect/shadekin_ability/Click(var/location, var/control, var/params)
	if(my_kin.stat) return

	var/list/clickprops = params2list(params)
	var/opts = clickprops["shift"]

	if(opts)
		to_chat(my_kin,"<span class='notice'><b>[name]</b> (Cost: [cost]%) - [desc]</span>")
	else
		do_ability(my_kin)

/obj/effect/shadekin_ability/proc/do_ability()
	if(my_kin.stat)
		to_chat(my_kin,"<span class='warning'>Can't use that ability in your state!</span>")
		return FALSE
	if(shift_mode == NOT_WHILE_SHIFTED && (my_kin.ability_flags & AB_PHASE_SHIFTED))
		to_chat(my_kin,"<span class='warning'>Can't use that ability while phase shifted!</span>")
		return FALSE
	else if(shift_mode == ONLY_WHILE_SHIFTED && !(my_kin.ability_flags & AB_PHASE_SHIFTED))
		to_chat(my_kin,"<span class='warning'>Can only use that ability while phase shifted!</span>")
		return FALSE
	else if(my_kin.energy < cost)
		to_chat(my_kin,"<span class='warning'>Not enough energy for that ability!</span>")
		return FALSE

	my_kin.energy -= cost
	if(ab_sound)
		playsound(src,ab_sound,75,1)

	return TRUE

/////////////////////////////////////////////////////////////////
/obj/effect/shadekin_ability/phase_shift
	ability_name = "Phase Shift"
	desc = "Shift yourself out of alignment with realspace to travel quickly between dark areas (or light areas, with a price)."
	icon_state = "tech_passwall"
	cost = 100
	shift_mode = SHIFTED_OR_NOT
	ab_sound = 'sound/effects/stealthoff.ogg'
/obj/effect/shadekin_ability/phase_shift/do_ability()
	if(!..())
		return
	my_kin.phase_shift()
	if(my_kin.ability_flags & AB_PHASE_SHIFTED)
		cost = 0 //Shifting back is free (but harmful in light)
	else
		cost = initial(cost)
/////////////////////////////////////////////////////////////////
/obj/effect/shadekin_ability/heal_boop
	ability_name = "Regenerate Other"
	desc = "Spend energy to heal physical wounds in another creature."
	icon_state = "tech_biomedaura"
	cost = 50
	shift_mode = NOT_WHILE_SHIFTED
	ab_sound = 'sound/effects/EMPulse.ogg'
/obj/effect/shadekin_ability/heal_boop/do_ability()
	if(!..())
		return
	if(!my_kin.mend_other())
		my_kin.energy += cost //Refund due to abort
/*
/datum/modifier/shadekin/heal_boop
	name = "Shadekin Regen"
	desc = "You feel serene and well rested."
	mob_overlay_state = "green_sparkles"

	on_created_text = "<span class='notice'>Sparkles begin to appear around you, and all your ills seem to fade away.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although you feel much healthier than before.</span>"
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
*/
/////////////////////////////////////////////////////////////////
/obj/effect/shadekin_ability/create_shade
	ability_name = "Create Shade"
	desc = "Create a field of darkness that follows you."
	icon_state = "tech_dispelold"
	cost = 25
	shift_mode = NOT_WHILE_SHIFTED
	ab_sound = 'sound/effects/bamf.ogg'
/obj/effect/shadekin_ability/create_shade/do_ability()
	if(!..())
		return
	my_kin.add_modifier(/datum/modifier/shadekin/create_shade,20 SECONDS)
/*
/datum/modifier/shadekin/create_shade
	name = "Shadekin Shadegen"
	desc = "Darkness envelops you."
	mob_overlay_state = ""

	on_created_text = "<span class='notice'>You drag part of The Dark into realspace, enveloping yourself.</span>"
	on_expired_text = "<span class='warning'>You lose your grasp on The Dark and realspace reasserts itself.</span>"
	stacks = MODIFIER_STACK_EXTEND
	var/mob/living/simple_mob/shadekin/my_kin

/datum/modifier/shadekin/create_shade/tick()
	if(my_kin.ability_flags & AB_PHASE_SHIFTED)
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
*/
/*
/////////////////////////////////////////////////////////////////
/obj/effect/shadekin_ability/energy_feast
	ability_name = "Devour Energy"
	desc = "Devour the energy from another creature (potentially fatal)."
	icon_state = "gen_eat"
	cost = 25
	shift_mode = NOT_WHILE_SHIFTED
/obj/effect/shadekin_ability/energy_feast/do_ability()
	if(!..())
		return
*/