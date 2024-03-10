/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = TRUE

	var/predefined_icon_num

	var/datum/component/artifact_master/artifact_master = /datum/component/artifact_master

	var/being_used = 0

/obj/machinery/artifact/New()
	..()

	if(ispath(artifact_master))
		AddComponent(artifact_master)

		artifact_master = GetComponent(artifact_master)

	if(!istype(artifact_master))
		return

	var/datum/artifact_effect/my_effect = artifact_master.get_primary()

	if(!isnull(predefined_icon_num))
		icon_num = predefined_icon_num
	else
		icon_num = rand(0, 15)

	icon_state = "ano[icon_num]0"
	if(icon_num == 7 || icon_num == 8 || icon_num == 15)
		name = "large crystal"
		desc = pick("It shines faintly as it catches the light.",
		"It appears to have a faint inner glow.",
		"It seems to draw you inward as you look it at.",
		"Something twinkles faintly as you look at it.",
		"It's mesmerizing to behold.")
		if(prob(50))
			my_effect.trigger = TRIGGER_ENERGY
	else if(icon_num == 9 || icon_num == 17 || icon_num == 19)
		name = "alien computer"
		desc = "It is covered in strange markings."
		if(prob(75))
			my_effect.trigger = TRIGGER_TOUCH
	else if(icon_num == 10)
		desc = "A large alien device, there appear to be some kind of vents in the side."
		if(prob(50))
			my_effect.trigger = pick(TRIGGER_ENERGY, TRIGGER_HEAT, TRIGGER_COLD, TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)
	else if(icon_num == 11)
		name = "sealed alien pod"
		desc = "A strange alien device."
		if(prob(25))
			my_effect.trigger = pick(TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN)
	else if(icon_num == 12 || icon_num == 14)
		name = "intricately carved statue"
		desc = "A strange statue."
		if(prob(60))
			my_effect.trigger = pick(TRIGGER_TOUCH, TRIGGER_HEAT, TRIGGER_COLD, TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)

/obj/machinery/artifact/update_icon()
	..()

	if(LAZYLEN(artifact_master.get_active_effects()))
		icon_state = "ano[icon_num]1"
	else
		icon_state = "ano[icon_num]0"
