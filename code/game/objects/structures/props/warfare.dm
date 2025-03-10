/obj/structure/prop/war
	name = "military hardware"
	desc = "What is it good for?"
	icon = 'icons/obj/props/decor.dmi'

// warheads from TGMC
/obj/structure/prop/war/warhead1
	name = "nuclear warhead"
	icon_state = "ob_warhead_1"

/obj/structure/prop/war/warhead2
	name = "incindiary warhead"
	icon_state = "ob_warhead_2"

/obj/structure/prop/war/warhead3
	name = "bluespace warhead"
	icon_state = "ob_warhead_3"

/obj/structure/prop/war/warhead4
	name = "phoron warhead"
	icon_state = "ob_warhead_4"

// minirocket pod from TGMC
/obj/structure/prop/war/minirocket_pod
	name = "rocket pod"
	icon_state = "minirocket_pod"

// sentry console from TGMC
/obj/structure/prop/war/sentry_control
	name = "portable sentry gun"
	desc = "Needs a dispenser."
	icon_state = "tgmc_sentry"

// various weapons from TGMC
/obj/structure/prop/war/tgmc_missile
	name = "missile"
	desc = "It seems to be some sort of spacecraft-tier ordinance."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "single"
	bound_width = 64

/obj/structure/prop/war/tgmc_missile/double
	icon_state = "widowmaker"

/obj/structure/prop/war/tgmc_missile/banshee
	icon_state = "banshee"

/obj/structure/prop/war/tgmc_missile/keeper
	icon_state = "keeper"

/obj/structure/prop/war/tgmc_missile/fatty
	icon_state = "fatty"

/obj/structure/prop/war/tgmc_missile/napalm
	icon_state = "napalm"

/**
 * Possible 'state' options for change_state(state) are:
 * empty, single, banshee, keeper, fatty, napalm
 */
// ship weapons from TGMC
/obj/structure/prop/war/tgmc_missile_rack
	name = "missile launcher"
	desc = "Some sort of spacecraft-tier missile weapon."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "rocket_pod"
	bound_height = 64

/obj/structure/prop/war/tgmc_missile_rack/change_state(state)
	. = ..()
	switch(state)
		if("empty")
			icon_state = "rocket_pod"
		if("single")
			icon_state = "rocket_pod_loaded"
		if("banshee")
			icon_state = "rocket_pod_loadedb"
		if("keeper")
			icon_state = "rocket_pod_loadedk"
		if("fatty")
			icon_state = "rocket_pod_loadedf"
		if("napalm")
			icon_state = "rocket_pod_loadedn"

/obj/structure/prop/war/tgmc_missile_rack/single
	icon_state = "rocket_pod_loaded"
/obj/structure/prop/war/tgmc_missile_rack/banshee
	icon_state = "rocket_pod_loadedb"
/obj/structure/prop/war/tgmc_missile_rack/keeper
	icon_state = "rocket_pod_loadedk"
/obj/structure/prop/war/tgmc_missile_rack/fatty
	icon_state = "rocket_pod_loadedf"
/obj/structure/prop/war/tgmc_missile_rack/napalm
	icon_state = "rocket_pod_loadedn"

/**
 * Possible 'state' options for change_state(state) are:
 * empty, loaded
 */
// ship weapons from TGMC
/obj/structure/prop/war/tgmc_minirockets
	name = "rocket pod"
	desc = "Some sort of spacecraft-tier rocket weapon."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "minirocket_pod"
	bound_height = 64

/obj/structure/prop/war/tgmc_minirockets/change_state(state)
	. = ..()
	switch(state)
		if("empty")
			icon_state = "minirocket_pod"
		if("loaded")
			icon_state = "minirocket_pod_loaded"

/obj/structure/prop/war/tgmc_minirockets/loaded
	icon_state = "minirocket_pod_loaded"

/**
 * Possible 'state' options for change_state(state) are:
 * empty, loaded
 */
// ship weapons from TGMC
/obj/structure/prop/war/tgmc_laser
	name = "laser cannon"
	desc = "Some sort of spacecraft-tier energy weapon."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "laser_beam"
	bound_height = 64

/obj/structure/prop/war/tgmc_laser/change_state(state)
	. = ..()
	switch(state)
		if("empty")
			icon_state = "laser_beam"
		if("loaded")
			icon_state = "laser_beam_loaded"

/obj/structure/prop/war/tgmc_laser/loaded
	icon_state = "laser_beam_loaded"

/**
 * Possible 'state' options for change_state(state) are:
 * empty, loaded, loadedempty
 */
// ship weapons from TGMC
/obj/structure/prop/war/tgmc_30mm
	name = "30mm cannon"
	desc = "Some sort of spacecraft-tier rotary cannon weapon."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "30mm_cannon"
	bound_height = 64

/obj/structure/prop/war/tgmc_30mm/change_state(state)
	. = ..()
	switch(state)
		if("empty")
			icon_state = "30mm_cannon"
		if("loaded")
			icon_state = "30mm_cannon_loaded1"
		if("loadedempty")
			icon_state = "30mm_cannon_loaded0"

/obj/structure/prop/war/tgmc_30mm/loaded
	icon_state = "30mm_cannon_loaded1"
/obj/structure/prop/war/tgmc_30mm/loadedempty
	icon_state = "30mm_cannon_loaded0"
