/obj/item/weapon/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Uses 12g rounds."
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
	var/recentpump = 0 // to prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'
	var/animated_pump = 0 //This is for cyling animations.
	var/empty_sprite = 0 //This is just a dirty var so it doesn't fudge up.

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(animated_pump)//This affects all bolt action and shotguns.
		flick("[icon_state]-cycling", src)//This plays any pumping

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/update_icon()//This adds empty sprite capability for shotguns.
	..()
	if(!empty_sprite)//Just a dirty check
		return
	if((loaded.len) || (chambered))
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-empty"

/obj/item/weapon/gun/projectile/shotgun/pump/slug
	ammo_type = /obj/item/ammo_casing/a12g

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. Uses 12g rounds."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/a12g
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/weapon/gun/projectile/shotgun/doublebarrel
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

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells. Uses 12g rounds."
	ammo_type = /obj/item/ammo_casing/a12g/flash

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/weapon/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/surgical/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			var/burstsetting = burst
			burst = 2
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			Fire_userless(user)
			burst = burstsetting
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = ITEMSIZE_NORMAL
			force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!" // I'm not gonna add "Uses 12g rounds." to this one. I'll just let this reference go undisturbed.
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	w_class = ITEMSIZE_NORMAL
	force = 5
