//Misc voidsuits

//Boarding ops.
/obj/item/clothing/head/helmet/space/void/boarding_ops
	name = "boarding operations voidsuit helmet"
	desc = "A first generation armoured voidsuit helmet designed for variable-gravity boarding operations where heavier combat suits would leave the user vulnerable once within a pressurized environment."
	icon_state = "light_ops"
	armor = list(melee = 30, bullet = 35, laser = 35, energy = 5, bomb = 30, bio = 100, rad = 50)
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/space/void/boarding_ops/mk2
	desc = "A second generation armoured voidsuit helmet designed for variable-gravity boarding operations where heavier combat suits would leave the user vulnerable once within a pressurized environment. This one has improved visibility at the cost of some plating."
	icon_state = "light_ops_mk2"
	armor = list(melee = 20, bullet = 30, laser = 40, energy = 5, bomb = 30, bio = 100, rad = 50)

/obj/item/clothing/suit/space/void/boarding_ops
	name = "boarding operations voidsuit"
	desc = "A moderately armoured voidsuit designed for variable-gravity boarding operations where heavier combat suits would leave the user vulnerable once within a pressurized environment."
	description_fluff = "Originally an Aether Atmospherics design intended for hazardous environment EVA, these lightweight armoured suits were adapted for combat use and for easy re-fabrication, making them a hit with pirates of both varieties."
	icon_state = "light_ops"
	armor = list(melee = 30, bullet = 35, laser = 35, energy = 5, bomb = 30, bio = 100, rad = 50)
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored
	siemens_coefficient = 0.8
	allowed = list(/obj/item/gun,
			/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/melee,
			/obj/item/grenade,
			/obj/item/flash,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/handcuffs,
			/obj/item/hailer,
			/obj/item/holowarrant,
			/obj/item/megaphone,
			/obj/item/ammo_magazine,
			/obj/item/cell
			)

//Tajaran Pearlshield Coalition Spacesuit
/obj/item/clothing/head/helmet/space/void/pearlshield
	name = "Pearlshield Coalition space helmet"
	desc = "A rugged, utilitarian space helmet designed for the Pearlshield Coalition military by PCA."
	description_fluff = "Pearlshield Consolidated Armories is a collaborative organization of Tajaran arms manufacturers tasked with producing equipment for the intergovernmental Pearlshield Coalition, the Tajaran representative body on the galactic stage."
	icon_state = "pearlshield_void"
	armor = list(melee = 30, bullet = 40, laser = 40, energy = 20, bomb = 30, bio = 100, rad = 50)
	species_restricted = list(SPECIES_TAJ)

/obj/item/clothing/suit/space/void/pearlshield
	name = "Pearlshield Coalition voidsuit"
	desc = "A rugged, utilitarian spacesuit designed for the Pearlshield Coalition military by PCA."
	description_fluff = "Pearlshield Consolidated Armories is a collaborative organization of Tajaran arms manufacturers tasked with producing equipment for the intergovernmental Pearlshield Coalition, the Tajaran representative body on the galactic stage."
	icon_state = "pearlshield_void"
	armor = list(melee = 20, bullet = 20, laser = 20, energy = 50, bomb = 50, bio = 100, rad = 50)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	species_restricted = list(SPECIES_TAJ)

//SCG Fleet Voidsuit(s)

/obj/item/clothing/head/helmet/space/void/scg
	name = "Fleet voidsuit helmet"
	desc = "A standard issue SCG Marine armoured voidsuit helmet for use in hazardous environment combat scenarios."
	icon_state = "scg_void"
	armor = list(melee = 50, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 70)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/space/void/scg/heavy
	name = "heavy Fleet voidsuit helmet"
	desc = "A heavier version of the standard issue SCG Marine armoured voidsuit helmet for use in hazardous environment combat scenarios."
	icon_state = "scg_voidcombat"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 70)
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/scg
	name = "Fleet voidsuit"
	desc = "A standard issue SCG Marine armoured voidsuit for use in hazardous environment combat scenarios."
	icon_state = "scg_void"
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 50, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 70)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.6
	breach_threshold = 16 //Extra Thicc
	resilience = 0.05 //Military Armor

//Misc Armoured Space helmets

/obj/item/clothing/head/helmet/space/void/grayson
	name = "heavy mining helmet"
	desc =  "An older model heavy-duty atmosphere-controlled mining helmet."
	description_fluff = "This armoured mining helmet was one of Grayson's best selling models before the advent rigsuit technology, and due to its relatively simple construction the design has remained in use for well over a century and is often adapted to function with the latest suits."
	icon_state = "grayson_helm"
	armor = list(melee = 60, bullet = 20, laser = 25, energy = 15, bomb = 55, bio = 100, rad = 50)
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/space/void/hedberg
	name = "Hedberg-Hammarstrom combat helmet"
	desc =  "A heavily armoured helmet with built-in faceplate, built to withstand the rigours of modern combat and equipped for space use."
	description_fluff = "The Hedberg-Hammarstrom company has operated Vir's military forces privately since 2566, but retains many of its unique armour designs exclusively for use in the private sector."
	icon_state = "hedberg_helmet"
	armor = list(melee = 70, bullet = 80, laser = 60, energy = 25, bomb = 40, bio = 100, rad = 0)
	siemens_coefficient = 0.8
	no_cycle = TRUE