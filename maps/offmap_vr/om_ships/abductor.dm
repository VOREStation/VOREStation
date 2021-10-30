// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "abductor.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/abductor
	name = "OM Ship - Abductor Ship (New Z)"
	desc = "A ship for spooky aliens to kidnap farmers and unfortunate spacemen."
	mappath = 'abductor.dmm'

/area/abductor
	requires_power = 0
	icon_state = "purple"

/area/abductor/
	name = "Abductor Ship"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/abductor/interior
	name = "Abductor Ship Interior"

/area/abductor/exterior
	name = "Abductor Ship Exterior"
	has_gravity = 0

// The 'Abductor Ship'
/obj/effect/overmap/visitable/ship/abductor
	name = "strange spacecraft"
	desc = "Spacefaring vessel."
	icon_state = "unkn_r"
	scanner_desc = @{"[i]Registration[/i]: Unknown
[i]Class[/i]: Corvette
[i]Transponder[/i]: No transponder detected."
[b]Notice[/b]: Deep scans detect unknown power signatures, and onboard transporter technology."}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("abductor_port", "abductor_starboard")
	fore_dir = NORTH
	known = FALSE

/obj/item/weapon/paper/alien/abductor
	name = "Read Me"
	info = {"<b>((Just to state the obvious here, but make sure you're reading OOC notes and all that. This role does not give you any special protections from the rules. Only abduct people who seem like they'd be cool with it.))</b><br><br>

Your mission is to travel out into space to retrieve individuals to experiment upon.<br><br>

Just what experiments you do are up to you, thought it should be noted, we can't do experiments on corpses, so you should be careful not to kill anyone in the process of acquiring your subject. Needless killing is grounds for termination from the organization.<br><br>

The experimentation process however can be fatal if necessary, so long as we get good data. ((And the person's cool with it OOCly))<br><br>

You will find that the ship is equipped with transporter technology. There are teleporters to the outside world on both the port and starboard sides. Each of the experimentation chambers is also outfitted with an advanced translocator device that is linked to its given room. You will want to ensure that you take a translocator device with you BEFORE you leave the ship, as there will be no other way for you to return without assistance.<br><br>

Your translocator device is arguably your most critical piece of equipment, and it is imperative that you not lose it, as possessing it would allow outsiders access to the ship.<br><br>

The center of the ship sports the shield generator, as well as the chemical and resleeving labs. It would be wise to ensure that if your experiments are fatal, to scan the mind and body of your subject before you proceed, so we can ensure that we can return the subjects to where we find them.<br><br>

To the starboard and port sides you will find a total of six experimentation rooms, and two transporter rooms, as well as two engine rooms at the aft.<br><br>

The aft center of the ship is the common equipment room. The items here are limited in quantity, so only take what you intend to use in your given task.<br><br>

At the fore of the vessel are the briefing rooms, and the bridge.<br><br>

Lastly, there are camera uplink consoles scattered around the ship. It is recommended that you take stock of where potential targets are before you depart.<br><br>

You will find a dispenser within the room you started in which contains some basic equipment that you may wish to take with you. Please do not loot the dispensers from other rooms unless the one assigned to it is okay with it.<br><br>

<b>And finally, to leave this room, you will want to put your ID on the table, and pray to the corporate overlords to add access 777 to it.</b>"}

/obj/machinery/porta_turret/alien/abductor
	name = "anti-personnel turret"
	installation = /obj/item/weapon/gun/energy/gun/taser
	lethal = FALSE
	health = 500 // Sturdier turrets, non-lethal, for capturing people alive
	maxhealth = 500
	req_one_access = list(777) // The code I've been using for events, same as the doors

/obj/machinery/porta_turret/alien/abductor/ion
	name = "anti-personnel turret"
	installation = /obj/item/weapon/gun/energy/ionrifle/weak
	lethal = TRUE

/obj/machinery/power/rtg/abductor/built/abductor
	name = "Void Core"
	power_gen = 5000000

