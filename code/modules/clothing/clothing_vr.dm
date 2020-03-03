/obj/item/clothing
	var/recent_struggle = 0

/obj/item/clothing/shoes
	var/list/inside_emotes = list()
	var/recent_squish = 0
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/shoes.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/shoes.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/feet.dmi')

/obj/item/clothing/shoes/New()
	inside_emotes = list(
		"<font color='red'>You feel weightless for a moment as \the [name] moves upwards.</font>",
		"<font color='red'>\The [name] are a ride you've got no choice but to participate in as the wearer moves.</font>",
		"<font color='red'>The wearer of \the [name] moves, pressing down on you.</font>",
		"<font color='red'>More motion while \the [name] move, feet pressing down against you.</font>"
	)

	..()
/* //Must be handled in clothing.dm
/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	if(prob(1) && !recent_squish)
		recent_squish = 1
		spawn(100)
			recent_squish = 0
		for(var/mob/living/M in contents)
			var/emote = pick(inside_emotes)
			to_chat(M,emote)
	return
*/

//This is a crazy 'sideways' override.
/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/holder/micro))
		var/full = 0
		for(var/mob/M in src)
			full++
		if(full >= 2)
			to_chat(user, "<span class='warning'>You can't fit anyone else into \the [src]!</span>")
		else
			var/obj/item/weapon/holder/micro/holder = I
			if(holder.held_mob && holder.held_mob in holder)
				to_chat(holder.held_mob, "<span class='warning'>[user] stuffs you into \the [src]!</span>")
				holder.held_mob.forceMove(src)
				to_chat(user, "<span class='notice'>You stuff \the [holder.held_mob] into \the [src]!</span>")
	else
		..()

/obj/item/clothing/shoes/attack_self(var/mob/user)
	for(var/mob/M in src)
		M.forceMove(get_turf(user))
		to_chat(M, "<span class='warning'>[user] shakes you out of \the [src]!</span>")
		to_chat(user, "<span class='notice'>You shake [M] out of \the [src]!</span>")

	..()

/obj/item/clothing/gloves
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/gloves.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/gloves.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/hands.dmi')

/obj/item/clothing/ears
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/ears.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/ears.dmi')

/obj/item/clothing/relaymove(var/mob/living/user,var/direction)

	if(recent_struggle)
		return

	recent_struggle = 1

	spawn(100)
		recent_struggle = 0

	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.shoes == src)
			to_chat(H, "<font color='red'>[user]'s tiny body presses against you in \the [src], squirming!</font>")
			to_chat(user, "<font color='red'>Your body presses out against [H]'s form! Well, what little you can get to!</font>")
		else
			to_chat(H, "<font color='red'>[user]'s form shifts around in the \the [src], squirming!</font>")
			to_chat(user, "<font color='red'>You move around inside the [src], to no avail.</font>")
	else
		src.visible_message("<font color='red'>\The [src] moves a little!</font>")
		to_chat(user, "<font color='red'>You throw yourself against the inside of \the [src]!</font>")

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks_vr.dmi' // This is intentional because of our custom species.
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	item_icons = list(
		slot_wear_mask_str = 'icons/mob/mask_vr.dmi'
		)
	sprite_sheets = list(
		SPECIES_TESHARI		= 'icons/mob/species/seromi/masks_vr.dmi',
		SPECIES_VOX 		= 'icons/mob/species/vox/masks.dmi',
		SPECIES_TAJ 		= 'icons/mob/species/tajaran/mask_vr.dmi',
		SPECIES_UNATHI 		= 'icons/mob/species/unathi/mask_vr.dmi',
		SPECIES_SERGAL 		= 'icons/mob/species/sergal/mask_vr.dmi',
		SPECIES_NEVREAN 	= 'icons/mob/species/nevrean/mask_vr.dmi',
		SPECIES_ZORREN_HIGH	= 'icons/mob/species/fox/mask_vr.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/species/fennec/mask_vr.dmi',
		SPECIES_AKULA 		= 'icons/mob/species/akula/mask_vr.dmi',
		SPECIES_VULPKANIN 	= 'icons/mob/species/vulpkanin/mask.dmi',
		SPECIES_XENOCHIMERA	= 'icons/mob/species/tajaran/mask_vr.dmi',
		SPECIES_WEREBEAST	= 'icons/mob/species/werebeast/masks.dmi'
		)
//"Spider" 		= 'icons/mob/species/spider/mask_vr.dmi' Add this later when they have custom mask sprites and everything.

//Switch to taur sprites if a taur equips
/obj/item/clothing/suit
	var/taurized = FALSE //Easier than trying to 'compare icons' to see if it's a taur suit
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/suit.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/suit.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/suit.dmi')

/obj/item/clothing/suit/equipped(var/mob/user, var/slot)
	var/normalize = TRUE

	//Pyramid of doom-y. Improve somehow?
	if(!taurized && slot == slot_wear_suit && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isTaurTail(H.tail_style))
			var/datum/sprite_accessory/tail/taur/taurtail = H.tail_style
			if(taurtail.suit_sprites && (get_worn_icon_state(slot_wear_suit_str) in icon_states(taurtail.suit_sprites)))
				icon_override = taurtail.suit_sprites
				normalize = FALSE
				taurized = TRUE

	if(normalize && taurized)
		icon_override = initial(icon_override)
		taurized = FALSE

	return ..()

// Taur suits need to be shifted so its centered on their taur half.
/obj/item/clothing/suit/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask)
	var/image/standing = ..()
	if(taurized) //Special snowflake var on suits
		standing.pixel_x = -16
		standing.layer = BODY_LAYER + 15 // 15 is above tail layer, so will not be covered by taurbody.
	return standing

//TFF 5/8/19 - sets Vorestation /obj/item/clothing/under sensor setting default?
/obj/item/clothing/under
	sensor_mode = 3
	var/sensorpref = 5
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/uniform.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/uniform.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/uniform.dmi')

//TFF 5/8/19 - define numbers and specifics for suit sensor settings
/obj/item/clothing/under/New(var/mob/living/carbon/human/H)
	..()
	sensorpref = isnull(H) ? 1 : (ishuman(H) ? H.sensorpref : 1)
	switch(sensorpref)
		if(1) sensor_mode = 0				//Sensors off
		if(2) sensor_mode = 1				//Sensors on binary
		if(3) sensor_mode = 2				//Sensors display vitals
		if(4) sensor_mode = 3				//Sensors display vitals and enables tracking
		if(5) sensor_mode = pick(0,1,2,3)	//Select a random setting
		else
			sensor_mode = pick(0,1,2,3)
			log_debug("Invalid switch for suit sensors, defaulting to random. [sensorpref] chosen")

/obj/item/clothing/head
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/head.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/head.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/head.dmi')
