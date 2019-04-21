// Collars

/datum/gear/collar
	display_name = "collar, silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/collar/golden
	display_name = "collar, golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/gear/collar/bell
	display_name = "collar, bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/gear/collar/shock
	display_name = "collar, shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/gear/collar/spike
	display_name = "collar, spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/gear/collar/pink
	display_name = "collar, pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/gear/collar/holo
	display_name = "collar, holo"
	path = /obj/item/clothing/accessory/collar/holo

/datum/gear/accessory/holster
	display_name = "holster selection (Security, CD, HoP, Exploration)"
	allowed_roles = list("Colony Director", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective","Explorer","Pathfinder")

/datum/gear/accessory/brown_vest
	display_name = "webbing, brown"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic","Pathfinder","Shaft Miner")

/datum/gear/accessory/black_vest
	display_name = "webbing, black"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic","Pathfinder","Shaft Miner")

/datum/gear/accessory/white_vest
	display_name = "webbing, white (Medical)"
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, brown"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic","Pathfinder","Shaft Miner")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, black"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic","Pathfinder","Shaft Miner")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, white (Medical)"
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Field Medic")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 1

/datum/gear/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic")

/datum/gear/accessory/khcrystal
	display_name = "KH Life Crystal"
	path = /obj/item/weapon/storage/box/khcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/tronket
    display_name = "metal necklace"
    description = "A shiny steel chain with a vague metallic object dangling off it."
    path = /obj/item/clothing/accessory/tronket

/datum/gear/accessory/flops
    display_name = "drop straps"
    description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
    path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)
