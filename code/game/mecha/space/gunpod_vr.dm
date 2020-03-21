/obj/mecha/working/hoverpod/gunpod
	name = "Gunpod"
	desc = "A more advanced (and angrier) variant of the hoverpod."
	catalogue_data = list(/datum/category_item/catalogue/technology/gunpod)
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "gunpod"
	initial_icon = "gunpod"
	internal_damage_threshold = 90
	step_in = 2
	step_energy_drain = 5
	max_temperature = 20000
	health = 400
	maxhealth = 400
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/gunpod
	cargo_capacity = 3
	max_equip = 3

	opacity = FALSE

	stomp_sound = 'sound/machines/generator/generator_end.ogg'
	swivel_sound = 'sound/machines/hiss.ogg'

	// Paint colors! Null if not set.
	var/stripe1_color
	var/stripe2_color
	var/image/stripe1_overlay
	var/image/stripe2_overlay

	bound_height = 64
	bound_width = 64

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/working/hoverpod/gunpod/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)

	update_icon() //In case we were mapped in with paint

/obj/mecha/working/hoverpod/gunpod/heavy/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/combat_shield
	ME.attach(src)

/obj/mecha/working/hoverpod/gunpod/agile/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/teleporter
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/repair_droid
	ME.attach(src)

/obj/mecha/working/hoverpod/gunpod/handle_equipment_movement()
	. = ..()
	if(has_gravity())
		start_hover()
	else
		stop_hover()

/obj/mecha/working/hoverpod/gunpod/proc/start_hover()
	if(!ion_trail.on)
		ion_trail.start()

/obj/mecha/working/hoverpod/gunpod/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()

/obj/mecha/working/hoverpod/gunpod/check_for_support()
	if (has_charge(step_energy_drain) && stabilization_enabled)
		return 1

	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille in things) || locate(/obj/structure/lattice in things) || locate(/turf/simulated in things) || locate(/turf/unsimulated in things))
		return 1
	else
		return 0

/obj/mecha/working/hoverpod/gunpod/update_icon()
	cut_overlays()
	..()

	if(stripe1_color)
		stripe1_overlay = image("gunpod_stripes1")
		stripe1_overlay.color = stripe1_color
		add_overlay(stripe1_overlay)
	if(stripe2_overlay)
		stripe2_overlay = image("gunpod_stripes2")
		stripe2_overlay.color = stripe2_color
		add_overlay(stripe2_overlay)

/obj/mecha/working/hoverpod/gunpod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Fore Stripe", "Aft Stripe", "CANCEL")
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input("Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Fore Stripe")
						stripe1_color = new_paint_color
					if("Aft Stripe")
						stripe2_color = new_paint_color

		update_icon()
	else ..()

/obj/effect/decal/mecha_wreckage/gunpod
	name = "Gunpod wreckage"
	desc = "Remains of some unfortunate gunpod. Completely unrepairable."
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "gunpod-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/gunpod
	name = "Voidcraft - Gunpod"
	desc = "This is a small space-capable fightercraft that has an arrowhead design. Can hold up to one pilot, \
	and sometimes one or two passengers, with the right modifications made. \
	Typically used as small fighter craft, the gunpod can't carry much of a payload, though it's still capable of holding it's own."
	value = CATALOGUER_REWARD_MEDIUM