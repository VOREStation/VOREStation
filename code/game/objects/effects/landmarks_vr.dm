/obj/effect/landmark
	var/abductor = 0

/obj/effect/landmark/vines
	name = "vinestart"

/obj/effect/landmark/vermin
	name = "verminstart"

/obj/effect/landmark/wildlife
	name = "wildlife"
	var/wildlife_type = 2		//1 for water, 2 for land; thats all for now

/obj/effect/landmark/late_antag
	name = "Antag Latespawn"
	var/antag_id

/obj/effect/landmark/late_antag/Initialize(mapload)
	. = ..()
	var/datum/antagonist/A = all_antag_types[antag_id]
	if(istype(A))
		A.starting_locations |= get_turf(src)
		var/list/allpoints = all_antag_spawnpoints[A.landmark_id]
		allpoints |= get_turf(src)

/obj/effect/landmark/late_antag/ert
	name = "Response Team - Lateload"
	antag_id = MODE_ERT

/obj/effect/landmark/late_antag/trader
	name = "Trader - Lateload"
	antag_id = MODE_TRADE

/obj/effect/landmark/late_antag/wizard
	name = "Wizard - Lateload"
	antag_id = MODE_WIZARD

/obj/effect/landmark/late_antag/technomancer
	name = "Technomancer - Lateload"
	antag_id = MODE_TECHNOMANCER

/obj/effect/landmark/late_antag/mercenary
	name = "Mercenary - Lateload"
	antag_id = MODE_MERCENARY

/obj/effect/landmark/late_antag/ninja
	name = "Ninja - Lateload"
	antag_id = MODE_NINJA

/obj/effect/landmark/late_antag/raider
	name = "Raider - Lateload"
	antag_id = MODE_RAIDER
