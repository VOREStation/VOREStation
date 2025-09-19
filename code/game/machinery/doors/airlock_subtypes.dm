/obj/machinery/door/airlock/command
	name = "Command Airlock"
	icon = 'icons/obj/doors/Doorcom.dmi'
	req_one_access = list(ACCESS_HEADS)
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/cmd3o.ogg'
	department_close_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 3

/obj/machinery/door/airlock/security
	name = "Security Airlock"
	icon = 'icons/obj/doors/Doorsec.dmi'
	req_one_access = list(ACCESS_SECURITY)
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sec1o.ogg'
	department_close_powered = 'sound/machines/door/sec1c.ogg'
	security_level = 2

/obj/machinery/door/airlock/engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/Dooreng.dmi'
	req_one_access = list(ACCESS_ENGINE)
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Doorengatmos.dmi'
	req_one_access = list(ACCESS_ATMOSPHERICS)
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/doormed.dmi'
	req_one_access = list(ACCESS_MEDICAL)
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/med1o.ogg'
	department_close_powered = 'sound/machines/door/med1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/Doormaint.dmi'
	//req_one_access = list(ACCESS_MAINT_TUNNELS) //Maintenance is open access
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/cargo
	icon = 'icons/obj/doors/Doormaint_cargo.dmi'
	req_one_access = list(ACCESS_CARGO)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/door2o.ogg'
	department_close_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/command
	icon = 'icons/obj/doors/Doormaint_command.dmi'
	req_one_access = list(ACCESS_HEADS)

/obj/machinery/door/airlock/maintenance/common
	icon = 'icons/obj/doors/Doormaint_common.dmi'
	open_sound_powered = 'sound/machines/door/hall3o.ogg'
	close_sound_powered = 'sound/machines/door/hall3c.ogg'

/obj/machinery/door/airlock/maintenance/engi
	icon = 'icons/obj/doors/Doormaint_engi.dmi'
	req_one_access = list(ACCESS_ENGINE)

/obj/machinery/door/airlock/maintenance/int
	icon = 'icons/obj/doors/Doormaint_int.dmi'

/obj/machinery/door/airlock/maintenance/medical
	icon = 'icons/obj/doors/Doormaint_med.dmi'
	req_one_access = list(ACCESS_MEDICAL)

/obj/machinery/door/airlock/maintenance/rnd
	icon = 'icons/obj/doors/Doormaint_rnd.dmi'
	req_one_access = list(ACCESS_RESEARCH)

/obj/machinery/door/airlock/maintenance/sec
	icon = 'icons/obj/doors/Doormaint_sec.dmi'
	req_one_access = list(ACCESS_SECURITY)

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorext.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/external/bolted
	icon_state = "door_locked" // So it looks visibly bolted in map editor
	locked = TRUE

// For convenience in making docking ports: one that is pre-bolted with frequency set!
/obj/machinery/door/airlock/external/bolted/cycling
	frequency = AIRLOCK_FREQ

/obj/machinery/door/airlock/glass_external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	opacity = 0
	glass = 1
	req_one_access = list(ACCESS_EXTERNAL_AIRLOCKS)
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	legacy_open_powered = 'sound/machines/door/windowdoor.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/centcom
	name = "Centcom Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	req_one_access = list(ACCESS_CENT_GENERAL)
	opacity = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 100

/obj/machinery/door/airlock/glass_centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Dooreleglass.dmi'
	opacity = 0
	glass = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 100

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(ACCESS_HEADS_VAULT)
	open_sound_powered = 'sound/machines/door/vault1o.ogg'
	close_sound_powered = 'sound/machines/door/vault1c.ogg'
	security_level = 5
	heat_proof = 1

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	req_one_access = list(ACCESS_MAINT_TUNNELS)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'
	heat_proof = 1

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch
	req_one_access = list(ACCESS_MAINT_TUNNELS)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'

/obj/machinery/door/airlock/glass_command
	name = "Command Airlock"
	icon = 'icons/obj/doors/Doorcomglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1
	req_one_access = list(ACCESS_HEADS)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/cmd1o.ogg'
	department_close_powered = 'sound/machines/door/cmd1c.ogg'
	security_level = 3

/obj/machinery/door/airlock/glass_engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/Doorengglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1
	req_one_access = list(ACCESS_ENGINE)
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/glass_engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Doorengatmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	glass = 1
	req_one_access = list(ACCESS_ATMOSPHERICS)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/glass_security
	name = "Security Airlock"
	icon = 'icons/obj/doors/Doorsecglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1
	req_one_access = list(ACCESS_SECURITY)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sec1o.ogg'
	department_close_powered = 'sound/machines/door/sec1c.ogg'
	security_level = 2

/obj/machinery/door/airlock/glass_medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/doormedglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1
	req_one_access = list(ACCESS_MEDICAL)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/med1o.ogg'
	department_close_powered = 'sound/machines/door/med1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doormining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	req_one_access = list(ACCESS_MINING)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/cgo1o.ogg'
	department_close_powered = 'sound/machines/door/cgo1c.ogg'

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	req_one_access = list(ACCESS_ATMOSPHERICS)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/research
	name = "Research Airlock"
	icon = 'icons/obj/doors/doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 2

/obj/machinery/door/airlock/glass_research
	name = "Research Airlock"
	icon = 'icons/obj/doors/doorresearchglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	req_one_access = list(ACCESS_RESEARCH)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 2

/obj/machinery/door/airlock/glass_mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doorminingglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1
	req_one_access = list(ACCESS_MINING)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/cgo1o.ogg'
	department_close_powered = 'sound/machines/door/cgo1c.ogg'

/obj/machinery/door/airlock/glass_atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1
	req_one_access = list(ACCESS_ATMOSPHERICS)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = MAT_GOLD

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral = MAT_SILVER

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral = MAT_DIAMOND

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral = MAT_URANIUM
	var/last_event = 0
	var/rad_power = 7.5

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			SSradiation.radiate(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/uranium_appearance
	icon = 'icons/obj/doors/Dooruranium.dmi'

/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorphoron.dmi'
	mineral = MAT_PHORON

/obj/machinery/door/airlock/phoron/attackby(obj/C, mob/user)
	if(C)
		ignite(is_hot(C))
	. = ..()

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas(GAS_PHORON, 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly(get_turf(src))
	qdel(src)

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/Doorsand.dmi'
	mineral = MAT_SANDSTONE

/obj/machinery/door/airlock/science
	name = "Research Airlock"
	icon = 'icons/obj/doors/doorsci.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	req_one_access = list(ACCESS_RESEARCH)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	icon = 'icons/obj/doors/doorsciglass.dmi'
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1
	req_one_access = list(ACCESS_RESEARCH)
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 1.5

/obj/machinery/door/airlock/highsecurity
	name = "Secure Airlock"
	icon = 'icons/obj/doors/hightechsecurity.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	req_one_access = list(ACCESS_HEADS_VAULT)
	open_sound_powered = 'sound/machines/door/secure1o.ogg'
	close_sound_powered = 'sound/machines/door/secure1c.ogg'
	security_level = 4

/obj/machinery/door/airlock/voidcraft
	name = "voidcraft hatch"
	desc = "It's an extra resilient airlock intended for spacefaring vessels."
	icon = 'icons/obj/doors/shuttledoors.dmi'
	explosion_resistance = 20
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'

// Airlock opens from top-bottom instead of left-right.
/obj/machinery/door/airlock/voidcraft/vertical
	icon = 'icons/obj/doors/shuttledoors_vertical.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft/vertical
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'

/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock
	name = "Precursor Alpha Object - Doors"
	desc = "This object appears to be used in order to restrict or allow access to \
	rooms based on its physical state. In other words, a door. \
	Despite being designed and created by unknown ancient alien hands, this door has \
	a large number of similarities to the conventional airlock, such as being driven by \
	electricity, opening and closing by physically moving, and being air tight. \
	It also operates by responding to signals through internal electrical conduits. \
	These characteristics make it possible for one with experience with a multitool \
	to manipulate the door.\
	<br><br>\
	The symbol on the door does not match any living species' patterns, giving further \
	implications that this door is very old, and yet it remains operational after \
	thousands of years. It is unknown if that is due to superb construction, or \
	unseen autonomous maintenance having been performed."
	value = CATALOGUER_REWARD_EASY

/obj/machinery/door/airlock/alien
	name = "alien airlock"
	desc = "You're fairly sure this is a door."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock)
	icon = 'icons/obj/doors/Dooralien.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_alien
	req_one_access = list(ACCESS_ALIEN)
	security_level = 100

/obj/machinery/door/airlock/alien/locked
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/alien/public // Entry to UFO.
	req_one_access = list()
	normalspeed = FALSE // So it closes faster and hopefully keeps the warm air inside.
	hackProof = TRUE //No borgs


/obj/machinery/door/airlock/glass_external/public
	req_one_access = list()

/obj/machinery/door/airlock/alien/blue
	name = "hybrid airlock"
	desc = "You're fairly sure this is a door."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock)
	icon = 'icons/obj/doors/Dooralien_blue.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_alien
	req_one_access = list()

/obj/machinery/door/airlock/alien/blue/locked
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/alien/blue/public // Entry to UFO.
	req_one_access = list()
	normalspeed = FALSE // So it closes faster and hopefully keeps the warm air inside.
	hackProof = TRUE //VOREStation Edit - No borgos

/obj/machinery/door/airlock/glass_security/polarized
	name = "Electrochromic Security Airlock"
	icon_tinted = 'icons/obj/doors/Doorsectinted_vr.dmi'

/obj/machinery/door/airlock/glass_medical/polarized
	name = "Electrochromic Medical Airlock"
	icon_tinted = 'icons/obj/doors/doormedtinted_vr.dmi'

/obj/machinery/door/airlock/glass_command/polarized
	name = "Electrochormic Command Airlock"
	icon_tinted = 'icons/obj/doors/Doorcomtinted_vr.dmi'
