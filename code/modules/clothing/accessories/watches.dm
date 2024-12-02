/obj/item/clothing/accessory/watch
	name = "wristwatch"
	desc = "A cheap plastic quartz-based wristwatch. Painfully archaic by modern standards, but there's something charming about it all the same."
	icon_state = "wristwatch_basic"
	siemens_coefficient = 1
	gender = "neuter"
	slot = ACCESSORY_SLOT_WRIST
	slot_flags = SLOT_GLOVES
	icon = 'icons/inventory/hands/item.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/hands/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/hands/mob_vox.dmi'
		)

/obj/item/clothing/accessory/watch/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		. += span_notice("The current station time is [stationtime2text()].")

/obj/item/clothing/accessory/watch/silver
	name = "silver wristwatch"
	desc = "A humble silver (or maybe chrome) plated wristwatch. It's quite archaic, but nonetheless classy in its own way."
	icon_state = "wristwatch_silver"

/obj/item/clothing/accessory/watch/gold
	name = "gold wristwatch"
	desc = "A very fancy gold-plated wristwatch. For when you want to casually show off just how wealthy you are. It even tells the time!"
	icon_state = "wristwatch_gold"

/obj/item/clothing/accessory/watch/survival
	name = "survival watch"
	desc = "An overengineered wristwatch that purports to be both space and water proof, and includes a compass, micro GPS beacon, and temperature and pressure sensors. The beacon is off by default, and can only transmit its location: it cannot scan for other signals."
	description_fluff = "Hold ALT whilst left-clicking on the survival watch to toggle the status of its micro-beacon."
	icon_state = "wristwatch_survival"

	var/obj/item/gps/gps = null

/obj/item/clothing/accessory/watch/survival/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		. += span_notice("You are currently facing [dir2text(user.dir)]. The micro beacon is [gps.tracking ? "on" : "off"].")
		var/TB = user.loc
		if(istype(TB, /turf/))	//no point returning light level if we're not on a turf (might be *in* someone!)
			var/turf/TL = TB
			var/light_level = TL.get_lumcount()
			if(light_level)
				. += span_notice("Light Level: [TL.get_lumcount()]")
			else
				. += span_notice("It's too dark to see the light level!")
		if(istype(TB, /turf/simulated))	//no point returning atmospheric data from unsimulated tiles (they don't track pressure anyway, only temperature)
			var/turf/simulated/T = TB
			var/datum/gas_mixture/env = T.return_air()
			. += span_notice("Pressure: [env.return_pressure()]kPa / Temperature: [env.temperature]K ")

/obj/item/clothing/accessory/watch/survival/New()
	gps = new/obj/item/gps/watch(src)

/obj/item/gps/watch
	gps_tag = "SRV-WTCH"

/obj/item/clothing/accessory/watch/survival/AltClick(mob/user)
	. = ..()

	if(Adjacent(user))
		gps.tracking = !gps.tracking
		to_chat(user,span_notice("You turn the micro beacon [gps.tracking ? "on" : "off"]."))
