/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "colony director's gloves"
	icon_state = "captain"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/forensic
	desc = "Specially made gloves for forensic technicians. The luminescent threads woven into the material stand out under scrutiny."
	name = "forensic gloves"
	icon_state = "forensic"
	item_state = "black"
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/sterile
	name = "sterile gloves"
	desc = "Sterile gloves."
	icon_state = "latex"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	siemens_coefficient = 1.0 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	fingerprint_chance = 25
//	var/balloonPath = /obj/item/latexballon

//TODO: Make inflating gloves a thing
/*/obj/item/clothing/gloves/sterile/proc/Inflate(/mob/living/carbon/human/user)
	user.visible_message("<span class='notice'>\The [src] expands!</span>")
	qdel(src)*/

/obj/item/clothing/gloves/sterile/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."

/obj/item/clothing/gloves/sterile/nitrile
	name = "nitrile gloves"
	desc = "Sterile nitrile gloves"
	icon_state = "nitrile"
	item_state = "ngloves"
//	balloonPath = /obj/item/nitrileballoon

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state_slots = list(slot_r_hand_str = "lightbrown", slot_l_hand_str = "lightbrown")
	permeability_coefficient = 0.05
	siemens_coefficient = 0.75 //thick work gloves

/obj/item/clothing/gloves/duty
	desc = "These brown duty gloves are made from a durable synthetic."
	name = "work gloves"
	icon_state = "work"
	item_state = "wgloves"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/tactical
	desc = "These brown tactical gloves are made from a durable synthetic, and have hardened knuckles."
	name = "tactical gloves"
	icon_state = "work"
	item_state = "wgloves"
	force = 5
	punch_force = 3
	siemens_coefficient = 0.75
	permeability_coefficient = 0.05
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/gloves/vox
	desc = "These bizarre gauntlets seem to be fitted for... bird claws?"
	name = "insulated gauntlets"
	icon_state = "gloves-vox"
	item_state = "gloves-vox"
	flags = PHORONGUARD
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	species_restricted = list("Vox")

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/knuckledusters
	name = "knuckle dusters"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	attack_verb = list("punched", "beaten", "struck")
	flags = THICKMATERIAL	// Stops rings from increasing hit strength
	siemens_coefficient = 1
	fingerprint_chance = 100
	overgloves = 1
	force = 5
	punch_force = 5
