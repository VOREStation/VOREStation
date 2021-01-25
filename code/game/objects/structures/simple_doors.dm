/obj/structure/simple_door
	name = "door"
	density = 1
	anchored = 1
	can_atmos_pass = ATMOS_PASS_DENSITY

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/datum/material/material
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7

/obj/structure/simple_door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	hardness -= material.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHardness()

/obj/structure/simple_door/New(var/newloc, var/material_name)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
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

/obj/structure/simple_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	update_nearby_tiles()
	return ..()

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
	density = 0
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
	density = 1
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

/obj/structure/simple_door/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W,/obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/digTool = W
		visible_message("<span class='danger'>[user] starts digging [src]!</span>")
		if(do_after(user,digTool.digspeed*hardness) && src)
			visible_message("<span class='danger'>[user] finished digging [src]!</span>")
			Dismantle()
	else if(istype(W,/obj/item/weapon)) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force/10
		visible_message("<span class='danger'>[user] hits [src] with [W]!</span>")
		if(material == get_material_by_name("resin"))
			playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
		else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD)))
			playsound(src, 'sound/effects/woodcutting.ogg', 100, 1)
		else
			playsound(src, 'sound/weapons/smash.ogg', 50, 1)
		CheckHardness()
	else if(istype(W,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		attack_hand(user)
	return

/obj/structure/simple_door/bullet_act(var/obj/item/projectile/Proj)
	hardness -= Proj.force/10
	CheckHardness()

/obj/structure/simple_door/take_damage(var/damage)
	hardness -= damage/10
	CheckHardness()

/obj/structure/simple_door/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	if(material == get_material_by_name("resin"))
		playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD)))
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
	visible_message("<span class='danger'>The [src] is destroyed!</span>")
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

/obj/structure/simple_door/iron/New(var/newloc,var/material_name)
	..(newloc, "iron")

/obj/structure/simple_door/silver/New(var/newloc,var/material_name)
	..(newloc, "silver")

/obj/structure/simple_door/gold/New(var/newloc,var/material_name)
	..(newloc, "gold")

/obj/structure/simple_door/uranium/New(var/newloc,var/material_name)
	..(newloc, "uranium")

/obj/structure/simple_door/sandstone/New(var/newloc,var/material_name)
	..(newloc, "sandstone")

/obj/structure/simple_door/phoron/New(var/newloc,var/material_name)
	..(newloc, "phoron")

/obj/structure/simple_door/diamond/New(var/newloc,var/material_name)
	..(newloc, "diamond")

/obj/structure/simple_door/wood/New(var/newloc,var/material_name)
	..(newloc, MAT_WOOD)

/obj/structure/simple_door/sifwood/New(var/newloc,var/material_name)
	..(newloc, MAT_SIFWOOD)

/obj/structure/simple_door/resin/New(var/newloc,var/material_name)
	..(newloc, "resin")

/obj/structure/simple_door/cult/New(var/newloc,var/material_name)
	..(newloc, "cult")

/obj/structure/simple_door/cult/TryToSwitchState(atom/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!iscultist(L) && !istype(L, /mob/living/simple_mob/construct))
			return
	..()
