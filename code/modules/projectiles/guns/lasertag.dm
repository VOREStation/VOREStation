/*
 * Handles lasertag attacks. Anything can call this.
 * Target can be a mob or a lasertag vest on the ground.
 * Attacker can be null (if vest_override is set) or a human mob
 * tag_damage is how much damage is dealt to the vest (defaults to 1 if no value given)
 * vest_override allows attacking without wearing a vest (defaults to FALSE)
 * required_vest is a list of what vests are required to have on to do damage
 * allowed_suits are what vests the attack is able to deal damage to. Must be a LIST. If not passed, we assume all suits are valid targets.
 * returns TRUE if damage was (theoretically) dealt. FALSE if not.
 *
*/
/proc/handle_lasertag_attack(target, mob/living/carbon/human/attacker, tag_damage, vest_override, required_vest, list/allowed_suits)
	//So, attacker should ALWAYS be true, but there's a problem. The code doesn't actually set 'thrower' which we used for thrown laser knives.
	//Instead of this PR getting massively out of scope and refactoring throwing code, we're just going to have thrown knives do vest override.
	if(vest_override || (attacker && istype(attacker) && (!required_vest || istype(attacker.wear_suit, required_vest))))
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(!allowed_suits) //Wasn't fed a suit. Let's just affect everything.
				allowed_suits = list(/obj/item/clothing/suit/lasertag)
			if(is_type_in_list(human_target.wear_suit, allowed_suits))
				var/obj/item/clothing/suit/lasertag/laser_suit = human_target.wear_suit
				laser_suit.handle_hit(tag_damage)
				return TRUE
		//We allow allow demonstrations of shooting it while it's on the ground.
		else if(is_type_in_list(target, allowed_suits))
			var/obj/item/clothing/suit/lasertag/laser_suit = target
			laser_suit.handle_hit(tag_damage)
			return TRUE
	else if(attacker)
		to_chat(attacker, span_warning("You need to be wearing your laser tag vest to use this!"))
	return FALSE

/obj/item/gun/energy/lasertag
	name = "omni laser tag gun"
	desc = "A laser tag gun that works on all vests!"
	icon = 'icons/obj/gun_toy.dmi'
	item_state = "omnitag"
	item_state = "retro"
	matter = list(MAT_STEEL = MATERIAL_COST(1))
	projectile_type = /obj/item/projectile/beam/lasertag/omni
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	var/required_vest = /obj/item/clothing/suit/lasertag/omni
	///Allows firing without a vest.
	var/vest_override = FALSE

/obj/item/gun/energy/lasertag/special_check(mob/living/carbon/human/M)
	if(ishuman(M) && !vest_override)
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, span_warning("You need to be wearing your laser tag vest!"))
			return FALSE
		var/obj/item/clothing/suit/lasertag/tag_vest = M.wear_suit
		if(tag_vest.lasertag_health <= 0)
			to_chat(M, span_warning("You're out of health!"))
			return FALSE
	return ..()

/obj/item/gun/energy/lasertag/blue
	name = "blue laser tag gun"
	desc = "A laser tag gun that works when wearing a blue vest!"
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	required_vest = /obj/item/clothing/suit/lasertag/bluetag
	fire_delay = 10

/obj/item/gun/energy/lasertag/blue/sub
	name = "Brigader Sidearm"
	desc = "A laser tag replica of the standard issue weapon for the Spacer Union Brigade from the hit series Spacer Trail (Blue Team)."
	icon_state = "bluetwo"
	item_state = "retro"

/obj/item/gun/energy/lasertag/red
	name = "red laser tag gun"
	desc = "A laser tag gun that works when wearing a red vest!"
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lasertag/red
	required_vest = /obj/item/clothing/suit/lasertag/redtag
	fire_delay = 10

/obj/item/gun/energy/lasertag/red/dom
	name = "Mu'tu'bi sidearm"
	desc = "A laser tag replica of the Mu'tu'bi sidearm from the hit series Spacer Trail (Red Team)."
	icon_state = "redtwo"
	item_state = "retro"

/obj/item/gun/energy/lasertag/omni
	icon_state = "omnitag"
	item_state = "omnitag"
	projectile_type = /obj/item/projectile/beam/lasertag/omni

//The lasertag knives also go here because whatever, go my bullshit explanation.

/obj/item/lasertagknife
	name = "universal laser tag dagger"
	desc = "Rubber knife with a glowing fancy edge. It has no team allegiance!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tagknifeomni"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',)
	item_state_slots = list(slot_r_hand_str = "tagknifeomni", slot_l_hand_str = "tagknifeomni")
	item_state = null
	hitsound = null
	w_class = ITEMSIZE_SMALL
	attackspeed = 1.2 SECONDS
	attack_verb = list("patted", "tapped")
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	///The vest we have to wear to use the knife.
	var/required_vest = /obj/item/clothing/suit/lasertag/omni
	///If we need a vest on ourselves to use it or not.
	var/vest_override = FALSE
	///How much damage it does to the lasertag vest. Generally for oneshots.
	var/tag_damage = 1
	///What vests we are allowed to hit with the knife.
	var/list/allowed_suits = list(/obj/item/clothing/suit/lasertag/bluetag, /obj/item/clothing/suit/lasertag/redtag, /obj/item/clothing/suit/lasertag/omni)

/obj/item/lasertagknife/examine(mob/user, infix, suffix)
	. = ..()
	. += "It is currently set to do [tag_damage] damage per hit. Alt-click to adjust."

/obj/item/lasertagknife/click_alt(mob/user)
	if(isliving(user))
		adjust_damage_proc(user)

/obj/item/lasertagknife/verb/adjust_damage()
	set name = "Adjust Knife Damage"
	set category = "Object"
	set src in usr
	if(isliving(usr))
		adjust_damage_proc(usr)

/obj/item/lasertagknife/proc/adjust_damage_proc(mob/living/user)
	if(user.stat)
		to_chat(user, span_warning("You must be conscious to adjust the knife damage!"))
	var/max_damage = 10
	var/min_damage = 1
	var/new_damage = tgui_input_number(user, "Select knife damage (Between 1 and 10)", "Tag Health", tag_damage, max_damage, min_damage, round_value=TRUE) //If you need to go above 10, ask admins.
	if(isnull(new_damage))
		return null
	if(new_damage > max_damage || new_damage < min_damage)
		to_chat(user, span_danger("Invalid damage value! Must be between [min_damage] and [max_damage]."))
		return null
	if(!Adjacent(user))
		to_chat(user, span_danger("You must be adjacent to the knife to adjust its healing timer!"))
		return null
	tag_damage = new_damage
	user.visible_message(user, span_notice("Set [src]'s damage to [tag_damage]!"))

/obj/item/lasertagknife/blue
	name = "blue laser tag dagger"
	desc = "Rubber knife with a blue glowing fancy edge!"
	icon_state = "tagknifeblue"
	item_state_slots = list(slot_r_hand_str = "tagknifeblue", slot_l_hand_str = "tagknifeblue")
	required_vest = /obj/item/clothing/suit/lasertag/bluetag
	allowed_suits = list(/obj/item/clothing/suit/lasertag/redtag, /obj/item/clothing/suit/lasertag/omni)

/obj/item/lasertagknife/red
	name = "red laser tag dagger"
	desc = "Rubber knife with a red glowing fancy edge!"
	icon_state = "tagknifered"
	item_state_slots = list(slot_r_hand_str = "tagknifered", slot_l_hand_str = "tagknifered")
	required_vest = /obj/item/clothing/suit/lasertag/redtag
	allowed_suits = list(/obj/item/clothing/suit/lasertag/bluetag, /obj/item/clothing/suit/lasertag/omni)

//We have to do this if(user) check all over the place because for some reason someone broke thrower code. Thanks.
/obj/item/lasertagknife/attack(mob/living/target, mob/living/user, target_zone, attack_modifier)
	if(user)
		user.setClickCooldown(user.get_attack_speed(src))
		user.do_attack_animation(target)
	var/success = handle_lasertag_attack(target, user, tag_damage, vest_override, required_vest, allowed_suits)

	if(success)
		user.visible_message(span_danger("[target] has been zapped with [src] by [user]!"))
		playsound(src, 'sound/weapons/Egloves.ogg', 50, 1, -1)
	else
		user.visible_message(span_danger("[target] has been harmlessly bonked with [src] by [user]!"))
		playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	return ITEM_INTERACT_SUCCESS

///go my hack
/obj/item/lasertagknife/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(ismob(hit_atom))
		//So, attacker should ALWAYS be true, but there's a problem. The code doesn't actually set 'thrower' which we used for thrown laser knives.
		//Instead of this PR getting massively out of scope and refactoring throwing code, we're just going to have thrown knives do vest override.
		return handle_lasertag_attack(hit_atom, throwingdatum?.get_thrower(), tag_damage, TRUE, required_vest, allowed_suits)
	..()
