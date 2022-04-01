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
<<<<<<< HEAD
	//Vorestation Edit: Because some things (read lift doors) don't get emagged
	if(used_uses)
		log_and_message_admins("emagged \an [A].")
	else
		log_and_message_admins("attempted to emag \an [A].")
	// Vorestation Edit: End of Edit
=======
	log_and_message_admins("emagged \an [A].", user)
>>>>>>> f06dcc071e5... Merge pull request #8470 from Verkister/patch-89

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
