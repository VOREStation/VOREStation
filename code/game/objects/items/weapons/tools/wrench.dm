/*
 * Wrench
 */
/obj/item/weapon/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6
	throwforce = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	usesound = 'sound/items/ratchet.ogg'
	toolspeed = 1

/obj/item/weapon/tool/wrench/is_wrench()
	return TRUE

/obj/item/weapon/tool/wrench/cyborg
	name = "automatic wrench"
	desc = "An advanced robotic wrench. Can be found in industrial synthetic shells."
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5

/obj/item/weapon/tool/wrench/alien
	name = "alien wrench"
	desc = "A polarized wrench. It causes anything placed between the jaws to turn."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)

/obj/item/weapon/tool/wrench/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a bolt bit."
	icon_state = "drill_bolt"
	item_state = "drill"
	usesound = 'sound/items/drill_use.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 150, MAT_SILVER = 50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	force = 8
	w_class = ITEMSIZE_SMALL
	throwforce = 8
	attack_verb = list("drilled", "screwed", "jabbed")
	toolspeed = 0.25
	var/obj/item/weapon/tool/screwdriver/power/counterpart = null

/obj/item/weapon/tool/wrench/power/New(newloc, no_counterpart = TRUE)
	..(newloc)
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/weapon/tool/wrench/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/weapon/tool/wrench/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	user.drop_item(src)
	counterpart.forceMove(get_turf(src))
	src.forceMove(counterpart)
	user.put_in_active_hand(counterpart)
	to_chat(user, "<span class='notice'>You attach the screw driver bit to [src].</span>")