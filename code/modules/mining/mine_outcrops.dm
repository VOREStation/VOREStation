/obj/structure/outcrop
	name = "outcrop"
	desc = "A boring rocky outcrop."
	icon = 'icons/obj/outcrop.dmi'
	density = TRUE
	throwpass = 1
	climbable = TRUE
	anchored = TRUE
	icon_state = "outcrop"
	var/mindrop = 5
	var/upperdrop = 10
	var/outcropdrop = /obj/item/ore/glass

/obj/structure/outcrop/Initialize()
	. = ..()
	if(prob(1))
		add_overlay("[initial(icon_state)]-egg")

/obj/structure/outcrop/diamond
	name = "shiny outcrop"
	desc = "A shiny rocky outcrop."
	icon_state = "outcrop-diamond"
	mindrop = 2
	upperdrop = 4
	outcropdrop = /obj/item/ore/diamond

/obj/structure/outcrop/phoron
	name = "shiny outcrop"
	desc = "A shiny rocky outcrop."
	icon_state = "outcrop-phoron"
	mindrop = 4
	upperdrop = 8
	outcropdrop = /obj/item/ore/phoron

/obj/structure/outcrop/iron
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-iron"
	mindrop = 10
	upperdrop = 20
	outcropdrop = /obj/item/ore/iron

/obj/structure/outcrop/coal
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-coal"
	mindrop = 10
	upperdrop = 20
	outcropdrop = /obj/item/ore/coal

/obj/structure/outcrop/lead
	name = "rugged outcrop"
	desc = "A rugged rocky outcrop."
	icon_state = "outcrop-lead"
	mindrop = 2
	upperdrop = 5
	outcropdrop = /obj/item/ore/lead

/obj/structure/outcrop/gold
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-gold"
	mindrop = 4
	upperdrop = 6
	outcropdrop = /obj/item/ore/gold

/obj/structure/outcrop/silver
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-silver"
	mindrop = 6
	upperdrop = 8
	outcropdrop = /obj/item/ore/silver

/obj/structure/outcrop/platinum
	name = "hollow outcrop"
	desc = "A hollow rocky outcrop."
	icon_state = "outcrop-platinum"
	mindrop = 2
	upperdrop = 5
	outcropdrop = /obj/item/ore/osmium

/obj/structure/outcrop/uranium
	name = "spiky outcrop"
	desc = "A spiky rocky outcrop, it glows faintly."
	icon_state = "outcrop-uranium"
	mindrop = 4
	upperdrop = 8
	outcropdrop = /obj/item/ore/uranium

/obj/structure/outcrop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pickaxe))
		to_chat(user, span_notice("[user] begins to hack away at \the [src]."))
		if(do_after(user,40))
			to_chat(user, span_notice("You have finished digging!"))
			for(var/i=0;i<(rand(mindrop,upperdrop));i++)
				new outcropdrop(get_turf(src))
			qdel(src)
			return
	if (istype(W, /obj/item/melee/shock_maul))
		var/obj/item/melee/shock_maul/S = W
		if(!S.wielded || !S.status)
			to_chat(user, span_warning("\The [W] must be wielded in two hands and powered on to be used for mining!"))
			return
		to_chat(user, span_notice("You pulverize \the [src]!"))
		for(var/i=0;i<(rand(mindrop,upperdrop));i++)
			new outcropdrop(get_turf(src))
		playsound(src, 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
		user.visible_message(span_warning("\The [S] discharges with a thunderous, hair-raising crackle!"))
		S.deductcharge()
		S.status = 0
		S.update_held_icon()
		qdel(src)
		return

/obj/random/outcrop //In case you want an outcrop without pre-determining the type of ore.
	name = "random rock outcrop"
	desc = "This is a random rock outcrop."
	icon = 'icons/obj/outcrop.dmi'
	icon_state = "outcrop-random"

/obj/random/outcrop/item_to_spawn()
	return pick(prob(100);/obj/structure/outcrop,
				prob(100);/obj/structure/outcrop/iron,
				prob(100);/obj/structure/outcrop/coal,
				prob(65);/obj/structure/outcrop/silver,
				prob(50);/obj/structure/outcrop/gold,
				prob(30);/obj/structure/outcrop/uranium,
				prob(30);/obj/structure/outcrop/phoron,
				prob(7);/obj/structure/outcrop/diamond,
				prob(15);/obj/structure/outcrop/platinum,
				prob(15);/obj/structure/outcrop/lead)
