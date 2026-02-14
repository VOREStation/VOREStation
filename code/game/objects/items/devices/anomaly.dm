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
	// If it will apply stats to it
	var/gives_stats = TRUE

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
	gives_stats = FALSE // Evil and fucked up...
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

	var/datum/weakref/buffered_anomaly = null

/obj/item/anomaly_scanner/attack_self(mob/living/user)
	if(loc == user)
		tgui_interact(user)
	else
		..()

/obj/item/anomaly_scanner/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnomalyScanner", name)
		ui.open()

/obj/item/anomaly_scanner/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	var/obj/effect/anomaly/anom = buffered_anomaly.resolve()

	if(!istype(anom))
		return data

	var/datum/anomaly_stats/stats = anom.stats

	data["anomaly_name"] = anom.name
	data["severity"] = stats.severity
	data["stability"] = stats.stability
	data["point_output"] = stats.points
	data["danger_type"] = stats.danger_type
	data["unstable_type"] = stats.unstable_type
	data["containment_type"] = stats.containment_type
	data["transformation_type"] = stats.transformation_type
	if(stats.modifier)
		data["modifier"] = stats.modifier.get_description()
	data["countdown"] = stats.get_activation_countdown()

	return data
