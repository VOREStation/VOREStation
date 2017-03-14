// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes armor and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart when hit.

// Putting these at /clothing/ level saves a lot of code duplication in armor/helmets/gauntlets/etc
/obj/item/clothing
	var/material/material = null // Why isn't this a datum?
	var/applies_material_color = TRUE
	var/unbreakable = FALSE
	var/default_material = null // Set this to something else if you want material attributes on init.

/obj/item/clothing/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	if(material_key) // May still be null if a material was not specified as a default.
		set_material(material_key)

/obj/item/clothing/Destroy()
	processing_objects -= src
	..()

/obj/item/clothing/get_material()
	return material

// Debating if this should be made an /atom/movable/ proc.
/obj/item/clothing/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		if(applies_material_color)
			color = material.icon_colour
		if(material.products_need_process())
			processing_objects |= src
		update_armor()

//f(x) = (x*a) / (x+b) + c
// a + c essentially* becomes your maximum possible output,
// c is your minimum, and b controls how quickly the output values scale and its effectiveness is relative to the value of a.

// Max is the cap, excluding min.
// Mid is the midpoint on the curve.
// Min adds a floor to the answer.  Min + Max is the maximum possible output.
/proc/calculate_curve(var/X, var/max, var/mid, var/min)
	return (X * max) / (X + mid) + min

/client/verb/test_curve(var/X as num, var/A as num, var/B as num, var/C as num)
	src << "Testing values: X:[X], A:[A], B:[B], C:[C]."
	src << calculate_curve(X, A, B, C)

/obj/item/clothing/proc/update_armor()
	if(material)
		var/melee_armor = 0, bullet_armor = 0, laser_armor = 0, energy_armor = 0, bomb_armor = 0

		melee_armor = round(Clamp(material.hardness, 0, 90))

		bullet_armor = round(Clamp(material.hardness * 0.6, 0, 90))

		laser_armor = material.hardness * 0.6
		if(material.reflectivity)
			laser_armor *= (material.reflectivity + 1) // Each 0.1th of reflectivity gives 10% more protection.
		if(material.opacity != 1)
			laser_armor *= max(material.opacity - 0.3, 0) // Glass and such has an opacity of 0.3, but lasers should go through glass armor entirely.
		laser_armor = round(Clamp(laser_armor, 0, 90))

		energy_armor = round(Clamp(laser_armor * 0.7, 0, 90))

		bomb_armor = round(Clamp(material.explosion_resistance * 2, 0, 90))

		armor["melee"] = melee_armor
		armor["bullet"] = bullet_armor
		armor["laser"] = laser_armor
		armor["energy"] = energy_armor
		armor["bomb"] = bomb_armor

		if(!isnull(material.conductivity))
			siemens_coefficient = Clamp(material.conductivity / 10, 0, 4)
		slowdown = Clamp(round(material.weight / 10, 0.1), 0, 6)
//		armor = list(
//			melee = melee_armor,
//			bullet = bullet_armor,
//			laser = laser_armor,
//			energy = energy_armor,
//			bomb = bomb_armor,
//			bio = 0,
//			rad = 0)
/*
/obj/item/weapon/material/proc/update_force()
	if(edge || sharp)
		force = material.get_edge_damage()
	else
		force = material.get_blunt_damage()
	force = round(force*force_divisor)
	throwforce = round(material.get_blunt_damage()*thrown_force_divisor)
	//spawn(1)
	//	world << "[src] has force [force] and throwforce [throwforce] when made from default material [material.name]"
*/
/obj/item/clothing/suit/armor/material
	icon_state = "material_armor_makeshift" // placeholder
	default_material = DEFAULT_WALL_MATERIAL


