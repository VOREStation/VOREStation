/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = ITEMSIZE_NORMAL

	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/abstract = 0
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/usesound = null // Like hitsound, but for when used properly and not to kill someone.
	var/storage_cost = null
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	var/no_attack_log = 0			//If it's an item we don't want to log attack_logs with, set this to 1
	pass_flags = PASSTABLE
	pressure_resistance = 5
//	causeerrorheresoifixthis
	var/obj/item/master = null
	var/list/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/force = 0

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/max_pressure_protection // Set this variable if the item protects its wearer against high pressures below an upper bound. Keep at null to disable protection.
	var/min_pressure_protection // Set this variable if the item protects its wearer against low pressures above a lower bound. Keep at null to disable protection. 0 represents protection against hard vacuum.


	var/datum/action/item_action/action = null
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.
	var/action_button_is_hands_free = 0 //If 1, bypass the restrained, lying, and stunned checks action buttons normally test for

	//This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	//It should be used purely for appearance. For gameplay effects caused by items covering body parts, use body_parts_covered.
	var/flags_inv = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/item_flags = 0 //Miscellaneous flags pertaining to equippable objects.

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/canremove = 1 //Mostly for Ninja code at this point but basically will not allow the item to be removed if set to 0. /N
	var/list/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/armorsoak = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
	var/zoomdevicename = null //name used for message when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.

	var/embed_chance = -1	//0 won't embed, and 100 will always embed

	var/icon_override = null  //Used to override hardcoded clothing dmis in human clothing proc.

	//** These specify item/icon overrides for _slots_

	var/list/item_state_slots = list() //overrides the default item_state for particular slots.

	// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons = list()

	//** These specify item/icon overrides for _species_

	/* Species-specific sprites, concept stolen from Paradise//vg/.
	ex:
	sprite_sheets = list(
		SPECIES_TAJ = 'icons/cat/are/bad'
		)
	If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = list()

	// Species-specific sprite sheets for inventory sprites
	// Works similarly to worn sprite_sheets, except the alternate sprites are used when the clothing/refit_for_species() proc is called.
	var/list/sprite_sheets_obj = list()

	var/toolspeed = 1.0 // This is a multipler on how 'fast' a tool works.  e.g. setting this to 0.5 will make the tool work twice as fast.
	var/attackspeed = DEFAULT_ATTACK_COOLDOWN // How long click delay will be when using this, in 1/10ths of a second. Checked in the user's get_attack_speed().
	var/reach = 1 // Length of tiles it can reach, 1 is adjacent.
	var/addblends // Icon overlay for ADD highlights when applicable.

	var/icon/default_worn_icon	//Default on-mob icon
	var/worn_layer				//Default on-mob layer

	// Pickup/Drop/Equip/Throw Sounds
	///Used when thrown into a mob
	var/mob_throw_hit_sound
	// Sound used when equipping the items into a valid slot.
	var/equip_sound
	// pickup sound - this is the default
	var/pickup_sound = "generic_pickup"
	// drop sound - this is the default
	var/drop_sound = "generic_drop"

	var/tip_timer // reference to timer id for a tooltip we might open soon

/obj/item/New()
	..()
	if(embed_chance < 0)
		if(sharp)
			embed_chance = max(5, round(force/w_class))
		else
			embed_chance = max(5, round(force/(w_class*3)))

/obj/item/equipped()
	..()
	var/mob/living/M = loc
	if(!istype(M))
		return
	M.update_held_icons()

/obj/item/Destroy()
	if(ismob(loc))
		var/mob/m = loc
		m.drop_from_inventory(src)
		m.update_inv_r_hand()
		m.update_inv_l_hand()
		src.loc = null
	return ..()

// Check if target is reasonable for us to operate on.
/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || ((!istype(target.loc, /turf)) && (!istype(target, /turf)) && (not_inside)))
		return FALSE
	else
		return TRUE

/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/is_held_twohanded(mob/living/M)
	var/check_hand
	if(M.l_hand == src && !M.r_hand)
		check_hand = BP_R_HAND //item in left hand, check right hand
	else if(M.r_hand == src && !M.l_hand)
		check_hand = BP_L_HAND //item in right hand, check left hand
	else
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/hand = H.organs_by_name[check_hand]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE


//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_held_icon()
	if(isliving(src.loc))
		var/mob/living/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

// See inventory_sizes.dm for the defines.
/obj/item/examine(mob/user)
	var/size
	switch(src.w_class)
		if(ITEMSIZE_TINY)
			size = "tiny"
		if(ITEMSIZE_SMALL)
			size = "small"
		if(ITEMSIZE_NORMAL)
			size = "normal-sized"
		if(ITEMSIZE_LARGE)
			size = "bulky"
		if(ITEMSIZE_HUGE)
			size = "huge"
	return ..(user, "", "It is a [size] item.")

/obj/item/attack_hand(mob/living/user as mob)
	if (!user) return
	if(anchored)
		to_chat(user, span("notice", "\The [src] won't budge, you can't pick it up!"))
		return
	if (hasorgans(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (user.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
		if(!temp)
			to_chat(user, "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>")
			return

	var/old_loc = src.loc
	src.pickup(user)
	if (istype(src.loc, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = src.loc
		S.remove_from_storage(src)

	src.throwing = 0
	if (src.loc == user)
		if(!user.unEquip(src))
			return
	else
		if(isliving(src.loc))
			return
	if(user.put_in_active_hand(src))
		if(isturf(old_loc))
			var/obj/effect/temporary_effect/item_pickup_ghost/ghost = new(old_loc)
			ghost.assumeform(src)
			ghost.animate_towards(user)
	return

/obj/item/attack_ai(mob/user as mob)
	if (istype(src.loc, /obj/item/weapon/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

/obj/item/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect all items
				if(isturf(src.loc))
					S.gather_all(src.loc, user)

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src)
	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/get_volume_by_throwforce_and_or_w_class() // This is used for figuring out how loud our sounds are for throwing.
	if(throwforce && w_class)
		return CLAMP((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return CLAMP(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0

/obj/item/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
		var/volume = get_volume_by_throwforce_and_or_w_class()
		if (throwforce > 0)
			if (mob_throw_hit_sound)
				playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
			else if(hitsound)
				playsound(hit_atom, hitsound, volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)
	else
		playsound(src, drop_sound, 30, preference = /datum/client_preference/drop_sounds)

// apparently called whenever an item is removed from a slot, container, or anything else.
/obj/item/proc/dropped(mob/user as mob)
	..()
	if(zoom)
		zoom() //binoculars, scope, etc
	appearance_flags &= ~NO_CLIENT_COLOR

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	pixel_x = 0
	pixel_y = 0
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/weapon/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/weapon/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(var/mob/user, var/slot)
	hud_layerise()
	user.position_hud_item(src,slot)
	if(user.client)	user.client.screen |= src
	if(user.pulling == src) user.stop_pulling()
	if((slot_flags & slot))
		if(equip_sound)
			playsound(src, equip_sound, 30)
		else
			playsound(src, drop_sound, 30)
	else if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, pickup_sound, 20, preference = /datum/client_preference/pickup_sounds)
	return

// As above but for items being equipped to an active module on a robot.
/obj/item/proc/equipped_robot(var/mob/user)
	return

//Defines which slots correspond to which slot flags
var/list/global/slot_flags_enumeration = list(
	"[slot_wear_mask]" = SLOT_MASK,
	"[slot_back]" = SLOT_BACK,
	"[slot_wear_suit]" = SLOT_OCLOTHING,
	"[slot_gloves]" = SLOT_GLOVES,
	"[slot_shoes]" = SLOT_FEET,
	"[slot_belt]" = SLOT_BELT,
	"[slot_glasses]" = SLOT_EYES,
	"[slot_head]" = SLOT_HEAD,
	"[slot_l_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_r_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_w_uniform]" = SLOT_ICLOTHING,
	"[slot_wear_id]" = SLOT_ID,
	"[slot_tie]" = SLOT_TIE,
	)

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Should probably move the bulk of this into mob code some time, as most of it is related to the definition of slots and not item-specific
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = FALSE)
	if(!slot) return 0
	if(!M) return 0

	if(!ishuman(M)) return 0

	var/mob/living/carbon/human/H = M
	var/list/mob_equip = list()
	if(H.species.hud && H.species.hud.equip_slots)
		mob_equip = H.species.hud.equip_slots

	if(H.species && !(slot in mob_equip))
		return 0

	//First check if the item can be equipped to the desired slot.
	if("[slot]" in slot_flags_enumeration)
		var/req_flags = slot_flags_enumeration["[slot]"]
		if(!(req_flags & slot_flags))
			return 0

	//Next check that the slot is free
	if(H.get_equipped_item(slot))
		return 0

	//Next check if the slot is accessible.
	var/mob/_user = disable_warning? null : H
	if(!H.slot_is_accessible(slot, src, _user))
		return 0

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(slot_l_ear, slot_r_ear)
			var/slot_other_ear = (slot == slot_l_ear)? slot_r_ear : slot_l_ear
			if( (w_class > ITEMSIZE_TINY) && !(slot_flags & SLOT_EARS) )
				return 0
			if( (slot_flags & SLOT_TWOEARS) && H.get_equipped_item(slot_other_ear) )
				return 0
		if(slot_wear_id)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
		if(slot_l_store, slot_r_store)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
			if(slot_flags & SLOT_DENYPOCKET)
				return 0
			if( w_class > ITEMSIZE_SMALL && !(slot_flags & SLOT_POCKET) )
				return 0
		if(slot_s_store)
			if(!H.wear_suit && (slot_wear_suit in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a suit before you can attach this [name].</span>")
				return 0
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(usr, "<span class='warning'>You somehow have a suit with no defined allowed items for suit storage, stop that.</span>")
				return 0
			if( !(istype(src, /obj/item/device/pda) || istype(src, /obj/item/weapon/pen) || is_type_in_list(src, H.wear_suit.allowed)) )
				return 0
		if(slot_legcuffed) //Going to put this check above the handcuff check because the survival of the universe depends on it.
			if(!istype(src, /obj/item/weapon/handcuffs/legcuffs)) //Putting it here might actually do nothing.
				return 0
		if(slot_handcuffed)
			if(!istype(src, /obj/item/weapon/handcuffs) || istype(src, /obj/item/weapon/handcuffs/legcuffs)) //Legcuffs are a child of handcuffs, but we don't want to use legcuffs as handcuffs...
				return 0 //In theory, this would never happen, but let's just do the legcuff check anyways.
		if(slot_in_backpack) //used entirely for equipping spawned mobs or at round start
			var/allow = 0
			if(H.back && istype(H.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = H.back
				if(B.can_be_inserted(src,1))
					allow = 1
			if(!allow)
				return 0
		if(slot_tie)
			var/allow = 0
			for(var/obj/item/clothing/C in H.worn_clothing)	//Runs through everything you're wearing, returns if you can't attach the thing
				if(C.can_attach_accessory(src))
					allow = 1
					break
			if(!allow)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You're not wearing anything you can attach this [name] to.</span>")
				return 0
	return 1

/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!M) return 0

	if(!canremove)
		return 0

	if(!slot)
		if(issilicon(M))
			return 1 // for stuff in grippers
		return 0

	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/carbon/brain)))//Is humanoid, and is not a brain
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	var/mob/living/carbon/C = usr
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if(src.anchored) //Object isn't anchored
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	if(C.get_active_hand()) //Hand is not full
		to_chat(usr, "<span class='warning'>Your hand is full.</span>")
		return
	if(!istype(src.loc, /turf)) //Object is on a turf
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(src)
	return


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	attack_self(usr)

//RETURN VALUES
//handle_shield should return a positive value to indicate that the attack is blocked and should be prevented.
//If a negative value is returned, it should be treated as a special return value for bullet_act() and handled appropriately.
//For non-projectile attacks this usually means the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	var/mob/living/carbon/human/U = user
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, "<span class='warning'>You're going to need to remove the eye covering first.</span>")
				return

	if(!M.has_eyes())
		to_chat(user, "<span class='warning'>You cannot locate any eyes on [M]!</span>")
		return

	//this should absolutely trigger even if not aim-impaired in some way
	var/hit_zone = get_zone_with_miss_chance(U.zone_sel.selecting, M, U.get_accuracy_penalty(U))
	if(!hit_zone)
		U.do_attack_animation(M)
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		visible_message(SPAN_DANGER("\The [U] attempts to stab \the [M] in the eyes, but misses!"))
		return

	add_attack_logs(user,M,"Attack eyes with [name]")

	user.setClickCooldown(user.get_attack_speed())
	user.do_attack_animation(M)

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		to_chat(M, "<span class='warning'>You stab yourself in the eye.</span>")
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/

	if(istype(H))

		var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[O_EYES]

		if(H != user)
			for(var/mob/O in (viewers(M) - user - M))
				O.show_message("<span class='danger'>[M] has been stabbed in the eye with [src] by [user].</span>", 1)
			to_chat(M, "<span class='danger'>[user] stabs you in the eye with [src]!</span>")
			to_chat(user, "<span class='danger'>You stab [M] in the eye with [src]!</span>")
		else
			user.visible_message( \
				"<span class='danger'>[user] has stabbed themself with [src]!</span>", \
				"<span class='danger'>You stab yourself in the eyes with [src]!</span>" \
			)

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(!(eyes.robotic >= ORGAN_ROBOT)) //robot eyes bleeding might be a bit silly
					to_chat(M, "<span class='danger'>Your eyes start to bleed profusely!</span>")
			if(prob(50))
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You drop what you're holding and clutch at your eyes!</span>")
					M.drop_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You go blind!</span>")
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	return

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(src, /obj/item/weapon/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//Make the blood_overlay have the proper color then apply it.
	blood_overlay.color = blood_color
	overlays += blood_overlay

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

GLOBAL_LIST_EMPTY(blood_overlays_by_type)
/obj/item/proc/generate_blood_overlay()
	// Already got one
	if(blood_overlay)
		return

	// Already cached
	if(GLOB.blood_overlays_by_type[type])
		blood_overlay = GLOB.blood_overlays_by_type[type]
		return

	// Firsties!
	var/image/blood = image(icon = 'icons/effects/blood.dmi', icon_state = "itemblood") // Needs to be a new one each time since we're slicing it up with filters.
	blood.filters += filter(type = "alpha", icon = icon(icon, icon_state)) // Same, this filter is unique for each blood overlay per type
	GLOB.blood_overlays_by_type[type] = blood

	// And finally
	blood_overlay = blood

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal vision. Still, increase viewsize a tiny bit so that sniping isn't as restricted to NSEW
/obj/item/var/ignore_visor_zoom_restriction = FALSE

/obj/item/proc/zoom(var/tileoffset = 14,var/viewsize = 9) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view

	var/devicename

	if(zoomdevicename)
		devicename = zoomdevicename
	else
		devicename = src.name

	var/cannotzoom

	if((usr.stat && !zoom) || !(istype(usr,/mob/living/carbon/human)))
		to_chat(usr, "You are unable to focus through the [devicename]")
		cannotzoom = 1
	else if(!zoom && global_hud.darkMask[1] in usr.client.screen)
		to_chat(usr, "Your visor gets in the way of looking through the [devicename]")
		cannotzoom = 1
	else if(!zoom && usr.get_active_hand() != src)
		to_chat(usr, "You are too distracted to look through the [devicename], perhaps if it was in your active hand this might work better")
		cannotzoom = 1

	//We checked above if they are a human and returned already if they weren't.
	var/mob/living/carbon/human/H = usr

	if(!zoom && !cannotzoom)
		if(H.hud_used.hud_shown)
			H.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		H.set_viewsize(viewsize)
		zoom = 1
		GLOB.moved_event.register(H, src, .proc/zoom)

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(H.dir)
			if (NORTH)
				H.client.pixel_x = 0
				H.client.pixel_y = viewoffset
			if (SOUTH)
				H.client.pixel_x = 0
				H.client.pixel_y = -viewoffset
			if (EAST)
				H.client.pixel_x = viewoffset
				H.client.pixel_y = 0
			if (WEST)
				H.client.pixel_x = -viewoffset
				H.client.pixel_y = 0

		H.visible_message("[usr] peers through the [zoomdevicename ? "[zoomdevicename] of the [src.name]" : "[src.name]"].")
		if(!ignore_visor_zoom_restriction)
			H.looking_elsewhere = TRUE
		H.handle_vision()

	else
		H.set_viewsize() // Reset to default
		if(!H.hud_used.hud_shown)
			H.toggle_zoom_hud()
		zoom = 0
		GLOB.moved_event.unregister(H, src, .proc/zoom)

		H.client.pixel_x = 0
		H.client.pixel_y = 0
		H.looking_elsewhere = FALSE
		H.handle_vision()

		if(!cannotzoom)
			usr.visible_message("[zoomdevicename ? "[usr] looks up from the [src.name]" : "[usr] lowers the [src.name]"].")

	return

/obj/item/proc/pwr_drain()
	return 0 // Process Kill

// Used for non-adjacent melee attacks with specific weapons capable of reaching more than one tile.
// This uses changeling range string A* but for this purpose its also applicable.
/obj/item/proc/attack_can_reach(var/atom/us, var/atom/them, var/range)
	if(us.Adjacent(them))
		return TRUE // Already adjacent.
	if(AStar(get_turf(us), get_turf(them), /turf/proc/AdjacentTurfsRangedSting, /turf/proc/Distance, max_nodes=25, max_node_depth=range))
		return TRUE
	return FALSE

// Check if an object should ignite others, like a lit lighter or candle.
/obj/item/proc/is_hot()
	return FALSE

// Called when you swap hands away from the item
/obj/item/proc/in_inactive_hand(mob/user)
	return

//Used for selecting a random pixel placement, usually on initialize. Checks for pixel_x/y to not interfere with mapped in items.
/obj/item/proc/randpixel_xy()
	if(!pixel_x && !pixel_y)
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
		return TRUE
	else
		return FALSE


// My best guess as to why this is here would be that it does so little. Still, keep it under all the procs, for sanity's sake.
/obj/item/device
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

//Worn icon generation for on-mob sprites
/obj/item/proc/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	//Get the required information about the base icon
	var/icon/icon2use = get_worn_icon_file(body_type = body_type, slot_name = slot_name, default_icon = default_icon, inhands = inhands)
	var/state2use = get_worn_icon_state(slot_name = slot_name)
	var/layer2use = get_worn_layer(default_layer = default_layer)

	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_name)
			if(slot_r_hand_str)
				state2use += "_r"
			if(slot_l_hand_str)
				state2use += "_l"

	// testing("[src] (\ref[src]) - Slot: [slot_name], Inhands: [inhands], Worn Icon:[icon2use], Worn State:[state2use], Worn Layer:[layer2use]")

	//Generate the base onmob icon
	var/icon/standing_icon = icon(icon = icon2use, icon_state = state2use)

	if(!inhands)
		apply_custom(standing_icon)		//Pre-image overridable proc to customize the thing
		apply_addblends(icon2use,standing_icon)		//Some items have ICON_ADD blend shaders

	var/image/standing = image(standing_icon)
	standing.alpha = alpha
	standing.color = color
	standing.layer = layer2use
	if(istype(clip_mask)) //VOREStation Edit - For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

	if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

	//Apply any special features
	if(!inhands)
		apply_blood(standing)			//Some items show blood when bloodied
		apply_accessories(standing)		//Some items sport accessories like webbing

	//Return our icon
	return standing

//Returns the icon object that should be used for the worn icon
/obj/item/proc/get_worn_icon_file(var/body_type,var/slot_name,var/default_icon,var/inhands)

	//1: icon_override var
	if(icon_override)
		return icon_override

	//2: species-specific sprite sheets (skipped for inhands)
	if(LAZYLEN(sprite_sheets))
		var/sheet = sprite_sheets[body_type]
		if(sheet && !inhands)
			return sheet

	//3: slot-specific sprite sheets
	if(LAZYLEN(item_icons))
		var/sheet = item_icons[slot_name]
		if(sheet)
			return sheet

	//4: item's default icon
	if(default_worn_icon)
		return default_worn_icon

	//5: provided default_icon
	if(default_icon)
		return default_icon

	//6: give up
	return

//Returns the state that should be used for the worn icon
/obj/item/proc/get_worn_icon_state(var/slot_name)

	//1: slot-specific sprite sheets
	if(LAZYLEN(item_state_slots))
		var/state = item_state_slots[slot_name]
		if(state)
			return state

	//2: item_state variable
	if(item_state)
		return item_state

	//3: icon_state variable
	if(icon_state)
		return icon_state

//Returns the layer that should be used for the worn icon (as a FLOAT_LAYER layer, so negative)
/obj/item/proc/get_worn_layer(var/default_layer = 0)

	//1: worn_layer variable
	if(!isnull(worn_layer)) //Can be zero, so...
		return BODY_LAYER+worn_layer

	//2: your default
	return BODY_LAYER+default_layer

//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(var/source_icon, var/icon/standing_icon)

	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)

//STUB
/obj/item/proc/apply_custom(var/icon/standing_icon)
	return standing_icon

//STUB
/obj/item/proc/apply_blood(var/image/standing)
	return standing

//STUB
/obj/item/proc/apply_accessories(var/image/standing)
	return standing

/obj/item/MouseEntered(location,control,params)
	. = ..()
	if(usr.is_preference_enabled(/datum/client_preference/inv_tooltips) && ((src in usr) || isstorage(loc))) // If in inventory or in storage we're looking at
		var/user = usr
		tip_timer = addtimer(CALLBACK(src, .proc/openTip, location, control, params, user), 5, TIMER_STOPPABLE)

/obj/item/MouseExited()
	. = ..()
	deltimer(tip_timer)
	closeToolTip(usr)

/obj/item/proc/openTip(location, control, params, user)
	openToolTip(user, src, params, title = name, content = desc)

// These procs are for RPEDs and part ratings. The concept for this was borrowed from /vg/station.
// Gets the rating of the item, used in stuff like machine construction.
/obj/item/proc/get_rating()
	return FALSE

// Like the above, but used for RPED sorting of parts.
/obj/item/proc/rped_rating()
	return get_rating()
