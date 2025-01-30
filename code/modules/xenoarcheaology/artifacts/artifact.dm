//Xenoarch machinery spawning code!
//These are colloquially refered to 'large' artifacts.
//The below dictates the icon, description, and the activation requirement.
//Additionally, it updates the icon based on if it's active or not.
//What the artifact does itself is dictated by effect.dm.

/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = TRUE
	//Note: If you adminspawn this, it will NOT have an assosciated artifact_id. You have to manually set it!

	var/predefined_icon_num

	var/datum/component/artifact_master/artifact_master = /datum/component/artifact_master

/obj/machinery/artifact/Destroy()
	if(artifact_master)
		var/datum/component/artifact_master/arti_mstr = artifact_master
		arti_mstr.RemoveComponent()
		artifact_master = null
		if(!QDELETED(arti_mstr))
			qdel(arti_mstr)
	. = ..()

/obj/machinery/artifact/New()
	..()

	if(ispath(artifact_master))
		AddComponent(artifact_master)

		artifact_master = GetComponent(artifact_master)

	if(!istype(artifact_master))
		return

	var/datum/artifact_effect/my_effect = artifact_master.get_primary() //Gets the primary effect of the artifact.

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
		my_effect.trigger = pick(TRIGGER_ENERGY, TRIGGER_TOUCH)
	else if(icon_num == 9 || icon_num == 17 || icon_num == 19)
		name = "alien computer"
		desc = "It is covered in strange markings."
		my_effect.trigger = TRIGGER_TOUCH
	else if(icon_num == 10)
		desc = "A large alien device, there appear to be some kind of vents in the side."
		my_effect.trigger = pick(TRIGGER_ENERGY, TRIGGER_HEAT, TRIGGER_COLD, TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)
	else if(icon_num == 11)
		name = "sealed alien pod"
		desc = "A strange alien device."
		my_effect.trigger = pick(TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN)
	else if(icon_num == 12 || icon_num == 14)
		name = "intricately carved statue"
		desc = "A strange statue."
		my_effect.trigger = pick(TRIGGER_TOUCH, TRIGGER_HEAT, TRIGGER_COLD, TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)

/obj/machinery/artifact/update_icon()
	..()

	if(LAZYLEN(artifact_master.get_active_effects()))
		icon_state = "ano[icon_num]1"
	else
		icon_state = "ano[icon_num]0"
