#define THROWER_MIN 50
#define THROWER_MAX 1000

/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
			)
	item_state = "flamethrower_0"
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(MAT_STEEL = 500)
	var/status = FALSE
	var/throw_amount = THROWER_MIN
	var/lit = FALSE	//on or off
	var/operating = FALSE //cooldown
	var/turf/previousturf = null
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/phoron/ptank = null
	var/volume_per_max_burn = 20 // gets divided by the intended burn ratio

/obj/item/flamethrower/Initialize(mapload)
	weldtool = new /obj/item/weldingtool(src)
	weldtool.status = 0 // for disassembly
	update_icon()
	. = ..()

/obj/item/flamethrower/full/Initialize(mapload)
	igniter = new /obj/item/assembly/igniter(src)
	igniter.secured = 0 // for disassembly
	. = ..()
	status = TRUE

/obj/item/flamethrower/Destroy()
	QDEL_NULL(weldtool)
	QDEL_NULL(igniter)
	QDEL_NULL(ptank)
	. = ..()

/obj/item/flamethrower/process()
	if(!lit)
		STOP_PROCESSING(SSobj, src)
		return null
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/living/M = location
		if(M.item_is_in_hands(src))
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return

/obj/item/flamethrower/update_icon()
	cut_overlays()
	if(igniter)
		add_overlay("+igniter[status]")
	if(ptank)
		add_overlay("+ptank")
	if(lit)
		add_overlay("+lit")
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(!lit || operating)
		return
	if(user && user.get_active_hand() == src)
		if(user.a_intent == I_HELP && user.client?.prefs?.read_preference(/datum/preference/toggle/safefiring))
			to_chat(user, span_warning("You refrain from firing \the [src] as your intent is set to help."))
			return
		if(check_fuel())
			// spawn projectile
			var/obj/item/projectile/P = new /obj/item/projectile/bullet/dragon/flamethrower(get_turf(src))
			P.submunition_spread_max = 90 + round(80*thrower_spew_percent())
			P.submunition_spread_min = 5 + round(50*thrower_spew_percent())
			P.submunitions = list(/obj/item/projectile/bullet/incendiary/dragonflame/flamethrower = 1 + round(thrower_spew_percent()*2))
			P.launch_projectile( target, BP_TORSO, user)

			// suck out fuel and burn it
			var/datum/gas_mixture/used_gas = ptank.air_contents.remove_ratio(volume_per_max_burn * thrower_spew_percent() / ptank.air_contents.volume)
			qdel(used_gas)
			if(!check_fuel())
				lit = FALSE
			update_icon()
		else
			to_chat(user, span_notice("There is not enough pressure in [src]'s tank!"))
			lit = FALSE
			update_icon()
		// prevent spam
		operating = TRUE
		addtimer(VARSET_CALLBACK(src, operating, FALSE), 15)
	return

/obj/item/flamethrower/proc/thrower_spew_percent()
	return throw_amount / THROWER_MAX

/obj/item/flamethrower/proc/check_fuel()
	return ptank != null && ptank.air_contents.total_moles > 5 // minimum fuel usage is five moles, for EXTREMELY hot mix or super low pressure

/obj/item/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)
		return

	if(W.has_tool_quality(TOOL_WRENCH) && !status)//Taking this apart
		var/turf/T = get_turf(src)
		if(weldtool)
			weldtool.forceMove(T)
			weldtool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(ptank)
			ptank.forceMove(T)
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	if(W.has_tool_quality(TOOL_SCREWDRIVER) && igniter && !lit)
		status = !status
		to_chat(user, span_notice("[igniter] is now [status ? "secured" : "unsecured"]!"))
		update_icon()
		return

	if(isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if(I.secured)	return
		if(igniter)		return
		user.drop_item()
		I.forceMove(src)
		igniter = I
		update_icon()
		return

	if(istype(W,/obj/item/tank/phoron))
		if(ptank)
			to_chat(user, span_notice("There appears to already be a phoron tank loaded in [src]!"))
			return
		user.drop_item()
		ptank = W
		W.forceMove(src)
		update_icon()
		return

	..()

/obj/item/flamethrower/attack_self(mob/user as mob)
	if(user.stat || user.restrained() || user.lying)
		return
	tgui_interact(user)

/obj/item/flamethrower/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Flamethrower", name)
		ui.open()

/obj/item/flamethrower/tgui_data(mob/user)
	var/list/dat = list()
	dat["lit"] = lit
	dat["constructed"] = status
	dat["throw_amount"] = throw_amount
	// Tank
	dat["has_tank"] = !isnull(ptank)
	dat["throw_min"] = THROWER_MIN
	dat["throw_max"] = THROWER_MAX
	dat["fuel_kpa"] = check_fuel() ? ptank.air_contents.return_pressure() : 0
	return dat

/obj/item/flamethrower/tgui_act(action, params, datum/tgui/ui)
	if(usr.stat || usr.restrained() || usr.lying)
		return FALSE
	if(..())
		return FALSE

	switch(action)
		if("light")
			if(!check_fuel() || ptank.air_contents.gas[GAS_PHORON] < 1 || !status)
				return FALSE
			lit = !lit
			if(lit)
				START_PROCESSING(SSobj, src)
				playsound(src, 'sound/items/welderactivate.ogg', 50, 1)
			else
				playsound(src, 'sound/items/welderdeactivate.ogg', 50, 1)
			update_icon()
			return TRUE
		if("amount")
			throw_amount = text2num(params["amount"])
			throw_amount = clamp(throw_amount,THROWER_MIN,THROWER_MAX)
			return TRUE
		if("remove")
			if(!ptank)
				return FALSE
			usr.put_in_hands(ptank)
			ptank = null
			lit = 0
			update_icon()
			return TRUE

// Projectile
/obj/item/projectile/bullet/dragon/flamethrower
	name = "flames"
	icon_state = "fireball2"
	submunitions = list(/obj/item/projectile/bullet/incendiary/dragonflame/flamethrower = 2)
	damage = 0
	hitsound_wall = null

/obj/item/projectile/bullet/incendiary/dragonflame/flamethrower
	name = "flames"
	icon_state = "fireball2"
	damage = 2
	hitsound_wall = null

#undef THROWER_MIN
#undef THROWER_MAX
