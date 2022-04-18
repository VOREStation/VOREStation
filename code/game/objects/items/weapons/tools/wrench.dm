/*
 * Wrench
 */
/obj/item/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	slot_flags = SLOT_BELT
	force = 6
	throwforce = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	usesound = 'sound/items/ratchet.ogg'
	toolspeed = 1
	drop_sound = 'sound/items/drop/wrench.ogg'
	pickup_sound = 'sound/items/pickup/wrench.ogg'
	tool_qualities = list(TOOL_WRENCH)

/obj/item/tool/wrench/cyborg
	name = "automatic wrench"
	desc = "An advanced robotic wrench. Can be found in industrial synthetic shells."
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5

<<<<<<< HEAD
/obj/item/weapon/tool/wrench/pipe
	name = "pipe wrench"
	desc = "A wrench used for plumbing. Can make a good makeshift weapon."
	icon_state = "pipe_wrench"
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 10

/obj/item/weapon/tool/wrench/hybrid	// Slower and bulkier than normal power tools, but it has the power of reach. If reach even worked half the time.
=======
/obj/item/tool/wrench/hybrid	// Slower and bulkier than normal power tools, but it has the power of reach. If reach even worked half the time.
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "strange wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "hybwrench"
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_PHORON = 2)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked", "warped", "blasted")
	usesound = 'sound/effects/stealthoff.ogg'
	toolspeed = 0.5
	reach = 2

/datum/category_item/catalogue/anomalous/precursor_a/alien_wrench
	name = "Precursor Alpha Object - Fastener Torque Tool"
	desc = "This is an object that has a distinctive tool shape. \
	It has a handle on one end, with a simple mechanism attached to it. \
	On the other end is the head of the tool, with two sides each glowing \
	a different color. The head opens up towards the top, in a similar shape \
	as a conventional wrench.\
	<br><br>\
	When an object is placed into the head section of the tool, the tool appears \
	to force the object to be turned in a specific direction. The direction can be \
	inverted by pressing down on the mechanism on the handle. It is not known if \
	this tool was intended by its creators to tighten fasteners or if it has a less obvious \
	purpose, however it is very well suited to act in a wrench's capacity regardless."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/wrench/alien
	name = "alien wrench"
	desc = "A polarized wrench. It causes anything placed between the jaws to turn."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wrench)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)

/obj/item/tool/wrench/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a bolt bit."
	icon_state = "drill_bolt"
	item_state = "drill"
	usesound = 'sound/items/drill_use.ogg'
	matter = list(MAT_STEEL = 150, MAT_SILVER = 50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	force = 8
	w_class = ITEMSIZE_SMALL
	throwforce = 8
	attack_verb = list("drilled", "screwed", "jabbed")
	toolspeed = 0.25
	var/obj/item/tool/screwdriver/power/counterpart = null

<<<<<<< HEAD
/obj/item/weapon/tool/wrench/power/New(newloc, no_counterpart = TRUE)
	..(newloc)
=======
/obj/item/tool/wrench/power/Initialize(var/ml, no_counterpart = TRUE)
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/tool/wrench/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/tool/wrench/power/attack_self(mob/user)
	playsound(src,'sound/items/change_drill.ogg',50,1)
	user.drop_item(src)
	counterpart.forceMove(get_turf(src))
	src.forceMove(counterpart)
	user.put_in_active_hand(counterpart)
	to_chat(user, "<span class='notice'>You attach the screw driver bit to [src].</span>")
