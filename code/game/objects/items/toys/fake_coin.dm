/*****************************Coin********************************/
// fake "toy" version that allows people to have them as trinkets
// without letting them easily get stuff from vending machines

/obj/item/fake_coin
	icon = 'icons/obj/coins.dmi'
	name = "Coin"
	desc = "A simple coin you can flip. The weight doesn't seem quite right..."
	description_fluff = "This isn't a real coin; you can't use it on vending machines."
	icon_state = "coin"
	randpixel = 8
	force = 0.0
	throwforce = 0.0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/sides = 2
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/fake_coin/New()
	randpixel_xy()

/obj/item/fake_coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/fake_coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/fake_coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/fake_coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/fake_coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"

/obj/item/fake_coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/fake_coin/platinum
	name = "platinum coin"
	icon_state = "coin_platinum"

/obj/item/fake_coin/morphium
	name = "morphium coin"
	icon_state = "coin_morphium"

/obj/item/fake_coin/aluminium
	name = "aluminium coin"
	icon_state = "coin_aluminium"

/obj/item/fake_coin/verdantium
	name = "verdantium coin"
	icon_state = "coin_verdantium"

/obj/item/fake_coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(span_notice("[user] has thrown \the [src]. It lands on [comment]!"), \
						 span_notice("You throw \the [src]. It lands on [comment]!"))
