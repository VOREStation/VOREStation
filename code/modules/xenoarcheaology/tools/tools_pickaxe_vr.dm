/obj/item/weapon/pickaxe/brush
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/one_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/two_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/three_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/four_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/five_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/six_pick
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/hand
	icon = 'icons/obj/xenoarchaeology_vr.dmi'

/obj/item/weapon/pickaxe/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology_vr.dmi'
	icon_state = "excavationdrill0"
	item_state = "syringe_0"
	excavation_amount = 15
	digspeed = 30
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 30 cms."
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "drilling"
	force = 15.0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("drilled")
	hitsound = 'sound/weapons/circsawhit.ogg'

/obj/item/weapon/pickaxe/excavationdrill/attack_self(mob/user as mob)
	var/depth = input("Put the desired depth (1-30 centimeters).", "Set Depth", 30) as num
	if(depth>30 || depth<1)
		user << "<span class='notice'>Invalid depth.</span>"
		return
	excavation_amount = depth
	user << "<span class='notice'>You set the depth to [depth]cm.</span>"
	if (depth<4)
		icon_state = "excavationdrill0"
	else if (depth >=4 && depth <8)
		icon_state = "excavationdrill1"
	else if (depth >=8 && depth <12)
		icon_state = "excavationdrill2"
	else if (depth >=12 && depth <16)
		icon_state = "excavationdrill3"
	else if (depth >=16 && depth <20)
		icon_state = "excavationdrill4"
	else if (depth >=20 && depth <24)
		icon_state = "excavationdrill5"
	else if (depth >=24 && depth <28)
		icon_state = "excavationdrill6"
	else
		icon_state = "excavationdrill7"

/obj/item/weapon/pickaxe/excavationdrill/examine(mob/user)
	..()
	var/depth = excavation_amount
	user << "<span class='info'>It is currently set at [depth]cms.</span>"
