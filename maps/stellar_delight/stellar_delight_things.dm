/obj/machinery/camera/network/halls
	network = list(NETWORK_HALLS)

/area/tether/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/turf/simulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"
	can_be_plated = FALSE

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
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()


/obj/item/paper/sdshield
	name = "ABOUT THE SHIELD GENERATOR"
	info = "<H1>ABOUT THE SHIELD GENERATOR</H1><BR><BR>If you&#39;re up here you are more than likely worried about hitting rocks or some other such thing. It is good to worry about such things as that is an inevitability.<BR><BR>The Stellar Delight is a rather compact vessel, so a setting of 55 to the range will just barely cover her aft. <BR><BR>It is recommended that you turn off all of the different protection types except multi dimensional warp and whatever it is you&#39;re worried about running into. (probably meteors (hyperkinetic)). <BR><BR>With only those two and all the other default settings, the shield uses more than 6 MW to run, which is more than the ship can ordinarily produce. AS SUCH, it is also recommended that you reduce the input cap to whatever you find reasonable (being as it defaults to 1 MW, which is the entirety of the stock power supply) and activate and configure the shield BEFORE you need it. <BR><BR>The shield takes some time to expand its range to the desired specifications, and on top of that, under the default low power setting, takes around 40 seconds to spool up. Once it is active, the fully charged internal capacitors will last for a few minutes before depleting fully. You can increase the passive energy use to decrease the spool up time, but it also uses the stored energy much faster, so, that is not recommended except in dire emergencies.<BR><BR>So, this shield is not intended to be run indefinitely, unless you seriously beef up the ship&#39;s engine and power supply.<BR><BR>Fortunately, if you&#39;ve got a good pilot, you shouldn&#39;t really need the shield generator except in rare cases and only for short distances. Still, it is a good idea to configure the shield to be ready before you need it.<BR><BR>Good luck out there - <I>Budly Gregington</I>"

/obj/item/book/manual/sd_guide
	name = "Stellar Delight User's Guide"
	icon = 'icons/obj/library.dmi'
	icon_state ="newscodex"
	item_state = "newscodex"
	author = "Central Command"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Stellar Delight User's Guide"

/obj/item/book/manual/sd_guide/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Stellar Delight Operations</h1>
				<br><br>
				Welcome to the Stellar Delight! Before you get started there are a few things you ought to know.
				<br><br>
				The Stellar Delight is a Nanotrasen response vessel operating in the Virgo-Erigone system. It's primary duty is in answering calls for help, investigating anomalies in space around the system, and generally responding to requests from Central Command or whoever else needs the services the vessel can provide. It has fully functioning security, medical, and research facilities, as well as a host of civillian facilities, in addition to the standard things one might expect to find on such a ship. That is to say, the ship doesn't have a highly defined specialization, it is just as capable as a small space station might be.
				<br><br>
				Notably though, there are some research facilities that are not safe to carry around. There is a refurbished Aerostat that has been set up over Virgo 2 that posesses a number of different, more dangerous research facilities.  The command staff of this vessel has access to its docking codes in their offices.
				<br><br>
				Mining and Exploration will probably also want to disembark to do their respective duties.
				<br><br>
				The ship is ordinarily protected from many space hazards by an array of point defense turrets, however, it should be noted that this defense network is not infallible. If the ship encounters a dangerous environment, occasionally hazardous material may slip past the network and damage the ship.
				<br><br><br>
				<h1>Before Moving the Ship</h1>
				<br><br>
				The ship requires power to fuel and run its engines and sensors. While there may be some charge in the ship at the start of the shift, it is <b>HIGHLY RECOMMENDED</b> that the engine be started before attempting to move the ship. If any of the components responsible for moving the ship lose power (including but not limited to the helm control console and the thrusters), then you will be incapable of adjusting the ship's speed or heading until the problem is resolved.
				<br><br>
				Additionally, the shield generator should be configured before the ship moves, as it takes time to calibrate before it can be activated. The shield should not be run indefinitely however, as it uses more power than the ship ordinarily generates. You can however activate it for a short time if you know that you need to proceed through a dangerous reigon of space. For more information, see the configuration guide sheet in the shield control room on deck 3, aft of the Command Office section.
				<br><br><br>
				<h1>Starting and Moving the Ship</h1>
				<br><br>
				The ship can of course move around on its own, but a few steps need to/should be taken before you can do so.
				<br><br>
				-FIRST. <b>You should appoint a pilot.</b> If there isn't a pilot, or the pilot isn't responding, you should fax for a pilot. If no pilots respond to the fax within a reasonable timeframe, then, if you are qualified to fly Nanotrasen spacecraft you may fly the ship. Appointing a pilot to the bridge however should always be done even if you know how to fly and have access to the helm control console. <i><b>Refusing to attempt to appoint a pilot and just flying the ship yourself can be grounds for demotion to pilot.</i></b>
				<br><br>
				-SECOND. In order for the ship to move one must start the engines. The ship's fuel pump in Atmospherics must be turned on and configured. Atmospheric technicians may elect to modify the fuel mix to help the ship go faster or make the fuel last longer. Either way, once the fuel pump is on, you may use the engine control console on the bridge to activate the engines.
				<br><br>
				Once these steps have been taken, the helm control console should respond to input commands from the pilot.
				<br><br><br>
				<h1>Disembarking</h1>
				<br><br>
				Being a response vessel, the Stellar Delight has 3 shuttles in total.
				<br><br>
				The mining and exploration shuttles are located in the aft of deck 1 between their respective departments. Both of these shuttles are short jump shuttles, meaning, they are not suitable for more than ferrying people back and forth between the ship and the present destination. They do have a small range that they can traverse in their bluespace hops, but they must be within one 'grid square' of a suitable landing site to jump. As such, it is recommended that you avoid flying away from wherever either of these shuttles are without establishing a flight plan with the away teams to indicate a time of returning. In cases where the mining team and the exploration team want to go to different places, it may be necessary to fly from one location to the other now and then to facilitate both operations. However, it is recommended that exploration and mining be encouraged to enter the same operations areas, as the mining team is poorly armed, and the exploration team is ideally equipped for offsite defense and support of ship personnel.
				<br><br>
				There is also the Starstuff, a long range capable shuttle which is ordinarily docked on the port landing pad of deck 3. This shuttle is meant for general crew transport, but does require a pilot to be flown.
				<br><br>
				In cases where the shuttles will be docking with another facility, such as the Science outpost on the Virgo 2 Aerostat, docking codes may be required in order to be accessed. Anywhere requiring such codes will need to have them entered into the given shuttle's short jump console. It is recommended that anyone operating such a shuttle take note of the Stellar Delight's docking codes, as they will need them to dock with the ship. Any Nanotrasen owned facility that requires them that your ship has authorization to access will have the codes stored in the Command Offices.
				<br><br>
				A final note on disembarking. While it may not necessarily be their job to do so, it is highly encouraged for the Command staff to attempt to involve volunteers in off ship operations as necessary. Just make sure to let let it be known what kind of operation is happening when you ask. This being a response ship, it is very good to get as much help to handle whatever the issue is as thoroughly as possible.
				<br><br>
				All that said, have a safe trip. - Central Command Officer <i>Alyssa Trems</i>				</body>
			</html>
			"}

// ### Wall Machines On Full Windows ###
// To make sure wall-mounted machines placed on full-tile windows are clickable they must be above the window
//
/obj/item/radio/intercom
	layer = ABOVE_WINDOW_LAYER
/obj/item/storage/secure/safe
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/airlock_sensor
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/alarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/access_button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/guestpass
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/security/telescreen
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/door_timer
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/embedded_controller
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/firealarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/flasher
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/keycard_auth
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/light_switch
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/processing_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/stacking_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/newscaster
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/power/apc
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/requests_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/status_display
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed1
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed2
	layer = ABOVE_WINDOW_LAYER
/obj/structure/fireaxecabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/extinguisher_cabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/mirror
	layer = ABOVE_WINDOW_LAYER
/obj/structure/noticeboard
	layer = ABOVE_WINDOW_LAYER

/obj/item/multitool/scioutpost
	name = "science outpost linked multitool"
	desc = "It has the data for the science outpost's quantum pad pre-loaded... assuming you didn't override it."

/obj/item/multitool/scioutpost/Initialize()
	. = ..()
	for(var/obj/machinery/power/quantumpad/scioutpost/outpost in world)
		connectable = outpost
		if(connectable)
			icon_state = "multitool_red"
		return

/obj/machinery/power/quantumpad/scioutpost
