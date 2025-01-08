/*
A collection of Protean rigsuit modules, intended to encourage Symbiotic relations with a host.
All of these should require someone else to be wearing the Protean to function.
These should come standard with the Protean rigsuit, unless you want them to work for some upgrades.
*/


//This rig module feeds nutrition directly from the wearer to the Protean, to help them stay charged while worn.
/obj/item/rig_module/protean
	permanent = 1

/obj/item/rig_module/protean/syphon
	name = "Protean Metabolic Syphon"
	desc = "This should never be outside of a RIG."
	icon_state = "flash"
	interface_name = "Protean Metabolic Syphon"
	interface_desc = "Toggle to drain nutrition/power from the user directly into the Protean's own energy stores."
	toggleable = 1
	activate_string = "Enable Syphon"
	deactivate_string = "Disable Syphon"

/obj/item/rig_module/protean/syphon/activate()
	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	if(H)
		to_chat(usr, span_boldnotice("You activate the suit's energy syphon."))
		to_chat(H, span_warning("Your suit begins to sap at your own energy stores."))
		active = 1
	else
		return 0

/obj/item/rig_module/protean/syphon/deactivate(var/forced)
	if(!..())
		return 0
	if(forced)
		active = 0
		return
	var/mob/living/carbon/human/H = holder.wearer
	if(H)
		to_chat(usr, span_boldnotice("You deactivate the suit's energy syphon."))
		to_chat(H, span_warning("Your suit ceases from sapping your own energy."))
		active = 0
	else
		return 0

/obj/item/rig_module/protean/syphon/process()
	if(active)
		var/mob/living/carbon/human/H = holder.wearer
		var/mob/living/P = holder?:myprotean
		if(istype(H.species, /datum/species/protean))
			to_chat(H, span_warning("Your Protean modules do not function on yourself."))
			deactivate(1)
		else
			P = P?:humanform
			if((H.nutrition >= 100) && (P.nutrition <= 5000))
				H.nutrition -= 10
				P.nutrition += 10

//This rig module allows a worn Protean to toggle and configure its armor settings.
/obj/item/rig_module/protean/armor
	name = "Protean Adaptive Armor"
	desc = "This should never be outside of a RIG."
	interface_name = "Protean Adaptive Armor"
	interface_desc = "Adjusts the proteans deployed armor values to fit the needs of the wearer."
	usable = 1
	toggleable = 1
	activate_string = "Enable Armor"
	deactivate_string = "Disable Armor"
	engage_string = "Configure Armor"
	var/list/armor_settings = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0)
	var/armor_weight_ratio = 0.01	//This amount of slowdown per 1% of armour. 3 slowdown at the max armour.

/obj/item/rig_module/protean/armor/engage()
	var/armor_chosen = input(usr, "Which armor to adjust?", "Protean Armor") as null|anything in armor_settings
	if(armor_chosen)
		var/armorvalue = tgui_input_number(usr, "Set armour reduction value (Max of 60%)", "Protean Armor",0,60)
		if(isnum(armorvalue))
			armor_settings[armor_chosen] = armorvalue
			interface_desc = initial(interface_desc)
			slowdown = 0
			for(var/entry in armor_settings)	//This is dumb and ugly but I dont feel like rewriting rig TGUI just to make this a pretty list
				interface_desc += " [entry]: [armor_settings[entry]]"
				slowdown += armor_settings[entry]*armor_weight_ratio
			interface_desc += " Slowdown: [slowdown]"

/obj/item/rig_module/protean/armor/activate()
	if(holder?:assimilated_rig)
		to_chat(usr, span_bolddanger("Armor module non-functional while a RIG is assimilated."))
		return
	if(!..(1))
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	if(H)
		var/list/temparmor = list("bio" = 100, "rad" = 100)
		temparmor = armor_settings + temparmor
		to_chat(usr, span_boldnotice("You signal the suit to harden."))
		to_chat(H, span_notice("Your suit hardens in response to physical trauma."))
		holder.armor = temparmor.Copy()
		for(var/obj/item/piece in list(holder.gloves,holder.helmet,holder.boots,holder.chest))
			piece.armor = temparmor.Copy()
		holder.slowdown = slowdown
		active = 1
	else
		return 0

/obj/item/rig_module/protean/armor/deactivate(var/forced)
	if(!..(1))
		return 0
	if(forced)
		holder.armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100)
		for(var/obj/item/piece in list(holder.gloves,holder.helmet,holder.boots,holder.chest))
			piece.armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100)
		holder.slowdown = initial(slowdown)
		active = 0
		return
	var/mob/living/carbon/human/H = holder.wearer
	if(H)
		to_chat(usr, span_boldnotice("You signal the suit to relax."))
		to_chat(H, span_warning("Your suit softens."))
		holder.armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100)
		for(var/obj/item/piece in list(holder.gloves,holder.helmet,holder.boots,holder.chest))
			piece.armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100)
		holder.slowdown = initial(slowdown)
		active = 0
	else
		return 0

/obj/item/rig_module/protean/armor/process()
	if(active)
		var/mob/living/carbon/human/H = holder.wearer
		if(!H)
			deactivate(1)
			return
		if(istype(H.species, /datum/species/protean))
			to_chat(H, span_warning("Your Protean modules do not function on yourself."))
			deactivate(1)


//This rig module lets a Protean expend its metal stores to heal its host
/obj/item/rig_module/protean/healing
	name = "Protean Restorative Nanites"
	desc = "This should never be outside of a RIG."
	interface_name = "Protean Restorative Nanites"
	interface_desc = "Utilises stored steel from the Protean to slowly heal and repair the wearer."
	toggleable = 1
	activate_string = "Enable Healing"
	deactivate_string = "Disable Healing"
	var/datum/modifier/healing

/obj/item/rig_module/protean/healing/activate()
	if(!..(1))
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	var/mob/living/P = holder?:myprotean
	if(H && P)
		if(istype(H.species, /datum/species/protean))
			to_chat(H, span_warning("Your Protean modules do not function on yourself."))
			return 0
		var/obj/item/organ/internal/nano/refactory/R = P.nano_get_refactory()
		if(R.get_stored_material(MAT_STEEL) >= 100)
			healing = holder.wearer.add_modifier(/datum/modifier/protean/steel, origin = R)
			to_chat(usr, span_boldnotice("You activate the suit's restorative nanites."))
			to_chat(H, span_warning("Your suit begins mending your injuries."))
			active = 1
			return 1
	return 0

/obj/item/rig_module/protean/healing/deactivate()
	if(!..(1))
		return 0
	var/mob/living/carbon/human/H = holder.wearer
	if(H)
		to_chat(usr, span_boldnotice("You deactivate the suit's restorative nanites."))
		to_chat(H, span_warning("Your suit is no longer mending your injuries."))
		active = 0
		if(healing)
			healing.expire()
			healing = null
		return 1
	else
		return 0

/obj/item/rig_module/protean/healing/process()
	if(active)
		var/mob/living/carbon/human/H = holder.wearer
		var/mob/living/P = holder?:myprotean
		if(!H || !P)
			deactivate()
			return
		if(istype(H.species, /datum/species/protean))
			to_chat(H, span_warning("Your Protean modules do not function on yourself."))
			deactivate()
			return
		var/obj/item/organ/internal/nano/refactory/R = P.nano_get_refactory()
		if((!R.get_stored_material(MAT_STEEL)))
			to_chat(H, span_warning("Your [holder] is out of steel."))
			deactivate()
			return

/obj/item/rig_module/protean/healing/accepts_item(var/obj/item/stack/material/steel/S, var/mob/living/user)

	if(!istype(S) || !istype(user))
		return 0

	var/mob/living/P = holder?:myprotean
	var/obj/item/organ/internal/nano/refactory/R = P?.nano_get_refactory()

	if(R?.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
		to_chat(user, span_boldnotice("You directly feed some steel to the [holder]."))
		return 1
	return 0
