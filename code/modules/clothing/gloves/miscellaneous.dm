/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "site manager's gloves"
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
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
//	var/balloonPath = /obj/item/latexballon

//TODO: Make inflating gloves a thing
/*/obj/item/clothing/gloves/sterile/proc/Inflate(/mob/living/carbon/human/user)
	user.visible_message("<b>\The [src]</b> expands!")
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
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

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
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/knuckledusters
	name = "knuckle dusters"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	matter = list(MAT_STEEL = 500)
	attack_verb = list("punched", "beaten", "struck")
	flags = THICKMATERIAL	// Stops rings from increasing hit strength
	siemens_coefficient = 1
	fingerprint_chance = 100
	overgloves = 1
	force = 5
	punch_force = 5
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/clothing/gloves/ranger
	var/glovecolor = "white"
	name = "ranger gloves"
	desc = "The gloves of the Rangers are the least memorable part. They're not even insulated in the show, so children \
	don't try and take apart a toaster with inadequate protection. They only serve to complete the fancy outfit."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_gloves"

/obj/item/clothing/gloves/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_gloves")
		name = "[glovecolor] ranger gloves"
		icon_state = "[glovecolor]_ranger_gloves"

/obj/item/clothing/gloves/ranger/black
	glovecolor = "black"

/obj/item/clothing/gloves/ranger/pink
	glovecolor = "pink"

/obj/item/clothing/gloves/ranger/green
	glovecolor = "green"

/obj/item/clothing/gloves/ranger/cyan
	glovecolor = "cyan"

/obj/item/clothing/gloves/ranger/orange
	glovecolor = "orange"

/obj/item/clothing/gloves/ranger/yellow
	glovecolor = "yellow"

/obj/item/clothing/gloves/waterwings
	name = "water wings"
	desc = "Swim aids designed to help a wearer float in water and learn to swim."
	icon_state = "waterwings"

/obj/item/clothing/gloves/watch
	name = "wristwatch"
	desc = "A cheap plastic quartz-based wristwatch. Painfully archaic by modern standards, but there's something charming about it all the same."
	icon_state = "wristwatch_basic"
	siemens_coefficient = 1
	gender = "neuter"

/obj/item/clothing/gloves/watch/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		. += "<span class='notice'>The current station time is [stationtime2text()].</span>"

/obj/item/clothing/gloves/watch/silver
	name = "silver wristwatch"
	desc = "A humble silver (or maybe chrome) plated wristwatch. It's quite archaic, but nonetheless classy in its own way."
	icon_state = "wristwatch_silver"

/obj/item/clothing/gloves/watch/gold
	name = "gold wristwatch"
	desc = "A very fancy gold-plated wristwatch. For when you want to casually show off just how wealthy you are. It even tells the time!"
	icon_state = "wristwatch_gold"

/obj/item/clothing/gloves/watch/survival
	name = "survival watch"
	desc = "An overengineered wristwatch that purports to be both space and water proof, and includes a compass, micro GPS beacon, and temperature and pressure sensors. The beacon is off by default, and can only transmit its location: it cannot scan for other signals."
	description_fluff = "Hold ALT whilst left-clicking on the survival watch to toggle the status of its micro-beacon."
	icon_state = "wristwatch_survival"

	var/obj/item/gps/gps = null

/obj/item/clothing/gloves/watch/survival/examine(mob/user)
	. = ..()

	if(Adjacent(user) && src.loc == user)
		. += "<span class='notice'>You are currently facing [dir2text(user.dir)]. The micro beacon is [gps.tracking ? "on" : "off"].</span>"
		var/TB = src.loc.loc
		if(istype(TB, /turf/))	//no point returning light level if we're not on a turf (might be *in* someone!)
			var/turf/TL = TB
			var/light_level = TL.get_lumcount()
			if(light_level)
				. += "<span class='notice'>Light Level: [TL.get_lumcount()]</span>"
			else
				. += "<span class='notice'>It's too dark to see the light level!</span>"
		if(istype(TB, /turf/simulated))	//no point returning atmospheric data from unsimulated tiles (they don't track pressure anyway, only temperature)
			var/turf/simulated/T = TB
			var/datum/gas_mixture/env = T.return_air()
			. += "<span class='notice'>Pressure: [env.return_pressure()]kPa / Temperature: [env.temperature]K </span>"

/obj/item/clothing/gloves/watch/survival/New()
	gps = new/obj/item/gps/watch(src)

/obj/item/gps/watch
	gps_tag = "SRV-WTCH"

/obj/item/clothing/gloves/watch/survival/AltClick(mob/user)
	. = ..()

	if(Adjacent(user))
		gps.tracking = !gps.tracking
		to_chat(user,"<span class='notice'>You turn the micro beacon [gps.tracking ? "on" : "off"].</span>")
