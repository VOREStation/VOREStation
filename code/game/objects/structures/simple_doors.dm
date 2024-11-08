/obj/structure/simple_door
	name = "door"
	description_info = "If you hold left alt whilst left-clicking on a door, you can knock on it to announce your presence to anyone on the other side! Alternately if you are on HARM intent when doing this, you will bang loudly on the door!"
	density = TRUE
	anchored = TRUE
	can_atmos_pass = ATMOS_PASS_DENSITY

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/datum/material/material
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7
	var/knock_sound = 'sound/machines/door/knock_glass.ogg'
	var/knock_hammer_sound = 'sound/weapons/sonic_jackhammer.ogg'

	var/locked = FALSE	//has the door been locked?
	var/lock_id = null	//does the door have an associated key?
	var/lock_type = "simple"	//string matched to "pick_type" on /obj/item/lockpick
	var/can_pick = TRUE	//can it be picked/bypassed?
	var/lock_difficulty = 1	//multiplier to picking/bypassing time
	var/keysound = 'sound/items/toolbelt_equip.ogg'

/obj/structure/simple_door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	hardness -= material.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHardness()

/obj/structure/simple_door/Initialize(mapload, var/material_name)
	. = ..()
	set_material(material_name)
	if(!material)
		return INITIALIZE_HINT_QDEL

/obj/structure/simple_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	update_nearby_tiles()
	return ..()

/obj/structure/simple_door/proc/set_material(var/material_name)
	if(!material_name)
		material_name = MAT_STEEL
	material = get_material_by_name(material_name)
	if(!material)
		return
	hardness = max(1,round(material.integrity/10))
	icon_state = material.door_icon_base
	name = "[material.display_name] door"
	color = material.icon_colour
	if(material.opacity < 0.5)
		set_opacity(0)
	else
		set_opacity(1)
	if(material.products_need_process())
		START_PROCESSING(SSobj, src)
	update_nearby_tiles(need_rebuild=1)

/obj/structure/simple_door/get_material()
	return material

/obj/structure/simple_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/simple_door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/simple_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/simple_door/AltClick(mob/user as mob)
	. = ..()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!Adjacent(user))
		return
	else if(user.a_intent == I_HURT)
		src.visible_message(span_warning("[user] hammers on \the [src]!"), span_warning("Someone hammers loudly on \the [src]!"))
		src.add_fingerprint(user)
		playsound(src, knock_hammer_sound, 50, 0, 3)
	else if(user.a_intent == I_HELP)
		src.visible_message("[user] knocks on \the [src].", "Someone knocks on \the [src].")
		src.add_fingerprint(user)
		playsound(src, knock_sound, 50, 0, 3)
	return

/obj/structure/simple_door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/simple_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(!material.can_open_material_door(user))
			return
		if(locked && state == 0)
			to_chat(M,span_warning("It's locked!"))
			return
		if(world.time - user.last_bumped <= 60)
			return
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/simple_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/simple_door/proc/Open()
	isSwitchingStates = 1
	playsound(src, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]opening",src)
	sleep(10)
	density = FALSE
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	playsound(src, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]closing",src)
	sleep(10)
	density = TRUE
	set_opacity(1)
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/update_icon()
	if(state)
		icon_state = "[material.door_icon_base]open"
	else
		icon_state = material.door_icon_base

/obj/structure/simple_door/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W,/obj/item/simple_key))
		var/obj/item/simple_key/key = W
		if(state)
			to_chat(user,span_notice("\The [src] must be closed in order for you to lock it."))
		else if(key.key_id != src.lock_id)
			to_chat(user,span_warning("The [key] doesn't fit \the [src]'s lock!"))
		else if(key.key_id == src.lock_id)
			visible_message(span_notice("[user] [key.keyverb] \the [key] and [locked ? "unlocks" : "locks"] \the [src]."))
			locked = !locked
			playsound(src, keysound,100, 1)
		return
	if(istype(W,/obj/item/pickaxe) && breakable)
		var/obj/item/pickaxe/digTool = W
		visible_message(span_danger("[user] starts digging [src]!"))
		if(do_after(user,digTool.digspeed*hardness) && src)
			visible_message(span_danger("[user] finished digging [src]!"))
			Dismantle()
	else if(istype(W,/obj/item) && breakable) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force/10
		visible_message(span_danger("[user] hits [src] with [W]!"))
		if(material == get_material_by_name("resin"))
			playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
		else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD) || get_material_by_name(MAT_HARDWOOD)))
			playsound(src, 'sound/effects/woodcutting.ogg', 100, 1)
		else
			playsound(src, 'sound/weapons/smash.ogg', 50, 1)
		CheckHardness()
	else if(W.has_tool_quality(TOOL_WELDER) && breakable)
		var/obj/item/weldingtool/WT = W.get_welder()
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		attack_hand(user)
	return

/obj/structure/simple_door/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.damage/10)
	CheckHardness()

/obj/structure/simple_door/take_damage(var/damage)
	hardness -= damage/10
	CheckHardness()

/obj/structure/simple_door/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message(span_danger("[user] [attack_verb] the [src]!"))
	if(material == get_material_by_name("resin"))
		playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD) || get_material_by_name(MAT_HARDWOOD)))
		playsound(src, 'sound/effects/woodcutting.ogg', 100, 1)
	else
		playsound(src, 'sound/weapons/smash.ogg', 50, 1)
	user.do_attack_animation(src)
	hardness -= damage/10
	CheckHardness()

/obj/structure/simple_door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/simple_door/proc/Dismantle(devastated = 0)
	material.place_dismantled_product(get_turf(src))
	visible_message(span_danger("The [src] is destroyed!"))
	qdel(src)

/obj/structure/simple_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

/obj/structure/simple_door/process()
	if(!material.radioactivity)
		return
	SSradiation.radiate(src, round(material.radioactivity/3))

/obj/structure/simple_door/iron/Initialize(mapload,var/material_name)
	..(mapload, material_name || "iron")

/obj/structure/simple_door/silver/Initialize(mapload,var/material_name)
	..(mapload, material_name || "silver")

/obj/structure/simple_door/gold/Initialize(mapload,var/material_name)
	..(mapload, material_name || "gold")

/obj/structure/simple_door/uranium/Initialize(mapload,var/material_name)
	..(mapload, material_name || "uranium")

/obj/structure/simple_door/sandstone/Initialize(mapload,var/material_name)
	..(mapload, material_name || "sandstone")

/obj/structure/simple_door/phoron/Initialize(mapload,var/material_name)
	..(mapload, material_name || "phoron")

/obj/structure/simple_door/diamond/Initialize(mapload,var/material_name)
	..(mapload, material_name || "diamond")

/obj/structure/simple_door/wood/Initialize(mapload,var/material_name)
	..(mapload, material_name || MAT_WOOD)
	knock_sound = 'sound/machines/door/knock_wood.wav'

/obj/structure/simple_door/hardwood/Initialize(mapload,var/material_name)
	..(mapload, material_name || MAT_HARDWOOD)

/obj/structure/simple_door/sifwood/Initialize(mapload,var/material_name)
	..(mapload, material_name || MAT_SIFWOOD)

/obj/structure/simple_door/resin/Initialize(mapload,var/material_name)
	..(mapload, material_name || "resin")

/obj/structure/simple_door/cult/Initialize(mapload,var/material_name)
	..(mapload, material_name || "cult")

/obj/structure/simple_door/cult/TryToSwitchState(atom/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!iscultist(L) && !istype(L, /mob/living/simple_mob/construct))
			return
	..()
