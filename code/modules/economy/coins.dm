/*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/coins.dmi'
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

/obj/item/coin/Initialize(mapload)
	. = ..()
	randpixel_xy()

/obj/item/coin/gold
	name = MAT_GOLD + " coin"
	desc = "A shiny gold coin. Just like in the old movies with pirates!"
	icon_state = "coin_gold"
	matter = list(MAT_GOLD = 250)

/obj/item/coin/silver
	name = MAT_SILVER + " coin"
	desc = "A shiny silver coin. You can almost see your reflection in it. Unless you're a vampire."
	icon_state = "coin_silver"
	matter = list(MAT_SILVER = 250)

/obj/item/coin/diamond
	name = MAT_DIAMOND + " coin"
	desc = "A coin made of solid diamond. Carbon, really, but who's counting?" // me, I'm counting
	icon_state = "coin_diamond"
	matter = list(MAT_DIAMOND = 250)

/obj/item/coin/iron
	name = MAT_IRON + " coin"
	desc = "A dull iron coin. Not that it's boring, it's just a bit plain."
	icon_state = "coin_iron"
	matter = list(MAT_IRON = 250)

/obj/item/coin/phoron
	name = "solid " + MAT_PHORON + " coin"
	desc = "Solid phoron, pressed into a coin and laminated for safety. Go ahead, lick it."
	icon_state = "coin_phoron"
	matter = list(MAT_PHORON = 250)

/obj/item/coin/uranium
	name = MAT_URANIUM + " coin"
	desc = "A uranium coin. You probably don't want to store this in your pants pocket..."
	icon_state = "coin_uranium"
	matter = list(MAT_URANIUM = 250)

/obj/item/coin/platinum
	name = MAT_PLATINUM + " coin"
	desc = "A shiny platinum coin. Truth is, the game was rigged from the start."
	icon_state = "coin_platinum"
	matter = list(MAT_GOLD = 250)

/obj/item/coin/morphium
	name = MAT_MORPHIUM + " coin"
	desc = "Morphium, made into a coin. Extravagant is putting it lightly."
	icon_state = "coin_morphium"
	matter = list(MAT_MORPHIUM = 250)

/obj/item/coin/aluminium
	name = MAT_ALUMINIUM + " coin"
	desc = "Aluminium, in coin format. Now your wallet can be lighter than ever."
	icon_state = "coin_aluminium"
	matter = list(MAT_ALUMINIUM = 250)

/obj/item/coin/verdantium
	name = MAT_VERDANTIUM + " coin"
	desc = "Shiny green verdantium, in a coin. Ding ding ding!"
	icon_state = "coin_verdantium"
	matter = list(MAT_VERDANTIUM = 250)

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, span_notice("There already is a string attached to this coin."))
			return
		if (CC.use(1))
			add_overlay("coin_string_overlay")
			string_attached = 1
			to_chat(user, span_notice("You attach a string to the coin."))
		else
			to_chat(user, span_notice("This cable coil appears to be empty."))
		return
	else if(W.has_tool_quality(TOOL_WIRECUTTER))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new (user.loc, 1)
		CC.update_icon()
		cut_overlays()
		string_attached = null
		to_chat(user, span_notice("You detach the string from the coin."))
	else ..()

/obj/item/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(span_notice("[user] has thrown \the [src]. It lands on [comment]!"), \
						 span_notice("You throw \the [src]. It lands on [comment]!"))
