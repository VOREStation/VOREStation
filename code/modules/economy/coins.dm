/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	desc = "A simple coin you can flip."
	icon_state = "coin"
	randpixel = 8
	force = 0.0
	throwforce = 0.0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/weapon/coin/New()
	randpixel_xy()

/obj/item/weapon/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"
	matter = list(MAT_GOLD = 250)

/obj/item/weapon/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"
	matter = list(MAT_SILVER = 250)

/obj/item/weapon/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"
	matter = list(MAT_DIAMOND = 250)

/obj/item/weapon/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"
	matter = list(MAT_IRON = 250)

/obj/item/weapon/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"
	matter = list(MAT_PHORON = 250)

/obj/item/weapon/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"
	matter = list(MAT_URANIUM = 250)

/obj/item/weapon/coin/platinum
	name = "platinum coin"
	icon_state = "coin_adamantine"
	matter = list(MAT_GOLD = 250)

/obj/item/weapon/coin/morphium
	name = "morphium coin"
	icon_state = "coin_morphium"
	matter = list(MAT_MORPHIUM = 250)

/obj/item/weapon/coin/aluminium
	name = "aluminium coin"
	icon_state = "coin_aluminium"
	matter = list(MAT_ALUMINIUM = 250)

/obj/item/weapon/coin/verdantium
	name = "verdantium coin"
	icon_state = "coin_verdantium"
	matter = list(MAT_VERDANTIUM = 250)

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, "<span class='notice'>There already is a string attached to this coin.</span>")
			return
		if (CC.use(1))
			add_overlay("coin_string_overlay")
			string_attached = 1
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
		else
			to_chat(user, "<span class='notice'>This cable coil appears to be empty.</span>")
		return
	else if(W.is_wirecutter())
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new (user.loc, 1)
		CC.update_icon()
		cut_overlays()
		string_attached = null
		to_chat(user, "<font color='blue'>You detach the string from the coin.</font>")
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
