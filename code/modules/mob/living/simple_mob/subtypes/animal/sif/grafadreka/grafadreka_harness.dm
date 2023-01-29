/obj/item/storage/internal/animal_harness/grafadreka
	abstract_type = /obj/item/storage/internal/animal_harness/grafadreka
	name = "grafadreka harness"
	self_attach_delay = 3 SECONDS

	// keys for animal_harness/attachable_type
	var/const/ATTACHED_GPS = "gps"
	var/const/ATTACHED_RADIO = "radio"
	var/const/ATTACHED_ARMOR = "armor plate"
	var/const/ATTACHED_LIGHT = "light"
	var/const/ATTACHED_ID = "access card"

	/// An attachable_types list shared between drake harness instances.
	var/static/list/grafadreka_attachable_types = list(
		/obj/item/gps = ATTACHED_GPS,
		/obj/item/radio = ATTACHED_RADIO,
		/obj/item/clothing/accessory/armor = list(
			ATTACHED_ARMOR,
			/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor
		),
		/obj/item/clothing/accessory/material/makeshift = list(
			ATTACHED_ARMOR,
			/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor
		),
		/obj/item/card/id = ATTACHED_ID,
		/obj/item/flashlight = ATTACHED_LIGHT
	)

/obj/item/storage/internal/animal_harness/grafadreka/GetIdCard()
	return attached_items[ATTACHED_ID]


/obj/item/storage/internal/animal_harness/grafadreka/Destroy()
	attachable_types = null
	return ..()


/obj/item/storage/internal/animal_harness/grafadreka/Initialize(mapload)
	attachable_types = grafadreka_attachable_types
	. = ..()


/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor()
	var/mob/living/simple_mob/animal/sif/grafadreka/drake = loc
	if (!istype(drake))
		return
	var/obj/item/clothing/accessory/armor = attached_items[ATTACHED_ARMOR]
	if (!armor)
		drake.armor = drake.original_armor
		return
	for (var/key in armor.armor)
		armor[key] = max(drake.original_armor[key], armor.armor[key])


// Basic trained drake harness contents on spawn
/obj/item/storage/internal/animal_harness/grafadreka/trained/CreateAttachments()
	var/mob/living/owner = loc
	if (!istype(owner))
		return
	attached_items[ATTACHED_RADIO] = new /obj/item/radio(owner)
	new /obj/item/stack/medical/bruise_pack (src)
	new /obj/item/stack/medical/ointment (src)
	var/obj/item/storage/mre/mre_type = pick(typesof(/obj/item/storage/mre) - list(
		/obj/item/storage/mre/menu11,
		/obj/item/storage/mre/menu12,
		/obj/item/storage/mre/menu13
	))
	new mre_type (src)
