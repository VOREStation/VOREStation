/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "A tiny plaque of plastic. Does card things."
	icon = 'icons/obj/card_new.dmi'
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/associated_account_number = 0

	var/list/initial_sprite_stack = list("")
	var/base_icon = 'icons/obj/card_new.dmi'
	var/list/sprite_stack

	var/list/files = list(  )
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/weapon/card/New()
	. = ..()
	reset_icon()

/obj/item/weapon/card/proc/reset_icon()
	sprite_stack = initial_sprite_stack
	update_icon()

/obj/item/weapon/card/update_icon()
	if(!sprite_stack || !istype(sprite_stack) || sprite_stack == list(""))
		icon = base_icon
		icon_state = initial(icon_state)

	var/icon/I = null
	for(var/iconstate in sprite_stack)
		if(!iconstate)
			iconstate = icon_state
		if(I)
			var/icon/IC = new(base_icon, iconstate)
			I.Blend(IC, ICON_OVERLAY)
		else
			I = new/icon(base_icon, iconstate)
	if(I)
		icon = I

/obj/item/weapon/card/data
	name = "data card"
	desc = "A solid-state storage card, used to back up or transfer information. What knowledge could it contain?"
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Card"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data card- '[]'", t)
	else
		src.name = "data card"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "rainbow"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag-spent"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user, var/click_parameters)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses < 0)
		return ..(A, user, click_parameters)

	uses -= used_uses
	A.add_fingerprint(user)
	//Vorestation Edit: Because some things (read lift doors) don't get emagged
	if(used_uses)
		log_and_message_admins("emagged \an [A].")
	else
		log_and_message_admins("attempted to emag \an [A].")
	// Vorestation Edit: End of Edit

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/emag/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/T = O
		if(T.get_amount() < 1)
			to_chat(usr, "<span class='notice'>You are not adding enough telecrystals to fuel \the [src].</span>")
			return
		uses += T.get_amount()*0.5 //Gives 5 uses per 10 TC
		uses = CEILING(uses, 1) //Ensures no decimal uses nonsense, rounds up to be nice
		to_chat(usr, "<span class='notice'>You add \the [O] to \the [src]. Increasing the uses of \the [src] to [uses].</span>")
		qdel(O)


/obj/item/weapon/card/emag/borg
	uses = 12
	var/burnt_out = FALSE

/obj/item/weapon/card/emag/borg/afterattack(atom/A, mob/user, proximity, var/click_parameters)
	if(!proximity || burnt_out) return
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses < 0)
		return ..(A, user, proximity, click_parameters)

	uses -= used_uses
	A.add_fingerprint(user)
	//Vorestation Edit: Because some things (read lift doors) don't get emagged
	if(used_uses)
		log_and_message_admins("emagged \an [A].")
	else
		log_and_message_admins("attempted to emag \an [A].")
	// Vorestation Edit: End of Edit

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		burnt_out = TRUE

	return 1

/// FLUFF PERMIT

/obj/item/weapon/card_fluff
	name = "fluff card"
	desc = "A tiny plaque of plastic. Purely decorative?"
	description_fluff = "This permit was not issued by any branch of NanoTrasen, and as such it is not formally recognized at any NanoTrasen-operated installations. The bearer is not - under any circumstances - entitled to ownership of any items or allowed to perform any acts that would normally be restricted or illegal for their current position, regardless of what they or this permit may claim."
	icon = 'icons/obj/card_fluff.dmi'
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS

	var/list/initial_sprite_stack = list("")
	var/base_icon = 'icons/obj/card_fluff.dmi'
	var/list/sprite_stack = list("")

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/weapon/card_fluff/proc/reset_icon()
	sprite_stack = list("")
	update_icon()

/obj/item/weapon/card_fluff/update_icon()
	if(!sprite_stack || !istype(sprite_stack) || sprite_stack == list(""))
		icon = base_icon
		icon_state = initial(icon_state)

	var/icon/I = null
	for(var/iconstate in sprite_stack)
		if(!iconstate)
			iconstate = icon_state
		if(I)
			var/icon/IC = new(base_icon, iconstate)
			I.Blend(IC, ICON_OVERLAY)
		else
			I = new/icon(base_icon, iconstate)
	if(I)
		icon = I

/obj/item/weapon/card_fluff/attack_self()

	var/choice = tgui_input_list(usr, "What element would you like to customize?", "Customize Card", list("Band","Stamp","Reset"))
	if(!choice) return

	if(choice == "Band")
		var/bandchoice = tgui_input_list(usr, "Select colour", "Band colour", list("red","orange","green","dark green","medical blue","dark blue","purple","tan","pink","gold","white","black"))
		if(!bandchoice) return

		if(bandchoice == "red")
			sprite_stack.Add("bar-red")
		else if(bandchoice == "orange")
			sprite_stack.Add("bar-orange")
		else if(bandchoice == "green")
			sprite_stack.Add("bar-green")
		else if(bandchoice == "dark green")
			sprite_stack.Add("bar-darkgreen")
		else if(bandchoice == "medical blue")
			sprite_stack.Add("bar-medblue")
		else if(bandchoice == "dark blue")
			sprite_stack.Add("bar-blue")
		else if(bandchoice == "purple")
			sprite_stack.Add("bar-purple")
		else if(bandchoice == "ran")
			sprite_stack.Add("bar-tan")
		else if(bandchoice == "pink")
			sprite_stack.Add("bar-pink")
		else if(bandchoice == "gold")
			sprite_stack.Add("bar-gold")
		else if(bandchoice == "white")
			sprite_stack.Add("bar-white")
		else if(bandchoice == "black")
			sprite_stack.Add("bar-black")

		update_icon()
		return
	else if(choice == "Stamp")
		var/stampchoice = tgui_input_list(usr, "Select image", "Stamp image", list("ship","cross","big ears","shield","circle-cross","target","smile","frown","peace","exclamation"))
		if(!stampchoice) return

		if(stampchoice == "ship")
			sprite_stack.Add("stamp-starship")
		else if(stampchoice == "cross")
			sprite_stack.Add("stamp-cross")
		else if(stampchoice == "big ears")
			sprite_stack.Add("stamp-bigears")	//get 'em outta the caption, wiseguy!!
		else if(stampchoice == "shield")
			sprite_stack.Add("stamp-shield")
		else if(stampchoice == "circle-cross")
			sprite_stack.Add("stamp-circlecross")
		else if(stampchoice == "target")
			sprite_stack.Add("stamp-target")
		else if(stampchoice == "smile")
			sprite_stack.Add("stamp-smile")
		else if(stampchoice == "frown")
			sprite_stack.Add("stamp-frown")
		else if(stampchoice == "peace")
			sprite_stack.Add("stamp-peace")
		else if(stampchoice == "exclamation")
			sprite_stack.Add("stamp-exclaim")

		update_icon()
		return
	else if(choice == "Reset")
		reset_icon()
		return
	return

/obj/item/weapon/card/id/cargo/miner/borg
	var/mob/living/silicon/robot/R
	var/last_robot_loc
	name = "Robot Miner ID"
	rank = JOB_SHAFT_MINER

/obj/item/weapon/card/id/cargo/miner/borg/Initialize()
	. = ..()
	if(loc)
		R = loc.loc
		if(istype(R))
			registered_name = R.braintype
			RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(check_loc))

/obj/item/weapon/card/id/cargo/miner/borg/proc/check_loc(atom/movable/mover, atom/old_loc, atom/new_loc)
	if(old_loc == R || old_loc == R.module)
		last_robot_loc = old_loc
	if(!istype(loc, /obj/machinery) && loc != R && loc != R.module)
		if(last_robot_loc)
			forceMove(last_robot_loc)
			last_robot_loc = null
		else
			forceMove(R)
		if(loc == R)
			hud_layerise()

/obj/item/weapon/card/id/cargo/miner/borg/Destroy()
	UnregisterSignal(src, COMSIG_OBSERVER_MOVED)
	R = null
	last_robot_loc = null
	..()
