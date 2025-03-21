// -- Areas -- //

/area/vr
	name = "VR world"
	icon_state = "green"
	base_turf = /turf/simulated/floor/outdoors/dirt
	flags = AREA_ALLOW_LARGE_SIZE | AREA_LIMIT_DARK_RESPITE

/area/vr/space
	name = "VR Space" //copypasta time
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg','sound/ambience/space/space_serithi.ogg','sound/music/freefallin.mid')
	base_turf = /turf/space
	ambience = AMBIENCE_SPACE
	flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_ALLOW_LARGE_SIZE | AREA_LIMIT_DARK_RESPITE

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return


/area/vr/outdoors
	outdoors = OUTDOORS_YES
	ambience = AMBIENCE_SIF

/area/vr/powered
	name = "Powered VR World Inside"
	icon_state = "away1"
	requires_power = 0
	power_equip = 1
	power_environ = 1
	power_light = 1

/area/vr/powered/rocks
	name = "VR World Underground"
	icon_state = "darkred"

/area/vr/outdoors/powered
	name = "Powered VR World Outside"
	icon_state = "away"
	requires_power = 0
	power_equip = 1
	power_environ = 1
	power_light = 1

/area/vr/powered/bluebase
	name = "Blue Base"
	icon_state = "bluenew"

/area/vr/powered/redbase
	name = "Red Base"
	icon_state = "red"

/area/vr/outdoors/powered/lava
	name = "VR Lava Bridge"

/area/vr/powered/vendor
	name = "VR Vendor Room"
	icon_state = "green"

/area/vr/powered/material
	name = "VR Material Room"
	icon_state = "green"

/area/vr/powered/building1
	name = "VR Building 1"
	icon_state = "green"

/area/vr/powered/building2
	name = "VR Building 2"
	icon_state = "green"

/area/vr/powered/conspawn
	name = "VR Construct Spawn"
	icon_state = "green"

/area/vr/powered/armory
	name = "VR Armory"
	icon_state = "firingrange"

/area/vr/powered/cult
	name = "VR Cultist Base"
	icon_state = "green"

/area/vr/outdoors/powered/cult
	name = "Cultist Outside"
	ambience = AMBIENCE_UNHOLY

//City section
/area/vr/powered/bar
	name = "VR Bar"
	icon_state = "green"

/area/vr/powered/cafe
	name = "VR Ghost Cafe"
	icon_state = "green"

/area/vr/powered/gunshop
	name = "VR GunShop"
	icon_state = "green"

/area/vr/powered/vet
	name = "VR Vet"
	icon_state = "green"

/area/vr/powered/shop
	name = "VR Shop"
	icon_state = "green"

/area/vr/powered/art
	name = "VR Art Gallery"
	icon_state = "green"

/area/vr/powered/constore
	name = "VR Convenience Store"
	icon_state = "green"

/area/vr/powered/nuke
	name = "VR Violation"
	icon_state = "green"

/area/vr/powered/motel
	name = "VR Motel"
	icon_state = "green"

/area/vr/powered/dungeon
	name = "VR Dungeon"
	icon_state = "darkred"

/area/vr/powered/mall
	name = "VR Mall"
	icon_state = "yellow"

/area/vr/powered/mall/vw
	name = "VR Vibe"
	icon_state = "pink"
	ambience = list('sound/ambience/vaporwave.ogg')

/area/vr/powered/mall/secondlife
	name = "VR Thirdlife Bar"
	icon_state = "pink"
	ambience = list(AMBIENCE_GENERIC)

/area/vr/powered/mall/dorms
	name = "VR Mall Dorms"
	icon_state = "Sleep"
	flags = RAD_SHIELDED | AREA_SOUNDPROOF | AREA_ALLOW_LARGE_SIZE | AREA_BLOCK_SUIT_SENSORS | AREA_BLOCK_TRACKING | AREA_LIMIT_DARK_RESPITE

/area/vr/powered/mall/dorms/dorms1

/area/vr/powered/mall/dorms/dorms2

/area/vr/powered/mall/dorms/dorms3

/area/vr/powered/mall/dorms/dorms4

/area/vr/powered/mall/dorms/dorms5

/area/vr/powered/mall/dorms/dorms6

/area/vr/powered/mall/dorms/secondlife
	name = "VR Third-Life Dorms"

/area/vr/powered/mall/dorms/secondlife2

/area/vr/powered/mall/dorms/secondlife3

/area/vr/powered/mall/dorms/secondlife4

/area/vr/powered/mall/dorms/secondlife5


/area/vr/outdoors/powered/mall
	name = "VR Mall Outdoors"
	icon_state = "bluenew"

/area/vr/powered/mall/backrooms
	name = "VR ???"
	icon_state = "darkred"
	forced_ambience = list('sound/ambience/fluorescentlight.ogg')

/area/vr/powered/dungeon/indoors
	name = "VR Sewers"
	icon_state = "red"

/area/vr/powered/space
	name = "VR Space Vessel"
	icon_state = "away2"
	base_turf = /turf/space
/area/vr/powered/space/whiteship
	name = "VR Whiteship"
	icon_state = "green"

/area/vr/powered/space/sciship
	name = "VR Sci Ship"
	icon_state = "green"

/area/vr/powered/space/mechfactory
	name = "VR Mech Factory"
	icon_state = "green"

// -- Objects -- //
/obj/effect/fake_sun/always_day
	name = "fake sun"
	advanced_lighting = TRUE
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs to cool colors."
	possible_light_setups = list(

		list(
			"brightness" = 6.0,
			"color" = "#ABfff7"
		),
		list(
			"brightness" = 4.0,
			"color" = "#F4EA55"
		),
		list(
			"brightness" = 2.5,
			"color" = "#EE9AC6"
		),
		list(
			"brightness" = 1.0,
			"color" = "#F07AD8"
		)
	)

// VR EXCLUSIVE ITEMS
/obj/item/reagent_containers/glass/beaker/mayo
	prefill = list("mayo" = 30) //;)
