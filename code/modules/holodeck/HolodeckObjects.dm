// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor
	desc = "A convincing simulation."
	thermal_conductivity = 0
	flags = TURF_ACID_IMMUNE

/turf/simulated/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/set_flooring()
	return

/turf/simulated/floor/holofloor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/holofloor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/holofloor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/holofloor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/holofloor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/holofloor/snow
	name = "snow"
	base_name = "snow"
	icon = 'icons/turf/floors.dmi'
	base_icon = 'icons/turf/floors.dmi'
	icon_state = "snow"
	base_icon_state = "snow"

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	plane = SPACE_PLANE
	name = "\proper space"
	icon_state = "white"

/turf/simulated/floor/holofloor/space/update_icon()
	. = ..()
	add_overlay(SSskybox.dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"])

/turf/simulated/floor/holofloor/reinforced
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /decl/flooring/reinforced
	name = "reinforced holofloor"
	icon_state = "reinforced"

/turf/simulated/floor/holofloor/beach
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon = 'icons/misc/beach.dmi'
	base_icon = 'icons/misc/beach.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/beach/sand
	name = "sand"
	icon_state = "desert"
	base_icon_state = "desert"

/turf/simulated/floor/holofloor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	base_icon_state = "sandwater"

/turf/simulated/floor/holofloor/beach/water
	name = "water"
	icon_state = "seashallow"
	base_icon_state = "seashallow"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	base_name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"
	base_icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/desert/Initialize(mapload)
	. = ..()
	if(prob(10))
		add_overlay("asteroid[rand(0,9)]")

/turf/simulated/floor/holofloor/bmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "darkmarble"
	initial_flooring = /decl/flooring/bmarble

/turf/simulated/floor/holofloor/wmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "lightmarble"
	initial_flooring = /decl/flooring/wmarble

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "stool_padded_preview"
	anchored = TRUE
	unacidable = TRUE
	pressure_resistance = 15

/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	unacidable = TRUE
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
			)
	item_state = "boxing"
	special_attack_type = /datum/unarmed_attack/holopugilism

/datum/unarmed_attack/holopugilism
	sparring_variant_type = /datum/unarmed_attack/holopugilism
	is_punch = TRUE

/datum/unarmed_attack/holopugilism/unarmed_override(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/zone)
	user.do_attack_animation(src)
	var/damage = rand(0, 9)
	if(!damage)
		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message(span_danger("[user] has attempted to punch [target]!"))
		return TRUE
	var/obj/item/organ/external/affecting = target.get_organ(ran_zone(user.zone_sel.selecting))
	var/armor_block = target.run_armor_check(affecting, "melee")
	var/armor_soak = target.get_armor_soak(affecting, "melee")

	if(HULK in user.mutations)
		damage += 5

	playsound(target, "punch", 25, 1, -1)

	target.visible_message(span_bolddanger("[user] has punched [target]!"))

	if(armor_soak >= damage)
		return TRUE

	target.apply_damage(damage, HALLOSS, affecting, armor_block, armor_soak)
	if(damage >= 9)
		target.visible_message(span_bolddanger("[user] has weakened [target]!"))
		target.apply_effect(4, WEAKEN, armor_block)

	return TRUE

/obj/structure/window/reinforced/holowindow/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return//I really wish I did not need this
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(isliving(G.affecting))
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
		to_chat(user, span_notice("It's a holowindow, you can't unfasten it!"))
	else if(W.has_tool_quality(TOOL_CROWBAR) && reinf && state <= 1)
		to_chat(user, span_notice("It's a holowindow, you can't pry it!"))
	else if(W.has_tool_quality(TOOL_WRENCH) && !anchored && (!state || !reinf))
		to_chat(user, span_notice("It's a holowindow, you can't dismantle it!"))
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force)
			if(health <= 7)
				anchored = FALSE
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)
	return

/obj/machinery/door/window/holowindoor/attackby(obj/item/I as obj, mob/user as mob)

	if (src.operating == 1)
		return

	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		var/aforce = I.force
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message(span_bolddanger("[src] was hit by [I]."))
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick(text("[]deny", src.base_state), src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.density = FALSE
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		to_chat(user, span_notice("It's a holochair, you can't dismantle it!"))
	return
//VOREStation Add
/obj/structure/bed/holobed/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		to_chat(user, span_notice("It's a holochair, you can't dismantle it!"))
	return
//VOREStation Add End
/obj/item/holo
	damtype = HALLOSS
	no_attack_log = 1
	no_random_knockdown = TRUE

/obj/item/holo/esword
	name = "holographic energy sword"
	desc = "May the force be within you. Sorta."
	icon_state = "esword"
	var/lcolor
	var/rainbow = FALSE
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	flags = NOBLOODY
	unacidable = TRUE
	var/active = 0

/obj/item/holo/esword/green
	lcolor = "#008000"

/obj/item/holo/esword/red
	lcolor = "#FF0000"

/obj/item/holo/esword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message(span_danger("\The [user] parries [attack_text] with \the [src]!"))

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return TRUE
	return FALSE

/obj/item/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		item_state = "[icon_state]_blade"
		w_class = ITEMSIZE_LARGE
		playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, span_notice("[src] is now active."))
	else
		force = 3
		item_state = "[icon_state]"
		w_class = ITEMSIZE_SMALL
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, span_notice("[src] can now be concealed."))

	update_icon()
	add_fingerprint(user)
	return

/obj/item/holo/esword/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool) && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, span_notice("You manipulate the color controller in [src]."))
		update_icon()
	return ..()

/obj/item/holo/esword/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

//BASKETBALL OBJECTS

/obj/item/beach_ball/holoball
	icon = 'icons/obj/balls_vr.dmi'
	icon_state = "basketball"
	name = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = ITEMSIZE_LARGE //Stops people from hiding it in their bags/pockets
	unacidable = TRUE
	drop_sound = 'sound/items/drop/basketball.ogg'
	pickup_sound = 'sound/items/pickup/basketball.ogg'

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/32x64.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	throwpass = 1

/obj/structure/holohoop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(G.state<2)
			to_chat(user, span_warning("You need a better grip to do that!"))
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message(span_warning("[G.assailant] dunks [G.affecting] into the [src]!"), 3)
		qdel(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_item(src.loc)
		visible_message(span_notice("[user] dunks [W] into the [src]!"), 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return TRUE
		if(prob(50))
			I.forceMove(loc)
			visible_message(span_notice("Swish! \the [I] lands in \the [src]."), 3)
		else
			visible_message(span_warning("\The [I] bounces off of \the [src]'s rim!"), 3)
		return FALSE
	return ..()

/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	layer = ABOVE_WINDOW_LAYER
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	unacidable = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user)
	to_chat(user, "The station AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/attackby(obj/item/W, mob/user)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/attack_hand(mob/user)

	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return

	if(!user.IsAdvancedToolUser())
		return 0

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(user, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

// A window that disappears when the ready button is pressed
/obj/structure/window/reinforced/holowindow/disappearing
	name = "Event Window"

//Holocarp

/mob/living/simple_mob/animal/space/carp/holodeck
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

/mob/living/simple_mob/animal/space/carp/holodeck/Initialize(mapload)
	. = ..()
	set_light(2) //hologram lighting

/mob/living/simple_mob/animal/space/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		faction = FACTION_NEUTRAL
		melee_damage_lower = 0
		melee_damage_upper = 0
	else
		faction = FACTION_CARP
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)

/mob/living/simple_mob/animal/space/carp/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_mob/animal/space/carp/holodeck/death()
	..()
	derez()

/mob/living/simple_mob/animal/space/carp/holodeck/proc/derez()
	visible_message(span_infoplain(span_bold("\The [src]") + " fades away!"))
	qdel(src)
