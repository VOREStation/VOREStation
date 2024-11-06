/*
 * Contains:
 *		Hard Hats
 *		Firefighter Hats
 *		Ranger Hats
 */

/*
 * Hard Hats
 */

/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	light_range = 4 //luminosity when on
	light_cone_y_offset = 14
	light_overlay = "hardhat_light"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9
	actions_types = list(/datum/action/item_action/toggle_head_light)
	w_class = ITEMSIZE_NORMAL
	ear_protection = 1
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	name = "orange hard hat"

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	name = "sleek hard hat"

/obj/item/clothing/head/hardhat/dblue
	name = "blue hard hat"
	icon_state = "hardhat0_dblue"

/*
 * Firefighter Hats
 */

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	name = "emergency fire helmet"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0.2* ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE

/obj/item/clothing/head/hardhat/firefighter
	name = "firefighter helmet"
	desc = "A helmet with face mask specially designed for firefighting. It's airtight and has a port for internals."
	icon_state = "helmet_firefighter"
	item_flags = THICKMATERIAL | AIRTIGHT
	permeability_coefficient = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE+5000
	min_pressure_protection = 0.5 * ONE_ATMOSPHERE
	max_pressure_protection = 20 * ONE_ATMOSPHERE
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	flash_protection = FLASH_PROTECTION_MODERATE
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/head/mob_tajaran.dmi',
		SPECIES_UNATHI = 'icons/inventory/head/mob_unathi.dmi'
		)

/obj/item/clothing/head/hardhat/firefighter/atmos
	name = "atmospheric firefighter helmet"
	desc = "An atmospheric firefighter's helmet, includes a face mask specially designed for firefighting. It's airtight and has a port for internals."
	icon_state = "atmos_fire"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/clothing/head/hardhat/firefighter/chief
	name = "chief firefighter helmet"
	desc = "A helmet with face mask specially designed for firefighting. This one is in the colors of the " + JOB_CHIEF_ENGINEER + ". It's airtight and has a port for internals."
	icon_state = "helmet_firefighter_ce"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/clothing/head/hardhat/old
	name = "classic hard hat"
	icon_state = "hardhat0_old_yellow"
	light_overlay = "hardhat_light_old"

/obj/item/clothing/head/hardhat/orange/old
	name = "classic orange hard hat"
	icon_state = "hardhat0_old_orange"
	light_overlay = "hardhat_light_old"

/obj/item/clothing/head/hardhat/white/old
	name = "classic sleek hard hat"
	icon_state = "hardhat0_old_white"
	light_overlay = "hardhat_light_old"

/obj/item/clothing/head/hardhat/dblue/old
	name = "classic blue hard hat"
	icon_state = "hardhat0_old_dblue"
	light_overlay = "hardhat_light_old"

/obj/item/clothing/head/hardhat/red/old
	name = "classic fire helmet"
	icon_state = "hardhat0_old_red"
	light_overlay = "hardhat_light_old"

/obj/item/clothing/head/hardhat/firefighter/old
	name = "classic firefighter helmet"
	icon_state = "helmet_firefighter_old"
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/head/mob_tajaran.dmi'
		)

/obj/item/clothing/head/hardhat/firefighter/atmos/old
	name = "classic atmospheric firefighter helmet"
	icon_state = "atmos_fire_old"
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/head/mob_tajaran.dmi'
		)

/obj/item/clothing/head/hardhat/firefighter/chief/old
	name = "classic chief firefighter helmet"
	icon_state = "helmet_firefighter_ce_old"
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/head/mob_tajaran.dmi'
		)

/*
 * Ranger Hats
 */

	//Missing onmob sprites.

/*
/obj/item/clothing/head/hardhat/ranger
	var/hatcolor = "white"
	name = "ranger helmet"
	desc = "A special helmet designed for the Go Go ERT-Rangers, able to withstand a pressureless environment, filter gas and provide air. It has thermal vision and sometimes \
	mesons to find breaches, as well as an integrated radio... well, only in the show, of course. This one has none of those features- it just has a flashlight instead."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_helmet"
	light_overlay = "helmet_light"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

/obj/item/clothing/head/hardhat/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_helmet")
		name = "[hatcolor] ranger helmet"
		icon_state = "[hatcolor]_ranger_helmet"

/obj/item/clothing/head/hardhat/ranger/black
	hatcolor = "black"

/obj/item/clothing/head/hardhat/ranger/pink
	hatcolor = "pink"

/obj/item/clothing/head/hardhat/ranger/green
	hatcolor = "green"

/obj/item/clothing/head/hardhat/ranger/cyan
	hatcolor = "cyan"

/obj/item/clothing/head/hardhat/ranger/orange
	hatcolor = "orange"

/obj/item/clothing/head/hardhat/ranger/yellow
	hatcolor = "yellow"
*/
