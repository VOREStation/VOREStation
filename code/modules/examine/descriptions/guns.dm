/obj/item/weapon/gun/proc/describe_firepower()
	var/obj/item/projectile/P
	if(istype(src, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/energy_gun = src
		P = new energy_gun.projectile_type()
	else if(istype(src, /obj/item/weapon/gun/projectile/shotgun/pump))
		var/obj/item/weapon/gun/projectile/shotgun/pump/projectile_gun = src
		if(isnull(projectile_gun.chambered) || isnull(projectile_gun.chambered.BB))
			return "no"
		else
			var/obj/item/ammo_casing/ammo = projectile_gun.chambered
			P = ammo.BB
	else if(istype(src, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/projectile_gun = src
		var/obj/item/ammo_casing/ammo
		if(projectile_gun.ammo_magazine)
			ammo = projectile_gun.ammo_magazine.contents[1]
		else
			ammo = projectile_gun.contents[1]
		P = ammo.BB
	if(!P)
		return "no"
	switch(P.damage)
		if(0)
			return "no"
		if(1 to 5)
			return "a very small amount of"
		if(6 to 15)
			return "a small amount of"
		if(16 to 25)
			return "a modest amount of"
		if(26 to 40)
			return "a respectable amount of"
		if(41 to 60)
			return "a serious amount of"
		if(61 to 80)
			return "a lot of"
		if(81 to 2000)
			return "a ruinous amount of"
	qdel(P)

/obj/item/weapon/gun/proc/describe_proj_penetration()
	var/obj/item/projectile/P
	if(istype(src, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/energy_gun = src
		P = new energy_gun.projectile_type()
	else if(istype(src, /obj/item/weapon/gun/projectile/shotgun/pump))
		var/obj/item/weapon/gun/projectile/shotgun/pump/projectile_gun = src
		if(isnull(projectile_gun.chambered) || isnull(projectile_gun.chambered.BB))
			return "as it has no projectile loaded"
		else
			var/obj/item/ammo_casing/ammo = projectile_gun.chambered
			P = ammo.BB
	else if(istype(src, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/projectile_gun = src
		var/obj/item/ammo_casing/ammo
		if(projectile_gun.ammo_magazine)
			ammo = projectile_gun.ammo_magazine.contents[1]
		else
			ammo = projectile_gun.contents[1]
		P = ammo.BB
	if(!P)
		return "no"
	switch(P.armor_penetration)
		if(0)
			return "cannot pierce armor"
		if(1 to 20)
			return "barely pierces armor"
		if(21 to 30)
			return "slightly pierces armor"
		if(31 to 40)
			return "reliably pierces lighter armors"
		if(41 to 50)
			return "pierces standard-issue armor reliably"
		if(51 to 60)
			return "pierces most armor reliably"
		if(61 to 70)
			return "pierces a great deal of armor"
		if(71 to 80)
			return "pierces the vast majority of armor"
		if(81 to 99)
			return "almost completely pierces all armor"
		if(100 to 1000)
			return "completely and utterly pierces all armor"
	qdel(P)

/obj/item/weapon/gun/proc/describe_firerate()
	switch(fire_delay)
		if(0)
			return "no delay"
		if(1 to 4)
			return "a very short delay"
		if(5 to 8)
			return "a short delay"
		if(9 to 12)
			return "a moderate delay"
		if(13 to 15)
			return "a noticeable delay"
		if(16 to 20)
			return "a distinct delay"
		if(21 to 30)
			return "a long delay"
		if(31 to 50)
			return "a very long delay"
		if(51 to 100)
			return "an extremely long delay"

/obj/item/weapon/gun/get_description_info()
	var/is_loaded
	var/non_lethal
	var/non_lethal_list = list(/obj/item/weapon/gun/energy/medigun,/obj/item/weapon/gun/energy/mouseray,/obj/item/weapon/gun/energy/temperature,/obj/item/weapon/gun/energy/sizegun,/obj/item/weapon/gun/projectile/shotgun/pump/toy,/obj/item/weapon/gun/projectile/revolver/toy,/obj/item/weapon/gun/projectile/pistol/toy,/obj/item/weapon/gun/projectile/automatic/toy)
	var/less_lethal
	var/less_lethal_list = list(/obj/item/weapon/gun/energy/taser,/obj/item/weapon/gun/energy/stunrevolver,/obj/item/weapon/gun/energy/plasmastun,/obj/item/weapon/gun/energy/bfgtaser)
	var/weapon_stats = description_info + "\
	<br>"
	if(istype(src, /obj/item/weapon/gun/energy))
		is_loaded = LAZYLEN(src.contents)
	if(istype(src, /obj/item/weapon/gun/projectile/shotgun/pump))
		var/obj/item/weapon/gun/projectile/shotgun/pump/shotgun = src
		if(isnull(shotgun.chambered) || isnull(shotgun.chambered.BB))
			is_loaded = null
		else
			is_loaded = shotgun.chambered
	if(istype(src, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/projectile_gun = src
		var/ammo
		if(projectile_gun.ammo_magazine)
			ammo = projectile_gun.ammo_magazine.contents
		else
			ammo = projectile_gun.contents
		is_loaded = LAZYLEN(ammo)
	for(var/llweapontype in less_lethal_list)
		if(istype(src,llweapontype))
			is_loaded = null
			less_lethal = TRUE
	for(var/nlweapontype in non_lethal_list)
		if(istype(src,nlweapontype))
			is_loaded = null
			non_lethal = TRUE

	if(is_loaded)
		weapon_stats += "\nIf fired, it would deal [describe_firepower()] damage, [describe_proj_penetration()], and has [describe_firerate()] between shots."
	else if(less_lethal)
		weapon_stats += "\nIf fired, it would deal stunning damage to incapacitate targets, and has [describe_firerate()] between shots."
	else if(non_lethal)
		weapon_stats += "\nThis is an entirely non-lethal weapon, such as a mouseray, toy, or sizegun! Its effects cannot easily be quantified."
	else
		weapon_stats += "\nIt isn't loaded!"
	if(force)
		weapon_stats += "\nIf used in melee, it deals [describe_power()] [sharp ? "sharp" : "blunt"] damage, [describe_penetration()], and has [describe_speed()]."
	if(can_cleave)
		weapon_stats += "\nIt is capable of hitting multiple targets with a single swing."
	if(reach > 1)
		weapon_stats += "\nIt can attack targets up to [reach] tiles away, and can attack over certain objects."

	return weapon_stats
