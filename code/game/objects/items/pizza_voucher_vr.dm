/obj/item/pizzavoucher
	name = "free pizza voucher"
	desc = "A pocket-sized plastic slip with a button in the middle. The writing on it seems to have faded."
	icon = 'icons/obj/items.dmi'
	icon_state = "pizza_voucher"
	var/spent = FALSE
	var/special_delivery = FALSE
	w_class = ITEMSIZE_SMALL

/obj/item/pizzavoucher/New()
	var/list/descstrings = list("24/7 PIZZA PIE HEAVEN",
	"WE ALWAYS DELIVER!",
	"24-HOUR PIZZA PIE POWER!",
	"TOMATO SAUCE, CHEESE, WE'VE BOTH BOTH OF THESE!",
	"COOKED WITH LOVE INSIDE A BIG OVEN!",
	"WHEN YOU NEED A SLICE OF JOY IN YOUR LIFE!",
	"WHEN YOU NEED A DISK OF OVEN BAKED BLISS!",
	"EVERY TIME YOU DREAM OF CIRCULAR CUISINE!",
	"WE ALWAYS DELIVER! WE ALWAYS DELIVER! WE ALWAYS DELIVER!")
	desc = "A pocket-sized plastic slip with a button in the middle. \"[pick(descstrings)]\" is written on the back."

/obj/item/pizzavoucher/attack_self(mob/user)
	add_fingerprint(user)
	if(!spent)
		user.visible_message("<span class='notice'>[user] presses a button on [src]!</span>")
		desc = desc + " This one seems to be used-up."
		spent = TRUE
		user.visible_message("<span class='notice'>A small bluespace rift opens just above your head and spits out a pizza box!</span>")
		if(special_delivery)
			command_announcement.Announce("SPECIAL DELIVERY PIZZA ORDER #[rand(1000,9999)]-[rand(100,999)] HAS BEEN RECIEVED. SHIPMENT DISPATCHED VIA EXTRA-POWERFUL BALLISTIC LAUNCHERS FOR IMMEDIATE DELIVERY! THANK YOU AND ENJOY YOUR PIZZA!", "WE ALWAYS DELIVER!")
			new /obj/effect/falling_effect/pizza_delivery/special(user.loc)
		else
			new /obj/effect/falling_effect/pizza_delivery(user.loc)
	else
		to_chat(user, "<span class='warning'>The [src] is spent!</span>")

/obj/item/pizzavoucher/emag_act(var/remaining_charges, var/mob/user)
	if(spent)
		to_chat(user, "<span class='warning'>The [src] is spent!</span>")
		return
	if(!special_delivery)
		to_chat(user, "<span class='warning'>You activate the special delivery protocol on the [src]!</span>")
		special_delivery = TRUE
		return 1
	else
		to_chat(user, "<span class='warning'>The [src] is already in special delivery mode!</span>")

/obj/effect/falling_effect/pizza_delivery
	name = "PIZZA PIE POWER!"
	crushing = FALSE

/obj/effect/falling_effect/pizza_delivery/Initialize(mapload)
	..()
	falling_type = pick(prob(20);/obj/item/pizzabox/meat,
				prob(20);/obj/item/pizzabox/margherita,
				prob(20);/obj/item/pizzabox/vegetable,
				prob(20);/obj/item/pizzabox/mushroom,
				prob(20);/obj/item/pizzabox/pineapple)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/falling_effect/pizza_delivery/special
	crushing = TRUE