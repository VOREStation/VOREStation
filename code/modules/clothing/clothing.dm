/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	var/list/species_restricted = null //Only these species can wear this kit.
	var/gunshot_residue //Used by forensics.

	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories

	/*
		Sprites used when the clothing item is refit. This is done by setting icon_override.
		For best results, if this is set then sprite_sheets should be null and vice versa, but that is by no means necessary.
		Ideally, sprite_sheets_refit should be used for "hard" clothing items that can't change shape very well to fit the wearer (e.g. helmets, hardsuits),
		while sprite_sheets should be used for "flexible" clothing items that do not need to be refitted (e.g. aliens wearing jumpsuits).
	*/
	var/list/sprite_sheets_refit = null
	var/ear_protection = 0

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	..()
	gunshot_residue = null

/obj/item/clothing/New()
	..()
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && istype(M,/mob/living/carbon/human))
		var/exclusive = null
		var/wearable = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		if(H.species)
			if(exclusive)
				if(!(H.species.get_bodytype(H) in species_restricted))	//Vorestation edit
					wearable = 1
			else
				if(H.species.get_bodytype(H) in species_restricted)	//Vorestation edit
					wearable = 1

			if(!wearable && !(slot in list(slot_l_store, slot_r_store, slot_s_store)))
				H << "<span class='danger'>Your species cannot wear [src].</span>"
				return 0
	return 1

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if("Human", "Skrell")	//humanoid bodytypes
			species_restricted = list("Human", "Skrell", "Promethean") //skrell/humans can wear each other's suits
		else
			species_restricted = list(target_species)

	//Set icon
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		icon_override = sprite_sheets_refit[target_species]
	else
		icon_override = initial(icon_override)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/head/helmet/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if("Skrell")
			species_restricted = list("Human", "Skrell", "Promethean") //skrell helmets fit humans too

		else
			species_restricted = list(target_species)

	//Set icon
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		icon_override = sprite_sheets_refit[target_species]
	else
		icon_override = initial(icon_override)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/ears.dmi')

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = ITEMSIZE_HUGE
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		set_dir(O.dir)

////////////////////////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.75
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/fingerprint_chance = 0	//How likely the glove is to let fingerprints through
	var/obj/item/clothing/gloves/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping
	var/glove_level = 2	//What "layer" the glove is on
	var/overgloves = 0	//Used by gauntlets and arm_guards
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/gloves.dmi',
		"Vox" = 'icons/mob/species/vox/gloves.dmi'
		)

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	if(ring)
		ring.emp_act(severity)
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/*/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		if (clipped)
			user << "<span class='notice'>The [src] have already been clipped!</span>"
			update_icon()
			return

		playsound(src.loc, W.usesound, 50, 1)
		user.visible_message("<font color='red'>[user] cuts the fingertips off of the [src].</font>","<font color='red'>You cut the fingertips off of the [src].</font>")

		clipped = 1
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		if("exclude" in species_restricted)
			species_restricted -= "Unathi"
			species_restricted -= "Tajara"
		return
*/

/obj/item/clothing/gloves/mob_can_equip(mob/user, slot)
	var/mob/living/carbon/human/H = user

	if(slot && slot == slot_gloves)
		if(istype(H.gloves, /obj/item/clothing/gloves/ring))
			ring = H.gloves
			if(ring.glove_level >= src.glove_level)
				to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
				ring = null
				return 0
			else
				H.drop_from_inventory(ring)	//Remove the ring (or other under-glove item in the hand slot?) so you can put on the gloves.
				ring.forceMove(src)
				to_chat(user, "You slip \the [src] on over \the [src.ring].")
		else
			ring = null

	if(!..())
		if(ring) //Put the ring back on if the check fails.
			if(H.equip_to_slot_if_possible(ring, slot_gloves))
				src.ring = null
		return 0

	wearer = H //TODO clean this when magboots are cleaned
	return 1

/obj/item/clothing/gloves/dropped()
	..()

	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(ring && istype(H))
		if(!H.equip_to_slot_if_possible(ring, slot_gloves))
			ring.forceMove(get_turf(src))
		src.ring = null
	wearer = null

/////////////////////////////////////////////////////////////////////
//Rings

/obj/item/clothing/gloves/ring
	name = "ring"
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/clothing/rings.dmi'
	gender = NEUTER
	species_restricted = list("exclude", "Diona")
	siemens_coefficient = 1
	glove_level = 1
	fingerprint_chance = 100

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEMSIZE_SMALL

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/head.dmi',
		"Vox" = 'icons/mob/species/vox/head.dmi'
		)

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]"
			return
		on = !on
		user << "You [on ? "enable" : "disable"] the helmet light."
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		user << "<span class='warning'>You are already wearing a hat.</span>"
	else if(success == 1)
		user << "<span class='notice'>You crawl under \the [src].</span>"
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)

	overlays.Cut()
	var/mob/living/carbon/human/H
	if(istype(user,/mob/living/carbon/human))
		H = user

	if(on)

		// Generate object icon.
		if(!light_overlay_cache["[light_overlay]_icon"])
			light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
		overlays |= light_overlay_cache["[light_overlay]_icon"]

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/cache_key = "[light_overlay][H ? "_[H.species.get_bodytype(H)]" : ""]"
		if(!light_overlay_cache[cache_key])
			var/use_icon = 'icons/mob/light_overlays.dmi'
			if(H && sprite_sheets[H.species.get_bodytype(H)])
				use_icon = sprite_sheets[H.species.get_bodytype(H)]
			light_overlay_cache[cache_key] = image("icon" = use_icon, "icon_state" = "[light_overlay]")

	if(H)
		H.update_inv_head()

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/masks.dmi',
		"Vox" = 'icons/mob/species/vox/masks.dmi',
		"Tajara" = 'icons/mob/species/tajaran/mask.dmi',
		"Unathi" = 'icons/mob/species/unathi/mask.dmi'
		)

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_shoes.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_shoes.dmi',
		)
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	var/can_hold_knife = 0
	var/obj/item/holding

	var/shoes_under_pants = 0

	var/water_speed = 0		//Speed boost/decrease in water, lower/negative values mean more speed
	var/snow_speed = 0		//Speed boost/decrease on snow, lower/negative values mean more speed

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	force = 2
	var/overshoes = 0
	species_restricted = list("exclude","Teshari", "Vox")
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/shoes.dmi',
		"Vox" = 'icons/mob/species/vox/shoes.dmi'
		)

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "IC"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message("<span class='danger'>\The [usr] pulls a knife out of their boot!</span>")
		holding = null
	else
		usr << "<span class='warning'>Your need an empty, unbroken hand to do that.</span>"
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()
	return

/obj/item/clothing/shoes/attack_hand(var/mob/living/M)
	if(can_hold_knife == 1 && holding && src.loc == M)
		draw_knife()
		return
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if((can_hold_knife == 1) && (istype(I, /obj/item/weapon/material/shard) || \
	 istype(I, /obj/item/weapon/material/butterfly) || \
	 istype(I, /obj/item/weapon/material/kitchen/utensil) || \
	 istype(I, /obj/item/weapon/material/hatchet/tacknife)))
		if(holding)
			user << "<span class='warning'>\The [src] is already holding \a [holding].</span>"
			return
		user.unEquip(I)
		I.forceMove(src)
		holding = I
		user.visible_message("<span class='notice'>\The [user] shoves \the [I] into \the [src].</span>")
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else
		return ..()

/obj/item/clothing/shoes/verb/toggle_layer()
	set name = "Switch Shoe Layer"
	set category = "Object"

	if(shoes_under_pants == -1)
		usr << "<span class='notice'>\The [src] cannot be worn above your suit!</span>"
		return
	shoes_under_pants = !shoes_under_pants
	update_icon()

/obj/item/clothing/shoes/update_icon()
	overlays.Cut()
	if(holding)
		overlays += image(icon, "[icon_state]_knife")
	if(ismob(usr))
		var/mob/M = usr
		M.update_inv_shoes()
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	if(prob(1) && !recent_squish) //VOREStation edit begin
		recent_squish = 1
		spawn(100)
			recent_squish = 0
		for(var/mob/living/M in contents)
			var/emote = pick(inside_emotes)
			M << emote //VOREStation edit end
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_suits.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_suits.dmi',
		)
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/weapon/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/suit.dmi',
		"Vox" = 'icons/mob/species/vox/suit.dmi'
		)

	valid_accessory_slots = list("over", "armband")
	restricted_accessory_slots = list("armband")

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = ITEMSIZE_NORMAL
	show_messages = 1

	var/has_sensor = 1 //For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/uniform.dmi',
		"Vox" = 'icons/mob/species/vox/uniform.dmi'
		)

	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/worn_state = null
	valid_accessory_slots = list("utility","armband","decor","over")
	restricted_accessory_slots = list("utility", "armband")

	var/icon/rolled_down_icon = 'icons/mob/uniform_rolled_down.dmi'
	var/icon/rolled_down_sleeves_icon = 'icons/mob/uniform_sleeves_rolled.dmi'


/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/New()
	..()
	if(worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[slot_w_uniform_str] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability
	if(rolled_down < 0)
		if(("[worn_state]_d_s" in icon_states(INV_W_UNIFORM_DEF_ICON)) || ("[worn_state]_s" in icon_states(rolled_down_icon)) || ("[worn_state]_d_s" in icon_states(icon_override)))
			rolled_down = 0

	if(rolled_down == -1)
		verbs -= /obj/item/clothing/under/verb/rollsuit
	if(rolled_sleeves == -1)
		verbs -= /obj/item/clothing/under/verb/rollsleeves

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else if ("[worn_state]_s" in icon_states(rolled_down_icon))
		under_icon = rolled_down_icon
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_icon && "[worn_state]_s" in icon_states(under_icon)) || ("[worn_state]_d_s" in icon_states(under_icon)))
		if(rolled_down != 1)
			rolled_down = 0
	else
		rolled_down = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else if ("[worn_state]_s" in icon_states(rolled_down_sleeves_icon))
		under_icon = rolled_down_sleeves_icon
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_sleeves_icon && "[worn_state]_s" in icon_states(under_icon)) || ("[worn_state]_r_s" in icon_states(under_icon)))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform()


/obj/item/clothing/under/examine(mob/user)
	..(user)
	switch(src.sensor_mode)
		if(0)
			user << "Its sensors appear to be disabled."
		if(1)
			user << "Its binary life sensors appear to be enabled."
		if(2)
			user << "Its vital tracker appears to be enabled."
		if(3)
			user << "Its vital tracker and tracking beacon appear to be enabled."

/obj/item/clothing/under/proc/set_sensors(mob/usr as mob)
	var/mob/M = usr
	if (istype(M, /mob/observer)) return
	if (usr.stat || usr.restrained()) return
	if(has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		usr << "You have moved too far away."
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				usr.visible_message("[usr] adjusts their sensors.", "You disable your suit's remote sensing equipment.")
			if(1)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report whether you are live or dead.")
			if(2)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report your vital lifesigns.")
			if(3)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report your vital lifesigns as well as your coordinate position.")

	else if (istype(src.loc, /mob))
		usr.visible_message("[usr] adjusts [src.loc]'s sensors.", "You adjust [src.loc]'s sensors.")

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)
	..()

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rolldown_status()
	if(rolled_down == -1)
		usr << "<span class='notice'>You cannot roll down [src]!</span>"
		return
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered = initial(body_parts_covered)
		body_parts_covered &= ~(UPPER_TORSO|ARMS)
		if("[worn_state]_s" in icon_states(rolled_down_icon))
			icon_override = rolled_down_icon
			item_state_slots[slot_w_uniform_str] = "[worn_state]"
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]_d"

		usr << "<span class='notice'>You roll down your [src].</span>"
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_icon)
			icon_override = initial(icon_override)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
		usr << "<span class='notice'>You roll up your [src].</span>"
	update_clothing_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rollsleeves_status()
	if(rolled_sleeves == -1)
		usr << "<span class='notice'>You cannot roll up your [src]'s sleeves!</span>"
		return
	if(rolled_down == 1)
		usr << "<span class='notice'>You must roll up your [src] first!</span>"
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS)
		if("[worn_state]_s" in icon_states(rolled_down_sleeves_icon))
			icon_override = rolled_down_sleeves_icon
			item_state_slots[slot_w_uniform_str] = "[worn_state]"
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]_r"
		usr << "<span class='notice'>You roll up your [src]'s sleeves.</span>"
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_sleeves_icon)
			icon_override = initial(icon_override)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
		usr << "<span class='notice'>You roll down your [src]'s sleeves.</span>"
	update_clothing_icon()


/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0,1,2,3)
	..()
