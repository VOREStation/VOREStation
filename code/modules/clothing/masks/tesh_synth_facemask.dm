//TESHARI FACE MASK //Defning all the procs in one go
/obj/item/clothing/mask/synthfacemask
	name = "Synth Face"
	desc = "A round dark muzzle made of LEDs."
	flags = PHORONGUARD //Since it cant easily be removed...
	item_flags = AIRTIGHT | FLEXIBLEMATERIAL | BLOCK_GAS_SMOKE_EFFECT //This should make it properly work as a mask... and allow you to eat stuff through it!
	icon = 'icons/mob/species/teshari/synth_facemask.dmi'
	icon_override = 'icons/mob/species/teshari/synth_facemask.dmi'
	icon_state = "synth_facemask"
	origin_tech = list(TECH_ILLEGAL = 1)
	var/lstat
	var/visor_state = "Neutral" //Separating this from lstat so that it could potentially be used for an override system or something
	var/mob/living/carbon/maskmaster

/obj/item/clothing/mask/synthfacemask/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		canremove = 0
		maskmaster = H
		START_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/synthfacemask/dropped(mob/user)
	canremove = 1
	maskmaster = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/clothing/mask/synthfacemask/Destroy()
	maskmaster = null
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/synthfacemask/mob_can_equip(var/mob/living/carbon/human/user, var/slot, var/disable_warning = FALSE)
	if (!..())
		return 0
	if(istype(user))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		if(istype(E) && (E.robotic >= ORGAN_ROBOT))
			return 1
		to_chat(user, span_warning("You must have a compatible robotic head to install this upgrade."))
	return 0

/obj/item/clothing/mask/synthfacemask/update_icon()
	var/mob/living/carbon/human/H = loc
	switch(visor_state)
		if (DEAD)
			icon_state = "synth_facemask_dead"
		else
			icon_state = "synth_facemask"
	if(istype(H)) H.update_inv_wear_mask()

/obj/item/clothing/mask/synthfacemask/process()
	if(maskmaster && lstat != maskmaster.stat)
		lstat = maskmaster.stat
		visor_state = "Neutral" //This does nothing at the moment, but it's there incase anyone wants to add more states.
		//Maybe a verb that sets an emote override here
		if(lstat == DEAD)
			visor_state = DEAD
		update_icon()


//LOADOUT ITEM
/datum/gear/mask/synthface/
	display_name = "Synth Facemask (Teshari)"
	path = /obj/item/clothing/mask/synthfacemask
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 1

/datum/gear/mask/synthface/New()
	..()
	gear_tweaks += list(gear_tweak_free_color_choice)
