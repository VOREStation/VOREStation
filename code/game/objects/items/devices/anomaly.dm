/obj/item/anomaly_neutralizer
	name = "anomaly neutralizer"
	desc = "A one-use device capable of instantly neutralizing anomalous or otherworldly entities."
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "neutralyzer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	item_flags = NOBLUDGEON

/obj/item/anomaly_neutralizer/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/effect_remover, \
		success_feedback = "You neutralize %THEEFFECT with %THEWEAPON, frying its circuitry in the process.", \
		on_clear_callback = CALLBACK(src, PROC_REF(on_anomaly_neutralized)), \
		effects_we_clear = list(/obj/effect/anomaly))

/obj/item/anomaly_neutralizer/proc/on_anomaly_neutralized(obj/effect/anomaly/target, mob/living/user)
	target.anomalyNeutralize()
	on_use(target, user)

/obj/item/anomaly_neutralizer/proc/on_use(obj/effect/target, mob/living/user)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
	sparks.set_up(3, 1, src)
	sparks.start()
	qdel(src)

/obj/item/anomaly_releaser
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "anomaly_releaser"
	name = "advanced anomaly releaser"
	desc = "Single-use injector that releases and stabilizes anomalies by injecting an unknown substance."
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 5

	///icon state after being used up
	var/used_icon_state = "anomaly_releaser_used"
	///are we used? if used we can't be used again
	var/used = FALSE
	///Can we be used infinitely?
	var/infinite = FALSE
	//If the created anomaly leaves a core behind
	var/has_core = TRUE
	//If this will anchor the anomaly in place
	var/will_anchor = TRUE

/obj/item/anomaly_releaser/science
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "sci_releaser"
	name = "scientific anomaly releaser"
	used_icon_state = "sci_releaser_used"
	has_core = FALSE

// The one for antags and evil-doers
/obj/item/anomaly_releaser/antag
	has_core = TRUE
	will_anchor = TRUE
	desc = "Single-use injector that releases and stabilizes anomalies by injecting an unknown substance. This one seems odd."

/obj/item/anomaly_scanner
	name = "anomaly scanner"
	desc = "A hand-held anomaly scanner, able to distinguish the particles that might affect a stable anomaly."
	icon = 'icons/obj/device.dmi'
	icon_state = "anom_scanner"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 200)

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
