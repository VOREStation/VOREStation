/obj/item/pickaxe/brush
	name = "brush"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_brush"
	item_state = "syringe_0"
	slot_flags = SLOT_EARS
	digspeed = 20
	force = 0
	throwforce = 0
	desc = "Thick metallic wires for clearing away dust and loose scree (1 centimetre excavation depth)."
	excavation_amount = 1
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/one_pick
	name = "2cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick1"
	item_state = "syringe_0"
	force = 2
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (2 centimetre excavation depth)."
	excavation_amount = 2
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/two_pick
	name = "4cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick2"
	item_state = "syringe_0"
	force = 2
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (4 centimetre excavation depth)."
	excavation_amount = 4
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/three_pick
	name = "6cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick3"
	item_state = "syringe_0"
	force = 3
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (6 centimetre excavation depth)."
	excavation_amount = 6
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/four_pick
	name = "8cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick4"
	item_state = "syringe_0"
	force = 3
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (8 centimetre excavation depth)."
	excavation_amount = 8
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/five_pick
	name = "10cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick5"
	item_state = "syringe_0"
	force = 5
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (10 centimetre excavation depth)."
	excavation_amount = 10
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/six_pick
	name = "12cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick6"
	item_state = "syringe_0"
	force = 5
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (12 centimetre excavation depth)."
	excavation_amount = 12
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEMSIZE_SMALL

/obj/item/pickaxe/hand
	name = "hand pickaxe"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_hand"
	item_state = "syringe_0"
	force = 10
	digspeed = 30
	desc = "A smaller, more precise version of the pickaxe (30 centimetre excavation depth)."
	excavation_amount = 30
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"
	w_class = ITEMSIZE_SMALL

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	desc = "A set of picks for excavation."
	item_state = "syringe_kit"
	storage_slots = 7
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/pickaxe/brush,
	/obj/item/pickaxe/one_pick,
	/obj/item/pickaxe/two_pick,
	/obj/item/pickaxe/three_pick,
	/obj/item/pickaxe/four_pick,
	/obj/item/pickaxe/five_pick,
	/obj/item/pickaxe/six_pick,
	/obj/item/pickaxe/hand)
	max_storage_space = ITEMSIZE_COST_SMALL * 9
	max_w_class = ITEMSIZE_SMALL
	use_to_pickup = TRUE

/obj/item/storage/excavation/Initialize()
	. = ..()
	new /obj/item/pickaxe/brush(src)
	new /obj/item/pickaxe/one_pick(src)
	new /obj/item/pickaxe/two_pick(src)
	new /obj/item/pickaxe/three_pick(src)
	new /obj/item/pickaxe/four_pick(src)
	new /obj/item/pickaxe/five_pick(src)
	new /obj/item/pickaxe/six_pick(src)

/obj/item/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/storage/excavation/proc/sort_picks()
	var/list/obj/item/pickaxe/picksToSort = list()
	for(var/obj/item/pickaxe/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/pickaxe/current = picksToSort[i]
			if(current.excavation_amount <= min)
				selected = i
				min = current.excavation_amount
		var/obj/item/pickaxe/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	orient2hud()

/obj/item/pickaxe/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill2"
	item_state = "syringe_0"
	excavation_amount = 15
	digspeed = 30
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The tip is adjustable from 1 to 30 cm."
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "drilling"
	force = 5
	w_class = 2
	attack_verb = list("drilled")

/obj/item/pickaxe/excavationdrill/attack_self(mob/user as mob)
	var/depth = tgui_input_number(usr, "Put the desired depth (1-30 centimeters).", "Set Depth", 30, 30, 1)
	if(depth>30 || depth<1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	excavation_amount = depth
	to_chat(user, "<span class='notice'>You set the depth to [depth]cm.</span>")
	switch(depth)
		if(1 to 5)
			icon_state = "excavationdrill0"
		if(6 to 10)
			icon_state = "excavationdrill1"
		if(11 to 15)
			icon_state = "excavationdrill2"
		if(16 to 20)
			icon_state = "excavationdrill3"
		if(21 to 25)
			icon_state = "excavationdrill4"
		if(25 to 30)
			icon_state = "excavationdrill5" //The other 2 sprites are comically long. Let's just cut it at 5.

/obj/item/pickaxe/excavationdrill/examine(mob/user)
	. = ..()
	. += "<span class='info'>It is currently set at [excavation_amount]cms.</span>"
