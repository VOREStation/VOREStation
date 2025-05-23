#define MATERIAL_ARMOR_COEFFICENT 0.05
/*
SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
This class of armor takes armor and appearance data from a material "datum".
They are also fragile based on material data and many can break/smash apart when hit.

Materials has a var called protectiveness which plays a major factor in how good it is for armor.
With the coefficent being 0.05, this is how strong different levels of protectiveness are (for melee)
For bullets and lasers, material hardness and reflectivity also play a major role, respectively.


Protectiveness | Armor %
			0  = 0%
			5  = 20%
			10 = 33%
			15 = 42%
			20 = 50%
			25 = 55%
			30 = 60%
			40 = 66%
			50 = 71%
			60 = 75%
			70 = 77%
			80 = 80%
*/


// Putting these at /clothing/ level saves a lot of code duplication in armor/helmets/gauntlets/etc
/obj/item/clothing
	var/datum/material/material = null // Why isn't this a datum?
	var/applies_material_color = TRUE
	var/unbreakable = FALSE
	var/default_material = null // Set this to something else if you want material attributes on init.
	var/material_armor_modifier = 1 // Adjust if you want seperate types of armor made from the same material to have different protectiveness (e.g. makeshift vs real armor)
	var/material_slowdown_modifier = 0
	var/material_slowdown_multiplier = 0.5

/obj/item/clothing/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	if(material_key) // May still be null if a material was not specified as a default.
		set_material(material_key)

/obj/item/clothing/get_material()
	return material

// Debating if this should be made an /obj/item/ proc.
/obj/item/clothing/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_color)
			color = material.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		update_armor()

// This is called when someone wearing the object gets hit in some form (melee, bullet_act(), etc).
// Note that this cannot change if someone gets hurt, as it merely reacts to being hit.
/obj/item/clothing/proc/clothing_impact(var/obj/source, var/damage)
	if(material && damage)
		material_impact(source, damage)

/obj/item/clothing/proc/material_impact(var/obj/source, var/damage)
	if(!material || unbreakable)
		return

	if(istype(source, /obj/item/projectile))
		var/obj/item/projectile/P = source
		if(P.pass_flags & PASSGLASS)
			if(material.opacity - 0.3 <= 0)
				return // Lasers ignore 'fully' transparent material.

	if(material.is_brittle())
		health = 0
	else if(!prob(material.hardness))
		health--

	if(health <= 0)
		shatter()

/obj/item/clothing/proc/shatter()
	if(!material)
		return
	var/turf/T = get_turf(src)
	T.visible_message(span_danger("\The [src] [material.destruction_desc]!"))
	if(isliving(loc))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
		if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
			var/obj/item/material/shard/S = material.place_shard(T)
			M.embed(S)

	playsound(src, "shatter", 70, 1)
	qdel(src)

// Might be best to make ablative vests a material armor using a new material to cut down on this copypaste.
/obj/item/clothing/suit/armor/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!material) // No point checking for reflection.
		return ..()

	if(material.negation && prob(material.negation)) // Strange and Alien materials, or just really strong materials.
		user.visible_message(span_danger("\The [src] completely absorbs [attack_text]!"))
		return TRUE

	if(material.spatial_instability && prob(material.spatial_instability))
		user.visible_message(span_danger("\The [src] flashes [user] clear of [attack_text]!"))
		var/list/turfs = new/list()
		for(var/turf/T in orange(round(material.spatial_instability / 10) + 1, user))
			if(istype(T,/turf/space)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/effects/teleport.ogg', 50, 1)

		user.loc = picked
		return PROJECTILE_FORCE_MISS

	if(material.reflectivity)
		if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
			var/obj/item/projectile/P = damage_source

			if(P.reflected) // Can't reflect twice
				return ..()

			var/reflectchance = (40 * material.reflectivity) - round(damage/3)
			reflectchance *= material_armor_modifier
			if(!(def_zone in list(BP_TORSO, BP_GROIN)))
				reflectchance /= 2
			if(P.starting && prob(reflectchance))
				visible_message(span_danger("\The [user]'s [src.name] reflects [attack_text]!"))

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, user)
				P.reflected = 1

				return PROJECTILE_CONTINUE // complete projectile permutation

/proc/calculate_material_armor(amount)
	var/result = 1 - MATERIAL_ARMOR_COEFFICENT * amount / (1 + MATERIAL_ARMOR_COEFFICENT * abs(amount))
	result = result * 100
	result = abs(result - 100)
	return round(result)

#undef MATERIAL_ARMOR_COEFFICENT

/obj/item/clothing/proc/update_armor()
	if(material)
		var/melee_armor = 0, bullet_armor = 0, laser_armor = 0, energy_armor = 0, bomb_armor = 0

		melee_armor = calculate_material_armor(material.protectiveness * material_armor_modifier)

		bullet_armor = calculate_material_armor((material.protectiveness * (material.hardness / 100) * material_armor_modifier) * 0.7)

		laser_armor = calculate_material_armor((material.protectiveness * (material.reflectivity + 1) * material_armor_modifier) * 0.7)
		if(material.opacity != 1)
			laser_armor *= max(material.opacity - 0.3, 0) // Glass and such has an opacity of 0.3, but lasers should go through glass armor entirely.

		energy_armor = calculate_material_armor((material.protectiveness * material_armor_modifier) * 0.4)

		bomb_armor = calculate_material_armor((material.protectiveness * material_armor_modifier) * 0.5)

		// Makes sure the numbers stay capped.
		for(var/number in list(melee_armor, bullet_armor, laser_armor, energy_armor, bomb_armor))
			number = between(0, number, 100)

		armor["melee"] = melee_armor
		armor["bullet"] = bullet_armor
		armor["laser"] = laser_armor
		armor["energy"] = energy_armor
		armor["bomb"] = bomb_armor

		if(!isnull(material.conductivity))
			siemens_coefficient = between(0, material.conductivity / 10, 10)

		var/slowdownModified = between(0, round(material.weight / 10, 0.1), 6)

		var/slowdownUncapped = (material_slowdown_multiplier * slowdownModified) - material_slowdown_modifier

		slowdown = max(slowdownUncapped, 0)

/obj/item/clothing/suit/armor/material
	name = "armor"
	default_material = MAT_STEEL

/obj/item/clothing/suit/armor/material/makeshift
	name = "sheet armor"
	desc = "This appears to be two 'sheets' of a material held together by cable.  If the sheets are strong, this could be rather protective."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/accessory/material/makeshift/light //Craftable with 4 material sheets, less slowdown, less armour
	name = "light armor plate"
	desc = "A thin plate of padded material, designed to fit into a plate carrier. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "armor_light"
	body_parts_covered = CHEST
	slot = ACCESSORY_SLOT_ARMOR_C
	material_armor_modifier = 0.8
	material_slowdown_modifier = 0.5 //Subtracted from total slowdown
	material_slowdown_multiplier = 0.4 //Multiplied by total slowdown

/obj/item/clothing/accessory/material/makeshift/heavy //Craftable with 8 material sheets, more slowdown, more armour
	name = "heavy armor plate"
	desc = "A thick plate of padded material, designed to fit into a plate carrier. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "armor_medium"
	body_parts_covered = CHEST
	slot = ACCESSORY_SLOT_ARMOR_C
	material_armor_modifier = 1.2
	material_slowdown_modifier = 0
	material_slowdown_multiplier = 0.5

/obj/item/clothing/accessory/material/custom //Not yet craftable, advanced version made with science!
	name = "custom armor plate"
	desc = "A composite plate of custom machined material, designed to fit into a plate carrier. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "armor_tactical"
	body_parts_covered = CHEST
	slot = ACCESSORY_SLOT_ARMOR_C
	material_armor_modifier = 1.2
	material_slowdown_modifier = 0.5
	material_slowdown_multiplier = 0.4

/obj/item/clothing/accessory/material/makeshift/armguards
	name = "arm guards"
	desc = "A pair of arm pads reinforced with material. Attaches to a plate carrier."
//	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_override = 'icons/mob/modular_armor.dmi'
	icon_state = "armguards_material"
	gender = PLURAL
	body_parts_covered = ARMS
	slot = ACCESSORY_SLOT_ARMOR_A
	material_armor_modifier = 0.8
	material_slowdown_modifier = 0.8
	material_slowdown_multiplier = 0.4

/obj/item/clothing/accessory/material/makeshift/legguards
	name = "leg guards"
	desc = "A pair of leg guards reinforced with material. Attaches to a plate carrier."
//	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_override = 'icons/mob/modular_armor.dmi'
	icon_state = "legguards_material"
	gender = PLURAL
	body_parts_covered = LEGS
	slot = ACCESSORY_SLOT_ARMOR_L
	material_armor_modifier = 0.8
	material_slowdown_modifier = 0.8
	material_slowdown_multiplier = 0.4

/obj/item/clothing/suit/armor/material/makeshift/durasteel
	default_material = MAT_DURASTEEL

/obj/item/clothing/suit/armor/material/makeshift/glass
	default_material = MAT_GLASS

// Used to craft sheet armor, and possibly other things in the Future(tm).
/obj/item/material/armor_plating
	name = "armor plating"
	desc = "A sheet designed to protect something."
	icon = 'icons/obj/items.dmi'
	icon_state = "armor_plate"
	unbreakable = TRUE
	force_divisor = 0.05 // Really bad as a weapon.
	thrown_force_divisor = 0.2
	var/wired = FALSE

/obj/item/material/armor_plating/insert
	unbreakable = FALSE
	name = "plate insert"
	desc = "used to craft armor plates for a plate carrier. Trim with a welder for light armor or add a second for heavy armor"

/obj/item/material/armor_plating/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/S = O
		if(wired)
			to_chat(user, span_warning("This already has enough wires on it."))
			return
		if(S.use(20))
			to_chat(user, span_notice("You attach several wires to \the [src].  Now it needs another plate."))
			wired = TRUE
			icon_state = "[initial(icon_state)]_wired"
			return
		else
			to_chat(user, span_notice("You need more wire for that."))
			return
	if(istype(O, /obj/item/material/armor_plating))
		var/obj/item/material/armor_plating/second_plate = O
		if(!wired && !second_plate.wired)
			to_chat(user, span_warning("You need something to hold the two pieces of plating together."))
			return
		if(second_plate.material != src.material)
			to_chat(user, span_warning("Both plates need to be the same type of material."))
			return
		user.drop_from_inventory(src)
		user.drop_from_inventory(second_plate)
		var/obj/item/clothing/suit/armor/material/makeshift/new_armor = new(null, src.material.name)
		user.put_in_hands(new_armor)
		qdel(second_plate)
		qdel(src)
	else
		..()

//Make plating inserts for modular armour.
/obj/item/material/armor_plating/insert/attackby(var/obj/item/O, mob/user)

	. = ..()

	if(O.has_tool_quality(TOOL_WELDER))
		var /obj/item/weldingtool/S = O.get_welder()
		if(S.remove_fuel(0,user))
			if(!src || !S.isOn()) return
			to_chat(user, span_notice("You trim down the edges to size."))
			user.drop_from_inventory(src)
			var/obj/item/clothing/accessory/material/makeshift/light/new_armor = new(null, src.material.name)
			user.put_in_hands(new_armor)
			qdel(src)
			return

	if(istype(O, /obj/item/material/armor_plating/insert))
		var/obj/item/material/armor_plating/insert/second_plate = O
		if(second_plate.material != src.material)
			to_chat(user, span_warning("Both plates need to be the same type of material."))
			return
		to_chat(user, span_notice("You bond the two plates together."))
		user.drop_from_inventory(src)
		user.drop_from_inventory(second_plate)
		var/obj/item/clothing/accessory/material/makeshift/heavy/new_armor = new(null, src.material.name)
		user.put_in_hands(new_armor)
		qdel(second_plate)
		qdel(src)
		return

	if(istype(O, /obj/item/tool/wirecutters))
		to_chat(user, span_notice("You split the plate down the middle, and joint it at the elbow."))
		user.drop_from_inventory(src)
		var/obj/item/clothing/accessory/material/makeshift/armguards/new_armor = new(null, src.material.name)
		user.put_in_hands(new_armor)
		qdel(src)
		return

	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(S.material == get_material_by_name(MAT_LEATHER))
			if(S.use(2))
				to_chat(user, span_notice("You curve the plate inwards, and add a strap for adjustment."))
				user.drop_from_inventory(src)
				var/obj/item/clothing/accessory/material/makeshift/legguards/new_armor = new(null, src.material.name)
				user.put_in_hands(new_armor)
				qdel(src)
				return

// Used to craft the makeshift helmet
/obj/item/clothing/head/helmet/bucket
	name = "bucket"
	desc = "It's a bucket with a large hole cut into it.  You could wear it on your head and look really stupid."
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	icon_state = "bucket"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/bucket/wood
	name = "wooden bucket"
	icon_state = "woodbucket"

/obj/item/clothing/head/helmet/bucket/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(S.use(2))
			to_chat(user, span_notice("You apply some [S.material.use_name] to \the [src].  Hopefully it'll make the makeshift helmet stronger."))
			var/obj/item/clothing/head/helmet/material/makeshift/helmet = new(null, S.material.name)
			user.put_in_hands(helmet)
			user.drop_from_inventory(src)
			qdel(src)
			return
		else
			to_chat(user, span_warning("You don't have enough material to build a helmet!"))
	else
		..()

/obj/item/clothing/head/helmet/material
	name = "helmet"
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	default_material = MAT_STEEL

/obj/item/clothing/head/helmet/material/makeshift
	name = "bucket"
	desc = "A bucket with plating applied to the outside.  Very crude, but could potentially be rather protective, if \
	it was plated with something strong."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/head/helmet/material/makeshift/durasteel
	default_material = MAT_DURASTEEL
