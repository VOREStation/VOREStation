// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/weapon/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	sharp = FALSE
	edge = FALSE
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)

	var/applies_material_colour = 1
	var/unbreakable = 0		//Doesn't lose health
	var/fragile = 0			//Shatters when it dies
	var/dulled = 0			//Has gone dull
	var/can_dull = 1		//Can it go dull?
	var/force_divisor = 0.5
	var/thrown_force_divisor = 0.5
	var/dulled_divisor = 0.5	//Just drops the damage by half
	var/default_material = MAT_STEEL
	var/datum/material/material
	var/drops_debris = 1

/obj/item/weapon/material/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	set_material(material_key)
	if(!material)
		qdel(src)
		return

	matter = material.get_matter()
	if(matter.len)
		for(var/material_type in matter)
			if(!isnull(matter[material_type]))
				matter[material_type] *= force_divisor // May require a new var instead.

	if(!(material.conductive))
		src.flags |= NOCONDUCT

/obj/item/weapon/material/get_material()
	return material

/obj/item/weapon/material/proc/update_force()
	if(edge || sharp)
		force = material.get_edge_damage()
	else
		force = material.get_blunt_damage()
	force = round(force*force_divisor)
	if(dulled)
		force = round(force*dulled_divisor)
	throwforce = round(material.get_blunt_damage()*thrown_force_divisor)
	//spawn(1)
	//	to_world("[src] has force [force] and throwforce [throwforce] when made from default material [material.name]")

/obj/item/weapon/material/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_colour)
			color = material.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		update_force()

/obj/item/weapon/material/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/material/apply_hit_effect()
	..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

/obj/item/weapon/material/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/whetstone))
		var/obj/item/weapon/whetstone/whet = W
		repair(whet.repair_amount, whet.repair_time, user)
	if(istype(W, /obj/item/weapon/material/sharpeningkit))
		var/obj/item/weapon/material/sharpeningkit/SK = W
		repair(SK.repair_amount, SK.repair_time, user)
	..()

/obj/item/weapon/material/proc/check_health(var/consumed)
	if(health<=0)
		health = 0

		if(fragile)
			shatter(consumed)
		else if(!dulled && can_dull)
			dull()

/obj/item/weapon/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris) material.place_shard(T)
	qdel(src)

/obj/item/weapon/material/proc/dull()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] goes dull!</span>")
	playsound(src, "shatter", 70, 1)
	dulled = 1
	if(is_sharp() || has_edge())
		sharp = FALSE
		edge = FALSE

/obj/item/weapon/material/proc/repair(var/repair_amount, var/repair_time, mob/living/user)
	if(!fragile)
		if(health < initial(health))
			user.visible_message("[user] begins repairing \the [src].", "You begin repairing \the [src].")
			if(do_after(user, repair_time))
				user.visible_message("[user] has finished repairing \the [src]", "You finish repairing \the [src].")
				health = min(health + repair_amount, initial(health))
				dulled = 0
				sharp = initial(sharp)
				edge = initial(edge)
		else
			to_chat(user, "<span class='notice'>[src] doesn't need repairs.</span>")
	else
		to_chat(user, "<span class='warning'>You can't repair \the [src].</span>")
		return

/obj/item/weapon/material/proc/sharpen(var/material, var/sharpen_time, var/kit, mob/living/M)
	if(!fragile && src.material.can_sharpen)
		if(health < initial(health))
			to_chat(M, "You should repair [src] first. Try using [kit] on it.")
			return FALSE
		M.visible_message("[M] begins to replace parts of [src] with [kit].", "You begin to replace parts of [src] with [kit].")
		if(do_after(usr, sharpen_time))
			M.visible_message("[M] has finished replacing parts of [src].", "You finish replacing parts of [src].")
			src.set_material(material)
			return TRUE
	else
		to_chat(M, "<span class = 'warning'>You can't sharpen and re-edge [src].</span>")
		return FALSE

/*
Commenting this out pending rebalancing of radiation based on small objects.
/obj/item/weapon/material/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/30),IRRADIATE,0)
*/

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/obj/item/weapon/material/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

// This might need adjustment. Will work that out later.
/obj/item/weapon/material/proc/TemperatureAct(temperature)
	health -= material.combustion_effect(get_turf(src), temperature, 0.1)
	check_health(1)

/obj/item/weapon/material/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		return ..()
*/
