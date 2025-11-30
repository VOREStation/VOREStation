#define UNDERWATER_CASINO_NAME "Casino Canal"

// ******************************
// *****      OBJECTS      ******
// ******************************

// Different type of chip machine that gives visitors a set amount of chips to start with.
// No pay-to-win here - One free use per ckey, and that's it!
/obj/machinery/oneuse_chipmachine
	name = "automated chip dispenser"
	desc = "A curious device that dispenses a set amount of chips to each visitor one time, and one time only."
	icon = 'icons/obj/casino.dmi'
	icon_state = "chipmachine"
	anchored = 1
	var/list/used_ckeys = list() // Players who have already received their chips.
	var/amt_chips_to_dispense = 250
	var/speaking = FALSE // Whether or not we are saying one message (to prevent overlap)

/obj/machinery/oneuse_chipmachine/proc/state_message(var/message, var/delay=0)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// If we don't want a delay, say the message
	if(!delay)
		speaking = FALSE
		playsound(loc, 'sound/voice/emotes/wawa.ogg', 50, 1)
		audible_message("[icon2html(src,hearers(src))] [span_bold("\The [src]")] states, \"[message]\"", runemessage = "wawa")
	// If we do, call the delay-less part of this but with, well, the delay
	else
		speaking = TRUE
		addtimer(CALLBACK(src, PROC_REF(state_message), message), delay, TIMER_DELETE_ME)


/obj/machinery/oneuse_chipmachine/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	if(!speaking)
		// No pay-to-win!
		if(istype(W,/obj/item/spacecash))
			state_message("Our apologies, but the [UNDERWATER_CASINO_NAME] does not accept payments of any kind. We ask only for your enjoyment of our games and facilities.")
			state_message("Instead, please extend an empty hand before this machine. If this is your first time using this machine this shift, we will provide you with a set of starting chips.", 3 SECONDS)
		if(istype(W,/obj/item/spacecasinocash))
			state_message("Our apologies, but the [UNDERWATER_CASINO_NAME] does not convert chips to money.")
			state_message("We do not require money to run our facilities. By that same token, you do not need money to enjoy them.", 3 SECONDS)

/obj/machinery/oneuse_chipmachine/attack_hand(mob/user)
	if(user.ckey in used_ckeys)
		if(!speaking)
			state_message("You have already received your chips for this shift.")
			state_message("The [UNDERWATER_CASINO_NAME] allows only [amt_chips_to_dispense] chips to be given per visitor, regardless of financial status.", 3 SECONDS)
	else
		spawn_casinochips(amt_chips_to_dispense, src.loc, user)
		playsound(loc, 'sound/items/vending.ogg', 50, 1)
		state_message("Thank you for visiting the [UNDERWATER_CASINO_NAME]. Please accept these complementary chips and enjoy your stay.", 1 SECONDS)
		used_ckeys += user.ckey

// ******************************
// *****       AREAS       ******
// ******************************

/area/redgate/underwater_casino
	name = UNDERWATER_CASINO_NAME
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/water/underwater

/area/redgate/underwater_casino/indoors
	name = UNDERWATER_CASINO_NAME + " Interior"
	requires_power = FALSE

// Upper floors

/area/redgate/underwater_casino/indoors/upper
	name = UNDERWATER_CASINO_NAME + " - Top Floor"
	icon_state = "deck2"
	base_turf = /turf/simulated/open

/area/redgate/underwater_casino/indoors/upper/hall
	name = UNDERWATER_CASINO_NAME + " - Halls (Top Floor)"
	ambience = AMBIENCE_CASINO

/area/redgate/underwater_casino/indoors/upper/maintenance
	name = UNDERWATER_CASINO_NAME + " - Maintenance (Top Floor)"
	icon_state = "deckmaint2"
	sound_env = TUNNEL_ENCLOSED

/area/redgate/underwater_casino/indoors/upper/bar
	name = UNDERWATER_CASINO_NAME + " - Bar"
	icon = 'icons/turf/areas.dmi'
	icon_state = "bar"
	sound_env = LARGE_ENCLOSED

/area/redgate/underwater_casino/indoors/upper/lounge
	name = UNDERWATER_CASINO_NAME + " - Lounge"
	icon_state = "grewhicir"
	sound_env = SMALL_SOFTFLOOR

/area/redgate/underwater_casino/indoors/upper/kitchen
	name = UNDERWATER_CASINO_NAME + " - Kitchen"
	icon = 'icons/turf/areas.dmi'
	icon_state = "kitchen"

/area/redgate/underwater_casino/indoors/upper/entry
	name = UNDERWATER_CASINO_NAME + " - Entry"
	icon_state = "redwhitri"

/area/redgate/underwater_casino/indoors/upper/shop
	name = UNDERWATER_CASINO_NAME + " - Shop"
	icon_state = "bluwhisqu"

/area/redgate/underwater_casino/indoors/upper/janitorcloset
	name = UNDERWATER_CASINO_NAME + " - Janitorial Supply Closet"
	icon_state = "bluwhitri"

/area/redgate/underwater_casino/indoors/upper/bathroom
	name = UNDERWATER_CASINO_NAME + " - Bathroom"
	sound_env = SOUND_ENVIRONMENT_BATHROOM
	icon = 'icons/turf/areas.dmi'
	icon_state = "toilet"

/area/redgate/underwater_casino/indoors/upper/comms
	name = UNDERWATER_CASINO_NAME + " - Communications"
	icon_state = "yellow"

/area/redgate/underwater_casino/indoors/upper/vacant
	name = UNDERWATER_CASINO_NAME + " - Vacant Site"
	icon = 'icons/turf/areas.dmi'
	icon_state = "vacant_site"

/area/redgate/underwater_casino/indoors/upper/barback
	name = UNDERWATER_CASINO_NAME + " - Bar Vacant Site (Top Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "vacant_site"

/area/redgate/underwater_casino/indoors/upper/airlock
	name = UNDERWATER_CASINO_NAME + " - Airlock"
	icon = 'icons/turf/areas.dmi'
	icon_state = "green"

/area/redgate/underwater_casino/indoors/upper/airlock/west
	name = UNDERWATER_CASINO_NAME + " - Airlock (West)"

/area/redgate/underwater_casino/indoors/upper/airlock/east
	name = UNDERWATER_CASINO_NAME + " - Airlock (East)"

/area/redgate/underwater_casino/indoors/upper/airlock/south
	name = UNDERWATER_CASINO_NAME + " - Airlock (South)"

/area/redgate/underwater_casino/indoors/upper/casino
	name = UNDERWATER_CASINO_NAME + " - Game Floor"
	icon = 'icons/turf/areas.dmi'
	icon_state = "casino"
	ambience = AMBIENCE_CASINO

/area/redgate/underwater_casino/indoors/upper/casino/back
	name = UNDERWATER_CASINO_NAME + " - Game Floor (Back Room)"
	icon_state = "casino2"

/area/redgate/underwater_casino/indoors/upper/casino/slots
	name = UNDERWATER_CASINO_NAME + " - Game Floor (Slot Machines)"
	icon_state = "casino2"

/area/redgate/underwater_casino/indoors/upper/security
	name = UNDERWATER_CASINO_NAME + " - Security (Top Floor)"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "security"

/area/redgate/underwater_casino/indoors/upper/security
	name = UNDERWATER_CASINO_NAME + " - Security Meeting Room"

// Lower floors

/area/redgate/underwater_casino/indoors/lower
	name = UNDERWATER_CASINO_NAME + " - Bottom Floor"
	icon_state = "deck1"
	base_turf = /turf/simulated/mineral/floor

/area/redgate/underwater_casino/indoors/lower/hall
	name = UNDERWATER_CASINO_NAME + " - Halls (Bottom Floor)"
	ambience = AMBIENCE_CASINO

/area/redgate/underwater_casino/indoors/lower/maintenance
	name = UNDERWATER_CASINO_NAME + " - Maintenance (Bottom Floor)"
	sound_env = TUNNEL_ENCLOSED
	icon_state = "deckmaint1"

/area/redgate/underwater_casino/indoors/lower/barback
	name = UNDERWATER_CASINO_NAME + " - Bar Vacant Site (Bottom Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "vacant_site"

/area/redgate/underwater_casino/indoors/lower/autoresleeving
	name = UNDERWATER_CASINO_NAME + " - Auto Resleeving"
	icon_state = "medical"

/area/redgate/underwater_casino/indoors/lower/resleeving
	name = UNDERWATER_CASINO_NAME + " - Resleeving"
	icon_state = "medical"

/area/redgate/underwater_casino/indoors/lower/laundry
	name = UNDERWATER_CASINO_NAME + " - Laundry"
	icon = 'icons/turf/areas.dmi'
	icon_state = "laundry"

/area/redgate/underwater_casino/indoors/lower/dorms
	name = UNDERWATER_CASINO_NAME + " - Dorms"
	flags = RAD_SHIELDED | BLUE_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FORBID_EVENTS | AREA_FORBID_SINGULO | AREA_SOUNDPROOF | AREA_ALLOW_LARGE_SIZE | AREA_BLOCK_SUIT_SENSORS | AREA_BLOCK_TRACKING | AREA_BLOCK_INSTANT_BUILDING

/area/redgate/underwater_casino/indoors/lower/dorms/dorm1
	name = UNDERWATER_CASINO_NAME + " - Dormitory One"
	icon_state = "dorm1"

/area/redgate/underwater_casino/indoors/lower/dorms/dorm2
	name = UNDERWATER_CASINO_NAME + " - Dormitory Two"
	icon_state = "dorm2"

/area/redgate/underwater_casino/indoors/lower/dorms/dorm3
	name = UNDERWATER_CASINO_NAME + " - Dormitory Three"
	icon_state = "dorm3"

/area/redgate/underwater_casino/indoors/lower/dorms/dorm4
	name = UNDERWATER_CASINO_NAME + " - Dormitory Four"
	icon_state = "dorm3"

/area/redgate/underwater_casino/indoors/lower/dorms/vip
	name = UNDERWATER_CASINO_NAME + " - VIP Suite"
	icon = 'icons/turf/areas.dmi'
	icon_state = "Sleep"

/area/redgate/underwater_casino/indoors/lower/dorms/vip/kitchen
	name = UNDERWATER_CASINO_NAME + " - VIP Suite Kitchen"
	icon_state = "kitchen"

/area/redgate/underwater_casino/indoors/lower/dorms/vip/bath
	name = UNDERWATER_CASINO_NAME + " - VIP Suite Bathroom"
	icon_state = "toilet"

/area/redgate/underwater_casino/indoors/lower/dorms/vip/bedroom
	name = UNDERWATER_CASINO_NAME + " - VIP Suite Bedroom"

/area/redgate/underwater_casino/indoors/lower/dorms/secret
	name = UNDERWATER_CASINO_NAME + " - The Back Dorm"
	icon = 'icons/turf/areas.dmi'
	icon_state = "Sleep"

/area/redgate/underwater_casino/indoors/lower/dorms/privategameroom1
	name = UNDERWATER_CASINO_NAME + " - Private Game Room One"
	icon = 'icons/turf/areas.dmi'
	icon_state = "casino"

/area/redgate/underwater_casino/indoors/lower/dorms/privategameroom2
	name = UNDERWATER_CASINO_NAME + " - Private Game Room Two"
	icon = 'icons/turf/areas.dmi'
	icon_state = "casino2"

/area/redgate/underwater_casino/indoors/lower/arcade
	name = UNDERWATER_CASINO_NAME + " - Arcade"
	icon = 'icons/turf/areas.dmi'
	icon_state = "arcade"

/area/redgate/underwater_casino/indoors/lower/boxing
	name = UNDERWATER_CASINO_NAME + " - The Ring"
	icon_state = "red"

/area/redgate/underwater_casino/indoors/lower/security
	name = UNDERWATER_CASINO_NAME + " - Security (Bottom Floor)"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "security"

/area/redgate/underwater_casino/indoors/lower/security/armory
	name = UNDERWATER_CASINO_NAME + " - Armory"
	icon_state = "armory"

// Misc. areas (caves, secret buildings etc)
/area/redgate/underwater_casino/indoors/upper/secret
	name = UNDERWATER_CASINO_NAME + " - ??? (Top Floor)"

/area/redgate/underwater_casino/indoors/lower/secret
	name = UNDERWATER_CASINO_NAME + " - ??? (Bottom Floor)"

/area/redgate/underwater_casino/indoors/upper/secret/researchbase
	name = UNDERWATER_CASINO_NAME + " - Secret Research Base"
	icon = 'icons/turf/areas.dmi'
	icon_state = "purple"

/area/redgate/underwater_casino/indoors/upper/secret/cave
	name = UNDERWATER_CASINO_NAME + " - Cave (Top Floor)"
	sound_env = SOUND_ENVIRONMENT_CAVE

/area/redgate/underwater_casino/indoors/lower/secret/cave
	name = UNDERWATER_CASINO_NAME + " - Cave (Bottom Floor)"
	sound_env = SOUND_ENVIRONMENT_CAVE

/area/redgate/underwater_casino/indoors/upper/secret/piratebase
	name = UNDERWATER_CASINO_NAME + " - Pirate Base (Top Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "red"

/area/redgate/underwater_casino/indoors/lower/secret/piratebase
	name = UNDERWATER_CASINO_NAME + " - Pirate Base (Bottom Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "red"

/area/redgate/underwater_casino/indoors/upper/secret/piratebasetunnel
	name = UNDERWATER_CASINO_NAME + " - Secret Tunnel (Top Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "red"
	sound_env = TUNNEL_ENCLOSED

/area/redgate/underwater_casino/indoors/lower/secret/piratebasetunnel
	name = UNDERWATER_CASINO_NAME + " - Secret Tunnel (Bottom Floor)"
	icon = 'icons/turf/areas.dmi'
	icon_state = "red"
	sound_env = TUNNEL_ENCLOSED

/area/redgate/underwater_casino/indoors/upper/secret/biodome
	name = UNDERWATER_CASINO_NAME + " - Biodome"
	icon = 'icons/turf/areas.dmi'
	icon_state = "green"
	sound_env = SMALL_ENCLOSED

// Outdoors areas

/area/redgate/underwater_casino/outdoors
	name = UNDERWATER_CASINO_NAME + " Exterior"
	icon_state = "blublacir"
	sound_env = SOUND_ENVIRONMENT_UNDERWATER
