/turf/simulated/floor/outdoors/newdirt/attack_hand(mob/user)
	var/static/list/has_rocks = list("dirt5", "dirt6", "dirt7", "dirt8", "dirt9")
	if(Adjacent(user))
		if(icon_state in has_rocks)
			user.visible_message("[user] loosens rocks from [src]...", runemessage = "loosens rocks from [src]")
			if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
				var/obj/item/stack/material/flint/R = new(get_turf(src))
				R.amount = rand(1,4)
				R.pixel_x = rand(-6,6)
				R.pixel_y = rand(-6,6)
				icon_state = "dirt0"
			return
		if(locate(/obj) in src)
			to_chat(user, "<span class='notice'>The dirt isn't clear.</span>")
		else
			var/choice= tgui_alert(user, "Do you want to build a growplot out of the dirt?", "Build growplot?" , list("Yes", "No"))
			if(!choice||choice=="No")
				return
			user.visible_message("[user] starts piling up [src]...", runemessage = "piles up [src]")
			if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
				new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

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
		user.visible_message("[user] searches [src] for loose sticks...", runemessage = "searches [src] for loose sticks")
		if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
			var/obj/item/stack/material/stick/S = new(get_turf(user))
			S.amount = rand(1,3)
			S.pixel_x = rand(-6,6)
			S.pixel_y = rand(-6,6)
			sticks = FALSE
	else
		to_chat(user, "<span class='notice'>You don't see any loose sticks...</span>")