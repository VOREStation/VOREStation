/area/awaymission/carpfarm
	icon_state = "blank"
	requires_power = 0
	unlimited_power = 1

/area/awaymission/carpfarm/arrival
	icon_state = "away"
	requires_power = 0
	unlimited_power = 1

/area/awaymission/carpfarm/base
	icon_state = "away"
	ambience = null // Todo: Add better ambience.

/area/awaymission/carpfarm/base/entry
	icon_state = "blue"
//	ambience = list('sound/music/TheClownChild.ogg')

// These extra areas must break up the large area, or the game crashes when machinery (like an airlock) makes sparks.
// I have no idea why. It's a nasty bug.
/area/awaymission/carpfarm/base/south_east
	icon_state = "red"

/area/awaymission/carpfarm/base/south_west
	icon_state = "bluenew"

/area/awaymission/carpfarm/base/south
	icon_state = "green"

/area/awaymission/carpfarm/base/west
	icon_state = "purple"

/area/awaymission/carpfarm/base/center
	icon_state = "yellow"

/area/awaymission/carpfarm/base/east
	icon_state = "blue"

/area/awaymission/carpfarm/base/north_east
	icon_state = "exit"

/area/awaymission/carpfarm/base/north_west
	icon_state = "orange"

/area/awaymission/carpfarm/base/north
	icon_state = "blue"

/area/awaymission/carpfarm/boss
	icon_state = "red"



/obj/item/weapon/paper/awaygate/carpfarm/suicide
	name = "suicide letter"
	info = "Dear rescue,<br><br>My name Vlad. If reading this, I am dead. I <s>am</s> was miner for 3rd Union of Soviet Socialist Republics. \
			Comrades Yuri, Dimitri, and Ivan, all eaten by space carp. All started month ago when Soviet shipment sent new sonic jackhammers. \
			Carp attracted to vibrations. Killed Dimitri. Yuri thought it good idea to jury-rig hoverpods with lasers. Was not good idea. \
			Was very bad idea. Only pissed them off. Giant white carp appeared. Killed Ivan. Then giant carp cracked Yuri's hoverpod like \
			eggshell and swallowed Yuri whole.<br><br>Out of food. Can't call for help. Carp chewed up comms relay. Two weeks gone since then. \
			Very little food. Can't eat the carp. Is poison.<br><br>Avenge comrades. Avenge me. I die now.<br><br>-Markov"