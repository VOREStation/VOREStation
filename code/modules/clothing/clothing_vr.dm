/obj/item/clothing
	var/recent_struggle = 0

/obj/item/clothing/shoes
	var/list/inside_emotes = list()
	var/recent_squish = 0
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/shoes.dmi',
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

/obj/item/clothing/shoes/container_resist(mob/living/micro)
	var/mob/living/carbon/human/macro = loc
	if(!istype(macro))
		to_chat(micro, "<span class='notice'>You start to climb out of [src]!</span>")
		if(do_after(micro, 50, src))
			to_chat(micro, "<span class='notice'>You climb out of [src]!</span>")
			micro.forceMove(loc)
		return

	var/escape_message_micro = "You start to climb out of [src]!"
	var/escape_message_macro = "Something is trying to climb out of your [src]!"
	var/escape_time = 60

	if(macro.shoes == src)
		escape_message_micro = "You start to climb around the larger creature's feet and ankles!"
		escape_time = 100

	to_chat(micro, "<span class='notice'>[escape_message_micro]</span>")
	to_chat(macro, "<span class='danger'>[escape_message_macro]</span>")
	if(!do_after(micro, escape_time, macro))
		to_chat(micro, "<span class='danger'>You're pinned underfoot!</span>")
		to_chat(macro, "<span class='danger'>You pin the escapee underfoot!</span>")
		return

	to_chat(micro, "<span class='notice'>You manage to escape [src]!</span>")
	to_chat(macro, "<span class='danger'>Someone has climbed out of your [src]!</span>")
	micro.forceMove(macro.loc)

/obj/item/clothing/gloves
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/gloves.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/gloves.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/hands.dmi')

/obj/item/clothing/ears
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/ears.dmi',
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
		SPECIES_TESHARI		= 'icons/mob/species/teshari/masks_vr.dmi',
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
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/suit.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/suit.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/suit.dmi')

//TFF 5/8/19 - sets Vorestation /obj/item/clothing/under sensor setting default?
/obj/item/clothing/under
	sensor_mode = 3
	var/sensorpref = 5
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/uniform.dmi',
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
		SPECIES_TESHARI = 'icons/mob/species/teshari/head.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/head.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/head.dmi')
