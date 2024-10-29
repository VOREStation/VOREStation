/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slot = ACCESSORY_SLOT_WEAPON
	concealed_holster = 1
	var/obj/item/holstered = null
	var/list/can_hold //VOREStation Add
	var/holster_in = 'sound/items/holsterin.ogg'
	var/holster_out = 'sound/items/holsterout.ogg'
	w_class = ITEMSIZE_NORMAL

/obj/item/clothing/accessory/holster/proc/holster(var/obj/item/I, var/mob/living/user)
	if(holstered && istype(user))
		to_chat(user, span_warning("There is already \a [holstered] holstered here!"))
		return
	//VOREStation Edit - Machete sheath support
	if (LAZYLEN(can_hold))
		if(!is_type_in_list(I,can_hold))
			to_chat(user, span_warning("[I] won't fit in [src]!"))
			return

	else if (!(I.slot_flags & SLOT_HOLSTER))
	//VOREStation Edit End
		to_chat(user, span_warning("[I] won't fit in [src]!"))
		return

	if(holster_in)
		playsound(src, holster_in, 50)

	if(istype(user))
		user.stop_aiming(no_message=1)
	holstered = I
	user.drop_from_inventory(holstered, target = src)
	holstered.add_fingerprint(user)
	w_class = max(w_class, holstered.w_class)
	user.visible_message(span_notice("[user] holsters \the [holstered]."), span_notice("You holster \the [holstered]."))
	name = "occupied [initial(name)]"

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	name = initial(name)

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		to_chat(user, span_warning("You need an empty hand to draw \the [holstered]!"))
	else
		var/sound_vol = 25
		if(user.a_intent == I_HURT)
			sound_vol = 50
			usr.visible_message(
				span_danger("[user] draws \the [holstered], ready to go!"), //VOREStation Edit
				span_warning("You draw \the [holstered], ready to go!") //VOREStation Edit
				)
		else
			user.visible_message(
				span_notice("[user] draws \the [holstered], pointing it at the ground."),
				span_notice("You draw \the [holstered], pointing it at the ground.")
				)

		if(holster_out)
			playsound(src, holster_out, sound_vol)

		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit && (slot & ACCESSORY_SLOT_UTILITY))	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	. = ..(user)
	if(holstered)
		. += "A [holstered] is holstered here."
	else
		. += "It is empty."

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	if(has_suit)
		has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	//can't we just use src here?
	var/obj/item/clothing/accessory/holster/H = null
	if (istype(src, /obj/item/clothing/accessory/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (LAZYLEN(S.accessories))
			H = locate() in S.accessories

	if (!H)
		to_chat(usr, span_warning("Something is very wrong."))

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, span_warning("You need your gun equipped to holster it."))
			return
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"

/obj/item/clothing/accessory/holster/armpit/black
	icon_state = "holster_b"

/obj/item/clothing/accessory/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/waist/black
	icon_state = "holster_b_low"

/obj/item/clothing/accessory/holster/hip
	name = "hip holster"
	desc = span_italics("No one dared to ask his business, no one dared to make a slip. The stranger there among them had a big iron on his hip.")
	icon_state = "holster_hip"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/hip/black
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_b_hip"

/obj/item/clothing/accessory/holster/leg
	name = "leg holster"
	desc = "A drop leg holster made of a durable synthetic leather."
	icon_state = "holster_leg"
	overlay_state = "holster_leg"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/leg/black
	desc = "A tacticool handgun holster. Worn on the upper leg."
	icon_state = "holster_b_leg"
