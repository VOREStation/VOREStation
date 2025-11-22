/obj/structure/window/maintenance_panel
	name = "maintenance panel"
	desc = "A maintenance panel. It covers important things hidden inside the wall."
	description_info = "Can be cut through or repaired with a welder. Can be deconstructed with a wrench once detached."
	icon = 'icons/obj/maintenance_panel.dmi'
	icon_state = "panel"
	basestate = "panel"
	maxhealth = 350
	glasstype = /obj/item/stack/tile/maintenance_panel // Yes these are technically windows, drops into their panel on deconstruct and shatter
	maximal_heat = /datum/material/steel::melting_point
	force_threshold = 5
	shardtype = null
	opacity = 1 // Difficult to see past

/obj/structure/window/maintenance_panel/apply_silicate(var/amount)
	return // can't fix it like that

/obj/structure/window/maintenance_panel/updateSilicate()
	return // can't fix it like that

/obj/structure/window/maintenance_panel/attack_ghost(mob/observer/dead/user as mob)
	return // Too powerful for ghosts

/obj/structure/window/maintenance_panel/is_fulltile()
	return FALSE // NEVER

/obj/structure/window/maintenance_panel/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		return // Cannot be screwed down
	if(istype(W, /obj/item/stack/cable_coil))
		return // Cannot be electrochromed
	if(W.has_tool_quality(TOOL_WELDER) && (user.a_intent != I_HELP || health == maxhealth)) // If at max health or not on help
		var/obj/item/weldingtool/WT = W.get_welder()
		if(WT.remove_fuel(1, user))
			to_chat(user, span_warning("You begin to [!anchored ? "weld" : "cut"] the [src] [!anchored ? "to" : "off"] the wall."))
			playsound(src, W.usesound, 75, 1)
			if(do_after(user, 2 SECONDS, target = src))
				anchored = !anchored
				update_nearby_tiles(need_rebuild = 1)
				update_nearby_icons()
				update_verbs()
				to_chat(user, span_info("You [anchored ? "weld" : "cut"] the [src] [anchored ? "to" : "off"] the wall."))
		return
	. = ..()


/obj/structure/window/maintenance_panel/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health
	health = max(0, health - damage)
	if(health <= 0)
		shatter()
		return

	if(sound_effect)
		if(damage < 30)
			playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
		else
			playsound(src, 'sound/effects/grillehit.ogg', 75, 1)
	if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
		visible_message("\the [src] is about to break free!")
		update_icon()
	else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
		visible_message("\the [src] looks seriously damaged!")
		update_icon()
	else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
		visible_message("\the [src] looks like it's taking damage!")
		update_icon()

/obj/structure/window/maintenance_panel/shatter(var/display_message = 1)
	playsound(src, pick(list('sound/effects/metalscrape1.ogg','sound/effects/metalscrape2.ogg','sound/effects/metalscrape3.ogg')), 70, 1)
	if(display_message)
		visible_message("\the [src] thunks free of the wall!")
	new glasstype(loc)
	qdel(src)

/obj/structure/window/maintenance_panel/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature <= maximal_heat)
		return
	var/burndamage = log(RAND_F(0.9, 1.1) * (exposed_temperature - maximal_heat))
	if(burndamage)
		take_damage(burndamage)

/obj/structure/window/maintenance_panel/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("It's welded firmly in place.")
	else
		. += span_warning("It's hanging freely, and hasn't been welded in place! It can be deconstructed with a wrench.")
