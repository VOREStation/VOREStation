///////////////////////////////////////////////////////////
/////Misc stuff from the tether that's likely to get used in one way or another!/////`

/obj/effect/landmark/arrivals
	name = "JoinLateShuttle"
	delete_me = 1

/obj/effect/landmark/arrivals/New()
	latejoin += loc 
	..()

var/global/list/latejoin_tram   = list()

/obj/effect/landmark/tram
	name = "JoinLateTram"
	delete_me = 1

/obj/effect/landmark/tram/New()
	latejoin_tram += loc // There's no tram but you know whatever man!
	..()

/datum/spawnpoint/tram
	display_name = "Tram Station"
	msg = "will arrive to the station shortly by shuttle"

/datum/spawnpoint/tram/New()
	..()
	turfs = latejoin_tram

/obj/machinery/camera/network/halls
	network = list(NETWORK_HALLS)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLORATION)

/obj/machinery/camera/network/research/xenobio
	network = list(NETWORK_RESEARCH, NETWORK_XENOBIO)

/obj/machinery/computer/security/xenobio
	name = "xenobiology camera monitor"
	desc = "Used to access the xenobiology cell cameras."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list(NETWORK_XENOBIO)
	circuit = /obj/item/weapon/circuitboard/security/xenobio
	light_color = "#F9BBFC"

/obj/item/weapon/circuitboard/security/xenobio
	name = T_BOARD("xenobiology camera monitor")
	build_path = /obj/machinery/computer/security/xenobio
	network = list(NETWORK_XENOBIO)
	req_access = list()

/obj/machinery/vending/wallmed1/public
	products = list(/obj/item/stack/medical/bruise_pack = 8,/obj/item/stack/medical/ointment = 8,/obj/item/weapon/reagent_containers/hypospray/autoinjector = 16,/obj/item/device/healthanalyzer = 4)

/turf/unsimulated/mineral/virgo3b
	blocks_air = TRUE

/area/tether/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/turf/simulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

	var/area/shock_area = /area/tether/surfacebase/tram

/turf/simulated/floor/maglev/Initialize()
	. = ..()
	shock_area = locate(shock_area)

// Walking on maglev tracks will shock you! Horray!
/turf/simulated/floor/maglev/Entered(var/atom/movable/AM, var/atom/old_loc)
	if(isliving(AM) && !(AM.is_incorporeal()) && prob(50))
		track_zap(AM)
/turf/simulated/floor/maglev/attack_hand(var/mob/user)
	if(prob(75))
		track_zap(user)
/turf/simulated/floor/maglev/proc/track_zap(var/mob/living/user)
	if (!istype(user)) return
	if (electrocute_mob(user, shock_area, src))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"

// Some turfs to make floors look better in centcom tram station.

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

/turf/unsimulated/wall/transit
	icon = 'icons/turf/transit_vr.dmi'

/turf/unsimulated/floor/transit
	icon = 'icons/turf/transit_vr.dmi'

/obj/effect/floor_decal/transit/orange
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "transit_techfloororange_edges"

/obj/effect/transit/light
	icon = 'icons/turf/transit_128.dmi'
	icon_state = "tube1-2"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/virgo3b
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
