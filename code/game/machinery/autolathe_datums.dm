/var/global/list/autolathe_recipes
/var/global/list/autolathe_categories

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	autolathe_categories = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes += recipe
		autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
		if(recipe.is_stack && istype(I, /obj/item/stack))
			var/obj/item/stack/IS = I
			recipe.max_stack = IS.max_amount
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack
	var/max_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/weapon/reagent_containers/glass/bucket
	category = "General"

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square
	category = "General"
	New()
		..()
		var/obj/O = path
		name = initial(O.name) // generic recipes yay

/datum/autolathe/recipe/drinkingglass/rocks
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/autolathe/recipe/drinkingglass/shake
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/autolathe/recipe/drinkingglass/cocktail
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/autolathe/recipe/drinkingglass/shot
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/autolathe/recipe/drinkingglass/pint
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/autolathe/recipe/drinkingglass/mug
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/autolathe/recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = "General"

/datum/autolathe/recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light
	category = "General"

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/weapon/extinguisher
	category = "General"

/datum/autolathe/recipe/jar
	name = "jar"
	path = /obj/item/glass_jar
	category = "General"

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/weapon/crowbar
	category = "Tools"

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/datum/autolathe/recipe/weldertool
	name = "welding tool"
	path = /obj/item/weapon/weldingtool
	category = "Tools"

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/weapon/screwdriver
	category = "Tools"

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/weapon/wirecutters
	category = "Tools"

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/weapon/wrench
	category = "Tools"

/datum/autolathe/recipe/hatchet
	name = "hatchet"
	path = /obj/item/weapon/material/hatchet
	category = "Tools"

/datum/autolathe/recipe/minihoe
	name = "mini hoe"
	path = /obj/item/weapon/material/minihoe
	category = "Tools"

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = "General"

/datum/autolathe/recipe/radio_bounced
	name = "station bounced radio"
	path = /obj/item/device/radio/off
	category = "General"

/datum/autolathe/recipe/suit_cooler
	name = "suit cooling unit"
	path = /obj/item/device/suit_cooling_unit
	category = "General"

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/weapon/material/knife
	category = "General"

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder
	category = "General"

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/weapon/airlock_electronics
	category = "Engineering"

/datum/autolathe/recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/weapon/circuitboard/airalarm
	category = "Engineering"

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/weapon/circuitboard/firealarm
	category = "Engineering"

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/weapon/module/power_control
	category = "Engineering"

/datum/autolathe/recipe/statusdisplay
	name = "status display electronics"
	path = /obj/item/weapon/circuitboard/status_display
	category = "Engineering"

/datum/autolathe/recipe/aistatusdisplay
	name = "ai status display electronics"
	path = /obj/item/weapon/circuitboard/ai_status_display
	category = "Engineering"

/datum/autolathe/recipe/newscaster
	name = "newscaster electronics"
	path = /obj/item/weapon/circuitboard/newscaster
	category = "Engineering"

/datum/autolathe/recipe/atm
	name = "atm electronics"
	path = /obj/item/weapon/circuitboard/atm
	category = "Engineering"

/datum/autolathe/recipe/intercom
	name = "intercom electronics"
	path = /obj/item/weapon/circuitboard/intercom
	category = "Engineering"

/datum/autolathe/recipe/holopad
	name = "holopad electronics"
	path = /obj/item/weapon/circuitboard/holopad
	category = "Engineering"

/datum/autolathe/recipe/guestpass
	name = "guestpass console electronics"
	path = /obj/item/weapon/circuitboard/guestpass
	category = "Engineering"

/datum/autolathe/recipe/entertainment
	name = "entertainment camera electronics"
	path = /obj/item/weapon/circuitboard/security/telescreen/entertainment
	category = "Engineering"

/datum/autolathe/recipe/keycard
	name = "keycard authenticator electronics"
	path = /obj/item/weapon/circuitboard/keycard_auth
	category = "Engineering"

/datum/autolathe/recipe/photocopier
	name = "photocopier electronics"
	path = /obj/item/weapon/circuitboard/photocopier
	category = "Engineering"

/datum/autolathe/recipe/fax
	name = "fax machine electronics"
	path = /obj/item/weapon/circuitboard/fax
	category = "Engineering"

/datum/autolathe/recipe/microwave
	name = "microwave electronics"
	path = /obj/item/weapon/circuitboard/microwave
	category = "Engineering"

/datum/autolathe/recipe/washing
	name = "washing machine electronics"
	path = /obj/item/weapon/circuitboard/washing
	category = "Engineering"

/datum/autolathe/recipe/request
	name = "request console electronics"
	path = /obj/item/weapon/circuitboard/request
	category = "Engineering"

/datum/autolathe/recipe/motor
	name = "motor"
	path = /obj/item/weapon/stock_parts/motor
	category = "Engineering"

/datum/autolathe/recipe/gear
	name = "gear"
	path = /obj/item/weapon/stock_parts/gear
	category = "Engineering"

/datum/autolathe/recipe/spring
	name = "spring"
	path = /obj/item/weapon/stock_parts/spring
	category = "Engineering"

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/weapon/rcd_ammo
	category = "Engineering"

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/weapon/scalpel
	category = "Medical"

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/weapon/circular_saw
	category = "Medical"

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/weapon/surgicaldrill
	category = "Medical"

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/weapon/retractor
	category = "Medical"

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/weapon/cautery
	category = "Medical"

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/weapon/hemostat
	category = "Medical"

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker
	category = "Medical"

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/large
	category = "Medical"

/datum/autolathe/recipe/vial
	name = "glass vial"
	path = /obj/item/weapon/reagent_containers/glass/beaker/vial
	category = "Medical"

/datum/autolathe/recipe/syringe
	name = "syringe"
	path = /obj/item/weapon/reagent_containers/syringe
	category = "Medical"

/datum/autolathe/recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/weapon/syringe_cartridge
	category = "Arms and Ammunition"

////////////////
/*Ammo casings*/
////////////////

/datum/autolathe/recipe/shotgun_blanks
	name = "ammunition (12g, blank)"
	path = /obj/item/ammo_casing/shotgun/blank
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_beanbag
	name = "ammunition (12g, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_flash
	name = "ammunition (12g, flash)"
	path = /obj/item/ammo_casing/shotgun/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun
	name = "ammunition (12g, slug)"
	path = /obj/item/ammo_casing/shotgun
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_pellet
	name = "ammunition (12g, pellet)"
	path = /obj/item/ammo_casing/shotgun/pellet
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell
	hidden = 1
	category = "Arms and Ammunition"

//////////////////
/*Ammo magazines*/
//////////////////

/////// 5mm
/*
/datum/autolathe/recipe/pistol_5mm
	name = "pistol magazine (5mm)"
	path = /obj/item/ammo_magazine/c5mm
	category = "Arms and Ammunition"
	hidden = 1
*/

/////// .45
/datum/autolathe/recipe/pistol_45
	name = "pistol magazine (.45)"
	path = /obj/item/ammo_magazine/c45m
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_45p
	name = "pistol magazine (.45 practice)"
	path = /obj/item/ammo_magazine/c45m/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_45r
	name = "pistol magazine (.45 rubber)"
	path = /obj/item/ammo_magazine/c45m/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_45f
	name = "pistol magazine (.45 flash)"
	path = /obj/item/ammo_magazine/c45m/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_45uzi
	name = "uzi magazine (.45)"
	path = /obj/item/ammo_magazine/c45uzi
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/tommymag
	name = "Tommygun magazine (.45)"
	path = /obj/item/ammo_magazine/tommymag
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/tommydrum
	name = "Tommygun drum magazine (.45)"
	path = /obj/item/ammo_magazine/tommydrum
	category = "Arms and Ammunition"
	hidden = 1

/////// 9mm

/obj/item/ammo_magazine/mc9mm/flash
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/mc9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mm/practice
	name = "magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

/datum/autolathe/recipe/pistol_9mm
	name = "pistol magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_9mmr
	name = "pistol magazine (9mm rubber)"
	path = /obj/item/ammo_magazine/mc9mm/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_9mmp
	name = "pistol magazine (9mm practice)"
	path = /obj/item/ammo_magazine/mc9mm/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_9mmf
	name = "pistol magazine (9mm flash)"
	path = /obj/item/ammo_magazine/mc9mm/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/smg_9mm
	name = "top-mounted SMG magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mmt
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/smg_9mmr
	name = "top-mounted SMG magazine (9mm rubber)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/smg_9mmp
	name = "top-mounted SMG magazine (9mm practice)"
	path = /obj/item/ammo_magazine/mc9mmt/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/smg_9mmf
	name = "top-mounted SMG magazine (9mm flash)"
	path = /obj/item/ammo_magazine/mc9mmt/flash
	category = "Arms and Ammunition"

/////// 10mm
/datum/autolathe/recipe/smg_10mm
	name = "SMG magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_50
	name = "pistol magazine (.50AE)"
	path = /obj/item/ammo_magazine/a50
	category = "Arms and Ammunition"
	hidden = 1

/////// 5.56mm
/datum/autolathe/recipe/rifle_556
	name = "10rnd rifle magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_556p
	name = "10rnd rifle magazine (5.56mm practice)"
	path = /obj/item/ammo_magazine/a556/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rifle_556m
	name = "20rnd rifle magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556m
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_556mp
	name = "20rnd rifle magazine (5.56mm practice)"
	path = /obj/item/ammo_magazine/a556m/practice
	category = "Arms and Ammunition"
	hidden = 1

/////// 7.62
/datum/autolathe/recipe/rifle_small_762
	name = "10rnd rifle magazine (7.62mm)"
	path = /obj/item/ammo_magazine/s762
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_762
	name = "20rnd rifle magazine (7.62mm)"
	path = /obj/item/ammo_magazine/c762
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/machinegun_762
	name = "machinegun box magazine (7.62)"
	path = /obj/item/ammo_magazine/a762
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/shotgun_magazine
	name = "24rnd shotgun magazine (12g)"
	path = /obj/item/ammo_magazine/g12
	category = "Arms and Ammunition"
	hidden = 1

/* Commented out until autolathe stuff is decided/fixed. Will probably remove these entirely. -Spades
// These should always be /empty! The idea is to fill them up manually with ammo clips.

/datum/autolathe/recipe/pistol_5mm
	name = "pistol magazine (5mm)"
	path = /obj/item/ammo_magazine/c5mm/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/smg_5mm
	name = "top-mounted SMG magazine (5mm)"
	path = /obj/item/ammo_magazine/c5mmt/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_45
	name = "pistol magazine (.45)"
	path = /obj/item/ammo_magazine/c45m/empty
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_45uzi
	name = "uzi magazine (.45)"
	path = /obj/item/ammo_magazine/c45uzi/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/tommymag
	name = "Tommygun magazine (.45)"
	path = /obj/item/ammo_magazine/tommymag/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/tommydrum
	name = "Tommygun drum magazine (.45)"
	path = /obj/item/ammo_magazine/tommydrum/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_9mm
	name = "pistol magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm/empty
	category = "Arms and Ammunition"

/datum/autolathe/recipe/smg_9mm
	name = "top-mounted SMG magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mmt/empty
	category = "Arms and Ammunition"

/datum/autolathe/recipe/smg_10mm
	name = "SMG magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_50
	name = "pistol magazine (.50AE)"
	path = /obj/item/ammo_magazine/a50/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_556
	name = "10rnd rifle magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556/empty
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rifle_556m
	name = "20rnd rifle magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556m/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_SVD
	name = "10rnd rifle magazine (7.62mm)"
	path = /obj/item/ammo_magazine/SVD/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_762
	name = "20rnd rifle magazine (7.62mm)"
	path = /obj/item/ammo_magazine/c762/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/machinegun_762
	name = "machinegun box magazine (7.62)"
	path = /obj/item/ammo_magazine/a762/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/shotgun_magazine
	name = "24rnd shotgun magazine (12g)"
	path = /obj/item/ammo_magazine/g12/empty
	category = "Arms and Ammunition"
	hidden = 1*/

///////////////////////////////
/*Ammo clips and Speedloaders*/
///////////////////////////////

/datum/autolathe/recipe/speedloader_357
	name = "speedloader (.357)"
	path = /obj/item/ammo_magazine/a357
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/speedloader_38
	name = "speedloader (.38)"
	path = /obj/item/ammo_magazine/c38
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/speedloader_38r
	name = "speedloader (.38 rubber)"
	path = /obj/item/ammo_magazine/c38/rubber
	category = "Arms and Ammunition"

// Commented out until metal exploits with autolathe is fixed.
/*/datum/autolathe/recipe/pistol_clip_45
	name = "ammo clip (.45)"
	path = /obj/item/ammo_magazine/clip/c45
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_clip_45r
	name = "ammo clip (.45 rubber)"
	path = /obj/item/ammo_magazine/clip/c45/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_45f
	name = "ammo clip (.45 flash)"
	path = /obj/item/ammo_magazine/clip/c45/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_45p
	name = "ammo clip (.45 practice)"
	path = /obj/item/ammo_magazine/clip/c45/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_9mm
	name = "ammo clip (9mm)"
	path = /obj/item/ammo_magazine/clip/c9mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_clip_9mmr
	name = "ammo clip (9mm rubber)"
	path = /obj/item/ammo_magazine/clip/c9mm/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_9mmp
	name = "ammo clip (9mm practice)"
	path = /obj/item/ammo_magazine/clip/c9mm/practice
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_9mmf
	name = "ammo clip (9mm flash)"
	path = /obj/item/ammo_magazine/clip/c9mm/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/pistol_clip_5mm
	name = "ammo clip (5mm)"
	path = /obj/item/ammo_magazine/clip/c5mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_clip_10mm
	name = "ammo clip (10mm)"
	path = /obj/item/ammo_magazine/clip/a10mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/pistol_clip_50
	name = "ammo clip (.50AE)"
	path = /obj/item/ammo_magazine/clip/a50
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_clip_556
	name = "ammo clip (5.56mm)"
	path = /obj/item/ammo_magazine/clip/a556
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_clip_556_practice
	name = "ammo clip (5.56mm practice)"
	path = /obj/item/ammo_magazine/clip/a556/practice
	category = "Arms and Ammunition"
*/

/datum/autolathe/recipe/rifle_clip_762
	name = "ammo clip (7.62mm)"
	path = /obj/item/ammo_magazine/clip/a762
	category = "Arms and Ammunition"
	hidden = 1

/datum/autolathe/recipe/rifle_clip_762_practice
	name = "ammo clip (7.62mm practice)"
	path = /obj/item/ammo_magazine/clip/a762/practice
	category = "Arms and Ammunition"

//////////////

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/weapon/stock_parts/console_screen
	category = "Devices and Components"

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/datum/autolathe/recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/weapon/light/tube
	category = "General"

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/weapon/light/bulb
	category = "General"

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/weapon/material/ashtray/glass
	category = "General"

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/weapon/camera_assembly
	category = "Engineering"

/datum/autolathe/recipe/weldinggoggles
	name = "welding goggles"
	path = /obj/item/clothing/glasses/welding
	category = "General"

/datum/autolathe/recipe/maglight
 	name = "maglight"
 	path = /obj/item/device/flashlight/maglight
 	hidden = 1
 	category = "General"

/datum/autolathe/recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/weapon/flamethrower/full
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rcd
	name = "rapid construction device"
	path = /obj/item/weapon/rcd
	hidden = 1
	category = "Engineering"

/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/beartrap
	name = "mechanical trap"
	path = /obj/item/weapon/beartrap
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/welder_industrial
	name = "industrial welding tool"
	path = /obj/item/weapon/weldingtool/largetank
	hidden = 1
	category = "Tools"

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/weapon/handcuffs
	hidden = 1
	category = "General"

/datum/autolathe/recipe/knuckledusters
	name = "knuckle dusters"
	path = /obj/item/weapon/material/knuckledusters
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/tacknife
	name = "tactical knife"
	path = /obj/item/weapon/material/hatchet/tacknife
	hidden = 1
	category = "Arms and Ammunition"