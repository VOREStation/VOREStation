/datum/uplink_category
	var/name = ""
	var/list/datum/uplink_item/items

/datum/uplink_category/New()
	..()
	items = list()

datum/uplink_category/ammunition
	name = "Ammunition"

/datum/uplink_category/services
	name = "Services"

/datum/uplink_category/armor
	name = "Armor"

/datum/uplink_category/badassery
	name = "Badassery"

/datum/uplink_category/grenades
	name = "Grenades and Thrown Objects"

/datum/uplink_category/hardsuit_modules
	name = "Hardsuit Modules"

/datum/uplink_category/implants
	name = "Implants"

/datum/uplink_category/medical
	name = "Medical"

/datum/uplink_category/stealth_items
	name = "Stealth and Camouflage Items"

/datum/uplink_category/stealthy_weapons
	name = "Stealthy and Inconspicuous Weapons"

/datum/uplink_category/tools
	name = "Devices and Tools"

/datum/uplink_category/visible_weapons
	name = "Highly Visible and Dangerous Weapons"

/datum/uplink_category/telecrystals
	name = "Telecrystals"

/datum/uplink_category/backup
	name = "Backup"
