/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/rainbow/attack_self(mob/living/user)
	var/new_colour = tgui_color_picker(user, "Please select the main colour.", "Crayon colour", colour)
	if(new_colour)
		colour = new_colour
	new_colour = tgui_color_picker(user, "Please select the shade colour.", "Crayon shade colour", shadeColour)
	if(new_colour)
		shadeColour = new_colour
	return

/obj/item/pen/crayon/afterattack(atom/target, mob/user, proximity, click_parameters)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = tgui_input_list(user, "Choose what you'd like to draw.", "Crayon scribbles", list("graffiti","rune","letter","arrow"))
		if(!drawtype)
			return
		if(get_dist(target, user) > 1 || !(user.z == target.z))
			return
		switch(drawtype)
			if("letter")
				drawtype = tgui_input_list(user, "Choose the letter.", "Crayon scribbles", list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))
				if(!drawtype || get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				drawtype = tgui_input_list(user, "Choose the graffiti.", "Crayon scribbles", list("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa"))
				if(!drawtype || get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				drawtype = tgui_input_list(user, "Choose the rune.", "Crayon scribbles", list("rune1", "rune2", "rune3", "rune4", "rune5", "rune6"))
				if(!drawtype || get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = tgui_input_list(user, "Choose the arrow.", "Crayon scribbles", list("left", "right", "up", "down"))
				if(!drawtype || get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			var/list/mouse_control = params2list(click_parameters)
			var/p_x = 0
			var/p_y = 0
			if(mouse_control["icon-x"])
				p_x = text2num(mouse_control["icon-x"]) - 16
			if(mouse_control["icon-y"])
				p_y = text2num(mouse_control["icon-y"]) - 16
			var/atom/new_graffiti = new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			new_graffiti.pixel_x = p_x
			new_graffiti.pixel_y = p_y
			to_chat(user, "You finish drawing.")

			var/msg = "[user.client.key] ([user]) has drawn [drawtype] (with [src]) at [target.x],[target.y],[target.z]."
			if(CONFIG_GET(flag/log_graffiti))
				message_admins(msg)
			log_game(msg) //We will log it anyways.

			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, span_warning("You used up your crayon!"))
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/living/M as mob, mob/living/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the crayon and swallow it.")
		user.nutrition += 1
		if(ishuman(user))
			var/mob/living/carbon/human/human = user
			human.ingested.add_reagent(REAGENT_ID_CRAYONDUST,min(5,uses)/3)
		else
			user.reagents.add_reagent(REAGENT_ID_CRAYONDUST,min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user, span_warning("You ate your crayon!"))
				qdel(src)
	else
		..()

/obj/item/pen/crayon/marker/black
	icon_state = "markerblack"
	colour = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/pen/crayon/marker/red
	icon_state = "markerred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/marker/orange
	icon_state = "markerorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/marker/green
	icon_state = "markergreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/marker/blue
	icon_state = "markerblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/marker/purple
	icon_state = "markerpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/marker/mime/attack_self(mob/living/user) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/marker/rainbow/attack_self(mob/living/user)
	var/new_colour = tgui_color_picker(user, "Please select the main colour.", "Marker colour", colour)
	if(new_colour)
		colour = new_colour
	new_colour = tgui_color_picker(user, "Please select the shade colour.", "Marker colour", shadeColour)
	if(new_colour)
		shadeColour = new_colour
	return

/obj/item/pen/crayon/marker/attack(mob/living/M, mob/living/user)
	if(M == user)
		to_chat(user, "You take a bite of the marker and swallow it.")
		user.nutrition += 1
		if(ishuman(user))
			var/mob/living/carbon/human/human = user
			human.ingested.add_reagent(REAGENT_ID_MARKERINK,6)
		else
			user.reagents.add_reagent(REAGENT_ID_MARKERINK,6)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user, span_warning("You ate the marker!"))
				qdel(src)
	else
		..()

/obj/item/pen/crayon/attack_self(var/mob/user)
	return
