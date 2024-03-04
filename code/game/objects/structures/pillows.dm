//Pillows with sprites ported from skyrat

/obj/item/weapon/bedsheet/pillow
	name = "pillow"
	desc = "A surprisingly soft stuffed pillow."
	icon = 'icons/obj/pillows.dmi'
	icon_state = "pillow_pink_square"
	slot_flags = 0
	var/pile_type = "/obj/structure/bed/pillowpile"
	throw_range = 7

/obj/item/weapon/bedsheet/pillow/attack_self(mob/user as mob)
	user.drop_item()
	if(icon_state == initial(icon_state))
		icon_state = "[icon_state]_placed"
	add_fingerprint(user)

/obj/item/weapon/bedsheet/pillow/pickup(mob/user)
	..()
	icon_state = initial(icon_state)

/obj/item/weapon/bedsheet/pillow/attackby(var/obj/item/component, mob/user as mob)
	if (istype(component,src))
		to_chat(user, "<span class='notice'>You assemble a pillow pile!</span>")
		user.drop_item()
		qdel(component)
		var/turf/T = get_turf(src)
		new pile_type(T)
		user.drop_from_inventory(src)
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You can't assemble a pillow pile out of mismatched stuff, it'd look hideous!</span>")

//Pillow Piles, they're piles of pillows! 	layer = BELOW_MOB_LAYER

/obj/structure/bed/pillowpile
	name = "pillow pile"
	desc = "A massive pile of pillows!"
	icon = 'icons/obj/pillows.dmi'
	icon_state = "pillowpile_large_pink"
	var/pillowpilefront = "/obj/structure/bed/pillowpilefront"
	var/sourcepillow = "/obj/item/weapon/bedsheet/pillow"

/obj/structure/bed/pillowpilefront
	name = "pillow pile"
	desc = "A massive pile of pillows!"
	icon = 'icons/obj/pillows.dmi'
	icon_state = "pillowpile_large_pink_overlay"
	layer = ABOVE_MOB_LAYER
	plane = MOB_PLANE
	var/sourcepillow = "/obj/item/weapon/bedsheet/pillow"

/obj/structure/bed/pillowpile/New()
	..()
	var/turf/T = get_turf(src)
	new pillowpilefront(T)

/obj/structure/bed/pillowpilefront/update_icon()
	return

/obj/structure/bed/pillowpile/update_icon()
	return

/obj/structure/bed/pillowpile/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>Now disassembling the large pillow pile...</span>")
	if(do_after(user, 30))
		if(!src) return
		to_chat(user, "<span class='notice'>You dissasembled the large pillow pile!</span>")
		new sourcepillow(src.loc)
		qdel(src)

/obj/structure/bed/pillowpilefront/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>Now disassembling the front of the pillow pile...</span>")
	if(do_after(user, 30))
		if(!src) return
		to_chat(user, "<span class='notice'>You dissasembled the the front of the pillow pile!</span>")
		new sourcepillow(src.loc)
		qdel(src)

//Colours

//teal

/obj/item/weapon/bedsheet/pillow/teal
	icon_state = "pillow_teal_square"
	pile_type = "/obj/structure/bed/pillowpile/teal"

/obj/structure/bed/pillowpile/teal
	icon_state = "pillowpile_large_teal"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/teal"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/teal"

/obj/structure/bed/pillowpilefront/teal
	icon_state = "pillowpile_large_teal_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/teal"

//yellow

/obj/item/weapon/bedsheet/pillow/yellow
	icon_state = "pillow_yellow_square"
	pile_type = "/obj/structure/bed/pillowpile/yellow"

/obj/structure/bed/pillowpile/yellow
	icon_state = "pillowpile_large_yellow"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/yellow"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/yellow"

/obj/structure/bed/pillowpilefront/yellow
	icon_state = "pillowpile_large_yellow_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/yellow"

//white

/obj/item/weapon/bedsheet/pillow/white
	icon_state = "pillow_white_square"
	pile_type = "/obj/structure/bed/pillowpile/white"

/obj/structure/bed/pillowpile/white
	icon_state = "pillowpile_large_white"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/white"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/white"

/obj/structure/bed/pillowpilefront/white
	icon_state = "pillowpile_large_white_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/white"

//black

/obj/item/weapon/bedsheet/pillow/black
	icon_state = "pillow_black_square"
	pile_type = "/obj/structure/bed/pillowpile/black"

/obj/structure/bed/pillowpile/black
	icon_state = "pillowpile_large_black"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/black"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/black"

/obj/structure/bed/pillowpilefront/black
	icon_state = "pillowpile_large_black_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/black"

//green

/obj/item/weapon/bedsheet/pillow/green
	icon_state = "pillow_green_square"
	pile_type = "/obj/structure/bed/pillowpile/green"

/obj/structure/bed/pillowpile/green
	icon_state = "pillowpile_large_green"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/green"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/green"

/obj/structure/bed/pillowpilefront/green
	icon_state = "pillowpile_large_green_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/green"

//red

/obj/item/weapon/bedsheet/pillow/red
	icon_state = "pillow_red_square"
	pile_type = "/obj/structure/bed/pillowpile/red"

/obj/structure/bed/pillowpile/red
	icon_state = "pillowpile_large_red"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/red"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/red"

/obj/structure/bed/pillowpilefront/red
	icon_state = "pillowpile_large_red_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/red"

//orange

/obj/item/weapon/bedsheet/pillow/orange
	icon_state = "pillow_orange_square"
	pile_type = "/obj/structure/bed/pillowpile/orange"

/obj/structure/bed/pillowpile/orange
	icon_state = "pillowpile_large_orange"
	pillowpilefront = "/obj/structure/bed/pillowpilefront/orange"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/orange"

/obj/structure/bed/pillowpilefront/orange
	icon_state = "pillowpile_large_orange_overlay"
	sourcepillow = "/obj/item/weapon/bedsheet/pillow/orange"

//crafting

/datum/crafting_recipe/pillowpink
	name = "pillow (pink)"
	result = /obj/item/weapon/bedsheet/pillow
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowteal
	name = "pillow (teal)"
	result = /obj/item/weapon/bedsheet/pillow/teal
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowwhite
	name = "pillow (white)"
	result = /obj/item/weapon/bedsheet/pillow/white
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowblack
	name = "pillow (black)"
	result = /obj/item/weapon/bedsheet/pillow/black
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowgreen
	name = "pillow (green)"
	result = /obj/item/weapon/bedsheet/pillow/green
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowyellow
	name = "pillow (yellow)"
	result = /obj/item/weapon/bedsheet/pillow/yellow
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pillowred
	name = "pillow (red)"
	result = /obj/item/weapon/bedsheet/pillow/red
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/pilloworange
	name = "pillow (orange)"
	result = /obj/item/weapon/bedsheet/pillow/orange
	reqs = list(
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 60
	category = CAT_MISC

