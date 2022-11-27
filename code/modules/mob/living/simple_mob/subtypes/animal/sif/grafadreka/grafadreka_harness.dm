/obj/item/storage/internal/animal_harness/grafadreka
	abstract_type = /obj/item/storage/internal/animal_harness/grafadreka
	name = "grafadreka harness"
	self_attach_delay = 3 SECONDS

	// keys for animal_harness/attachable_type
	var/const/ATTACHED_GPS = "gps"
	var/const/ATTACHED_RADIO = "radio"
	var/const/ATTACHED_ARMOR = "armor plate"
	var/const/ATTACHED_LIGHT = "light"

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
		/obj/item/flashlight = ATTACHED_LIGHT
	)

	/// The drake that owns this harness.
	var/mob/living/simple_mob/animal/sif/grafadreka/trained/owner


/obj/item/storage/internal/animal_harness/grafadreka/Destroy()
	attachable_types = null
	owner = null
	return ..()


/obj/item/storage/internal/animal_harness/grafadreka/Initialize(mapload)
	attachable_types = grafadreka_attachable_types
	. = ..()
	owner = loc
	if (!istype(owner))
		log_debug("Drake harness created without a drake!")
		return INITIALIZE_HINT_QDEL


/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor()
	if (!owner)
		return
	var/obj/item/clothing/accessory/armor = attached_items[ATTACHED_ARMOR]
	if (!armor)
		owner.armor = owner.original_armor
		return
	for (var/key in armor.armor)
		armor[key] = max(owner.original_armor[key], armor.armor[key])


// Basic trained drake harness contents on spawn
/obj/item/storage/internal/animal_harness/grafadreka/trained/CreateAttachments()
	attached_items[ATTACHED_RADIO] = new /obj/item/radio (owner)
	new /obj/item/stack/medical/bruise_pack (src)
	new /obj/item/stack/medical/ointment (src)
	var/obj/item/storage/mre/mre_type = pick(typesof(/obj/item/storage/mre) - list(
		/obj/item/storage/mre/menu11,
		/obj/item/storage/mre/menu12,
		/obj/item/storage/mre/menu13
	))
	new mre_type (src)


// Station/Science drake harness contents on spawn
/obj/item/storage/internal/animal_harness/grafadreka/expedition/CreateAttachments()
	attached_items[ATTACHED_RADIO] = new /obj/item/radio (owner)
	new /obj/item/stack/medical/bruise_pack (src)
	new /obj/item/stack/medical/ointment (src)
	new /obj/item/storage/mre/menu13 (src) // The good stuff
	var/obj/item/gps/explorer/on/gps = new (owner)
	gps.SetTag(owner.name)
	attached_items[ATTACHED_GPS] = gps
	attached_items[ATTACHED_LIGHT] = new /obj/item/flashlight/glowstick/grafadreka (owner)



/obj/item/flashlight/glowstick/grafadreka
	name = "high duration glowstick"
	action_button_name = null


/obj/item/flashlight/glowstick/grafadreka/Initialize()
	. = ..()
	var/obj/item/flashlight/glowstick/archetype = pick(typesof(/obj/item/flashlight/glowstick) - type)
	flashlight_colour = initial(archetype.flashlight_colour)
	icon_state = initial(archetype.icon_state)
	item_state = initial(archetype.item_state)
	fuel = rand(3200, 4800)
	on = TRUE
	update_icon()
	START_PROCESSING(SSobj, src)
