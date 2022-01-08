/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
	w_class = ITEMSIZE_TINY

/obj/item/clothing/mask/muzzle/Initialize()
    . = ..()
    say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
    say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/living/user as mob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state_slots = list(slot_r_hand_str = "sterile", slot_l_hand_str = "sterile")
	w_class = ITEMSIZE_SMALL
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)
	var/hanging = 0

/obj/item/clothing/mask/surgical/proc/adjust_mask(mob_user)
	if(usr.canmove && !usr.stat)
		src.hanging = !src.hanging
		if (src.hanging)
			gas_transfer_coefficient = 1
			body_parts_covered = body_parts_covered & ~FACE
			armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
			icon_state = "steriledown"
			to_chat(usr, "You pull the mask below your chin.")
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)
			armor = initial(armor)
			to_chat(usr, "You pull the mask up to cover your face.")
		update_clothing_icon()

/obj/item/clothing/mask/surgical/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	adjust_mask(usr)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0

//scarves (fit in in mask slot)
//None of these actually have on-mob sprites...
/obj/item/clothing/mask/bluescarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/redscarf
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/greenscarf
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/ninjascarf
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	siemens_coefficient = 0

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/shark
	name = "shark mask"
	desc = "A rubber shark mask."
	icon_state = "shark"
	flags_inv = HIDEFACE
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/dolphin
	name = "dolphin mask"
	desc = "A rubber dolphin mask."
	icon_state = "dolphin"
	flags_inv = HIDEFACE
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/goblin
	name = "goblin mask"
	desc = "A rubber goblin mask."
	icon_state = "goblin"
	flags_inv = HIDEFACE
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/demon
	name = "demon mask"
	desc = "A rubber demon mask."
	icon_state = "demon"
	flags_inv = HIDEFACE
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	w_class = ITEMSIZE_SMALL
	siemens_coefficient = 0.9

/obj/item/clothing/mask/nock_scarab
	name = "nock mask (blue, scarab)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_scarab"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_demon
	name = "nock mask (purple, demon)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_demon"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_life
	name = "nock mask (green, life)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_life"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_ornate
	name = "nock mask (red, ornate)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_ornate"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/horsehead/Initialize()
    . = ..()
    // The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
    say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
    say_verbs = list("whinnies", "neighs", "says")

/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")
	flags_inv = HIDEFACE
	body_parts_covered = 0
	var/mob/observer/eye/aiEye/eye

/obj/item/clothing/mask/ai/Initialize()
	. = ..()
	eye = new(src)

/obj/item/clothing/mask/ai/equipped(var/mob/user, var/slot)
	..(user, slot)
	if(slot == slot_wear_mask)
		eye.owner = user
		user.eyeobj = eye

		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)
		eye.setLoc(user)

/obj/item/clothing/mask/ai/dropped(var/mob/user)
	..()
	if(eye.owner == user)
		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)

		eye.owner.eyeobj = null
		eye.owner = null

/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining. Can be worn on the head or face."
	w_class = ITEMSIZE_TINY
	flags_inv = HIDEFACE
	slot_flags = SLOT_MASK|SLOT_HEAD
	body_parts_covered = FACE
	icon_state = "bandblack"
	item_state_slots = list(slot_r_hand_str = "bandblack", slot_l_hand_str = "bandblack")

/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	switch(slot)
		if(slot_wear_mask) //Mask is the default for all the settings
			flags_inv = initial(flags_inv)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)

		if(slot_head)
			flags_inv = 0
			body_parts_covered = HEAD
			icon_state = "[initial(icon_state)]_up"

	return ..()

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandred"
	item_state_slots = list(slot_r_hand_str = "bandred", slot_l_hand_str = "bandred")

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandblue"
	item_state_slots = list(slot_r_hand_str = "bandblue", slot_l_hand_str = "bandblue")

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgreen"
	item_state_slots = list(slot_r_hand_str = "bandgreen", slot_l_hand_str = "bandgreen")

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgold"
	item_state_slots = list(slot_r_hand_str = "bandgold", slot_l_hand_str = "bandgold")

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem. Can be worn on the head or face."
	icon_state = "bandskull"
	item_state_slots = list(slot_r_hand_str = "bandskull", slot_l_hand_str = "bandskull")

/obj/item/clothing/mask/veil
	name = "black veil"
	desc = "A black veil, typically worn at funerals or by goths."
	w_class = ITEMSIZE_TINY
	body_parts_covered = FACE
	icon_state = "veil"

/obj/item/clothing/mask/paper
	name = "paper mask"
	desc = "A neat, circular mask made out of paper. Perhaps you could try drawing on it with a pen!"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = FACE
	icon_state = "papermask"
	action_button_name = "Redraw Design"
	action_button_is_hands_free = TRUE
	var/list/papermask_designs = list()

/obj/item/clothing/mask/paper/Initialize(mapload)
	. = ..()
	papermask_designs = list(
		"Blank" = image(icon = src.icon, icon_state = "papermask"),
		"Neutral" = image(icon = src.icon, icon_state = "neutralmask"),
		"Eyes" = image(icon = src.icon, icon_state = "eyemask"),
		"Sleeping" = image(icon = src.icon, icon_state = "sleepingmask"),
		"Heart" = image(icon = src.icon, icon_state = "heartmask"),
		"Core" = image(icon = src.icon, icon_state = "coremask"),
		"Plus" = image(icon = src.icon, icon_state = "plusmask"),
		"Square" = image(icon = src.icon, icon_state = "squaremask"),
		"Bullseye" = image(icon = src.icon, icon_state = "bullseyemask"),
		"Vertical" = image(icon = src.icon, icon_state = "verticalmask"),
		"Horizontal" = image(icon = src.icon, icon_state = "horizontalmask"),
		"X" = image(icon = src.icon, icon_state = "xmask"),
		"Bugeyes" = image(icon = src.icon, icon_state = "bugmask"),
		"Double" = image(icon = src.icon, icon_state = "doublemask"),
		"Mark" = image(icon = src.icon, icon_state = "markmask")
		)

/obj/item/clothing/mask/paper/attack_self(mob/user)
	. = ..()
	if(!istype(user) || user.incapacitated())
		return

	var/static/list/options = list("Blank" = "papermask", "Neutral" = "neutralmask", "Eyes" = "eyemask",
							"Sleeping" ="sleepingmask", "Heart" = "heartmask", "Core" = "coremask",
							"Plus" = "plusmask", "Square" ="squaremask", "Bullseye" = "bullseyemask",
							"Vertical" = "verticalmask", "Horizontal" = "horizontalmask", "X" ="xmask",
							"Bugeyes" = "bugmask", "Double" = "doublemask", "Mark" = "markmask")

	var/choice = show_radial_menu(user, src, papermask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)

	if(src && choice && !user.incapacitated() && in_range(user,src))
		icon_state = options[choice]
		user.update_inv_wear_mask()
		user.update_action_buttons()
		to_chat(user, "<span class='notice'>Your paper mask now is now [choice].</span>")
		return 1

/obj/item/clothing/mask/emotions
	name = "emotional mask"
	desc = "Express your happiness or hide your sorrows with this modular cutout. Draw your current emotions onto it with a pen!"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = FACE
	icon_state = "joy"
	action_button_name = "Redraw Design"
	action_button_is_hands_free = TRUE
	var/static/list/joymask_designs = list()


/obj/item/clothing/mask/emotions/Initialize(mapload)
	. = ..()
	joymask_designs = list(
		"Joy" = image(icon = src.icon, icon_state = "joy"),
		"Flushed" = image(icon = src.icon, icon_state = "flushed"),
		"Pensive" = image(icon = src.icon, icon_state = "pensive"),
		"Angry" = image(icon = src.icon, icon_state = "angry"),
		)

/obj/item/clothing/mask/emotions/attack_self(mob/user)
	. = ..()
	if(!istype(user) || user.incapacitated())
		return

	var/static/list/options = list("Joy" = "joy", "Flushed" = "flushed", "Pensive" = "pensive","Angry" ="angry")

	var/choice = show_radial_menu(user, src, joymask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)

	if(src && choice && !user.incapacitated() && in_range(user,src))
		icon_state = options[choice]
		user.update_inv_wear_mask()
		user.update_action_buttons()
		to_chat(user, "<span class='notice'>Your [src] now displays a [choice] emotion.</span>")
		return 1

/obj/item/clothing/mask/mouthwheat
	name = "mouth wheat"
	desc = "100% synthetic \"Country Girls LLC.\" brand mouth wheat. Warning: not for actual consumption."
	icon_state = "mouthwheat"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = 0