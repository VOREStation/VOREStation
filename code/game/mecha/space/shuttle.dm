/obj/mecha/working/hoverpod/shuttlecraft
	desc = "A more advanced variant of the hoverpod."
	name = "Shuttle"
	catalogue_data = list(/datum/category_item/catalogue/technology/hoverpod)
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "shuttle_standard"
	initial_icon = "shuttle_standard"
	internal_damage_threshold = 60
	step_in = 2
	step_energy_drain = 5
	max_temperature = 20000
	health = 300
	maxhealth = 300
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/shuttlecraft
	cargo_capacity = 3
	max_equip = 3

	opacity = FALSE

	stomp_sound = 'sound/machines/generator/generator_end.ogg'
	swivel_sound = 'sound/machines/hiss.ogg'

	// Paint colors! Null if not set.
	var/base_paint
	var/engine_paint
	var/central_paint
	var/front_paint

	var/image/base_paint_mask
	var/image/engine_paint_mask
	var/image/central_paint_mask
	var/image/front_paint_mask

	bound_height = 64
	bound_width = 64

	max_hull_equip = 2
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/working/hoverpod/shuttlecraft/update_icon()
	cut_overlays()
	..()

	if(base_paint)
		if(!base_paint_mask)
			base_paint_mask = image(icon, "[initial_icon]-mask+base", src.layer + 1)
		base_paint_mask.color = base_paint
		add_overlay(base_paint_mask)
	if(front_paint)
		if(!front_paint_mask)
			front_paint_mask = image(icon, "[initial_icon]-mask+front", src.layer + 1)
		front_paint_mask.color = front_paint
		add_overlay(front_paint_mask)
	if(engine_paint)
		if(!engine_paint_mask)
			engine_paint_mask = image(icon, "[initial_icon]-mask+engine", src.layer + 1)
		engine_paint_mask.color = engine_paint
		add_overlay(engine_paint_mask)
	if(central_paint)
		if(!engine_paint_mask)
			central_paint_mask = image(icon, "[initial_icon]-mask+central", src.layer + 2)
		central_paint_mask.color = central_paint
		add_overlay(central_paint_mask)

<<<<<<< HEAD
/obj/mecha/working/hoverpod/shuttlecraft/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool) && state == 1)
		var/new_paint_location = tgui_input_list(usr, "Please select a target zone.", "Paint Zone", list("Central", "Engine", "Base", "Front", "CANCEL"))
=======
/obj/mecha/working/hoverpod/shuttlecraft/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Central", "Engine", "Base", "Front", "CANCEL")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input(usr, "Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Central")
						central_paint = new_paint_color
					if("Engine")
						engine_paint = new_paint_color
					if("Front")
						front_paint = new_paint_color
					if("Base")
						base_paint = new_paint_color
		update_icon()
	else ..()
