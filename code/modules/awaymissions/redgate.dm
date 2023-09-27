/obj/structure/redgate
	name = "redgate"
	desc = "It leads to someplace else!"
	icon = 'icons/obj/redgate.dmi'
	icon_state = "off"
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	pixel_x = -16

	var/obj/structure/redgate/target
	var/secret = FALSE	//If either end of the redgate has this enabled, ghosts will not be able to click to teleport
	var/list/exceptions = list(
		/obj/structure/ore_box
		)	//made it a var so that GMs or map makers can selectively allow things to pass through
	var/list/restrictions = list(
		/mob/living/simple_mob/vore/overmap/stardog,
		/mob/living/simple_mob/vore/bigdragon
		)	//There are some things we don't want to come through no matter what.

/obj/structure/redgate/Destroy()
	if(target)
		target.target = null
		target.toggle_portal()
		target = null
		set_light(0)

	return ..()

/obj/structure/redgate/proc/teleport(var/mob/M as mob)
	var/keycheck = TRUE
	if (!istype(M,/mob/living))		//We only want mob/living, no bullets or mechs or AI eyes or items
		if(M.type in exceptions)
			keycheck = FALSE		//we'll allow it
		else
			return

	if(M.type in restrictions)	//Some stuff we don't want to bring EVEN IF it has a key.
		return

	for(var/obj/O in M.contents)
		if(O.redgate_allowed == FALSE)
			to_chat(M, "<span class='warning'>The redgate refuses to allow you to pass whilst you possess \the [O].</span>")
			return

	if(keycheck)		//exceptions probably won't have a ckey
		if(!M.ckey)		//We only want players, no bringing the weird stuff on the other side back
			return

	if(!target)
		toggle_portal()

	var/turf/ourturf = find_our_turf(M)		//Find the turf on the opposite side of the target
	if(!ourturf.check_density(TRUE,TRUE))	//Make sure there isn't a wall there
		M.unbuckle_all_mobs(TRUE)
		M.stop_pulling()
		playsound(src,'sound/effects/ominous-hum-2.ogg', 100,1)
		M.forceMove(ourturf)		//Let's just do forcemove, I don't really want people teleporting to weird places if they have bluespace stuff
	else
		to_chat(M, "<span class='notice'>Something blocks your way.</span>")

/obj/structure/redgate/proc/find_our_turf(var/atom/movable/AM)	//This finds the turf on the opposite side of the target gate from where you are
	var/offset_x = x - AM.x										//used for more smooth teleporting
	var/offset_y = y - AM.y

	var/turf/temptarg = locate((target.x + offset_x),(target.y + offset_y),target.z)

	return temptarg

/obj/structure/redgate/proc/toggle_portal()
	if(target)
		icon_state = "on"
		density = TRUE
		plane = ABOVE_MOB_PLANE
		set_light(5, 0.75, "#da5656")
	else
		icon_state = "off"
		density = FALSE
		plane = OBJ_PLANE
		set_light(0)

/obj/structure/redgate/Bumped(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/Crossed(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/attack_hand(mob/M as mob)
	if(density)
		src.teleport(M)
	else
		if(!find_partner())
			to_chat(M, "<span class='warning'>The [src] remains off... seems like it doesn't have a destination.</span>")


/obj/structure/redgate/attack_ghost(var/mob/observer/dead/user)

	if(target)
		if(!(secret || target.secret) || user?.client?.holder)
			user.forceMove(get_turf(target))
	else
		return ..()

/obj/structure/redgate/away/Initialize()
	. = ..()
	if(!find_partner())
		log_and_message_admins("An away redgate spawned but wasn't able to find a gateway to link to. If this appeared at roundstart, something has gone wrong, otherwise if you spawn another gate they should connect.")

/obj/structure/redgate/proc/find_partner()
	for(var/obj/structure/redgate/g in world)
		if(istype(g, /obj/structure/redgate))
			if(g.target)
				continue
			else if(g == src)
				continue
			else if(g.z in using_map.station_levels)
				target = g
				g.target = src
				toggle_portal()
				target.toggle_portal()
				break
			else if(g != src)
				target = g
				g.target = src
				toggle_portal()
				target.toggle_portal()
				break
	if(!target)
		return FALSE
	else
		return TRUE

/area/redgate
	name = "redgate"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "redblacir"
	base_turf = /turf/simulated/mineral/floor/cave

/area/redgate/wilds
	name = "wilderness"

/area/redgate/structure
	name = "structure"
	icon_state = "redwhisqu"

/area/redgate/structure/powered
	requires_power = 0

/area/redgate/lit
	dynamic_lighting = 0

/area/redgate/structure/powered/teppi_ranch
	name = "ranch"

/area/redgate/structure/powered/teppi_ranch/barn
	name = "barn"

/obj/item/weapon/paper/teppiranch
	name = "elegantly scrawled note"
	info = {"<i>Goeleigh,<BR><BR>

	This isn't how I wanted to give this message to you. They say that the light is coming this way, and we won't even know it's here until it's upon us. There's no way to know when it will arrive, so we can't really afford to wait around. My family has secured us a ride on a ship, and we'll be going to one of the rimward colonies. They say that they are making strides to build some new kind of gate there, something that will take us far from that light, somewhere safe. We can't really bring the animals, but perhaps you can make some arrangements for them.<BR><BR>

	As soon as you read this, get yourself out of here and come find us. We left you enough money to make the trip in the usual spot. We'll be in the registry once we arrive. We're waiting for you.<BR><BR>

	Yours, Medley</i>"}

/area/redgate/hotsprings
	name = "hotsprings"
	requires_power = 0

/area/redgate/hotsprings/outdoors
	name = "snowfields"
	icon_state = "hotsprings_outside"

/area/redgate/hotsprings/redgate
	name = "redgate facility"
	icon_state = "hotsprings_redgate"

/area/redgate/hotsprings/westcave
	name = "hotspring caves"
	icon_state = "hotsprings_westcave"

/area/redgate/hotsprings/eastcave
	name = "icy caverns"
	icon_state = "hotsprings_eastcave"

/area/redgate/hotsprings/house
	name = "snowy cabin"
	icon_state = "hotsprings_house"

/area/redgate/hotsprings/house/dorm1
	name = "hotsprings dorm 1"
	icon_state = "hotsprings_dorm1"

/area/redgate/hotsprings/house/dorm2
	name = "hotsprings dorm 2"
	icon_state = "hotsprings_dorm2"

/area/redgate/hotsprings/house/hotspringhouse
	name = "small cabin"
	icon_state = "hotsprings_hotspringhouse"

/area/redgate/hotsprings/house/lovercave
	name = "cosy cave"
	icon_state = "hotsprings_lovercave"

/area/redgate/hotsprings/house/succcave
	name = "tiny cave"
	icon_state = "hotsprings_succcave"

// City areas, there are soooo many

/area/redgate/city
	name = "rain city"
	icon_state = "red"
	requires_power = 0

/area/redgate/city/streets
	name = "streets"
	icon_state = "red"
	forced_ambience = list('sound/effects/weather/acidrain_mid.ogg')

/area/redgate/city/science
	name = "science facility"
	icon_state = "purple"

/area/redgate/city/hospital
	name = "hospital"
	icon_state = "green"

/area/redgate/city/casino
	name = "casino"
	icon_state = "yellow"

/area/redgate/city/comms
	name = "radio tower"
	icon_state = "yellow"

/area/redgate/city/check1
	name = "checkpoint"
	icon_state = "purple"

/area/redgate/city/check2
	name = "checkpoint"
	icon_state = "purple"

/area/redgate/city/apartments
	name = "apartments"
	icon_state = "bluenew"

/area/redgate/city/warehouse
	name = "warehouse"
	icon_state = "green"

/area/redgate/city/corporation
	name = "corporation"
	icon_state = "yellow"

/area/redgate/city/pool
	name = "pool"
	icon_state = "bluenew"

/area/redgate/city/morgue
	name = "funeral home"
	icon_state = "green"

/area/redgate/city/dealership
	name = "car dealership"
	icon_state = "yellow"

/area/redgate/city/hotel
	name = "hotel"
	icon_state = "purple"

/area/redgate/city/police
	name = "police station"
	icon_state = "green"

/area/redgate/city/church
	name = "church"
	icon_state = "yellow"

/area/redgate/city/bar1
	name = "dance bar"
	icon_state = "green"

/area/redgate/city/bar2
	name = "abandoned bar"
	icon_state = "green"

/area/redgate/city/lasertag
	name = "laser tag"
	icon_state = "purple"

/area/redgate/city/gym
	name = "gym"
	icon_state = "green"

/area/redgate/city/scughouse
	name = "abandoned house"
	icon_state = "bluenew"

/area/redgate/city/parkinglot
	name = "parking lot"
	icon_state = "green"

/area/redgate/city/supermarket
	name = "supermarket"
	icon_state = "green"

/area/redgate/city/nifshop
	name = "NIF store"
	icon_state = "bluenew"

/area/redgate/city/clotheshop
	name = "unclothe"
	icon_state = "yellow"

/area/redgate/city/toys
	name = "toystore"
	icon_state = "green"

/area/redgate/city/offlicense
	name = "off-license"
	icon_state = "green"

/area/redgate/city/cafe
	name = "cafe"
	icon_state = "purple"

/area/redgate/city/restaurant
	name = "restaurant"
	icon_state = "green"

/area/redgate/city/laundry
	name = "laundromat"
	icon_state = "green"

/area/redgate/city/wiz
	name = "wizard store"
	icon_state = "bluenew"

/area/redgate/city/altevian
	name = "altevian imports"
	icon_state = "yellow"

/area/redgate/city/pizza
	name = "pizza place"
	icon_state = "green"

/area/redgate/city/pharmacy
	name = "pharmacy"
	icon_state = "green"

/area/redgate/city/costumes
	name = "costume store"
	icon_state = "purple"

/area/redgate/city/stripclub
	name = "strip club"
	icon_state = "party"

/area/redgate/city/cards
	name = "card game stadium"
	icon_state = "purple"

/area/redgate/city/waterworks
	name = "water treatment plant"
	icon_state = "green"

/area/redgate/city/workshop
	name = "ship hanger"
	icon_state = "purple"

/area/redgate/city/ripper
	name = "prosthetic lab"
	icon_state = "purple"

/area/redgate/city/engine
	name = "singularity power station"
	icon_state = "green"

/area/redgate/city/spa
	name = "spa"
	icon_state = "purple"

/area/redgate/city/library
	name = "library"
	icon_state = "bluenew"

/area/redgate/city/teppi
	name = "farm"
	icon_state = "purple"

/area/redgate/city/gallery
	name = "art gallery"
	icon_state = "green"

/area/redgate/city/theatre
	name = "theatre"
	icon_state = "purple"

/area/redgate/city/doctor
	name = "back alley doctor"
	icon_state = "bluenew"

/area/redgate/city/sims
	name = "weird pool"
	icon_state = "bluenew"

/area/redgate/city/weretiger
	name = "back alley home"
	icon_state = "purple"

/area/redgate/city/dump
	name = "trash pile"
	icon_state = "purple"

/area/redgate/city/succ
	name = "alien home"
	icon_state = "green"

/area/redgate/city/chopshop
	name = "back alley workshop"
	icon_state = "yellow"

/area/redgate/city/crates
	name = "empty building"
	icon_state = "purple"

/area/redgate/city/drugden
	name = "back alley home"
	icon_state = "purple"

/area/redgate/city/gamblingden
	name = "gambling den"
	icon_state = "yellow"

/area/redgate/city/tarot
	name = "tarot card reading"
	icon_state = "green"

/area/redgate/city/fightclub
	name = "empty back-alley house"
	icon_state = "purple"

/area/redgate/city/rats
	name = "rat infested house"
	icon_state = "bluenew"

/area/redgate/city/shooting
	name = "shooting gallery"
	icon_state = "green"

/area/redgate/city/storage
	name = "storage units"
	icon_state = "bluenew"

/area/redgate/city/cardmon
	name = "back-alley home"
	icon_state = "green"

/area/redgate/city/conveyors
	name = "conveyor building"
	icon_state = "bluenew"

/area/redgate/city/dodgypharmacy
	name = "back-alley pharmacy"
	icon_state = "purple"

/area/redgate/city/house1
	name = "house"
	icon_state = "green"

/area/redgate/city/house2
	name = "house"
	icon_state = "green"

/area/redgate/city/house3
	name = "house"
	icon_state = "green"

/area/redgate/city/house4
	name = "house"
	icon_state = "green"

/area/redgate/city/house5
	name = "house"
	icon_state = "green"

/area/redgate/city/house6
	name = "house"
	icon_state = "green"

/area/redgate/city/house7
	name = "house"
	icon_state = "green"

/area/redgate/city/house8
	name = "house"
	icon_state = "green"

/area/redgate/city/house9
	name = "house"
	icon_state = "green"

/area/redgate/city/house10
	name = "house"
	icon_state = "green"

/area/redgate/city/house11
	name = "house"
	icon_state = "green"

/area/redgate/city/house12
	name = "house"
	icon_state = "green"

/area/redgate/city/house13
	name = "house"
	icon_state = "green"

/area/redgate/city/house14
	name = "house"
	icon_state = "green"

/area/redgate/city/house15
	name = "house"
	icon_state = "green"

/area/redgate/city/house16
	name = "house"
	icon_state = "green"

/area/redgate/city/house17
	name = "house"
	icon_state = "green"

/area/redgate/city/house18
	name = "house"
	icon_state = "green"

// Islands areas

/area/redgate/islands
	name = "Islands"
	icon_state = "red"
	requires_power = 0

/area/redgate/islands/ocean
	name = "Islands - Ocean"
	icon_state = "purple"
	forced_ambience = list('sound/effects/ocean.ogg')

/area/redgate/islands/volcano
	name = "Islands - Volcano"
	icon_state = "red"

/area/redgate/islands/cave
	name = "Islands - Cave"
	icon_state = "yellow"

/area/redgate/islands/gear
	name = "Islands - Rig Gear Room"
	icon_state = "bluenew"

/area/redgate/islands/control
	name = "Islands - Rig Control Room"
	icon_state = "bluenew"

/area/redgate/islands/telecomms
	name = "Islands - Telecomms"
	icon_state = "red"

/area/redgate/islands/ladder
	name = "Islands - Ladder"
	icon_state = "red"

/area/redgate/islands/redgate
	name = "Islands - Redgate"
	icon_state = "red"

/area/redgate/islands/oxygen
	name = "Islands - Oxygen Shed"
	icon_state = "bluenew"

/area/redgate/islands/fishing
	name = "Islands - Fishing Shed"
	icon_state = "red"

/area/redgate/islands/livingroom
	name = "Islands - Living Room"
	icon_state = "red"

/area/redgate/islands/diningroom
	name = "Islands - Dining Room"
	icon_state = "bluenew"

/area/redgate/islands/dorm1
	name = "Islands - House Dorm 1"
	icon_state = "yellow"

/area/redgate/islands/dorm2
	name = "Islands - House Dorm 2"
	icon_state = "yellow"

/area/redgate/islands/bathroom
	name = "Islands - Bathroom"
	icon_state = "red"

/area/redgate/islands/kitchen
	name = "Islands - Kitchen"
	icon_state = "red"

/area/redgate/islands/office
	name = "Islands - Office"
	icon_state = "bluenew"

/area/redgate/islands/secretladder
	name = "Islands - Secret Ladder"
	icon_state = "red"

/area/redgate/islands/alienship
	name = "Islands - Alien Ship"
	icon_state = "bluenew"

/area/redgate/islands/underwater
	name = "Islands - Under The Sea"
	icon_state = "bluenew"
	forced_ambience = list('sound/effects/underwater.ogg')

/area/redgate/islands/storeroom
	name = "Islands - Store Room"
	icon_state = "red"

/area/redgate/islands/kegs
	name = "Islands - Kegs"
	icon_state = "yellow"

/area/redgate/islands/bar
	name = "Islands - Bar"
	icon_state = "green"

/area/redgate/islands/backroom
	name = "Islands - Bar Backroom"
	icon_state = "yellow"

/area/redgate/islands/piratecave
	name = "Islands - Smuggling Caves"
	icon_state = "red"

/area/redgate/islands/gambling
	name = "Islands - Games Room"
	icon_state = "yellow"

/area/redgate/islands/sparerooms
	name = "Islands - Spare Rooms"
	icon_state = "yellow"

/area/redgate/islands/gamblingbackroom
	name = "Islands - Gambling Backroom"
	icon_state = "purple"

/area/redgate/islands/lavabase
	name = "Islands - Lava Base"
	icon_state = "red"

/area/redgate/islands/lavadorm
	name = "Islands - Lava Dorm"
	icon_state = "purple"

/area/redgate/islands/robotics
	name = "Islands - Robotics Lab"
	icon_state = "yellow"

/area/redgate/islands/lavagear
	name = "Islands - Lava Base Equipment"
	icon_state = "green"

/area/redgate/islands/underwatercave
	name = "Islands - Underwater cave"
	icon_state = "yellow"

/area/redgate/islands/ruins
	name = "Islands - Golden Ruins"
	icon_state = "yellow"

/area/redgate/islands/cult
	name = "Islands - Sunken Ruins"
	icon_state = "red"

/area/redgate/islands/divingbay
	name = "Islands - Diving Bay"
	icon_state = "green"

/area/redgate/islands/shower
	name = "Islands - Shower Room"
	icon_state = "purple"

/area/redgate/islands/righall
	name = "Islands - Rig Bowels"
	icon_state = "red"

/area/redgate/islands/rig1
	name = "Islands - Rig Dorm 1"
	icon_state = "yellow"

/area/redgate/islands/rig2
	name = "Islands - Rig Dorm 2"
	icon_state = "yellow"

/area/redgate/islands/meeting
	name = "Islands - Rig Briefing Room"
	icon_state = "purple"

/area/redgate/islands/mess
	name = "Islands - Rig Mess"
	icon_state = "red"

//train areas

/area/redgate/train
	name = "Train"
	icon_state = "red"
	requires_power = 0

/area/redgate/train/overboard
	name = "Outside of the Train"
	icon_state = "red"

/area/redgate/train/connection
	name = "Train Connection"
	icon_state = "bluenew"

/area/redgate/train/cab
	name = "Train Cab"
	icon_state = "yellow"

/area/redgate/train/meeting
	name = "Train Meeting Room"
	icon_state = "green"

/area/redgate/train/storage
	name = "Train Storage"
	icon_state = "green"

/area/redgate/train/viewing
	name = "Train Viewing Carriage"
	icon_state = "green"

/area/redgate/train/seating
	name = "Train Seating"
	icon_state = "green"

/area/redgate/train/tableseating
	name = "Train Table Seating"
	icon_state = "green"

/area/redgate/train/bar
	name = "Train Bar"
	icon_state = "green"

/area/redgate/train/arena
	name = "Train Arena"
	icon_state = "green"

/area/redgate/train/redgate
	name = "Train Redgate"
	icon_state = "purple"

/area/redgate/train/casino
	name = "Train Casino"
	icon_state = "green"

/area/redgate/train/animals
	name = "Train Animal Transport"
	icon_state = "green"

/area/redgate/train/teppi
	name = "Train Teppi Transport"
	icon_state = "green"

/area/redgate/train/fuel
	name = "Train Fuel Transport"
	icon_state = "green"

/area/redgate/train/wood
	name = "Train Wood Transport"
	icon_state = "green"

/area/redgate/train/rear
	name = "Train Rear Carriage"
	icon_state = "green"

/area/redgate/train/balcony
	name = "Train Balcony"
	icon_state = "yellow"

/area/redgate/train/roof
	name = "Train Roof"
	icon_state = "green"

/area/redgate/train/staff
	name = "Train Staffroom"
	icon_state = "green"

/area/redgate/train/helipad
	name = "Train Helipad"
	icon_state = "green"

/area/redgate/train/medbay
	name = "Train Medical"
	icon_state = "green"

/area/redgate/train/gym
	name = "Train Gym"
	icon_state = "green"

/area/redgate/train/pool
	name = "Train Pool"
	icon_state = "green"

/area/redgate/train/chef
	name = "Train Chef Room"
	icon_state = "yellow"

/area/redgate/train/freezer
	name = "Train Freezer"
	icon_state = "green"

/area/redgate/train/kitchen
	name = "Train Kitchen"
	icon_state = "purple"

/area/redgate/train/dining
	name = "Train Dining Room"
	icon_state = "green"

/area/redgate/train/sleeper1
	name = "Train Sleeper Carriage One"
	icon_state = "green"

/area/redgate/train/sleeper2
	name = "Train Sleeper Carriage Two"
	icon_state = "green"

/area/redgate/train/dorm1
	name = "Train Dorm 1"
	icon_state = "purple"

/area/redgate/train/dorm2
	name = "Train Dorm 2"
	icon_state = "yellow"

/area/redgate/train/dorm3
	name = "Train Dorm 3"
	icon_state = "purple"

/area/redgate/train/dorm4
	name = "Train Dorm 4"
	icon_state = "purple"

/area/redgate/train/dorm5
	name = "Train Dorm 5"
	icon_state = "yellow"

/area/redgate/train/dorm6
	name = "Train Dorm 6"
	icon_state = "purple"

/area/redgate/train/seclobby
	name = "Train Security Lobby"
	icon_state = "green"

/area/redgate/train/security
	name = "Train Security"
	icon_state = "purple"

/area/redgate/train/gear
	name = "Train Security Gear"
	icon_state = "yellow"

/area/redgate/train/command
	name = "Train Command"
	icon_state = "green"

/area/redgate/train/vault
	name = "Train Vault"
	icon_state = "yellow"

/area/redgate/train/captain
	name = "Train Captain's Quarters"
	icon_state = "purple"


// fantasy areas

/area/redgate/fantasy
	name = "Fantasy"
	icon_state = "red"
	requires_power = 0

/area/redgate/fantasy/streets
	name = "Fantasy outside"
	icon_state = "red"

/area/redgate/fantasy/tavern
	name = "Fantasy tavern"
	icon_state = "yellow"

/area/redgate/fantasy/shop
	name = "Fantasy shop"
	icon_state = "yellow"

/area/redgate/fantasy/alchemist
	name = "Fantasy alchemist"
	icon_state = "yellow"

/area/redgate/fantasy/castle
	name = "Fantasy castle"
	icon_state = "yellow"

/area/redgate/fantasy/blacksmith
	name = "Fantasy blacksmith"
	icon_state = "yellow"

/area/redgate/fantasy/hedgemaze
	name = "Fantasy hedgemaze"
	icon_state = "green"

/area/redgate/fantasy/butcher
	name = "Fantasy butcher"
	icon_state = "yellow"

/area/redgate/fantasy/jewler
	name = "Fantasy jewler"
	icon_state = "yellow"

/area/redgate/fantasy/restaurant
	name = "Fantasy restaurant"
	icon_state = "yellow"

/area/redgate/fantasy/cafe
	name = "Fantasy cafe"
	icon_state = "yellow"

/area/redgate/fantasy/house
	name = "Fantasy house"
	icon_state = "yellow"

/area/redgate/fantasy/gambling
	name = "Fantasy gambling den"
	icon_state = "yellow"

/area/redgate/fantasy/washhouse
	name = "Fantasy wash house"
	icon_state = "yellow"

/area/redgate/fantasy/aliens
	name = "Fantasy alien house"
	icon_state = "purple"

/area/redgate/fantasy/walls
	name = "Fantasy green"
	icon_state = "green"

/area/redgate/fantasy/guardhouse
	name = "Fantasy guard house"
	icon_state = "yellow"

/area/redgate/fantasy/mininghouse
	name = "Fantasy mining house"
	icon_state = "yellow"

/area/redgate/fantasy/farmhouse
	name = "Fantasy farm house"
	icon_state = "yellow"

/area/redgate/fantasy/church
	name = "Fantasy church"
	icon_state = "yellow"

/area/redgate/fantasy/churchhouse
	name = "Fantasy church house"
	icon_state = "yellow"

/area/redgate/fantasy/arena
	name = "Fantasy arena"
	icon_state = "yellow"

/area/redgate/fantasy/redgate
	name = "Fantasy redgate"
	icon_state = "yellow"

/area/redgate/fantasy/paladinhouse
	name = "Fantasy paladin house"
	icon_state = "yellow"

/area/redgate/fantasy/druid
	name = "Fantasy druid house"
	icon_state = "yellow"

/area/redgate/fantasy/bard
	name = "Fantasy bard house"
	icon_state = "yellow"

/area/redgate/fantasy/rogue
	name = "Fantasy rogue house"
	icon_state = "yellow"

/area/redgate/fantasy/grocery
	name = "Fantasy grocery store"
	icon_state = "yellow"

/area/redgate/fantasy/bakery
	name = "Fantasy bakery"
	icon_state = "yellow"

/area/redgate/fantasy/barbarian
	name = "Fantasy barbarian house"
	icon_state = "yellow"

/area/redgate/fantasy/ranger
	name = "Fantasy ranger house"
	icon_state = "yellow"

/area/redgate/fantasy/ratbasement
	name = "Fantasy rat infested basement"
	icon_state = "yellow"

/area/redgate/fantasy/underground
	name = "Fantasy underground"
	icon_state = "red"

/area/redgate/fantasy/dungeon
	name = "Fantasy dungeon"
	icon_state = "yellow"

/area/redgate/fantasy/underwater
	name = "Fantasy underwater"
	icon_state = "bluenew"

/area/redgate/fantasy/crypt
	name = "Fantasy crypt"
	icon_state = "green"

/area/redgate/fantasy/caves
	name = "Fantasy caves"
	icon_state = "yellow"

/area/redgate/fantasy/alienbasement
	name = "Fantasy alien basement"
	icon_state = "yellow"

/area/redgate/fantasy/dark
	name = "Fantasy dark"
	icon_state = "green"

/area/redgate/fantasy/mines
	name = "Fantasy house"
	icon_state = "green"

//HIIIIGHWAY TO THE! LASER-DOME!
/area/redgate/laserdome
	name = "Laserdome Safe Zone"
	icon_state = "bluwhisqu"
	dynamic_lighting = 0
	requires_power = 0

/area/redgate/laserdome/lobby
	name = "Laserdome Lobby & Lounge"
	icon_state = "greblasqu"

/area/redgate/laserdome/arena
	name = "Laserdome Arenas"
	icon_state = "yelwhisqu"

/area/redgate/laserdome/arena/capture_the_flag
	name = "Laserdome Capture The Flag Arena"
	icon_state = "redwhitri"

/area/redgate/laserdome/arena/hyperball
	name = "Laserdome Hyperball Arena"
	icon_state = "redwhicir"

/area/redgate/laserdome/space
	name = "Laserdome Space View"
	icon_state = "dark128"

/obj/item/weapon/laserdome_flag
	name = "Flag"
	desc = "Steal the enemy flag and take it to your base in order to score! First team to three captures wins! Or was it five? Eh, check with the referee I guess."
	description_info = "Simply pick up your team's flag to return it to your base. If you're carrying the enemy flag, use it on your team's flag base to score a point!"
	slowdown = 1 //big flag is harder to run with, encourages teamwork
	icon = 'icons/obj/flags.dmi'
	icon_state = "flag"
	var/laser_team = "neutral"
	w_class = ITEMSIZE_NO_CONTAINER //no stashing the flag in a bag for you, bucko!
	redgate_allowed = FALSE //no running off the map with the flags either
	var/start_pos
	var/flag_return_delay = 3 SECONDS	//how long you have to hold onto your team's flag before it returns home

/obj/item/weapon/laserdome_flag/Initialize()
	. = ..()
	start_pos = src.loc	//save our starting location for later

/*
//TODO - make this not trigger when the flag is returned to its original location
/obj/item/weapon/laserdome_flag/dropped()
	. = ..()
	global_announcer.autosay("[src] dropped!","Laserdome Announcer","Entertainment")
*/

/obj/item/weapon/laserdome_flag/attack_hand(mob/user as mob)
	. = ..()
	var/mob/living/carbon/human/M = loc
	var/grabbing_team

	//if they're not a carbon, we don't care
	if(!istype(M))
		return

	//get their uniform
	if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
		grabbing_team = "red"
	else if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
		grabbing_team = "blue"
	else
		return	//if they're not on a team, stop!

	//set the verb based on matching (or mismatching) outfits, and teleport the flag back to base if it was touched by the owning team
	if(grabbing_team == laser_team)
		user.visible_message("<span class='warning'>[user] is returning \the [src]!</span>")
		if(do_after(user,flag_return_delay))	//channel return, rather than instant
			user.drop_from_inventory(src)
			src.loc = src.start_pos
			global_announcer.autosay("[capitalize(laser_team)] flag returned by [user]!","Laserdome Announcer","Entertainment")
		else	//if they fail the channel (e.g. because they got tagged!) then drop it
			user.drop_from_inventory(src)
			return
	else
		user.visible_message("<span class='warning'>[user] has taken \the [src]!</span>")
		global_announcer.autosay("[src] taken by [capitalize(grabbing_team)] team!","Laserdome Announcer","Entertainment")

/obj/item/weapon/laserdome_flag/red
	name = "Red flag"
	icon_state = "red_flag"
	laser_team = "red"

/obj/item/weapon/laserdome_flag/blue
	name = "Blue flag"
	icon_state = "blue_flag"
	laser_team = "blue"

/obj/structure/flag_base
	name = "Flag base"
	desc = "Where your flag rests. Bring the enemy flag here to score!"
	icon = 'icons/obj/flags.dmi'
	icon_state = "flag_base"
	var/base_team
	var/score = 0
	var/score_limit = 3

/obj/structure/flag_base/blue
	name = "Blue team flag base"
	base_team = "blue"

/obj/structure/flag_base/red
	name = "Red team flag base"
	base_team = "red"

/obj/structure/flag_base/attackby(obj/F as obj, mob/user as mob)
	. = ..()

	//TODO- require the team's flag to be present before they can score?
	if(istype(F,/obj/item/weapon/laserdome_flag))
		var/obj/item/weapon/laserdome_flag/flag = F
		if(flag.laser_team != base_team)
			global_announcer.autosay("[user] captured the [capitalize(flag.laser_team)] flag for [capitalize(base_team)] team!","Laserdome Announcer","Entertainment")
			user.drop_from_inventory(flag)
			flag.loc = flag.start_pos	//teleport the captured flag back to its base location
			score++	//increment our score by 1!
			if(score < score_limit)	//announce the current score and how many more captures are needed
				global_announcer.autosay("[num2text(score_limit-score)] captures remain until [capitalize(base_team)] team wins.","Laserdome Announcer","Entertainment")
			if(score >= score_limit)	//now, if score equals or exceeds (somehow) the score limit, announce that our team won and reset the score for all flag bases nearby
				global_announcer.autosay("+|[uppertext(base_team)] TEAM HAS WON THE MATCH!|+","Laserdome Announcer","Entertainment")
				for(var/obj/structure/flag_base/FB in src.loc.loc.contents)	//this feels dirty, but it works
					FB.score = 0
		else if(flag.laser_team == base_team)
			global_announcer.autosay("[capitalize(base_team)] flag returned!","Laserdome Announcer","Entertainment")
			user.drop_from_inventory(flag)
			flag.loc = src.loc			//place our flag neatly back on its pedestal

/obj/item/weapon/laserdome_hyperball
	name = "Hyperball"
	desc = "Because regular balls aren't exciting enough, the future needs the hyperball!"
	description_info = "Take the ball and dunk it into the opposing team's goal to score a point! But don't dunk it into your own goal, or you lose a point!"
	slowdown = -0.5	//carrying the ball actually speeds you up a little bit?
	icon = 'icons/obj/flags.dmi'
	icon_state = "hyperball"
	w_class = ITEMSIZE_NO_CONTAINER
	redgate_allowed = FALSE
	glow_color = "#C28310"
	var/start_pos

/obj/item/weapon/laserdome_hyperball/Initialize()
	. = ..()
	start_pos = src.loc	//save our starting location for later

/obj/structure/hyperball_pedestal
	name = "Hyperball pedestal"
	desc = "A fancy stand that the hyperball appears on. Looks strangely like one of the goals, come to think of it..."
	icon = 'icons/obj/flags.dmi'
	icon_state = "hyperball_stand"

/obj/structure/hyperball_goal
	name = "Hyperball goal"
	desc = "A dangerous-looking hole, with an energy net that stops anything but a hyperball from passing through."
	description_info = "Dunk the hyperball here to score! Just don't get an own goal."
	icon = 'icons/obj/flags.dmi'
	icon_state = "hyperball_goal"
	var/goal_team
	var/score = 0
	var/score_limit = 3

/obj/structure/hyperball_goal/blue
	name = "Blue team hyperball goal"
	icon_state = "hyperball_goal_blue"
	goal_team = "blue"

/obj/structure/hyperball_goal/red
	name = "Red team hyperball goal"
	icon_state = "hyperball_goal_red"
	goal_team = "red"

/obj/structure/hyperball_goal/attackby(obj/B as obj, mob/user as mob)
	. = ..()
	var/mob/living/carbon/human/M = user
	var/dunking_team
	if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
		dunking_team = "red"
	else if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
		dunking_team = "blue"
	else
		return	//if they're not on a team, stop!

	if(istype(F,/obj/item/weapon/laserdome_hyperball))
		var/obj/item/weapon/laserdome_hyperball/ball = B
		if(dunking_team != goal_team)
			global_announcer.autosay("[user] dunked the hyperball for [capitalize(base_team)] team! +|Point scored!|+","Laserdome Announcer","Entertainment")
			score++	//increment our score by 1!
			if(score < score_limit)	//announce the current score and how many more captures are needed
				global_announcer.autosay("[num2text(score_limit-score)] dunks remain until [capitalize(base_team)] team wins.","Laserdome Announcer","Entertainment")
			if(score >= score_limit)	//now, if score equals or exceeds (somehow) the score limit, announce that our team won and reset the score for all flag bases nearby
				global_announcer.autosay("+|[uppertext(base_team)] TEAM HAS WON THE MATCH!|+","Laserdome Announcer","Entertainment")
				for(var/obj/structure/hyperball_goal/HB in src.loc.loc.contents)	//this feels dirty, but it works
					HB.score = 0
		else if(dunking_team == goal_team)	//discourage people from dunking the ball into their own goal as a quick way to teleport it back to the midfield
			global_announcer.autosay("[user] dunked the hyperball and scored an own goal! +Point |de-ducted!|+","Laserdome Announcer","Entertainment")
			score = max(0,score-1)

		user.drop_from_inventory(ball)
		ball.loc = ball.start_pos	//teleport the ball back to the midfield
