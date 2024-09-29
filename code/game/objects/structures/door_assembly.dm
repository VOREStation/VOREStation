/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	anchored = FALSE
	density = TRUE
	w_class = ITEMSIZE_HUGE
	var/state = 0
	var/base_icon_state = ""
	var/base_name = "airlock"
	var/obj/item/airlock_electronics/electronics = null
	var/airlock_type = "" //the type path of the airlock once completed
	var/glass_type = "/glass"
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null

/obj/structure/door_assembly/New()
	update_state()

/obj/structure/door_assembly/door_assembly_com
	base_icon_state = "com"
	base_name = "Command airlock"
	glass_type = "/glass_command"
	airlock_type = "/command"

/obj/structure/door_assembly/door_assembly_sec
	base_icon_state = "sec"
	base_name = "Security airlock"
	glass_type = "/glass_security"
	airlock_type = "/security"

/obj/structure/door_assembly/door_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering airlock"
	glass_type = "/glass_engineering"
	airlock_type = "/engineering"

/obj/structure/door_assembly/door_assembly_eat
	base_icon_state = "eat"
	base_name = "Engineering atmos airlock"
	glass_type = "/glass_engineeringatmos"
	airlock_type = "/engineering"

/obj/structure/door_assembly/door_assembly_min
	base_icon_state = "min"
	base_name = "Mining airlock"
	glass_type = "/glass_mining"
	airlock_type = "/mining"

/obj/structure/door_assembly/door_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics airlock"
	glass_type = "/glass_atmos"
	airlock_type = "/atmos"

/obj/structure/door_assembly/door_assembly_research
	base_icon_state = "res"
	base_name = "Research airlock"
	glass_type = "/glass_research"
	airlock_type = "/research"

/obj/structure/door_assembly/door_assembly_science
	base_icon_state = "sci"
	base_name = "Science airlock"
	glass_type = "/glass_science"
	airlock_type = "/science"

/obj/structure/door_assembly/door_assembly_med
	base_icon_state = "med"
	base_name = "Medical airlock"
	glass_type = "/glass_medical"
	airlock_type = "/medical"

/obj/structure/door_assembly/door_assembly_ext
	base_icon_state = "ext"
	base_name = "External airlock"
	glass_type = "/glass_external"
	airlock_type = "/external"

/obj/structure/door_assembly/door_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance airlock"
	airlock_type = "/maintenance"
	glass = -1

/obj/structure/door_assembly/door_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer airlock"
	airlock_type = "/freezer"
	glass = -1

/obj/structure/door_assembly/door_assembly_hatch
	base_icon_state = "hatch"
	base_name = "airtight hatch"
	airlock_type = "/hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "maintenance hatch"
	airlock_type = "/maintenance_hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "high security airlock"
	airlock_type = "/highsecurity"
	glass = -1

/obj/structure/door_assembly/door_assembly_voidcraft
	base_icon_state = "voidcraft"
	base_name = "voidcraft hatch"
	airlock_type = "/voidcraft"
	glass = -1

/obj/structure/door_assembly/door_assembly_voidcraft/vertical
	base_icon_state = "voidcraft_vertical"
	airlock_type = "/voidcraft/vertical"

/obj/structure/door_assembly/door_assembly_alien
	base_icon_state = "alien"
	base_name = "alien airlock"
	airlock_type = "/alien"
	glass = -1

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/door_assembly2x1.dmi'
	dir = EAST
	var/width = 1

/*Temporary until we get sprites.
	glass_type = "/multi_tile/glass"
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = "/multi_tile/glass"
	glass = -1 //To prevent bugs in deconstruction process.

/obj/structure/door_assembly/multi_tile/New()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	update_state()

/obj/structure/door_assembly/multi_tile/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/structure/door_assembly/proc/rename_door(mob/living/user)
	var/t = sanitizeSafe(tgui_input_text(user, "Enter the name for the [base_name].", src.name, src.created_name, MAX_NAME_LEN), MAX_NAME_LEN)
	if(!in_range(src, user) && src.loc != user)	return
	created_name = t
	update_state()

/obj/structure/door_assembly/attack_robot(mob/living/silicon/robot/user)
	if(Adjacent(user) && (user.module && (istype(user.module,/obj/item/robot_module/robot/engineering)) \
	|| istype(user.module,/obj/item/robot_module/drone))) //Only drone (and engiborg) needs this.
		rename_door(user)

/obj/structure/door_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen))
		rename_door(user)
		return

	if(W.has_tool_quality(TOOL_WELDER) && ( (istext(glass)) || (glass == 1) || (!anchored) ))
		var/obj/item/weldingtool/WT = W.get_welder()
		if (WT.remove_fuel(0, user))
			playsound(src, WT.usesound, 50, 1)
			if(istext(glass))
				user.visible_message("[user] welds the [glass] plating off the airlock assembly.", "You start to weld the [glass] plating off the airlock assembly.")
				if(do_after(user, 4 SECONDS * WT.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You welded the [glass] plating off!</span>")
					var/M = text2path("/obj/item/stack/material/[glass]")
					new M(src.loc, 2)
					glass = 0
			else if(glass == 1)
				user.visible_message("[user] welds the glass panel out of the airlock assembly.", "You start to weld the glass panel out of the airlock assembly.")
				if(do_after(user, 4 SECONDS * WT.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You welded the glass panel out!</span>")
					new /obj/item/stack/material/glass/reinforced(src.loc)
					glass = 0
			else if(!anchored)
				user.visible_message("[user] dissassembles the airlock assembly.", "You start to dissassemble the airlock assembly.")
				if(do_after(user, 4 SECONDS * WT.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You dissasembled the airlock assembly!</span>")
					new /obj/item/stack/material/steel(src.loc, 4)
					qdel (src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
			return

	else if(W.has_tool_quality(TOOL_WRENCH) && state == 0)
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring the airlock assembly from the floor.", "You starts unsecuring the airlock assembly from the floor.")
		else
			user.visible_message("[user] begins securing the airlock assembly to the floor.", "You starts securing the airlock assembly to the floor.")

		if(do_after(user, 4 SECONDS * W.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured the airlock assembly!</span>")
			anchored = !anchored

	else if(istype(W, /obj/item/stack/cable_coil) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = W
		if (C.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire the airlock assembly.</span>")
			return
		user.visible_message("[user] wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 4 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				to_chat(user, "<span class='notice'>You wire the airlock.</span>")

	else if(W.has_tool_quality(TOOL_WIRECUTTER) && state == 1 )
		playsound(src, W.usesound, 100, 1)
		user.visible_message("[user] cuts the wires from the airlock assembly.", "You start to cut the wires from airlock assembly.")

		if(do_after(user, 4 SECONDS * W.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the airlock wires.!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			src.state = 0

	else if(istype(W, /obj/item/airlock_electronics) && state == 1)
		playsound(src, W.usesound, 100, 1)
		user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 4 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE))
			if(!src) return
			user.drop_item()
			W.loc = src
			to_chat(user, "<span class='notice'>You installed the airlock electronics!</span>")
			src.state = 2
			src.electronics = W

	else if(W.has_tool_quality(TOOL_CROWBAR) && state == 2 )
		//This should never happen, but just in case I guess
		if (!electronics)
			to_chat(user, "<span class='notice'>There was nothing to remove.</span>")
			src.state = 1
			return

		playsound(src, W.usesound, 100, 1)
		user.visible_message("\The [user] starts removing the electronics from the airlock assembly.", "You start removing the electronics from the airlock assembly.")

		if(do_after(user, 4 SECONDS * W.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")
			src.state = 1
			electronics.loc = src.loc
			electronics = null

	else if(istype(W, /obj/item/stack/material) && !glass)
		var/obj/item/stack/S = W
		var/material_name = S.get_material_name()
		if (S)
			if (S.get_amount() >= 1)
				if(material_name == "rglass")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
					if(do_after(user, 4 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) && !glass)
						if (S.use(1))
							to_chat(user, "<span class='notice'>You installed reinforced glass windows into the airlock assembly.</span>")
							glass = 1
				else if(material_name)
					// Ugly hack, will suffice for now. Need to fix it upstream as well, may rewrite mineral walls. ~Z
					if(!(material_name in list("gold", "silver", "diamond", "uranium", "phoron", "sandstone")))
						to_chat(user, "You cannot make an airlock out of that material.")
						return
					if(S.get_amount() >= 2)
						playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
						user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
						if(do_after(user, 4 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) && !glass)
							if (S.use(2))
								to_chat(user, "<span class='notice'>You installed [material_display_name(material_name)] plating into the airlock assembly.</span>")
								glass = material_name

	else if(W.has_tool_quality(TOOL_SCREWDRIVER) && state == 2 )
		playsound(src, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>Now finishing the airlock.</span>")

		if(do_after(user, 4 SECONDS * W.toolspeed, src, exclusive = TASK_ALL_EXCLUSIVE))
			if(!src) return
			to_chat(user, "<span class='notice'>You finish the airlock!</span>")
			var/path
			if(istext(glass))
				path = text2path("/obj/machinery/door/airlock/[glass]")
			else if (glass == 1)
				path = text2path("/obj/machinery/door/airlock[glass_type]")
			else
				path = text2path("/obj/machinery/door/airlock[airlock_type]")

			new path(src.loc, src)
			qdel(src)
	else
		..()
	update_state()

/obj/structure/door_assembly/proc/update_state()
	icon_state = "door_as_[glass == 1 ? "g" : ""][istext(glass) ? glass : base_icon_state][state]"
	name = ""
	switch (state)
		if(0)
			if (anchored)
				name = "secured "
		if(1)
			name = "wired "
		if(2)
			name = "near finished "
	name += "[glass == 1 ? "window " : ""][istext(glass) ? "[glass] airlock" : base_name] assembly ([created_name])"

// Airlock frames are indestructable, so bullets hitting them would always be stopped.
// To fix this, airlock assemblies will sometimes let bullets pass through, since generally the sprite shows them partially open.
/obj/structure/door_assembly/bullet_act(var/obj/item/projectile/P)
	if(prob(40)) // Chance for the frame to let the bullet keep going.
		return PROJECTILE_CONTINUE
	return ..()
