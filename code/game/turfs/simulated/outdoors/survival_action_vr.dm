/turf/simulated/floor/outdoors/newdirt/attack_hand(mob/user)
	if(user.pulling)
		return ..()
	var/static/list/has_rocks = list("dirt5", "dirt6", "dirt7", "dirt8", "dirt9")
	if(!Adjacent(user))
		return ..()
	if(icon_state in has_rocks)
		user.visible_message("[user] loosens rocks from \the [src]...", "You loosen rocks from \the [src]...")
		if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
			var/obj/item/stack/material/flint/R = new(get_turf(src), rand(1,4))
			R.pixel_x = rand(-6,6)
			R.pixel_y = rand(-6,6)
			icon_state = "dirt0"
		return
	if(locate(/obj) in src)
		to_chat(user, "<span class='notice'>The [name] isn't clear.</span>")
		return
	else
		var/choice= tgui_alert(user, "Do you want to build a growplot out of the dirt?", "Build growplot?" , list("Yes", "No"))
		if(!choice||choice=="No")
			return
		user.visible_message("[user] starts piling up \the [src]...", "You start piling up \the [src]...")
		if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
			new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

/turf/simulated/floor/outdoors
	var/rock_chance = 0

/turf/simulated/floor/outdoors/proc/rock_gathering(var/mob/user as mob)
	if(locate(/obj) in src)
		to_chat(user, "<span class='notice'>The [name] isn't clear.</span>")
		return
	user.visible_message("[user] starts digging around in \the [src]...", "You start digging around in \the [src]...")
	if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
		if(prob(rock_chance))
			var/obj/item/stack/material/flint/R = new(get_turf(src), rand(1,4))
			to_chat(user, "<span class='notice'>You found some [R]</span>")
			R.pixel_x = rand(-6,6)
			R.pixel_y = rand(-6,6)
		else
			to_chat(user, "<span class='notice'>You didn't find anything...</span>")
	else
		return

/turf/simulated/floor/outdoors/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/shovel) && rock_chance)
		rock_gathering(user)
	else
		return ..()

/turf/simulated/floor/outdoors/newdirt
	rock_chance = 5
/turf/simulated/floor/outdoors/dirt
	rock_chance = 10
/turf/simulated/floor/outdoors/rocks
	rock_chance = 100
/turf/simulated/floor/outdoors/ironsand
	rock_chance = 50

/turf/simulated/floor/outdoors/newdirt/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		var/static/list/has_rocks = list("dirt5", "dirt6", "dirt7", "dirt8", "dirt9")
		if(icon_state in has_rocks)
			. += "<span class='notice'>There are some rocks in the dirt.</span>"

/obj/structure/flora/tree
	var/sticks = TRUE

/obj/structure/flora/tree/attack_hand(mob/user)
	if(sticks)
		user.visible_message("[user] searches \the [src] for loose sticks...", "You search \the [src] for loose sticks...")
		if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
			var/obj/item/stack/material/stick/S = new(get_turf(user), rand(1,3))
			S.pixel_x = rand(-6,6)
			S.pixel_y = rand(-6,6)
			sticks = FALSE
	else
		to_chat(user, "<span class='notice'>You don't see any loose sticks...</span>")
