GLOBAL_LIST_INIT(has_rocks, list("dirt5", "dirt6", "dirt7", "dirt8", "dirt9"))

/turf/simulated/floor/outdoors/newdirt/attack_hand(mob/user)
	if(user.pulling)
		return ..()
	if(!Adjacent(user))
		return ..()
	if(user.a_intent != I_HELP)
		return ..()
	if(icon_state in GLOB.has_rocks)
		user.visible_message("[user] loosens rocks from \the [src]...", "You loosen rocks from \the [src]...")
		if(do_after(user, 5 SECONDS, target = src))
			var/obj/item/stack/material/flint/R = new(get_turf(src), rand(1,4))
			R.pixel_x = rand(-6,6)
			R.pixel_y = rand(-6,6)
			icon_state = "dirt0"
		return
	if(locate(/obj) in src)
		to_chat(user, span_notice("The [name] isn't clear."))
		return
	else
		var/choice= tgui_alert(user, "Do you want to build a growplot out of the dirt?", "Build growplot?" , list("Yes", "No"))
		if(!choice||choice=="No")
			return
		user.visible_message("[user] starts piling up \the [src]...", "You start piling up \the [src]...")
		if(do_after(user, 5 SECONDS, target = src))
			new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

/turf/simulated/floor/outdoors/newdirt/get_dig_loot_type(mob/user, obj/item/W)
	if(prob(5))
		return /obj/item/stack/material/flint
	if(prob(2))
		return pick(/obj/fruitspawner/potato, /obj/fruitspawner/carrot)
	. = ..()

/turf/simulated/floor/outdoors/dirt/get_dig_loot_type(mob/user, obj/item/W)
	if(prob(10))
		return /obj/item/stack/material/flint
	if(prob(2))
		return pick(/obj/fruitspawner/potato, /obj/fruitspawner/carrot)
	. = ..()

/turf/simulated/floor/outdoors/rocks/get_dig_loot_type(mob/user, obj/item/W)
	return /obj/item/stack/material/flint

/turf/simulated/floor/outdoors/ironsand/get_dig_loot_type(mob/user, obj/item/W)
	if(prob(50))
		return pick(/obj/item/stack/material/flint, /obj/item/ore/iron)
	. = ..()

/turf/simulated/floor/outdoors/newdirt/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		var/static/list/has_rocks = list("dirt5", "dirt6", "dirt7", "dirt8", "dirt9")
		if(icon_state in has_rocks)
			. += span_notice("There are some rocks in the dirt.")

/obj/structure/flora/tree
	var/sticks = TRUE

/obj/structure/flora/tree/attack_hand(mob/user)
	if(sticks)
		user.visible_message("[user] searches \the [src] for loose sticks...", "You search \the [src] for loose sticks...")
		if(do_after(user, 5 SECONDS, target = src))
			var/obj/item/stack/material/stick/S = new(get_turf(user), rand(1,3))
			S.pixel_x = rand(-6,6)
			S.pixel_y = rand(-6,6)
			sticks = FALSE
	else
		to_chat(user, span_notice("You don't see any loose sticks..."))
