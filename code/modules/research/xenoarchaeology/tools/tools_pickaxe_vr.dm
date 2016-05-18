
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Excavation pickaxes - sorted in order of delicacy. Players will have to choose the right one for each part of excavation.

/obj/item/weapon/pickaxe/brush
	name = "brush"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick_brush"
	item_state = "syringe_0"
	digspeed = 20
	desc = "Thick metallic wires for clearing away dust and loose scree (1 centimetre excavation depth)."
	excavation_amount = 0.5
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"
	w_class = 2

/obj/item/weapon/pickaxe/one_pick
	name = "1/6 pick"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick1"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (2 centimetre excavation depth)."
	excavation_amount = 1
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/two_pick
	name = "1/3 pick"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick2"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (4 centimetre excavation depth)."
	excavation_amount = 2
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/three_pick
	name = "1/2 pick"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick3"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (6 centimetre excavation depth)."
	excavation_amount = 3
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/four_pick
	name = "2/3 pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick4"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (8 centimetre excavation depth)."
	excavation_amount = 4
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/five_pick
	name = "5/6 pick"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick5"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (10 centimetre excavation depth)."
	excavation_amount = 5
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/six_pick
	name = "1/1 pick"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick6"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (12 centimetre excavation depth)."
	excavation_amount = 6
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = 2

/obj/item/weapon/pickaxe/hand
	name = "hand pickaxe"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "pick_hand"
	item_state = "syringe_0"
	digspeed = 30
	desc = "A smaller, more precise version of the pickaxe (30 centimetre excavation depth)."
	excavation_amount = 15
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"
	w_class = 3

/obj/item/weapon/pickaxe/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill"
	item_state = "syringe_0"
	excavation_amount = 15
	digspeed = 30
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 30 cm."
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "drilling"
	force = 15.0
	w_class = 2
	attack_verb = list("drilled")

/obj/item/weapon/pickaxe/excavationdrill/attack_self(mob/user as mob)
	var/depth = input("Put the desired depth (1-30 centimeters).", "Set Depth", 30) as num
	if(depth>30 || depth<1)
		user << "<span class='notice'>Invalid depth.</span>"
		return
	excavation_amount = depth/2
	user << "<span class='notice'>You set the depth to [depth]cm.</span>"

/obj/item/weapon/pickaxe/excavationdrill/examine(mob/user)
	..()
	var/depth = excavation_amount*2
	user << "<span class='info'>It is currently set at [depth]cms.</span>"
