/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 500)
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	var/elastic
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"
	var/use_time = 30
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/handcuffs.dmi')

/obj/item/handcuffs/get_worn_icon_state(var/slot_name)
	if(slot_name == slot_handcuffed_str)
		return "handcuff1" //Simple

	return ..()

/obj/item/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_handcuffs(user, user)
		return

	if(!C.handcuffed)
		if (C == user)
			place_handcuffs(user, user)
			return

		//check for an aggressive grab (or robutts)
		if(can_place(C, user))
			place_handcuffs(C, user)
		else
			to_chat(user, "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>")

/obj/item/handcuffs/proc/can_place(var/mob/target, var/mob/user)
	if(user == target)
		return 1
	if(istype(user, /mob/living/silicon/robot))
		if(user.Adjacent(target))
			return 1
	else
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.loc == user && G.state >= GRAB_AGGRESSIVE)
				return 1
	return 0

/obj/item/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if (!H.has_organ_for_slot(slot_handcuffed))
		to_chat(user, "<span class='danger'>\The [H] needs at least two wrists before you can cuff them together!</span>")
		return 0

	if(istype(H.gloves,/obj/item/clothing/gloves/gauntlets/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.gloves]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_after(user,use_time))
		return 0

	if(!can_place(target, user)) //victim may have resisted out of the grab in the meantime
		return 0

	add_attack_logs(user,H,"Handcuffed (attempt)")
	feedback_add_details("handcuffs","H")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(get_turf(user))
	else
		user.drop_from_inventory(cuffs)
	cuffs.loc = target
	target.handcuffed = cuffs
	target.update_handcuffed()
	target.drop_r_hand()
	target.drop_l_hand()
	target.stop_pulling()
	return 1

/obj/item/handcuffs/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == slot_handcuffed)
		user.drop_r_hand()
		user.drop_l_hand()
		user.stop_pulling()

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != I_HURT) return
	if (H.zone_sel.selecting != O_MOUTH) return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[(H.hand ? BP_L_HAND : BP_R_HAND)]
	if (!O) return

	var/datum/gender/T = gender_datums[H.get_visible_gender()]

	var/s = "<span class='warning'>[H.name] chews on [T.his] [O.name]!</span>"
	H.visible_message(s, "<span class='warning'>You chew on your [O.name]!</span>")
	add_attack_logs(H,H,"chewed own [O.name]")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/handcuffs/fuzzy
	name = "fuzzy cuffs"
	icon_state = "fuzzycuff"
	breakouttime = 100 //VOREstation edit
	desc = "Use this to keep... 'prisoners' in line."

/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"
	elastic = 1

/obj/item/handcuffs/cable/red
	color = "#DD0000"

/obj/item/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/handcuffs/cable/green
	color = "#00DD00"

/obj/item/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/handcuffs/cyborg
	dispenser = 1

/obj/item/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 200
	cuff_type = "duct tape"

/obj/item/handcuffs/cable/tape/cyborg
	dispenser = TRUE

//Legcuffs. Not /really/ handcuffs, but its close enough.
/obj/item/handcuffs/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "legcuff"
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	breakouttime = 300	//Deciseconds = 30s = 0.5 minute
	cuff_type = "legcuffs"
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/handcuffs.dmi')
	elastic = 0
	cuff_sound = 'sound/weapons/handcuffs.ogg' //This shold work for now.

/obj/item/handcuffs/legcuffs/get_worn_icon_state(var/slot_name)
	if(slot_name == slot_legcuffed_str)
		return "legcuff1"

	return ..()

/obj/item/handcuffs/legcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)
	if(!user.IsAdvancedToolUser())
		return

	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_legcuffs(user, user)
		return

	if(!C.legcuffed)
		if (C == user)
			place_legcuffs(user, user)
			return

		//check for an aggressive grab (or robutts)
		if(can_place(C, user))
			place_legcuffs(C, user)
		else
			to_chat(user, "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>")

/obj/item/handcuffs/legcuffs/proc/place_legcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if (!H.has_organ_for_slot(slot_legcuffed))
		to_chat(user, "<span class='danger'>\The [H] needs at least two ankles before you can cuff them together!</span>")
		return 0

	if(istype(H.shoes,/obj/item/clothing/shoes/magboots/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.shoes]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_after(user,use_time))
		return 0

	if(!can_place(target, user)) //victim may have resisted out of the grab in the meantime
		return 0

	add_attack_logs(user,H,"Legcuffed (attempt)")
	feedback_add_details("legcuffs","H")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/handcuffs/legcuffs/lcuffs = src
	if(dispenser)
		lcuffs = new(get_turf(user))
	else
		user.drop_from_inventory(lcuffs)
	lcuffs.loc = target
	target.legcuffed = lcuffs
	target.update_inv_legcuffed()
	if(target.m_intent != "walk")
		target.m_intent = "walk"
		if(target.hud_used && user.hud_used.move_intent)
			target.hud_used.move_intent.icon_state = "walking"
	return 1

/obj/item/handcuffs/legcuffs/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == slot_legcuffed)
		if(user.m_intent != "walk")
			user.m_intent = "walk"
			if(user.hud_used && user.hud_used.move_intent)
				user.hud_used.move_intent.icon_state = "walking"


/obj/item/handcuffs/legcuffs/bola
	name = "bola"
	desc = "Keeps prey in line."
	elastic = 1
	use_time = 0
	breakouttime = 30
	cuff_sound = 'sound/weapons/towelwipe.ogg' //Is there anything this sound can't do?

/obj/item/handcuffs/legcuffs/bola/can_place(var/mob/target, var/mob/user)
	if(user) //A ranged legcuff, until proper implementation as items it remains a projectile-only thing.
		return 1

<<<<<<< HEAD
/obj/item/weapon/handcuffs/legcuffs/bola/dropped()
	visible_message("<b>\The [src]</b> falls apart!")
=======
/obj/item/handcuffs/legcuffs/bola/dropped()
	visible_message("<span class='notice'>\The [src] falls apart!</span>")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	qdel(src)

/obj/item/handcuffs/legcuffs/bola/place_legcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		src.dropped()
		return 0

	if(!H.has_organ_for_slot(slot_legcuffed))
		H.visible_message("<b>\The [src]</b> slams into [H], but slides off!")
		src.dropped()
		return 0

	H.visible_message("<span class='danger'>\The [H] has been snared by \the [src]!</span>")

	// Apply cuffs.
	var/obj/item/handcuffs/legcuffs/lcuffs = src
	lcuffs.loc = target
	target.legcuffed = lcuffs
	target.update_inv_legcuffed()
	if(target.m_intent != "walk")
		target.m_intent = "walk"
		if(target.hud_used && user.hud_used.move_intent)
			target.hud_used.move_intent.icon_state = "walking"
	return 1

/obj/item/weapon/handcuffs/cable/plantfiber
	name = "rope bindings"
	desc = "A length of rope fashioned to hold someone's hands together."
	color = "#7e6442"
