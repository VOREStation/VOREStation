/obj/item/clothing/accessory/locket
	name = "silver locket"
	desc = "A small locket of high-quality metal."
	icon_state = "locket"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR
	var/base_icon
	var/open
	var/obj/item/held //Item inside locket.

/obj/item/clothing/accessory/locket/attack_self(mob/user as mob)
	if(!base_icon)
		base_icon = icon_state

	if(!("[base_icon]_open" in icon_states(icon)))
		user << "\The [src] doesn't seem to open."
		return

	open = !open
	user << "You flip \the [src] [open?"open":"closed"]."
	if(open)
		icon_state = "[base_icon]_open"
		if(held)
			user << "\The [held] falls out!"
			held.loc = get_turf(user)
			held = null
	else
		icon_state = "[base_icon]"

/obj/item/clothing/accessory/locket/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!open)
		user << "You have to open it first."
		return

	if(istype(O,/obj/item/weapon/paper) || istype(O, /obj/item/weapon/photo))
		if(held)
			usr << "\The [src] already has something inside it."
		else
			usr << "You slip [O] into [src]."
			user.drop_item()
			O.loc = src
			held = O
		return
	..()
