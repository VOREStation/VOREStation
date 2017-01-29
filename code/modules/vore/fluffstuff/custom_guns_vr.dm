/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"

	on guns, in particular:
	item_state being null makes it look for exactly the icon_state in the on-mob file,
		including any 0,75,etc appended from the energy bar setting
	item_state being present prevents different mode sprites, sadly, but you may
		be able to override this on the gun itself with a proc
*/

/* TEMPLATE
//ckey:Character Name
/obj/item/weapon/gun/type/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "myicon"

*/

//////////////////// Projectile Weapons ////////////////////
// For general use
/obj/item/weapon/gun/projectile/automatic/battlerifle
	name = "\improper BR55 Service Rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I brought this motivational device! Uses unique 9.5x40mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "battlerifle"
	item_icons = null
	w_class = ITEMSIZE_LARGE
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a95mm
	magazine_type = /obj/item/ammo_magazine/battlerifle
	allowed_magazines = list(/obj/item/ammo_magazine/battlerifle)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	//requires_two_hands = 1
	one_handed_penalty = 4 // The weapon itself is heavy

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/unsc
	name = "\improper M45E Tactical Shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day."

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "haloshotgun"

	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "haloshotgun"
	item_icons = null

	ammo_type = /obj/item/ammo_casing/shotgun
	max_shells = 12

// jertheace : Jeremiah 'Ace' Acacius
/obj/item/weapon/gun/projectile/shotgun/pump/unsc/fluff/ace
	name = "Ace's M45D Tactical Shotgun" // D-model holds half as many shells as the normal version so as not to be OP as shit. Better than shotgun, worse than combat shotgun.
	desc = "Owned by the respected (or feared?) veteran Captain of VORE Station. Inscribed on the barrel are the words \"Speak softly, and carry a big stick.\" It has a folding stock so it can fit into bags."
	w_class = ITEMSIZE_NORMAL // Because collapsable stock so it fits in backpacks.
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	max_shells = 6

// bwoincognito:Tasald Corlethian
/obj/item/weapon/gun/projectile/revolver/mateba/fluff/tasald_corlethian //Now that it is actually Single-Action and not hacky broken SA, I see no reason to nerf this down to .38. --Joan Risu
	name = "Big Iron revolver"
	desc = "A .357 revolver for veteran rangers on the planet Orta. The right side of the handle has a logo for Quarion industries, and the left is the Rangers. The primary ammo for this gun is .38 rubber. According to the CentCom Chief of Security, this revolver was more controversial than it needed to be."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "tasaldrevolver"

	item_state = "revolver"

	fire_sound = 'sound/weapons/pistol.ogg'
	ammo_type = /obj/item/ammo_casing/a357/rubber //Like I said, no reason to nerf. --Joan Risu
	var/recentpump = 0
	var/cocksound = 'sound/weapons/revolvercock.ogg'

	consume_next_projectile()
		if(chambered)
			return chambered.BB
		usr << "<span class='warning'>It's a single action revolver, pull the hammer back!</span>"
		return null

	attack_self(mob/living/user as mob)
		if(world.time >= recentpump + 10)
			pump(user)
			recentpump = world.time

	proc/pump(mob/M as mob)
		playsound(M, cocksound, 60, 1)

		if(chambered)//We have a shell in the chamber
			chambered.loc = get_turf(src)//Eject casing
			chambered = null

		if(loaded.len)
			var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
			loaded -= AC //Remove casing from loaded list.
			chambered = AC

		update_icon()

// wankersonofjerkin : Ryan Winz
/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver
	name = "Ryan's 'Devilgun'"
	desc = "You notice the serial number on the revolver is 666. The word 'Sin' is engraved on the blood-red rosewood grip. Uses .357 rounds."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "ryan_winz"

	item_state = "revolver"

/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver/redemption
	name = "Ryan's 'Redeemer'"
	desc = "You notice the serial number on the revolver is 667. The word 'Redemption' is engraved on dark rosewood grip. Uses .357 rounds."

// sasoperative : Joseph Skinner
/obj/item/weapon/gun/projectile/revolver/judge/fluff/sasoperative
	name = "\"The Jury\""
	desc = "A customized variant of the \"The Judge\" revolver sold by Cybersun Industries, built specifically for Joseph Skinner. Uses 12g shells."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "jury"
	item_state = "gun"
	accuracy = 0 // Because I know you're not an idiot who needs to be nerfed. -Ace
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

// For general use
/obj/item/weapon/gun/projectile/automatic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "stg60"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	max_shells = 30
	caliber = "kurz"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/stg
	allowed_magazines = list(/obj/item/ammo_magazine/stg)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/automatic/stg/update_icon(var/ignore_inhands)
	..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-empty"
	item_state = (ammo_magazine)? "arifle" : "arifle-empty"
	if(!ignore_inhands) update_held_icon()

/*
// For general use
/obj/item/weapon/gun/projectile/automatic/m14/fluff/gallian
	name = "\improper Gallian 4 Rifle"
	desc = "The ever reliable Gallian 4 Rifle. Produced by the National Armory on the Planet of Gaia located in Gallia, the Gallian 4 Rifle offers high accuracy and is widely used in the United Federation's Military. Uses 7.62mm rounds."
*/

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/zmkar
	name = "\improper ZM Kar 1"
	desc = "A reproduction of an old ZM Kar 1 Rifle from the Autocratic East Europan Imperial Alliance of Gaia. Popular among imperials and collectors within the Federation and its allies. Uses 7.62mm rounds."

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/wicked
	name = "Wicked Butterfly ZM Kar S1"
	desc = "A customized bolt-action sniper rifle that was carried by some of the most revered snipers in the Federation. The stock has a small butterfly engraved on it. Uses 7.62mm rounds."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "wickedbutterfly"

	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "SVD"
	item_icons = null

	recoil = 2 //extra kickback
	accuracy = -1
	scoped_accuracy = 2
	load_method = SINGLE_CASING

	verb/scope()
		set category = "Object"
		set name = "Use Scope"
		set popup_menu = 1

		toggle_scope(2.0)

// For general use
/obj/item/weapon/gun/projectile/automatic/pdw // Vorestation SMG because the WT550 is ugly and bad.
	name = "personal defense weapon"
	desc = "The X-9MM is a select-fire personal defense weapon designed in-house by Xing Private Security. It was made to compete with the WT550 Saber, but hasn't yet caught on with NanoTrasen. Uses 9mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "pdw"
	item_state = "c20r" // Placeholder
	w_class = ITEMSIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mml
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mm, /obj/item/ammo_magazine/mc9mml)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-2), dispersion=list(0.0, 0.6, 0.6))
		)

/obj/item/weapon/gun/projectile/automatic/pdw/update_icon(var/ignore_inhands)
	..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/mc9mm))
		icon_state = "pdw-short"
	else
		icon_state = (ammo_magazine)? "pdw" : "pdw-empty"
	if(!ignore_inhands) update_held_icon()


//Currently, the only problem I have now is that this weapon's item_state isn't working.
/obj/item/weapon/gun/projectile/automatic/fluff/crestrose
	name = "Crescent Rose"
	desc = "Can you match my resolve? If so then you will succeed. I believe that the human spirit is indomitable. Keep Moving Forward. Uses 5.56mm rounds."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "crestrose_fold"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "crestrose_fold_mob"

	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4)
	slot_flags = null
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	force = 3
	recoil = 2
	var/on = 0
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	hitsound = null
	caliber = "a556"
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)

/obj/item/weapon/gun/projectile/automatic/fluff/crestrose/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message("<span class='warning'>With a press of a button, [user]'s gun turns into a deadly scythe.</span>",\
		"<span class='warning'>You extend The Rose's thorns.</span>",\
		"You hear an ominous click.")
		icon = 'icons/vore/custom_guns_vr.dmi'
		icon_state = "crestrose"
		icon_override = 'icons/vore/custom_guns_vr.dmi'
		item_state = "crestrose_mob"
		w_class = ITEMSIZE_LARGE
		force = 15//Obscenely robust
		attack_verb = list("slashed", "cut", "drives")
		hitsound = 'sound/weapons/bladeslice.ogg'
	else
		user.visible_message("<span class='notice'>\The [user] folds the weapon back up into a gun.</span>",\
		"<span class='notice'>You fold up the weapon.</span>",\
		"You hear a click.")
		icon = 'icons/vore/custom_guns_vr.dmi'
		icon_state = "crestrose_fold"
		icon_override = 'icons/vore/custom_guns_vr.dmi'
		item_state = "crestrose_fold_mob"
		w_class = ITEMSIZE_NORMAL
		force = 3//Not so obscenely robust
		attack_verb = list("hit", "melee'd")
		hitsound = null
	update_icon()


/obj/item/weapon/gun/projectile/automatic/fluff/crestrose/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//-----------------------G44----------------------------------
/obj/item/weapon/gun/projectile/automatic/carbine/fluff/g44
	name = "G44 Rifle"
	desc = "The G44 is a lightweight assault rifle manufactured by the National Armory of Gaia and sold almost exclusively to the United Federation's standing army, the Military Assault Command Operations Department (MACOs)."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "g44"
	item_state = "bullpup"

/obj/item/weapon/gun/projectile/automatic/carbine/fluff/g44/update_icon(var/ignore_inhands)
	..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/a556m))
		icon_state = "g44"
	else
		icon_state = (ammo_magazine)? "g44" : "g44-empty"
	item_state = (ammo_magazine)? "bullpup" : "bullpup-empty"
	if(!ignore_inhands) update_held_icon()

//-----------------------G44 Energy Variant--------------------

/obj/item/weapon/gun/energy/gun/burst/g44e
	name = "G44 Energy Rifle"
	desc = "The G44 Energy is a laser variant of the G44 lightweight assault rifle manufactured by the National Armory of Gaia. Though almost exclusively to the United Federation's Military Assault Command Operations Department (MACOs) and Starfleet, it is occassionally sold to security departments for their stun capabilities."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "g44estun100"
	item_state = "energystun100" //This is temporary.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 6

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "g44estun"

//	requires_two_hands = 1
	one_handed_penalty = 2

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg'),
		)


// molenar:Kari Akiren
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/fluff/kari_akiren
	name = "clockwork rifle"
	desc = "Brass, copper, and lots of gears. Well lubricated for fluid movement as each round is loaded, locked, and fired. Just like clockwork."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "clockworkrifle_icon"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "clockworkrifle"
	item_icons = null

//Razerwing:Archer Maximus
/obj/item/weapon/gun/projectile/colt/fluff/archercolt
	name = "\improper MEUSOC .45"
	desc = "Some serious drywall work, coming up!"

//////////////////// Energy Weapons ////////////////////
// -------------- Dominator -------------
/obj/item/weapon/gun/energy/gun/fluff/dominator
	name = "\improper MWPSB Dominator"
	desc = "A MWPSB's Dominator from the Federation. Like the basic Energy Gun, this gun has two settings. It is used by the United Federation Public Safety Bureau's Criminal Investigation Division."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "dominatorstun100"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = null
	item_icons = null

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/beam/stun

	modifystate = "dominatorstun"

	firemodes = list(
	list(mode_name="stun", charge_cost=240,projectile_type=/obj/item/projectile/beam/stun, modifystate="dominatorstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=480,projectile_type=/obj/item/projectile/beam/dominator, modifystate="dominatorkill", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)

// ------------ Energy Luger ------------
/obj/item/weapon/gun/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser, this pistol can punch a hole through inch thick steel plating. This ain't your great-grand-daddy's Luger! Can switch between stun and kill."

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "elugerstun100"

	item_state = "gun"

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/beam/stun

	modifystate = "elugerstun"
	fire_sound = 'sound/weapons/Taser.ogg'

	firemodes = list(
	list(mode_name="stun", charge_cost=100,projectile_type=/obj/item/projectile/beam/stun, modifystate="elugerstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=200,projectile_type=/obj/item/projectile/beam/eluger, modifystate="elugerkill", fire_sound='sound/weapons/eluger.ogg'),
	)

//////////////////// Custom Ammo ////////////////////
//---------------- Beams ----------------
/obj/item/projectile/beam/eluger
	name = "laser beam"
	icon_state = "emitter"

/obj/item/projectile/beam/dominator
	name = "dominator lethal beam"
	icon_state = "xray"
	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

//--------------- StG-60 ----------------
/obj/item/ammo_magazine/stg
	name = "box mag (7.92x33mm Kurz)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stg_30rnd"
	caliber = "kurz"
	ammo_type = /obj/item/ammo_casing/stg
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_casing/stg
	desc = "A 7.92�33mm Kurz casing."
	icon_state = "rifle-casing"
	caliber = "kurz"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/stg/empty
	initial_ammo = 0

//------------- Battlerifle -------------
/obj/item/ammo_magazine/battlerifle
	name = "box mag (9.5x40mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "battlerifle"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95mm
	max_ammo = 36
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/a95mm
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a95mm

/obj/item/projectile/bullet/rifle/a95mm
	damage = 40
	penetrating = 2 // Better penetration than the 7.62mm

/obj/item/ammo_magazine/battlerifle/empty
	initial_ammo = 0

//---------------- PDW ------------------
/obj/item/ammo_magazine/mc9mml
	name = "\improper SMG magazine (9mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mml/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mml/ap
	name = "\improper SMG magazine (9mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_magazine/mc9mml/flash
	name = "\improper SMG magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/mc9mml/rubber
	name = "\improper SMG magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mml/practice
	name = "\improper SMG magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

//.357 special ammo
/obj/item/ammo_magazine/a357/stun
	name = "speedloader (.357 stun)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357/stun


/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	caliber = "357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stun357"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot

/obj/item/ammo_magazine/a357/rubber
	name = "speedloader (.357 rubber)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "r357"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357/rubber


/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	caliber = "357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "rubber357"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_magazine/a357/flash
	name = "speedloader (.357 flash)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "f357"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357/flash


/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	caliber = "357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "flash357"
	projectile_type = /obj/item/projectile/energy/flash
