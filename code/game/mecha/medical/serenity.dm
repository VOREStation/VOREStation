
/obj/mecha/medical/serenity
	desc = "A lightweight exosuit made from a modified Gygax chassis combined with proprietary VeyMed medical tech. It's faster and sturdier than most medical mechs, but much of the armor plating has been stripped out, leaving it more vulnerable than a regular Gygax."
	name = "Serenity"
	icon_state = "medgax"
	initial_icon = "medgax"
	health = 150
	maxhealth = 150
	deflect_chance = 20
	step_in = 2
	max_temperature = 20000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity
	max_equip = 3
	step_energy_drain = 8
	cargo_capacity = 2
	max_hull_equip = 2
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	overload_possible = 1

	force = 20	// 10 less than normal combat exos.
	melee_can_hit = TRUE
	melee_sound = 'sound/weapons/heavysmash.ogg'

	catalogue_data = list(
		/datum/category_item/catalogue/information/organization/vey_med
		)
