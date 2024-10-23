/*
 * Shotgun
 */

/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced MarsTech Meteor 29 shotgun is a favourite of police and security forces on many worlds. Uses 12g rounds."
	description_fluff = "The leading civilian-sector high-quality small arms brand of Hephaestus Industries, \
	MarsTech has been the provider of choice for law enforcement and security forces for over 300 years."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	projectile_type = /obj/item/projectile/bullet/shotgun
	handle_casings = HOLD_CASINGS
	var/recentpump = 0 			//To prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'
	var/empty_sprite = 0 		//This is just a dirty var so it doesn't fudge up.
	var/pump_animation = "shotgun-pump"	//You put the reference to the animation in question here. Frees up namming. Ex: "shotgun_old_pump" or "sniper_cycle"

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(src, action_sound, 60, 1)

	// We have a shell in the chamber
	if(chambered)
		if(chambered.caseless)
			qdel(chambered) // Delete casing
		else
			chambered.loc = get_turf(src) // Eject casing
		chambered = null
		M.hud_used.update_ammo_hud(M, src) // TGMC Ammo HUD Port

	// Load next shell
	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] // Load next casing.
		loaded -= AC // Remove casing from loaded list.
		chambered = AC
		M.hud_used.update_ammo_hud(M, src) // TGMC Ammo HUD Port

	if(pump_animation) // This affects all bolt action and shotguns.
		flick("[pump_animation]", src) // This plays any pumping

	update_icon()

/obj/item/gun/projectile/shotgun/pump/update_icon()//This adds empty sprite capability for shotguns.
	..()
	if(!empty_sprite)//Just a dirty check
		return
	if((loaded.len) || (chambered))
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-empty"

/obj/item/gun/projectile/shotgun/pump/empty
	ammo_type = null

/obj/item/gun/projectile/shotgun/pump/slug
	ammo_type = /obj/item/ammo_casing/a12g
	pump_animation = null

/*
 * Combat Shotgun
 */
/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. Uses 12g rounds."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' \
	branding for its military-grade equipment used by armed forces across human space."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/a12g
	load_method = SINGLE_CASING|SPEEDLOADER
	pump_animation = "cshotgun-pump"

/obj/item/gun/projectile/shotgun/pump/combat/empty
	ammo_type = null

/*
 * Double-Barreled Shotgun
 */
/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A truely classic weapon. No need to change what works. Uses 12g rounds."
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

	var/unique_reskin
	var/sawn_off = FALSE

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells. Uses 12g rounds."
	ammo_type = /obj/item/ammo_casing/a12g/flash

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/doublebarrel/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun."

	var/input = sanitizeSafe(input(usr, "What do you want to name the gun?", ,""), MAX_NAME_LEN)

	var/mob/M = usr
	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/shotgun/doublebarrel/verb/reskin_gun()
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["Default"] = "dshotgun"
	options["Cherry Red"] = "dshotgun_d"
	options["Ash"] = "dshotgun_f"
	options["Faded Grey"] = "dshotgun_g"
	options["Maple"] = "dshotgun_l"
	options["Rosewood"] = "dshotgun_p"
	options["Olive Green"] = "dshotgun_o"
	options["Blued"] = "dshotgun_b"
	var/choice = tgui_input_list(M,"Choose your sprite!","Resprite Gun", options)
	if(sawn_off)
		to_chat(M, span_warning("The [src] is already shortened and cannot be resprited!"))
		return
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1

//this is largely hacky and bad :(	-Pete //less hacky and bad now :) -Ghost
/obj/item/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(sawn_off)
		to_chat(user, span_warning("The [src] is already shortened!"))
		return
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, span_notice("You begin to shorten the barrel of \the [src]."))
		if(loaded.len)
			var/burstsetting = burst
			burst = 2
			user.visible_message(span_danger("The shotgun goes off!"), span_danger("The shotgun goes off in your face!"))
			Fire_userless(user)
			user.hud_used.update_ammo_hud(user, src) // TGMC Ammo HUD Port
			burst = burstsetting
			return
		if(do_after(user, 30)) // SHIT IS STEALTHY EYYYYY
			if(sawn_off)
				return
			if(unique_reskin)
				icon_state = "[unique_reskin]_sawn"
			else
				icon_state = "dshotgun_sawn"
			item_state = "sawnshotgun"
			w_class = ITEMSIZE_NORMAL
			force = 5
			slot_flags &= ~SLOT_BACK // you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) // but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, span_warning("You shorten the barrel of \the [src]!"))
			sawn_off = TRUE
	else
		..()

/*
 * Sawn-Off Shotgun
 */
/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!" // I'm not gonna add "Uses 12g rounds." to this one. I'll just let this reference go undisturbed.
	icon_state = "dshotgun_sawn"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	w_class = ITEMSIZE_NORMAL
	force = 5
	sawn_off = TRUE

//Sjorgen Inertial Shotgun
/obj/item/gun/projectile/shotgun/semi
	name = "semi-automatic shotgun"
	desc = "A shotgun with a simple, yet effective recoil inertia loading mechanism for semi-automatic fire. This gun uses 12 gauge ammunition."
	description_fluff = "Looking back on yet another venerable design, Hedberg-Hammarstrom settled on a pattern of shotgun that both had the reliability of a well proven semi-automatic loading system in addition to a striking visual aesthetic that would be appealing to even the most discerning of firearm collectors."
	icon_state = "sjorgen"
	item_state = "shotgun"
	w_class = ITEMSIZE_LARGE
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
