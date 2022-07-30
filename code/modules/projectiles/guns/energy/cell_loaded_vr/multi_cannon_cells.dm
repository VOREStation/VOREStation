/obj/item/ammo_casing/macrobattery
	caliber = "macrobat"
	name = "macrobattery"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "macrobat_wtf"
	desc = "A large nanite fabricator for a medigun. Powered by a mix of precursor and modern tech, this fancy device recharges without an outside power source."

	projectile_type = /obj/item/projectile/beam/chain_lightning //why the hell not

	var/bat_colour = "#ff33cc"
	var/charge
	var/max_charge = 10
	var/ticks = 1
	var/ticks_to_charge = 15 //10 secs per shot charged

/obj/item/ammo_casing/macrobattery/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSobj, src)
	charge = max_charge

/obj/item/ammo_casing/macrobattery/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/ammo_casing/macrobattery/process()
	ticks++
	if(ticks%ticks_to_charge == 0)
		recharge()
		if(charge >= max_charge)
			return PROCESS_KILL

/obj/item/ammo_casing/macrobattery/expend()
	if(charge)
		charge --
		ticks = 1 //so we have to start over on the charge time.
		START_PROCESSING(SSobj, src)
		. = BB
		//alright, the below seems jank. it IS jank, but for whatever reason I can't reuse BB. big bad
		BB = null
		BB = new projectile_type
		// TGMC Ammo HUD - Update the HUD every time we expend/fire, given the Curabitur's method of handling firing.
		if(istype(loc, /obj/item/gun/projectile/multi_cannon))
			var/obj/item/gun/projectile/multi_cannon = loc
			var/mob/living/user = multi_cannon.loc
			if(istype(user))
				user?.hud_used.update_ammo_hud(user, multi_cannon)
		return
	else
		BB = null
		return null

/obj/item/ammo_casing/macrobattery/proc/recharge()
	if(charge < max_charge)
		charge ++
		if(!BB)
			BB = new projectile_type
	if(charge >= max_charge)
		STOP_PROCESSING(SSobj, src)
	if(istype(loc,/obj/item/gun/projectile/multi_cannon))
		loc.update_icon()

	// TGMC Ammo HUD - Update the HUD every time we're called to recharge.
	if(istype(loc, /obj/item/gun/projectile/multi_cannon))
		var/obj/item/gun/projectile/multi_cannon = loc
		var/mob/living/user = multi_cannon.loc
		if(istype(user))
			user?.hud_used.update_ammo_hud(user, multi_cannon)

//variants here, there's not many of them.

/obj/item/ammo_casing/macrobattery/stabilize
	name = "Macrobattery - STABILIZE"
	icon_state = "macrobat_stabilize"
	bat_colour = "#3399ff"
	projectile_type = /obj/item/projectile/beam/medical_cell/stabilize2

/obj/item/ammo_casing/macrobattery/buff
	name = "Macrobattery - BOOSTER"
	icon_state = "macrobat_uber"
	bat_colour = "#993300"
	projectile_type = /obj/item/projectile/beam/medical_cell/resist

/obj/item/ammo_casing/macrobattery/detox
	name = "Macrobattery - DETOX"
	icon_state = "macrobat_purifier"
	bat_colour = "#339933"
	projectile_type = /obj/item/projectile/beam/medical_cell/detox

/obj/item/ammo_casing/macrobattery/ouchie
	name = "Macrobattery - LETHAL"
	icon_state = "macrobat_ouchie"
	bat_colour = "#cc3300"
	projectile_type = /obj/item/projectile/beam/heavylaser/lessheavy

/obj/item/ammo_casing/macrobattery/healie
	name = "Macrobattery - RESTORE"
	icon_state = "macrobat_inverseouchie"
	bat_colour = "#ff9966"
	projectile_type = /obj/item/projectile/beam/medical_cell/phys_heal

/obj/item/projectile/beam/medical_cell/phys_heal/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-20)
		target.adjustFireLoss(-20)
	else
		return 1

/obj/item/projectile/beam/medical_cell/detox/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-15)
		target.radiation = max(target.radiation - 75, 0) //worse than mlem for rad, better for tox.
	else
		return 1

/obj/item/projectile/beam/heavylaser/lessheavy //all bark. no (or little) bite.
	damage = 15
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
