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


////////////////////////////////////////////////////////////
//////////////////// Projectile Weapons ////////////////////
////////////////////////////////////////////////////////////
// For general use
/obj/item/weapon/gun/projectile/automatic/battlerifle
	name = "\improper USDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = ITEMSIZE_LARGE
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m95
	allowed_magazines = list(/obj/item/ammo_magazine/m95)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/USDF
	name = "\improper USDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12

// For general use
/obj/item/weapon/gun/projectile/automatic/pdw
	name = "personal defense weapon"
	desc = "The X-9MM is a select-fire personal defense weapon designed in-house by Xing Private Security. It was made to compete with the WT550 Saber, but never caught on with NanoTrasen. Uses 9mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "pdw"
	item_state = "c20r" // Placeholder
	w_class = ITEMSIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mml
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm, /obj/item/ammo_magazine/m9mml)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30), dispersion=list(0.0, 0.6, 0.6))
		)

/obj/item/weapon/gun/projectile/automatic/pdw/update_icon(var/ignore_inhands)
	..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m9mm))
		icon_state = "pdw-short"
	else
		icon_state = (ammo_magazine)? "pdw" : "pdw-empty"
	if(!ignore_inhands) update_held_icon()

// For general use
/obj/item/weapon/gun/energy/imperial
	name = "imperial energy pistol"
	desc = "An elegant weapon developed by the Imperium Auream. Their weaponsmiths have cleverly found a way to make a gun that is only about the size of an average energy pistol, yet with the fire power of a laser carbine."
	icon_state = "ge_pistol"
	item_state = "ge_pistol"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon = 'icons/obj/gun_vr.dmi'
	item_icons = list(slot_r_hand_str = 'icons/obj/gun_vr.dmi', slot_l_hand_str = 'icons/obj/gun_vr.dmi') // WORK YOU FUCKING CUNT PIECE OF SHIT BASTARD STUPID BITCH ITEM ICON AAAAHHHH
	item_state_slots = list(slot_r_hand_str = "ge_pistol_r", slot_l_hand_str = "ge_pistol_l")
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/imperial

// jertheace : Jeremiah 'Ace' Acacius
/obj/item/weapon/gun/projectile/shotgun/pump/USDF/fluff/ace
	name = "Ace's tactical shotgun" // D-model holds half as many shells as the normal version so as not OP as shit. Better than normal shotgun, worse than combat shotgun.
	desc = "Owned by the respected (or feared?) veteran Captain of the original NSS Adephagia. Inscribed on the barrel are the words \"Speak softly, and carry a big stick.\""
	ammo_type = /obj/item/ammo_casing/a12g/stunshell
	max_shells = 6

/* // jertheace : Jeremiah 'Ace' Acacius
/obj/item/ammo_magazine/m9mm/large/preban/hp // Not yet implemented. Waiting on a PR to Polaris. -Ace
	ammo_type = /obj/item/ammo_casing/a9mm/hp
*/

// bwoincognito:Tasald Corlethian
/obj/item/weapon/gun/projectile/revolver/mateba/fluff/tasald_corlethian //Now that it is actually Single-Action and not hacky broken SA, I see no reason to nerf this down to .38. --Joan Risu
	name = "\improper \"Big Iron\" revolver"
	desc = "A .357 revolver for veteran rangers on the planet Orta. The right side of the handle has a logo for Quarion industries, and the left is the Rangers. The primary ammo for this gun is .357 rubber. According to the CentCom Chief of Security, this revolver was more controversial than it needed to be."
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
		to_chat(usr, "<span class='warning'>It's a single action revolver, pull the hammer back!</span>")
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

/obj/item/weapon/gun/projectile/revolver/mateba/fluff/tasald_corlethian/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump = 1)
	else
		..()

// wankersonofjerkin : Glenn Pink
/obj/item/weapon/gun/projectile/revolver/fluff/admiral_pink_revolver
	name = "Admiral Pink's 'Devilgun'"
	desc = "You notice the serial number on the revolver is 666. The word 'Sin' is engraved on the blood-red rosewood grip. Uses .357 rounds." //Edgy, but based on real guns the player owns.
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "ryan_winz"
	item_state = "revolver"

/obj/item/weapon/gun/projectile/revolver/fluff/admiral_pink_revolver/redemption
	name = "Admiral Pink's 'Redeemer'"
	desc = "You notice the serial number on the revolver is 667. The word 'Redemption' is engraved on dark rosewood grip. Uses .357 rounds." //Edgy, but based on real guns the player owns.

// sasoperative : Joseph Skinner
/obj/item/weapon/gun/projectile/revolver/judge/fluff/sasoperative
	name = "\"The Jury\""
	desc = "A customized variant of the \"The Judge\" revolver sold by Cybersun Industries, built specifically for Joseph Skinner. Uses 12g shells."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "jury"
	item_state = "gun"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

// Dhaeleena : Dhaeleena M'iar
/obj/item/weapon/gun/projectile/revolver/mateba/fluff/dhael
	name = "Dhaeleena's engraved mateba"
	desc = "This unique looking handgun is engraved with roses along the barrel and the cylinder as well as the initials DM under the grip. Along the middle of the barrel an engraving shows the words 'Mateba Unica 6'. Uses .357 rounds."
	icon_state = "mateba"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a357/stun

// SilencedMP5A5 : Serdykov Antoz
/obj/item/weapon/gun/projectile/colt/fluff/serdy
	name = "Raikov PPS/45"
	desc = "An expertly crafted and reliable .45 sidearm with a 7 round single-stack magazine, originally built and in 2369 for frontier men and peacekeepers. The frame and slide are nickel plated, and it has a synthetic black ivory grip. The words 'Krasnaya Raketa' are engraved on the slide near the muzzle. It's relatively thin, but heavy. It also has an ambidextrous mag release and safety lever, making it grippable in either hand comfortably."
	icon = 'icons/vore/custom_guns_vr.dmi'
	item_state = "raikov"
	icon_state = "raikov"
	fire_sound = 'sound/weapons/45pistol_vr.ogg'
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/* //Commented out due to weapon change.
/obj/item/weapon/gun/projectile/revolver/detective/fluff/serdy //This forces it to be .38 bullets only
	name = "Vintage S&W Model 10"
	desc = "It's a classic S&W Model 10 revolver. This one in particular is beautifully restored with a chromed black frame and cylinder, and a nice redwood grip. The name 'Serdykov A.' is engraved into the base of the grip."
	icon = 'icons/vore/custom_guns_vr.dmi'
	item_state = "model10"
	icon_state = "model10"
	fire_sound = 'sound/weapons/deagle.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a38r //Rubber rounds.
*/

// LuminescentRing : Briana Moore
/obj/item/weapon/gun/projectile/derringer/fluff/briana
	name = "second-hand derringer"
	desc = "It's a palm sized gun. One of the few things that won't break an angel's wrists. Uses 10mm rounds."
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm

// For general use
/obj/item/weapon/gun/projectile/automatic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "stg60"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	max_shells = 30
	caliber = "7.92x33mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/mtg
	allowed_magazines = list(/obj/item/ammo_magazine/mtg)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/automatic/stg/update_icon(var/ignore_inhands)
	..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-empty"
	item_state = (ammo_magazine)? "arifle" : "arifle-empty"
	if(!ignore_inhands) update_held_icon()

//-----------------------Tranq Gun----------------------------------
/obj/item/weapon/gun/projectile/dartgun/tranq
	name = "tranquilizer gun"
	desc = "A gas-powered dart gun designed by the National Armory of Gaia. This gun is used primarily by United Federation special forces for Tactical Espionage missions. Don't forget your bandana."
	icon_state = "tranqgun"
	item_state = null

	caliber = "dart"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = list(/obj/item/ammo_magazine/chemdart)
	auto_eject = 0

/obj/item/weapon/gun/projectile/dartgun/tranq/update_icon()
	if(!ammo_magazine)
		icon_state = "tranqgun"
		return 1

	if(!ammo_magazine.stored_ammo || ammo_magazine.stored_ammo.len)
		icon_state = "tranqgun"
	else if(ammo_magazine.stored_ammo.len > 5)
		icon_state = "tranqgun"
	else
		icon_state = "tranqgun"
	return 1

// Removed because gun64_vr.dmi guns don't work.
/*//-----------------------UF-ARC----------------------------------
/obj/item/weapon/gun/projectile/automatic/carbine/fluff/ufarc
	name = "UF-ARC"
	desc = "The UF-ARC is a lightweight assault rifle manufactured by the National Armory of Gaia and sold almost exclusively to the United Federation's standing army, the Military Assault Command Operations Department (MACOs)."
	icon = 'icons/obj/gun64_vr.dmi'
	icon_state = "ufarc"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	pixel_x = -16

/obj/item/weapon/gun/projectile/automatic/carbine/fluff/ufarc/update_icon(var/ignore_inhands)
	..()
	// TODO - Fix this for spriting different size magazines
	icon_state = (ammo_magazine)? "ufarc" : "ufarc-empty"
	item_state = (ammo_magazine)? "bullpup" : "bullpup-empty"
	if(!ignore_inhands) update_held_icon()



//-----------------------G44----------------------------------
/obj/item/weapon/gun/projectile/automatic/carbine/fluff/g44
	name = "G44 Rifle"
	desc = "The G44 is a lightweight assault rifle manufactured by the National Armory of Gaia and sold almost exclusively to the United Federation's standing army, the Military Assault Command Operations Department (MACOs)."
	icon = 'icons/obj/gun64_vr.dmi'
	icon_state = "g44"
	item_state = "bullpup"
	pixel_x = -16

/obj/item/weapon/gun/projectile/automatic/carbine/fluff/g44/update_icon(var/ignore_inhands)
	..()
	// TODO - Fix this for spriting different size magazines
	icon_state = (ammo_magazine)? "g44" : "g44-empty"
	item_state = (ammo_magazine)? "bullpup" : "bullpup-empty"
	if(!ignore_inhands) update_held_icon()

//-----------------------G44 Energy Variant--------------------
/obj/item/weapon/gun/energy/gun/burst/g44e
	name = "G44 Energy Rifle"
	desc = "The G44 Energy is a laser variant of the G44 lightweight assault rifle manufactured by the National Armory of Gaia. Though almost exclusively to the United Federation's Military Assault Command Operations Department (MACOs) and Starfleet, it is occassionally sold to security departments for their stun capabilities."
	icon = 'icons/obj/gun64_vr.dmi'
	icon_state = "g44estun100"
	item_state = "energystun100" //This is temporary.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 6
	pixel_x = -16

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "g44estun"

	one_handed_penalty = 60

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg'),
		)*/


// molenar:Kari Akiren
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/fluff/kari_akiren
	name = "clockwork rifle"
	desc = "Brass, copper, and lots of gears. Well lubricated for fluid movement as each round is loaded, locked, and fired. Just like clockwork."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "clockworkrifle_icon"
	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "clockworkrifle"
	item_icons = null

/* Permit Expired
//Razerwing:Archer Maximus
/obj/item/weapon/gun/projectile/colt/fluff/archercolt
	name = "\improper MEUSOC .45"
	desc = "Some serious drywall work, coming up!"
*/
//hzdonut:Jesse Soemmer
/obj/item/weapon/gun/projectile/revolver/fluff/jesselemat
	name = "Modified LeMat"
	desc = "The LeMat Revolver is a 9 shot revolver with a secondary firing barrel for loading shotgun shells. Uses .38-Special and 12g rounds depending on the barrel. This one appears to have had it's secondary barrel sealed off and looks to be in pristine condition. Either it's brand new, or its owner takes very good care of it."
	icon_state = "lemat"
	max_shells = 9
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	preserve_item = FALSE

//////////////////// Energy Weapons ////////////////////

// ------------ Energy Luger ------------
/obj/item/weapon/gun/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser. Although its battery cannot be removed, its ergonomic design makes it easy to shoot, allowing for rapid follow-up shots. It also has the ability to toggle between stun and kill."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "elugerstun100"
	item_state = "gun"
	fire_delay = null // Lugers are quite comfortable to shoot, thus allowing for more controlled follow-up shots. Rate of fire similar to a laser carbine.
	battery_lock = 1 // In exchange for balance, you cannot remove the battery. Also there's no sprite for that and I fucking suck at sprites. -Ace
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2) // Illegal tech cuz Space Nazis
	modifystate = "elugerstun"
	fire_sound = 'sound/weapons/Taser.ogg'
	firemodes = list(
	list(mode_name="stun", charge_cost=120,projectile_type=/obj/item/projectile/beam/stun, modifystate="elugerstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=240,projectile_type=/obj/item/projectile/beam/eluger, modifystate="elugerkill", fire_sound='sound/weapons/eluger.ogg'),
	)

//////////////////// Eris Ported Guns ////////////////////
//HoS Gun
/*/obj/item/weapon/gun/projectile/lamia
	name = "FS HG .44 \"Lamia\""
	desc = "Uses .44 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "Headdeagle"
	item_state = "revolver"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	caliber = ".44"
	magazine_type = /obj/item/ammo_magazine/m44/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m44,/obj/item/ammo_magazine/m44/rubber)
	load_method = MAGAZINE
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)

/obj/item/weapon/gun/projectile/lamia/update_icon()
	overlays.Cut()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len * 100 / ammo_magazine.max_ammo
	ratio = round(ratio, 33)
	overlays += "deagle_[ratio]"*/ // Fugly.


//Civilian gun
/obj/item/weapon/gun/projectile/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "giskardcivil"
	caliber = ".380"
	magazine_type = /obj/item/ammo_magazine/m380
	allowed_magazines = list(/obj/item/ammo_magazine/m380)
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/weapon/gun/projectile/giskard/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "giskardcivil"
	else
		icon_state = "giskardcivil_empty"

//Not so civilian gun
/obj/item/weapon/gun/projectile/giskard/olivaw
	name = "\improper \"Olivaw\" holdout burst-pistol"
	desc = "The FS HG .380 \"Olivaw\" is a more advanced version of the \"Giskard\". This one seems to have a two-round burst-fire mode. Uses .380 rounds."
	icon_state = "olivawcivil"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    burst_accuracy=list(0,-15),       dispersion=list(1.2, 1.8)),
		)

/obj/item/weapon/gun/projectile/giskard/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"

//Detective gun
/obj/item/weapon/gun/projectile/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "inspector"
	item_state = "revolver"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/rubber
	handle_casings = CYCLE_CASINGS
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/weapon/gun/projectile/revolver/consul/proc/update_charge()
	if(loaded.len==0)
		overlays += "inspector_off"
	else
		overlays += "inspector_on"

/obj/item/weapon/gun/projectile/revolver/consul/update_icon()
	overlays.Cut()
	update_charge()

// No idea what this is for.
/obj/item/weapon/gun/projectile/automatic/sol
	name = "\improper \"Sol\" SMG"
	desc = "The FS 9x19mm \"Sol\" is a compact and reliable submachine gun. Uses 9mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	caliber = "9mm"
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)
	load_method = MAGAZINE
	multi_aim = 1
	burst_delay = 2
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-15,-15),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "smg_[ratio]"

/obj/item/weapon/gun/projectile/automatic/sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	overlays.Cut()
	update_charge()

//HoP gun
/obj/item/weapon/gun/energy/gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout e-gun. Don't miss!"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "PDW"
	item_state = "gun"
	w_class = ITEMSIZE_SMALL
	projectile_type = /obj/item/projectile/beam/stun
	charge_cost = 1200
	charge_meter = 0
	modifystate = null
	battery_lock = 1
	fire_sound = 'sound/weapons/Taser.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', charge_cost = 600),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg', charge_cost = 1200),
		)

/obj/item/weapon/gun/energy/gun/martin/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") add_overlay("taser_pdw")
		if("lethal") add_overlay("lazer_pdw")

/obj/item/weapon/gun/energy/gun/martin/update_icon()
	cut_overlays()
	update_mode()

/////////////////////////////////////////////////////
//////////////////// Custom Ammo ////////////////////
/////////////////////////////////////////////////////
//---------------- Beams ----------------
/obj/item/projectile/beam/eluger
	name = "laser beam"
	icon_state = "xray"
	light_color = "#00FF00"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter

/obj/item/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

//--------------- StG-60 ----------------
/obj/item/ammo_magazine/m792
	name = "box mag (7.92x33mm Kurz)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stg_30rnd"
	caliber = "7.92x33mm"
	ammo_type = /obj/item/ammo_casing/a792
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_casing/a792
	desc = "A 7.92x33mm Kurz casing."
	icon_state = "rifle-casing"
	caliber = "7.92x33mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/mtg/empty
	initial_ammo = 0

//------------- Battlerifle -------------
/obj/item/ammo_magazine/m95
	name = "box mag (9.5x40mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "battlerifle"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95
	max_ammo = 36
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/a95
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a95

/obj/item/projectile/bullet/rifle/a95
	damage = 40

/obj/item/ammo_magazine/m95/empty
	initial_ammo = 0

//---------------- PDW ------------------
/obj/item/ammo_magazine/m9mml
	name = "\improper SMG magazine (9mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mml/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mml/ap
	name = "\improper SMG magazine (9mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a9mm/ap

/* Seems to have been de-coded?
/obj/item/ammo_magazine/m9mml/flash
	name = "\improper SMG magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mmf

/obj/item/ammo_magazine/m9mml/rubber
	name = "\improper SMG magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mmr

/obj/item/ammo_magazine/m9mml/practice
	name = "\improper SMG magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mmp
*/

//.357 special ammo
/obj/item/ammo_magazine/s357/stun
	name = "speedloader (.357 stun)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/stun


/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stun357"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot/strong

/obj/item/ammo_magazine/s357/rubber
	name = "speedloader (.357 rubber)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "r357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/rubber


/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "rubber357"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_magazine/s357/flash
	name = "speedloader (.357 flash)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "f357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/flash

/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "flash357"
	projectile_type = /obj/item/projectile/energy/flash/strong

//.380
/obj/item/ammo_casing/a380
	desc = "A .380 bullet casing."
	caliber = ".380"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_magazine/m380
	name = "magazine (.380)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 480)
	caliber = ".380"
	ammo_type = /obj/item/ammo_casing/a380
	max_ammo = 8
	multiple_sprites = 1

//.44
/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_magazine/m44/rubber
	desc = "A magazine for .44 less-than-lethal ammo."
	ammo_type = /obj/item/ammo_casing/a44/rubber

//.44 speedloaders
/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	desc = "A speedloader for .44 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = ".44"
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	max_ammo = 6
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "r357"
	ammo_type = /obj/item/ammo_casing/a44/rubber

//Expedition Frontier Phaser
/obj/item/weapon/gun/energy/frontier
	name = "frontier phaser"
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "phaser"
	item_state = "phaser"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi', "slot_belt" = 'icons/mob/belt_vr.dmi')
	fire_sound = 'sound/weapons/laser2.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	charge_cost = 300

	battery_lock = 1
	unacidable = 1

	var/recharging = 0
	var/phase_power = 75

	projectile_type = /obj/item/projectile/beam
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam, charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 60),
	)

/obj/item/weapon/gun/energy/frontier/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] opens \the [src] and starts pumping the handle.</span>", \
						"<span class='notice'>You open \the [src] and start pumping the handle.</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()

/obj/item/weapon/gun/energy/frontier/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		update_held_icon()
		return
	..()

/obj/item/weapon/gun/energy/frontier/emp_act(severity)
	return ..(severity+2)

/obj/item/weapon/gun/energy/frontier/ex_act() //|rugged|
	return

/obj/item/weapon/gun/energy/frontier/locked
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/energy/frontier/locked/attackby(obj/item/I, mob/user)
	var/obj/item/weapon/card/id/id = I.GetID()
	if(istype(id))
		if(check_access(id))
			locked = !locked
			to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
	else
		return ..()

/obj/item/weapon/gun/energy/frontier/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	locked = !locked
	to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src]!</span>")

/obj/item/weapon/gun/energy/frontier/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()

//Phaser Carbine - Reskinned phaser
/obj/item/weapon/gun/energy/frontier/locked/carbine
	name = "frontier carbine"
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "carbinekill"
	item_state = "retro"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi')

	modifystate = "carbinekill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam, modifystate="carbinekill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser, modifystate="carbinestun", charge_cost = 60),
	)

/obj/item/weapon/gun/energy/frontier/locked/carbine/update_icon()
	if(recharging)
		icon_state = "[modifystate]_pump"
		update_held_icon()
		return
	..()

//Expeditionary Holdout Phaser Pistol
/obj/item/weapon/gun/energy/frontier/locked/holdout
	name = "holdout frontier phaser"
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "holdoutkill"
	item_state = null
	phase_power = 100

	w_class = ITEMSIZE_SMALL
	charge_cost = 600
	modifystate = "holdoutkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam, modifystate="holdoutkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser, modifystate="holdoutstun", charge_cost = 120),
		list(mode_name="stun", fire_delay=12, projectile_type=/obj/item/projectile/beam/stun/med, modifystate="holdoutshock", charge_cost = 300),
	)
