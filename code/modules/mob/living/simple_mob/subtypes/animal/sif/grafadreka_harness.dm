// It's just a backpack.
/obj/item/storage/internal/animal_harness
	color = COLOR_BEASTY_BROWN
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE
	var/obj/item/gps/attached_gps
	var/obj/item/clothing/accessory/attached_plate
	var/obj/item/radio/attached_radio

/obj/item/storage/internal/animal_harness/Initialize()

	// Spawn some useful items. We can't use them, but anyone we find can.
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	var/ration_type = pick(list(
		/obj/item/storage/mre,
		/obj/item/storage/mre/menu2,
		/obj/item/storage/mre/menu3,
		/obj/item/storage/mre/menu4,
		/obj/item/storage/mre/menu5,
		/obj/item/storage/mre/menu6,
		/obj/item/storage/mre/menu7,
		/obj/item/storage/mre/menu8,
		/obj/item/storage/mre/menu9,
		/obj/item/storage/mre/menu10
	))
	new ration_type(src)

	. = ..() // Name is set lower in Initialize() so we set it again here.
	name = "animal harness"

/obj/item/storage/internal/animal_harness/Destroy()
	var/mob/living/simple_mob/animal/sif/grafadreka/trained/drake = loc
	if(istype(drake) && drake.harness == src)
		drake.harness = null
		drake.armor = drake.original_armor
	QDEL_NULL(attached_radio)
	QDEL_NULL(attached_gps)
	QDEL_NULL(attached_plate)
	return ..()


/obj/item/storage/internal/animal_harness/attackby(obj/item/W, mob/user, silent)
	if (user == loc) // Drakes can't attach stuff to themselves, only shove it in their storage.
		return ..()
	if (!istype(loc, /mob/living/simple_mob/animal/sif/grafadreka/trained)) // Only allow attaching behaviors when worn by an appropriate subject.
		return ..()
	if (istype(W, /obj/item/gps)) // Attach a tracker.
		if (attached_gps)
			if (!silent)
				to_chat(user, SPAN_WARNING("There is already \a [attached_gps] attached to \the [loc]'s harness."))
		else if (user.unEquip(W))
			W.forceMove(loc)
			if (!silent)
				user.visible_message(SPAN_NOTICE("\The [user] attaches \the [W] to \the [loc]'s harness."))
			attached_gps = W
		return TRUE
	if (istype(W, /obj/item/radio)) // Attach a radio.
		if (attached_radio)
			if (!silent)
				to_chat(user, SPAN_WARNING("There is already \a [attached_radio] attached to \the [loc]'s harness."))
		else if (user.unEquip(W))
			W.forceMove(loc)
			if (!silent)
				user.visible_message(SPAN_NOTICE("\The [user] attaches \the [W] to \the [loc]'s harness."))
			attached_radio = W
		return TRUE
	if (istype(W, /obj/item/clothing/accessory/armor) || istype(W, /obj/item/clothing/accessory/material/makeshift)) // Attach an armor plate.
		if (attached_plate)
			if (!silent)
				to_chat(user, SPAN_WARNING("There is already \a [attached_plate] inside \the [loc]'s harness."))
		else if (user.unEquip(W))
			W.forceMove(loc)
			if (!silent)
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [W] inside \the [loc]'s harness."))
			attached_plate = W
			var/mob/living/simple_mob/animal/sif/grafadreka/trained/drake = loc
			drake.recalculate_armor()
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/recalculate_armor()
	armor = list()
	if(istype(harness) && harness.attached_plate)
		for(var/armor_key in harness.attached_plate.armor)
			armor[armor_key] = max(original_armor[armor_key], harness.attached_plate.armor[armor_key])

/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate()
	set name = "Remove Attached Plate"
	set category = "IC"
	set src in view(1)
	if(istype(harness) && harness.attached_plate)
		harness.attached_plate.dropInto(get_turf(src))
		if(usr == src)
			var/datum/gender/G = gender_datums[get_visible_gender()]
			visible_message("\The [src] awkwardly pulls \the [harness.attached_plate] out of [G.his] harness and drops it.")
		else
			visible_message("\The [usr] removes \the [harness.attached_plate] from \the [src]'s harness.")
			usr.put_in_hands(harness.attached_plate)
		harness.attached_plate = null
		armor = original_armor
	verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate

/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps()
	set name = "Remove Attached GPS"
	set category = "IC"
	set src in view(1)
	if(istype(harness) && harness.attached_gps)
		harness.attached_gps.dropInto(get_turf(src))
		if(usr == src)
			var/datum/gender/G = gender_datums[get_visible_gender()]
			visible_message("\The [src] awkwardly pulls \the [harness.attached_gps] off [G.his] harness and drops it.")
		else
			visible_message("\The [usr] detaches \the [harness.attached_gps] from \the [src]'s harness.")
			usr.put_in_hands(harness.attached_gps)
		harness.attached_gps = null
	verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps

/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio()
	set name = "Remove Attached Radio"
	set category = "IC"
	set src in view(1)
	if(istype(harness) && harness.attached_radio)
		harness.attached_radio.dropInto(get_turf(src))
		if(usr == src)
			var/datum/gender/G = gender_datums[get_visible_gender()]
			visible_message("\The [src] awkwardly pulls \the [harness.attached_radio] off [G.his] harness and drops it.")
		else
			visible_message("\The [usr] detaches \the [harness.attached_radio] from \the [src]'s harness.")
			usr.put_in_hands(harness.attached_radio)
		harness.attached_radio = null
	verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
