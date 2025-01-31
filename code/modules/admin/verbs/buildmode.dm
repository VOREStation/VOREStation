#define BUILDMODE_BASIC 	1
#define BUILDMODE_ADVANCED 	2
#define BUILDMODE_EDIT 		3
#define BUILDMODE_THROW 	4
#define BUILDMODE_ROOM 		5
#define BUILDMODE_LADDER 	6
#define BUILDMODE_CONTENTS 	7
#define BUILDMODE_LIGHTS 	8
#define BUILDMODE_AI 		9
#define BUILDMODE_DROP 		10

#define LAST_BUILDMODE		10

/proc/togglebuildmode(mob/M as mob in player_list)
	set name = "Toggle Build Mode"
	set category = "Special Verbs"
	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(M)] has left build mode.")
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			M.plane_holder.set_vis(VIS_BUILDMODE, FALSE)
			for(var/obj/effect/bmode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			log_admin("[key_name(M)] has entered build mode.")
			M.client.buildmode = 1
			M.client.show_popup_menus = 0
			M.plane_holder.set_vis(VIS_BUILDMODE, TRUE)

			var/obj/effect/bmode/buildholder/H = new/obj/effect/bmode/buildholder()
			var/obj/effect/bmode/builddir/A = new/obj/effect/bmode/builddir(H)
			A.master = H
			var/obj/effect/bmode/buildhelp/B = new/obj/effect/bmode/buildhelp(H)
			B.master = H
			var/obj/effect/bmode/buildmode/C = new/obj/effect/bmode/buildmode(H)
			C.master = H
			var/obj/effect/bmode/buildquit/D = new/obj/effect/bmode/buildquit(H)
			D.master = H

			H.builddir = A
			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D
			M.client.screen += A
			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			H.cl = M.client

/obj/effect/bmode//Cleaning up the tree a bit
	density = TRUE
	anchored = TRUE
	layer = LAYER_HUD_BASE
	plane = PLANE_PLAYER_HUD
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/bmode/buildholder/master = null

/obj/effect/bmode/Destroy()
	if(master && master.cl)
		master.cl.screen -= src
	master = null
	return ..()

/obj/effect/bmode/builddir
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/effect/bmode/builddir/Click()
	switch(dir)
		if(NORTH)
			set_dir(EAST)
		if(EAST)
			set_dir(SOUTH)
		if(SOUTH)
			set_dir(WEST)
		if(WEST)
			set_dir(NORTHWEST)
		if(NORTHWEST)
			set_dir(NORTH)
	return 1

/obj/effect/bmode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/buildhelp/Click()
	switch(master.cl.buildmode)

		if(BUILDMODE_BASIC)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button        = Construct / Upgrade<br>\
							Right Mouse Button       = Deconstruct / Delete / Downgrade<br>\
							Left Mouse Button + ctrl = R-Window<br>\
							Left Mouse Button + alt  = Airlock<br><br>\
							Use the button in the upper left corner to<br>\
							change the direction of built objects.<br>\
							***********************************************************"))

		if(BUILDMODE_ADVANCED)
			to_chat(usr, span_notice("***********************************************************<br>\
							Right Mouse Button on buildmode button = Set object type<br>\
							Middle Mouse Button on buildmode button= On/Off object type saying<br>\
							Middle Mouse Button on turf/obj        = Capture object type<br>\
							Left Mouse Button on turf/obj          = Place objects<br>\
							Right Mouse Button                     = Delete objects<br>\
							Mouse Button + ctrl                    = Copy object type<br><br>\
							Use the button in the upper left corner to<br>\
							change the direction of built objects.<br>\
							***********************************************************"))

		if(BUILDMODE_EDIT)
			to_chat(usr, span_notice("***********************************************************<br>\
							Right Mouse Button on buildmode button = Select var(type) & value<br>\
							Left Mouse Button on turf/obj/mob      = Set var(type) & value<br>\
							Right Mouse Button on turf/obj/mob     = Reset var's value<br>\
							***********************************************************"))

		if(BUILDMODE_THROW)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button on turf/obj/mob      = Select<br>\
							Right Mouse Button on turf/obj/mob     = Throw<br>\
							***********************************************************"))

		if(BUILDMODE_ROOM)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button on turf              = Select as point A<br>\
							Right Mouse Button on turf             = Select as point B<br>\
							Right Mouse Button on buildmode button = Change floor/wall type/area name<br>\
							***********************************************************"))

		if(BUILDMODE_LADDER)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button on turf              = Set as upper ladder loc<br>\
							Right Mouse Button on turf             = Set as lower ladder loc<br>\
							***********************************************************"))

		if(BUILDMODE_CONTENTS)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button on turf/obj/mob      = Select<br>\
							Right Mouse Button on turf/obj/mob     = Move into selection<br>\
							***********************************************************"))

		if(BUILDMODE_LIGHTS)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button on turf/obj/mob      = Make it glow<br>\
							Right Mouse Button on turf/obj/mob     = Reset glowing<br>\
							Right Mouse Button on buildmode button = Change glow properties<br>\
							***********************************************************"))

		if(BUILDMODE_AI)
			to_chat(usr, span_notice("***********************************************************<br>\
							Left Mouse Button drag box             = Select only mobs in box<br>\
							Left Mouse Button drag box + shift     = Select additional mobs in area<br>\
							Left Mouse Button on non-mob           = Deselect all mobs<br>\
							Left Mouse Button on AI mob            = Select/Deselect mob<br>\
							Left Mouse Button + alt on AI mob      = Toggle hostility on mob<br>\
							Left Mouse Button + shift on AI mob    = Toggle AI (also resets)<br>\
							Left Mouse Button + ctrl on AI mob 	   = Copy mob faction<br>\
							Middle Mouse Button + alt on any atom  = Add atom to entity narrate menu <br>\
							Middle Mouse Button + shift on any     = Set selected mob(s) to wander<br>\
							Middle Mouse Button + ctrl on any      = Set selected mob(s) to NOT wander<br>\
							Right Mouse Button + ctrl on any mob   = Paste mob faction copied with Left Mouse Button + shift<br>\
							Right Mouse Button on enemy mob        = Command selected mobs to attack mob<br>\
							Right Mouse Button on allied mob       = Command selected mobs to follow mob<br>\
							Right Mouse Button + shift on any mob  = Command selected mobs to follow mob regardless of faction<br>\
							Note: The following also reset the mob's home position:<br>\
							Right Mouse Button on tile             = Command selected mobs to move to tile (will cancel if enemies are seen)<br>\
							Right Mouse Button + shift on tile     = Command selected mobs to reposition to tile (will not be interrupted by enemies)<br>\
							Right Mouse Button + alt on obj/turfs  = Command selected mobs to attack obj/turf<br>\
							***********************************************************"))

		if(BUILDMODE_DROP)
			to_chat(usr, span_notice("***********************************************************<br>\
							Right Mouse Button on buildmode button = Set object type<br>\
							Middle Mouse Button on buildmode button= On/Off object type saying<br>\
							Middle Mouse Button on turf/obj        = Capture object type<br>\
							Left Mouse Button on turf/obj          = Drop objects safely<br>\
							Right Mouse Button                     = Drop objects unsafely<br>\
							Mouse Button + ctrl                    = Copy object type<br><br>\
							***********************************************************"))
	return 1

/obj/effect/bmode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/effect/bmode/buildquit/Click()
	togglebuildmode(master.cl.mob)
	return 1

/obj/effect/bmode/buildholder
	density = FALSE
	anchored = TRUE
	var/client/cl = null
	var/obj/effect/bmode/builddir/builddir = null
	var/obj/effect/bmode/buildhelp/buildhelp = null
	var/obj/effect/bmode/buildmode/buildmode = null
	var/obj/effect/bmode/buildquit/buildquit = null
	var/atom/movable/throw_atom = null
	var/list/selected_mobs = list()
	var/copied_faction = null
	var/warned = 0

/obj/effect/bmode/buildholder/Destroy()
	qdel(builddir)
	builddir = null
	qdel(buildhelp)
	buildhelp = null
	qdel(buildmode)
	buildmode = null
	qdel(buildquit)
	buildquit = null
	throw_atom = null
	for(var/mob/living/unit in selected_mobs)
		deselect_AI_mob(cl, unit)
	selected_mobs.Cut()
	cl = null
	return ..()

/obj/effect/bmode/buildholder/proc/select_AI_mob(client/C, mob/living/unit)
	selected_mobs += unit
	C.images += unit.selected_image

/obj/effect/bmode/buildholder/proc/deselect_AI_mob(client/C, mob/living/unit)
	selected_mobs -= unit
	C.images -= unit.selected_image

/obj/effect/bmode/buildmode
	icon_state = "buildmode1"
	screen_loc = "NORTH,WEST+2"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = null
	var/objsay = 1

	var/wall_holder = /turf/simulated/wall
	var/floor_holder = /turf/simulated/floor/plating
	var/turf/coordA = null
	var/turf/coordB = null
	var/area_enabled = 0
	var/area_name = "New Area"

	var/new_light_color = "#FFFFFF"
	var/new_light_range = 3
	var/new_light_intensity = 3

/obj/effect/bmode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("middle"))
		switch(master.cl.buildmode)
			if(BUILDMODE_ADVANCED)
				objsay=!objsay

	if(pa.Find("left"))
		if(master.cl.buildmode == LAST_BUILDMODE)
			master.cl.buildmode = 1
		else
			master.cl.buildmode++
		src.icon_state = "buildmode[master.cl.buildmode]"

	else if(pa.Find("right"))
		switch(master.cl.buildmode)
			if(BUILDMODE_BASIC)

				return 1
			if(BUILDMODE_ADVANCED)
				objholder = get_path_from_partial_text()

			if(BUILDMODE_EDIT)
				var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine")

				master.buildmode.varholder = tgui_input_text(usr,"Enter variable name:" ,"Name", "name")
				if(master.buildmode.varholder in locked && !check_rights(R_DEBUG,0))
					return 1
				var/thetype = tgui_input_list(usr,"Select variable type:", "Type", list("text","number","mob-reference","obj-reference","turf-reference"))
				if(!thetype) return 1
				switch(thetype)
					if("text")
						master.buildmode.valueholder = tgui_input_text(usr,"Enter variable value:" ,"Value", "value")
					if("number")
						master.buildmode.valueholder = tgui_input_number(usr,"Enter variable value:" ,"Value", 123)
					if("mob-reference")
						master.buildmode.valueholder = tgui_input_list(usr,"Enter variable value:", "Value", mob_list)
					if("obj-reference")
						master.buildmode.valueholder = tgui_input_list(usr,"Enter variable value:", "Value", world)
					if("turf-reference")
						master.buildmode.valueholder = tgui_input_list(usr,"Enter variable value:", "Value", world)

			if(BUILDMODE_ROOM)
				switch(tgui_alert(usr, "Would you like to generate a new area as well?","Room Builder", list("No", "Yes")))
					if(null)
						return
					if("No")
						area_enabled = 0
					if("Yes")
						area_enabled = 1
						area_name = tgui_input_text(usr, "New area name", "Room Buildmode", max_length = MAX_NAME_LEN)
						if(isnull(area_name))
							to_chat(usr, span_notice("You must enter a non-null name."))
							area_enabled = 0
							return
						area_name = sanitize(area_name,MAX_NAME_LEN)
				var/choice = tgui_alert(usr, "Would you like to change the floor or wall holders?","Room Builder", list("Floor", "Wall"))
				switch(choice)
					if("Floor")
						floor_holder = get_path_from_partial_text(/turf/simulated/floor/plating)
					if("Wall")
						wall_holder = get_path_from_partial_text(/turf/simulated/wall)

			if(BUILDMODE_LIGHTS)
				var/choice = tgui_alert(usr, "Change the new light range, power, or color?", "Light Maker", list("Range", "Power", "Color"))
				switch(choice)
					if("Range")
						var/input = tgui_input_number(usr, "New light range.","Light Maker",3)
						if(input)
							new_light_range = input
					if("Power")
						var/input = tgui_input_number(usr, "New light power.","Light Maker",3)
						if(input)
							new_light_intensity = input
					if("Color")
						var/input = input(usr, "New light color.","Light Maker",3) as null|color
						if(input)
							new_light_color = input
			if(BUILDMODE_DROP)
				objholder = get_path_from_partial_text()
	return 1

/proc/build_click(var/mob/user, buildmode, params, var/obj/object)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(buildmode)
		if(BUILDMODE_BASIC)
			if(istype(object,/turf) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				if(istype(object,/turf/space))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall/r_wall)
					return
			else if(pa.Find("right"))
				if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					if(!holder.warned)
						var/warning = tgui_alert(user, "Are you -sure- you want to delete this turf and make it the base turf for this Z level?", "GRIEF ALERT", list("No", "Yes"))
						if(warning == "Yes")
							holder.warned = 1
						else
							return
					T.ChangeTurf(get_base_turf_by_area(T)) //Defaults to Z if area does not have a special base turf.
					return
				else if(istype(object,/turf/simulated/wall/r_wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/obj))
					qdel(object)
					return
			else if(istype(object,/turf) && pa.Find("alt") && pa.Find("left"))
				new/obj/machinery/door/airlock(get_turf(object))
			else if(istype(object,/turf) && pa.Find("ctrl") && pa.Find("left"))
				switch(holder.builddir.dir)
					if(NORTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTH)
					if(SOUTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(SOUTH)
					if(EAST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(EAST)
					if(WEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(WEST)
					if(NORTHWEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTHWEST)
			else if(istype(object,/turf) && pa.Find("ctrl") && pa.Find("alt") && pa.Find("middle"))
				var/turf/T = object
				var/obj/item/toy/plushie/teshari/easter_egg = new /obj/item/toy/plushie/teshari(T)
				easter_egg.name = "coding teshari plushie"
				easter_egg.desc = "A small purple teshari with a plush keyboard attached to it. Where did this come from?"
				easter_egg.color = "#a418c7"


		if(BUILDMODE_ADVANCED)
			if(pa.Find("left") && !pa.Find("ctrl"))
				if(ispath(holder.buildmode.objholder,/turf))
					var/turf/T = get_turf(object)
					T.ChangeTurf(holder.buildmode.objholder)
				else if(ispath(holder.buildmode.objholder))
					var/obj/A = new holder.buildmode.objholder (get_turf(object))
					A.set_dir(holder.builddir.dir)
			else if(pa.Find("right"))
				if(isobj(object))
					qdel(object)
			else if(pa.Find("ctrl"))
				holder.buildmode.objholder = object.type
				to_chat(user, span_notice("[object]([object.type]) copied to buildmode."))
			if(pa.Find("middle"))
				holder.buildmode.objholder = text2path("[object.type]")
				if(holder.buildmode.objsay)
					to_chat(usr, "[object.type]")

		if(BUILDMODE_EDIT)
			if(pa.Find("left")) //I cant believe this shit actually compiles.
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = holder.buildmode.valueholder
				else
					to_chat(user, span_danger("[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'"))
			if(pa.Find("right"))
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = initial(object.vars[holder.buildmode.varholder])
				else
					to_chat(user, span_danger("[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'"))

		if(BUILDMODE_THROW)
			if(pa.Find("left"))
				if(istype(object, /atom/movable))
					holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom)
					holder.throw_atom.throw_at(object, 10, 1)
					log_admin("[key_name(usr)] threw [holder.throw_atom] at [object]")

		if(BUILDMODE_ROOM)
			if(pa.Find("left"))
				holder.buildmode.coordA = get_turf(object)
				to_chat(user, span_notice("Defined [object] ([object.type]) as point A."))

			if(pa.Find("right"))
				holder.buildmode.coordB = get_turf(object)
				to_chat(user, span_notice("Defined [object] ([object.type]) as point B."))

			if(holder.buildmode.coordA && holder.buildmode.coordB)
				if(isnull(holder.buildmode.area_name))
					to_chat(user, span_notice("ERROR: Insert area name before use."))
					holder.buildmode.coordA = null
					holder.buildmode.coordB = null
					return
				to_chat(user, span_notice("A and B set, creating rectangle."))
				holder.buildmode.make_rectangle(
					holder.buildmode.coordA,
					holder.buildmode.coordB,
					holder.buildmode.wall_holder,
					holder.buildmode.floor_holder,
					holder.buildmode.area_enabled,
					holder.buildmode.area_name)
				holder.buildmode.coordA = null
				holder.buildmode.coordB = null

		if(BUILDMODE_LADDER)
			if(pa.Find("left"))
				holder.buildmode.coordA = get_turf(object)
				to_chat(user, span_notice("Defined [object] ([object.type]) as upper ladder location."))

			if(pa.Find("right"))
				holder.buildmode.coordB = get_turf(object)
				to_chat(user, span_notice("Defined [object] ([object.type]) as lower ladder location."))

			if(holder.buildmode.coordA && holder.buildmode.coordB)
				to_chat(user, span_notice("Ladder locations set, building ladders."))
				var/obj/structure/ladder/A = new /obj/structure/ladder/up(holder.buildmode.coordA)
				var/obj/structure/ladder/B = new /obj/structure/ladder(holder.buildmode.coordB)
				A.target_up = B
				B.target_down = A
				A.update_icon()
				B.update_icon()
				holder.buildmode.coordA = null
				holder.buildmode.coordB = null

		if(BUILDMODE_CONTENTS)
			if(pa.Find("left"))
				if(istype(object, /atom))
					holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom && istype(object, /atom/movable))
					object.forceMove(holder.throw_atom)
					log_admin("[key_name(usr)] moved [object] into [holder.throw_atom].")

		if(BUILDMODE_LIGHTS)
			if(pa.Find("left"))
				if(object)
					object.set_light(holder.buildmode.new_light_range, holder.buildmode.new_light_intensity, holder.buildmode.new_light_color)
			if(pa.Find("right"))
				if(object)
					object.set_light(0, 0, "#FFFFFF")

		if(BUILDMODE_AI)
			if(pa.Find("left"))
				if(isliving(object))
					var/mob/living/L = object

					// Pause/unpause AI
					if(pa.Find("shift"))
						var/stance = L.get_AI_stance()
						if(!isnull(stance)) // Null means there's no AI datum or it has one but is player controlled w/o autopilot on.
							var/datum/ai_holder/AI = L.ai_holder
							if(stance == STANCE_SLEEP)
								AI.go_wake()
								to_chat(user, span_notice("\The [L]'s AI has been enabled."))
							else
								AI.go_sleep()
								to_chat(user, span_notice("\The [L]'s AI has been disabled."))
							return
						else
							to_chat(user, span_warning("\The [L] is not AI controlled."))
						return

					// Toggle hostility
					if(pa.Find("alt"))
						if(!isnull(L.get_AI_stance()))
							var/datum/ai_holder/AI = L.ai_holder
							AI.hostile = !AI.hostile
							to_chat(user, span_notice("\The [L] is now [AI.hostile ? "hostile" : "passive"]."))
						else
							to_chat(user, span_warning("\The [L] is not AI controlled."))
						return

					// Copy faction
					if(pa.Find("ctrl"))
						holder.copied_faction = L.faction
						to_chat(user, span_notice("Copied faction '[holder.copied_faction]'."))
						return

					// Select/Deselect
					if(!isnull(L.get_AI_stance()))
						if(L in holder.selected_mobs)
							holder.deselect_AI_mob(user.client, L)
							to_chat(user, span_notice("Deselected \the [L]."))
						else
							holder.select_AI_mob(user.client, L)
							to_chat(user, span_notice("Selected \the [L]."))
						return
					else
						to_chat(user, span_warning("\The [L] is not AI controlled."))
						return
				else //Not living
					for(var/mob/living/unit in holder.selected_mobs)
						holder.deselect_AI_mob(user.client, unit)

			if(pa.Find("middle"))
				if(pa.Find("shift"))
					to_chat(user, span_notice("All selected mobs set to wander"))
					for(var/mob/living/unit in holder.selected_mobs)
						var/datum/ai_holder/AI = unit.ai_holder
						AI.wander = TRUE
				if(pa.Find("ctrl"))
					to_chat(user, span_notice("Setting mobs set to NOT wander"))
					for(var/mob/living/unit in holder.selected_mobs)
						var/datum/ai_holder/AI = unit.ai_holder
						AI.wander = FALSE
				if(pa.Find("alt") && isatom(object))
					to_chat(user, span_notice("Adding [object] to Entity Narrate List!"))
					user.client.add_mob_for_narration(object)


			if(pa.Find("right"))
				// Paste faction
				if(pa.Find("ctrl") && isliving(object))
					if(!holder.copied_faction)
						to_chat(user, span_warning("LMB+Shift a mob to copy their faction before pasting."))
						return
					else
						var/mob/living/L = object
						L.faction = holder.copied_faction
						to_chat(user, span_notice("Pasted faction '[holder.copied_faction]'."))
						return

				if(istype(object, /atom)) // Force attack.
					var/atom/A = object

					if(pa.Find("alt"))
						var/i = 0
						for(var/mob/living/unit in holder.selected_mobs)
							var/datum/ai_holder/AI = unit.ai_holder
							AI.give_target(A)
							i++
						to_chat(user, span_notice("Commanded [i] mob\s to attack \the [A]."))
						var/image/orderimage = image(buildmode_hud,A,"ai_targetorder")
						orderimage.plane = PLANE_BUILDMODE
						flick_overlay(orderimage, list(user.client), 8, TRUE)
						return

				if(isliving(object)) // Follow or attack.
					var/mob/living/L = object
					var/i = 0 // Attacking mobs.
					var/j = 0 // Following mobs.
					for(var/mob/living/unit in holder.selected_mobs)
						var/datum/ai_holder/AI = unit.ai_holder
						if(L.IIsAlly(unit) || !AI.hostile || pa.Find("shift"))
							AI.set_follow(L)
							j++
						else
							AI.give_target(L)
							i++
					var/message = "Commanded "
					if(i)
						message += "[i] mob\s to attack \the [L]"
						if(j)
							message += ", and "
						else
							message += "."
					if(j)
						message += "[j] mob\s to follow \the [L]."
					to_chat(user, span_notice(message))
					var/image/orderimage = image(buildmode_hud,L,"ai_targetorder")
					orderimage.plane = PLANE_BUILDMODE
					flick_overlay(orderimage, list(user.client), 8, TRUE)
					return

				if(isturf(object)) // Move or reposition.
					var/turf/T = object
					var/forced = 0
					var/told = 0
					for(var/mob/living/unit in holder.selected_mobs)
						var/datum/ai_holder/AI = unit.ai_holder
						AI.home_turf = T
						if(unit.get_AI_stance() == STANCE_SLEEP)
							unit.forceMove(T)
							forced++
						else
							AI.give_destination(T, 1, pa.Find("shift")) // If shift is held, the mobs will not stop moving to attack a visible enemy.
							told++
					to_chat(user, span_notice("Commanded [told] mob\s to move to \the [T], and manually placed [forced] of them."))
					var/image/orderimage = image(buildmode_hud,T,"ai_turforder")
					orderimage.plane = PLANE_BUILDMODE
					flick_overlay(orderimage, list(user.client), 8, TRUE)
					return


		if(BUILDMODE_DROP)
			if(ispath(holder.buildmode.objholder,/turf))
				to_chat(user, span_warning("Cannot use turfs with this mode."))
				return
			if(pa.Find("left") && !pa.Find("ctrl"))
				if(ispath(holder.buildmode.objholder))
					var/obj/effect/falling_effect/FE = new /obj/effect/falling_effect(get_turf(object), holder.buildmode.objholder)
					FE.crushing = FALSE
			else if(pa.Find("right"))
				if(ispath(holder.buildmode.objholder))
					var/obj/effect/falling_effect/FE = new /obj/effect/falling_effect(get_turf(object), holder.buildmode.objholder)
					FE.crushing = TRUE
			else if(pa.Find("ctrl"))
				holder.buildmode.objholder = object.type
				to_chat(user, span_notice("[object]([object.type]) copied to buildmode."))
			if(pa.Find("middle"))
				holder.buildmode.objholder = text2path("[object.type]")
				if(holder.buildmode.objsay)
					to_chat(usr, "[object.type]")

/proc/build_drag(var/client/user, buildmode, var/atom/fromatom, var/atom/toatom, var/atom/fromloc, var/atom/toloc, var/fromcontrol, var/tocontrol, params)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H)
		if(H.cl == user)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(buildmode)
		if(BUILDMODE_AI)

			//Holding shift prevents the deselection of existing
			if(!pa.Find("shift"))
				for(var/mob/living/unit in holder.selected_mobs)
					holder.deselect_AI_mob(user, unit)

			var/turf/c1 = get_turf(fromatom)
			var/turf/c2 = get_turf(toatom)
			if(!c1 || !c2)
				return //Dragged outside window or something

			var/low_x = min(c1.x,c2.x)
			var/low_y = min(c1.y,c2.y)
			var/hi_x = max(c1.x,c2.x)
			var/hi_y = max(c1.y,c2.y)
			var/z = c1.z //Eh

			var/i = 0
			for(var/mob/living/L in living_mob_list)
				if(L.z != z || L.client)
					continue
				if(L.x >= low_x && L.x <= hi_x && L.y >= low_y && L.y <= hi_y)
					holder.select_AI_mob(user, L)
					i++

			to_chat(user, span_notice("Band-selected [i] mobs."))
			return

/obj/effect/bmode/buildmode/proc/get_path_from_partial_text(default_path)
	var/desired_path = tgui_input_text(usr, "Enter full or partial typepath.","Typepath","[default_path]")

	if(!desired_path)	//VOREStation Add - If you don't give it anything it builds a list of every possible thing in the game and crashes your client.
		return			//VOREStation Add - And the main way for it to do that is to push the cancel button, which should just do nothing. :U

	var/list/types = typesof(/atom)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", desired_path))
			matches += path

	if(matches.len==0)
		tgui_alert_async(usr, "No results found.  Sorry.")
		return

	var/result = null

	if(matches.len==1)
		result = matches[1]
	else
		result = tgui_input_list(usr, "Select an atom type", "Spawn Atom", matches, strict_modern = TRUE)
	return result

/obj/effect/bmode/buildmode/proc/make_rectangle(var/turf/A, var/turf/B, var/turf/wall_type, var/turf/floor_type, var/area_enabled, var/area_name)
	if(!A || !B) // No coords
		return
	if(A.z != B.z) // Not same z-level
		return

	var/height = A.y - B.y
	var/width = A.x - B.x
	var/z_level = A.z

	var/turf/lower_left_corner = null
	// First, try to find the lowest part
	var/desired_y = 0
	if(A.y <= B.y)
		desired_y = A.y
	else
		desired_y = B.y

	//Now for the left-most part.
	var/desired_x = 0
	if(A.x <= B.x)
		desired_x = A.x
	else
		desired_x = B.x

	lower_left_corner = locate(desired_x, desired_y, z_level)

	// Now we can begin building the actual room.  This defines the boundries for the room.
	var/low_bound_x = lower_left_corner.x
	var/low_bound_y = lower_left_corner.y

	var/high_bound_x = lower_left_corner.x + abs(width)
	var/high_bound_y = lower_left_corner.y + abs(height)

	var/origin_x = lower_left_corner.x + round((abs(width)/2))
	var/origin_y = lower_left_corner.y + round((abs(height)/2))
	var/turf/origin

	for(var/i = low_bound_x, i <= high_bound_x, i++)
		for(var/j = low_bound_y, j <= high_bound_y, j++)
			var/turf/T = locate(i, j, z_level)
			if(i == low_bound_x || i == high_bound_x || j == low_bound_y || j == high_bound_y)
				if(isturf(wall_type))
					T.ChangeTurf(wall_type)
				else
					new wall_type(T)

			else
				if(T.x == origin_x && T.y == origin_y) //Get the middle of the square.
					origin = T
				if(isturf(floor_type))
					T.ChangeTurf(floor_type)
				else
					new floor_type(T)
	if(area_enabled) //Let's try not to make a new area unless you got walls and a floor.
		create_buildmode_area(area_name, origin) //Generates a new area.

/proc/create_buildmode_area(var/area_name, var/turf/origin)
	var/turfs = detect_room_buildmode(origin)

	var/area/newA
	var/area/oldA = get_area(origin)
	var/str = area_name
	str = sanitize(str,MAX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	newA = new /area/buildmode
	newA.dynamic_lighting = FALSE // Without this it's pitch black if you build anywhere but space.
	newA.luminosity = TRUE // Without this it's pitch black if you build anywhere but space.
	newA.setup(str)
	newA.has_gravity = oldA.has_gravity

	for(var/i in 1 to length(turfs)) //Fix lighting. Praise the lord.
		var/turf/thing = turfs[i]
		newA.contents += thing
		thing.change_area(oldA, newA)

	set_area_machinery(newA, newA.name, oldA.name)// Change the name and area defines of all the machinery to the correct area.
	oldA.power_check() //Simply makes the area turn the power off if you nicked an APC from it.
	return TRUE

/proc/detect_room_buildmode(var/turf/first, var/allowedAreas = AREA_SPACE)
	if(!istype(first))
		return
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		var/turf/T = pending[1]
		pending -= T
		for (var/dir in cardinal)
			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue
			// We ask ZAS to determine if its airtight.  Thats what matters anyway right?
			if(SSair.air_blocked(T, NT))
				// Okay thats the edge of the room
				if(get_area_type_buildmode(NT.loc) == AREA_SPACE && SSair.air_blocked(NT, NT))
					found += NT // So we include walls/doors not already in any area
				continue
			if (istype(NT, /turf/space))
				return //omg hull breach we all going to die here
			if (istype(NT, /turf/simulated/shuttle))
				return // Unsure why this, but was in old code. Trusting for now.
			if (NT.loc != first.loc && !(get_area_type_buildmode(NT.loc) & allowedAreas))
				// Edge of a protected area.  Lets stop here...
				continue
			if (!istype(NT, /turf/simulated))
				// Great, unsimulated... eh, just stop searching here
				continue
			// Okay, NT looks promising, lets continue the search there!
			pending += NT
		found += T
	// end while
	return found

/proc/get_area_type_buildmode(area/A)
	if(A.outdoors)
		return AREA_SPACE

	for (var/type in BUILDABLE_AREA_TYPES)
		if ( istype(A,type) )
			return AREA_SPACE

	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return AREA_SPECIAL
	return AREA_STATION

/area/buildmode
	dynamic_lighting = FALSE
	luminosity = FALSE

#undef BUILDMODE_BASIC
#undef BUILDMODE_ADVANCED
#undef BUILDMODE_EDIT
#undef BUILDMODE_THROW
#undef BUILDMODE_ROOM
#undef BUILDMODE_LADDER
#undef BUILDMODE_CONTENTS
#undef BUILDMODE_LIGHTS
#undef BUILDMODE_AI
#undef LAST_BUILDMODE
#undef BUILDMODE_DROP
