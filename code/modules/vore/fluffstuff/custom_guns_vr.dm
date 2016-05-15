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
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I brought this motivational device! Uses unique 9.5x40mm ammo."

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "battlerifle"

	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "battlerifle"
	item_icons = null

	w_class = 4
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = "combat=2;materials=2;"
	ammo_type = /obj/item/ammo_casing/a95mm
	magazine_type = /obj/item/ammo_magazine/battlerifle
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK

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
	w_class = 3 // Because collapsable stock so it fits in backpacks.
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	max_shells = 6

// bwoincognito:Tasald Corlethian
/obj/item/weapon/gun/projectile/revolver/detective/fluff/tasald_corlethian
	name = "Big Iron revolver"
	desc = "A .38 revolver for veteran rangers on the planet Orta. The right side of the handle has a logo for Quarion industries, and the left is the Rangers. The primary ammo for this gun is .38 rubber. According to the CentCom Chief of Security, this revolver was more controversial than it needed to be."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "tasaldrevolver"

	item_state = "revolver"

	fire_sound = 'sound/weapons/pistol.ogg'
	ammo_type = /obj/item/ammo_casing/c38r
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

// roaper : Callum Leamas
/obj/item/weapon/gun/projectile/revolver/detective/fluff/callum_leamas
	name = "Deckard .38"
	desc = "A custom built revolver, based off the semi-popular Detective Special model."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "leamas"
	ammo_type = /obj/item/ammo_magazine/c38/rubber

	load_ammo(var/obj/item/A, mob/user)
		if(istype(A, /obj/item/ammo_magazine))
			flick("leamas-reloading",src)
		..()

// wankersonofjerkin : Ryan Winz
/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver
	name = "Ryan's 'Devilgun'"
	desc = "You notice the serial number on the revolver is 666. The word 'Sin' is engraved on the blood-red rosewood grip. Uses .357 ammo."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "ryan_winz"

	item_state = "revolver"

/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver/redemption
	name = "Ryan's 'Redeemer'"
	desc = "You notice the serial number on the revolver is 667. The word 'Redemption' is engraved on dark rosewood grip. Uses .357 ammo."

// sasoperative : Joseph Skinner
/obj/item/weapon/gun/projectile/revolver/shotgun/fluff/sasoperative
	name = "\"The Jury\""
	desc = "A customized variant of the \"The Judge\" revolver sold by Cybersun Industries, built specifically for Joseph Skinner."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "jury"

	item_state = "gun"

	accuracy = 0 // Because I know you're not an idiot who needs to be nerfed. -Ace
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

// For general use
/obj/item/weapon/gun/projectile/automatic/stg
	name = "\improper StG-650"
	desc = "Experience the terror of the Siegfried line, redone for the 26th century! With a fire rate of over 1,400 rounds per minute, the Kaiser would be proud. Uses unique 7.92x33mm Kurz ammo."

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "stg60"

	item_state = "gun"

	w_class = 4
	max_shells = 30
	caliber = "kurz"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = /obj/item/ammo_casing/stg
	magazine_type = /obj/item/ammo_magazine/stg
	load_method = MAGAZINE

// For general use
/obj/item/weapon/gun/projectile/automatic/m14/fluff/gallian
	name = "\improper Gallian 4 Rifle"
	desc = "The ever reliable Gallian 4 Rifle. Produced by the National Armory on the Planet of Gaia located in Gallia, the Gallian 4 Rifle offers high accuracy and is widely used in the United Federation's Military. Uses 7.62mm ammo."

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/zmkar
	name = "\improper ZM Kar 1"
	desc = "A reproduction of an old ZM Kar 1 Rifle from the Autocratic East Europan Imperial Alliance of Gaia. Popular among imperials and collectors within the Federation and its allies. Uses 7.62mm ammo."

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/wicked
	name = "'Wicked Butterfly' ZM Kar S1"
	desc = "A customized bolt-action sniper rifle that was carried by some of the most revered snipers in the Federation. The stock has a small butterfly engraved on it. Uses 7.62mm ammo."

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

//This weapon is shelved until someone can fix the modifystate var and apply a safety to the scythe mode.
/*
/obj/item/weapon/gun/projectile/automatic/crestrose
	name = "Crescent Rose"
	desc = "Can you match my resolve? If so then you will succeed. I believe that the human spirit is indomitable. Keep Moving Forward."
	origin_tech = "materials=7"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "crestrose"
	item_state = null // So it inherits the icon_state.
	w_class = 4
	fire_sound = 'sound/weapons/rifleshot.ogg'
	force = 40
	throwforce = 10
	max_shells = 10
	magazine_type = /obj/item/ammo_magazine/m14
	allowed_magazines = list(magazine_type = /obj/item/ammo_magazine/m14)
	load_method = MAGAZINE
	caliber = "a762"

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/modifystate = "crestrose"
	var/mode = 0 //0 = unfolded, 1 = folded

/obj/item/weapon/gun/projectile/automatic/crestrose/attack_self(mob/living/user as mob)
	switch(mode)
		if(0)
			mode = 1
			user.visible_message("<span class='warning'>[src.name] folds up into a cool looking rifle.</span>")
			force = 5
			throwforce = 2
			modifystate = crestrose_fold
		if(1)
			mode = 0 // I feel like this mode should prevent it from shooting. Otherwise, what's the point? -Spades ||Probably need assistance in that. Original design of Crescent Rose is to shoot no matter what form it was in. Perhaps lowering accuracy will provide a con buffer here. -- Joan
			user.visible_message("<span class='warning'>[src.name] changes into a very intimidating looking weapon.</span>")
			force = 40
			throwforce = 10
			modifystate = crestrose
	update_icon()
	update_held_icon()
*/

// molenar:Kari Akiren
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/fluff/kari_akiren
	name = "Clockwork Rifle"
	desc = "Brass, copper, and lots of gears. Well lubricated for fluid movement as each round is loaded, locked, and fired. Just like clockwork."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "clockworkrifle"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "clockworkrifle"
	item_icons = null

//////////////////// Energy Weapons ////////////////////
//arokha:Aronai Kadigan
/obj/item/weapon/gun/energy/gun/fluff/aro
	name = "KIN-H21"
	desc = "The Kitsuhana Heavy Industries standard Imperial Navy energy sidearm, commonly called the KIN21. This one appears to have been modified to have additional features at the cost of battery life."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "kinh21stun100"

	item_state = "laser"

	modifystate = "kinh21stun"

	projectile_type = /obj/item/projectile/beam/stun/kin21

	max_shots = 8
	charge_cost = 125
	charge_meter = 1

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/kin21, modifystate="kinh21stun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="kinh21kill", fire_sound='sound/weapons/blaster_pistol.ogg'),
		list(mode_name="shrink", projectile_type=/obj/item/projectile/beam/shrinklaser, modifystate="kinh21shrink", fire_sound='sound/weapons/wave.ogg'),
		list(mode_name="grow", projectile_type=/obj/item/projectile/beam/growlaser, modifystate="kinh21grow", fire_sound='sound/weapons/pulse3.ogg'),
		)

// -------------- Dominator -------------
/obj/item/weapon/gun/energy/gun/fluff/dominator
	name = "MWPSB Dominator"
	desc = "A MWPSB's Dominator from the Federation. Like the basic Energy Gun, this gun has two settings. It is used by the United Federation Public Safety Bureau's Criminal Investigation Division."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "dominatorstun100"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = null
	item_icons = null

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = "combat=3;magnets=2"

	modifystate = "dominatorstun"

	firemodes = list(
	list(mode_name="stun", charge_cost=100,projectile_type=/obj/item/projectile/beam/stun, modifystate="dominatorstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=125,projectile_type=/obj/item/projectile/beam/dominator, modifystate="dominatorkill", fire_sound='sound/weapons/gauss_shoot.ogg'),
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
/obj/item/ammo_casing/stg
	desc = "A 7.92×33mm Kurz casing."
	icon_state = "762-casing"
	caliber = "kurz"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/stg
	name = "box mag (7.92x33mm Kurz)"
	icon_state = "stg_30rnd"
	caliber = "kurz"
	ammo_type = /obj/item/ammo_casing/stg
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_magazine/stg/empty
	initial_ammo = 0

//---------------- Battle ----------------
/obj/item/ammo_magazine/battlerifle
	name = "box mag (9.5x40mm)"
	icon_state = "battlerifle"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95mm
	max_ammo = 36
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/a95mm
	desc = "A 9.5x40mm bullet casing."
	icon_state = "762-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a95mm

/obj/item/projectile/bullet/rifle/a95mm
	damage = 40
	penetrating = 2 // Better penetration than the 7.62mm

/obj/item/ammo_magazine/battlerifle/empty
	initial_ammo = 0
