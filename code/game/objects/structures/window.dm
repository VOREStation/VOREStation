/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures_vr.dmi' // VOREStation Edit - New icons
	density = TRUE
	can_atmos_pass = ATMOS_PASS_PROC
	w_class = ITEMSIZE_NORMAL

	layer = WINDOW_LAYER
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE
	flags = ON_BORDER
	var/maxhealth = 14.0
	var/maximal_heat = T0C + 100 		// Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/health
	var/force_threshold = 0
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate
	var/fulltile = FALSE // Set to true on full-tile variants.

/obj/structure/window/examine(mob/user)
	. = ..()

	if(health == maxhealth)
		. += span_notice("It looks fully intact.")
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			. += span_notice("It has a few cracks.")
		else if(perc > 0.5)
			. += span_warning("It looks slightly damaged.")
		else if(perc > 0.25)
			. += span_warning("It looks moderately damaged.")
		else
			. += span_danger("It looks heavily damaged.")
	if(silicate)
		if (silicate < 30)
			. += span_notice("It has a thin layer of silicate.")
		else if (silicate < 70)
			. += span_notice("It is covered in silicate.")
		else
			. += span_notice("There is a thick layer of silicate covering it.")

/obj/structure/window/examine_icon()
	return icon(icon=initial(icon),icon_state=initial(icon_state))

/obj/structure/window/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
			update_icon()
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
			update_icon()
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
			update_icon()
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	cut_overlays()
	update_icon()

	var/image/img = image(src)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	add_overlay(img)

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	new shardtype(loc)
	if(reinf)
		new /obj/item/stack/rods(loc)
	if(is_fulltile())
		new shardtype(loc) //todo pooling?
		if(reinf)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	..()
	take_damage(proj_damage)
	return


/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return

/obj/structure/window/blob_act()
	take_damage(50)

/obj/structure/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return TRUE
	if(is_fulltile())
		return FALSE	//full tile window, you can't move into it!
	if(get_dir(mover, target) == reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	else
		return TRUE

/obj/structure/window/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return TRUE
	if(get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return !density
	else
		return TRUE

/obj/structure/window/CanZASPass(turf/T, is_zone)
	if(is_fulltile() || get_dir(T, loc) == turn(dir, 180)) // Make sure we're handling the border correctly.
		return !anchored // If it's anchored, it'll block air.
	return TRUE // Don't stop airflow from the other sides.

/obj/structure/window/hitby(AM as mob|obj)
	..()
	visible_message(span_danger("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(health - tforce <= 7 && !reinf)
		anchored = FALSE
		update_verbs()
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message(span_notice("Something knocks on [src]."))
	playsound(src, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(user.get_attack_speed())
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(span_danger("[user] smashes through [src]!"))
		user.do_attack_animation(src)
		shatter()

	else if (user.a_intent == I_HURT)

		if (istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		user.visible_message(span_danger("\The [user] bangs against \the [src]!"),
							span_danger("You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
		user.visible_message("[user.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(user.get_attack_speed())
	if(!damage)
		return
	if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
		visible_message(span_danger("[user] smashes into [src]!"))
		if(reinf)
			damage = damage / 2
		take_damage(damage)
	else
		visible_message(span_infoplain(span_bold("\The [user]") + " bonks \the [src] harmlessly."))
	user.do_attack_animation(src)
	return 1

/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this

	// Fixing.
	if(W.has_tool_quality(TOOL_WELDER) && user.a_intent == I_HELP)
		var/obj/item/weldingtool/WT = W.get_welder()
		if(health < maxhealth)
			if(WT.remove_fuel(1 ,user))
				to_chat(user, span_notice("You begin repairing [src]..."))
				playsound(src, WT.usesound, 50, 1)
				if(do_after(user, 40 * WT.toolspeed, target = src))
					health = maxhealth
			//		playsound(src, 'sound/items/Welder.ogg', 50, 1)
					update_icon()
					to_chat(user, span_notice("You repair [src]."))
		else
			to_chat(user, span_warning("[src] is already in good condition!"))
		return

	// Slamming.
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch (state)
				if(1)
					M.visible_message(span_warning("[user] slams [M] against \the [src]!"))
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message(span_danger("[user] bashes [M] against \the [src]!"))
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message(span_danger("<big>[user] crushes [M] against \the [src]!</big>"))
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			return

	if(W.flags & NOBLUDGEON) return

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(reinf && state >= 1)
			state = 3 - state
			update_nearby_icons()
			playsound(src, W.usesound, 75, 1)
			to_chat(user, span_notice("You have [state == 1 ? "un" : ""]fastened the window [state ? "from" : "to"] the frame."))
		else if(reinf && state == 0)
			anchored = !anchored
			update_nearby_tiles(need_rebuild=1)
			update_nearby_icons()
			update_verbs()
			playsound(src, W.usesound, 75, 1)
			to_chat(user, span_notice("You have [anchored ? "" : "un"]fastened the frame [anchored ? "to" : "from"] the floor."))
		else if(!reinf)
			anchored = !anchored
			update_nearby_tiles(need_rebuild=1)
			update_nearby_icons()
			update_verbs()
			playsound(src, W.usesound, 75, 1)
			to_chat(user, span_notice("You have [anchored ? "" : "un"]fastened the window [anchored ? "to" : "from"] the floor."))
	else if(W.has_tool_quality(TOOL_CROWBAR) && reinf && state <= 1)
		state = 1 - state
		playsound(src, W.usesound, 75, 1)
		to_chat(user, span_notice("You have pried the window [state ? "into" : "out of"] the frame."))
	else if(W.has_tool_quality(TOOL_WRENCH) && !anchored && (!state || !reinf))
		if(!glasstype)
			to_chat(user, span_notice("You're not sure how to dismantle \the [src] properly."))
		else
			playsound(src, W.usesound, 75, 1)
			visible_message(span_notice("[user] dismantles \the [src]."))
			var/obj/item/stack/material/mats = new glasstype(loc)
			if(is_fulltile())
				mats.set_amount(4)
			qdel(src)
	else if(istype(W, /obj/item/stack/cable_coil) && reinf && state == 0 && !istype(src, /obj/structure/window/reinforced/polarized))
		var/obj/item/stack/cable_coil/C = W
		if (C.use(1))
			playsound(src, 'sound/effects/sparks1.ogg', 75, 1)
			user.visible_message( \
				span_infoplain(span_bold("\The [user]") + " begins to wire \the [src] for electrochromic tinting."), \
				span_notice("You begin to wire \the [src] for electrochromic tinting."), \
				"You hear sparks.")
			if(do_after(user, 20 * C.toolspeed, src) && state == 0)
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				var/obj/structure/window/reinforced/polarized/P = new(loc, dir)
				if(is_fulltile())
					P.fulltile = TRUE
					P.icon_state = "fwindow"
				P.maxhealth = maxhealth
				P.health = health
				P.state = state
				P.anchored = anchored
				qdel(src)
	else if(istype(W,/obj/item/frame) && anchored)
		var/obj/item/frame/F = W
		F.try_build(src, user)
	else
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			if(health <= 7)
				anchored = FALSE
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(damage < force_threshold || force_threshold < 0)
		return
	if(reinf) damage *= 0.5
	take_damage(damage)
	return


/obj/structure/window/verb/rotate_counterclockwise()
	set name = "Rotate Window Counterclockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	src.set_dir(turn(src.dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/verb/rotate_clockwise()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	src.set_dir(turn(src.dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return

/obj/structure/window/New(Loc, start_dir=null, constructed=0)
	..()

	if (start_dir)
		set_dir(start_dir)

	//player-constructed windows
	if (constructed)
		anchored = FALSE
		state = 0
		update_verbs()

	health = maxhealth

	ini_dir = dir

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()


/obj/structure/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	. = ..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	return fulltile

/obj/structure/window/is_between_turfs(var/turf/origin, var/turf/target)
	if(is_fulltile())
		return TRUE
	return ..()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored || is_fulltile())
		verbs -= /obj/structure/window/verb/rotate_counterclockwise
		verbs -= /obj/structure/window/verb/rotate_clockwise
	else if(!is_fulltile())
		verbs += /obj/structure/window/verb/rotate_counterclockwise
		verbs += /obj/structure/window/verb/rotate_clockwise

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	cut_overlays()
	if(!is_fulltile())
		// Rotate the sprite somewhat so non-fulltiled windows can be seen as needing repair.
		var/full_tilt_degrees = 15
		var/tilt_to_apply = abs((health / maxhealth) - 1)
		if(tilt_to_apply && prob(50))
			tilt_to_apply = -tilt_to_apply
		adjust_rotation(LERP(0, full_tilt_degrees, tilt_to_apply))

		icon_state = "[basestate]"
		return
	else
		flags = 0 // Removes ON_BORDER and OPPOSITE_OPACITY
	var/list/dirs = list()
	if(anchored)
		for(var/obj/structure/window/W in orange(src,1))
			if(W.anchored && W.density && W.glasstype == src.glasstype && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
				dirs += get_dir(src, W)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		add_overlay(I)

	// Damage overlays.
	var/ratio = health / maxhealth
	ratio = CEILING(ratio * 4, 1) * 25

	if(ratio > 75)
		return
	var/image/I = image(icon, "damage[ratio]", layer = layer + 0.1)
	add_overlay(I)

	return

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()



/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... almost anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 2.0
	maxhealth = 12.0
	force_threshold = 3

/obj/structure/window/basic/full
	icon_state = "window-full"
	maxhealth = 24
	fulltile = TRUE
	flags = 0

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	basestate = "phoronwindow"
	icon_state = "phoronwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 40.0
	force_threshold = 5

/obj/structure/window/phoronbasic/full
	icon_state = "phoronwindow-full"
	maxhealth = 80
	fulltile = TRUE
	flags = 0

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "phoronrwindow"
	icon_state = "phoronrwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 80.0
	force_threshold = 10

/obj/structure/window/phoronreinforced/full
	icon_state = "phoronrwindow-full"
	maxhealth = 160
	fulltile = TRUE
	flags = 0

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 40.0
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced
	force_threshold = 6

/obj/structure/window/reinforced/full
	icon_state = "rwindow-full"
	maxhealth = 80
	fulltile = TRUE
	flags = 0

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 30
	force_threshold = 5

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	maxhealth = 40
	reinf = 1
	basestate = "w"
	dir = 5
	force_threshold = 7

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/full
	icon_state = "rwindow-full"
	maxhealth = 80
	fulltile = TRUE
	flags = 0

/obj/structure/window/reinforced/polarized/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && !anchored) // Only allow programming if unanchored!
		var/obj/item/multitool/MT = W
		// First check if they have a windowtint button buffered
		if(istype(MT.connectable, /obj/machinery/button/windowtint))
			var/obj/machinery/button/windowtint/buffered_button = MT.connectable
			src.id = buffered_button.id
			to_chat(user, span_notice("\The [src] is linked to \the [buffered_button] with ID '[id]'."))
			return TRUE
		// Otherwise fall back to asking them... and remind them what the current ID is.
		if(id)
			to_chat(user, "The window's current ID is [id].")
		var/t = sanitizeSafe(input(user, "Enter the new ID for the window.", src.name, null), MAX_NAME_LEN)
		if(t && in_range(src, user))
			src.id = t
			to_chat(user, span_notice("The new ID of \the [src] is '[id]'."))
			return TRUE
	. = ..()

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)
	var/turf/T = get_turf(src)
	T.recalculate_directional_opacity()

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/stationobjs_vr.dmi' // VOREStation Edit - New icons
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7
	circuit = /obj/item/circuitboard/electrochromic

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"

/obj/machinery/button/windowtint/attackby(obj/item/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	else if(alarm_deconstruction_wirecutters(user, W))
		return
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/MT = W
		if(!id)
			// If no ID is set yet (newly built button?) let them select an ID for first-time use!
			var/t = sanitizeSafe(tgui_input_text(user, "Enter an ID for \the [src].", src.name, null, MAX_NAME_LEN), MAX_NAME_LEN)
			if (t && in_range(src, user))
				src.id = t
				to_chat(user, span_notice("The new ID of \the [src] is '[id]'. To reset this, rebuild the control."))
		if(id)
			// It already has an ID (or they just set one), buffer it for copying to windows.
			to_chat(user, span_notice("You store \the [src] ID ('[id]') in \the [MT]'s buffer!"))
			MT.connectable = src
			MT.update_icon()
		return TRUE
	. = ..()

/obj/structure/window/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)

/obj/structure/window/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE
