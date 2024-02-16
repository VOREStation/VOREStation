/obj/machinery/power/supermatter
	description_info = "When energized by a laser (or something hitting it), it emits radiation and heat.  If the heat reaches above 7000 kelvin, it will send an alert and start taking damage. \
	After integrity falls to zero percent, it will delaminate, causing a massive explosion, station-wide radiation spikes, and hallucinations. \
	Supermatter reacts badly to oxygen in the atmosphere.  It'll also heat up really quick if it is in vacuum.<br>\
	<br>\
	Supermatter cores are extremely dangerous to be close to, and requires protection to handle properly.  The protection you will need is:<br>\
	Optical meson scanners on your eyes, to prevent hallucinations when looking at the supermatter.<br>\
	Radiation helmet and suit, as the supermatter is radioactive.<br>\
	<br>\
	Touching the supermatter will result in *instant death*, with no corpse left behind!  You can drag the supermatter, but anything else will kill you. \
	It is advised to obtain a genetic backup before trying to drag it."

	description_antag = "Exposing the supermatter to oxygen or vacuum will cause it to start rapidly heating up.  Sabotaging the supermatter and making it explode will \
	cause a period of lag as the explosion is processed by the server, as well as irradiating the entire station and causing hallucinations to happen.  \
	Wearing radiation equipment will protect you from most of the delamination effects sans explosion."

/obj/machinery/power/apc
	description_info = "An APC (Area Power Controller) regulates and supplies backup power for the area they are in. Their power channels are divided \
	out into 'environmental' (Items that manipulate airflow and temperature), 'lighting' (the lights), and 'equipment' (Everything else that consumes power).  \
	Power consumption and backup power cell charge can be seen from the interface, further controls (turning a specific channel on, off or automatic, \
	toggling the APC's ability to charge the backup cell, or toggling power for the entire area via master breaker) first requires the interface to be unlocked \
	with an ID with Engineering access or by one of the station's robots or the artificial intelligence."

	description_antag = "This can be emagged to unlock it.  It will cause the APC to have a blue error screen. \
	Wires can be pulsed remotely with a signaler attached to it.  A powersink will also drain any APCs connected to the same wire the powersink is on."

/obj/item/inflatable
	description_info = "Inflate by using it in your hand.  The inflatable barrier will inflate on your tile.  To deflate it, use the 'deflate' verb.  \
	You can also inflate this on an adjacent tile by clicking the tile."

/obj/structure/inflatable
	description_info = "To remove these safely, use the 'deflate' verb, or alt-click on it.  Hitting these with any objects will probably puncture and break it forever."

/obj/structure/inflatable/door
	description_info = "Click the door to open or close it.  It only stops air while closed.<br>\
	To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."

/obj/machinery/door/get_description_interaction()
	var/list/results = list()
	//VOREstation Edit: Removing material requirements
	if((health < maxhealth) && !(stat & BROKEN))
		results += "[desc_panel_image("welder")]to start repairing damage."
	//VOREstation Edit End
	return results

/obj/machinery/door/airlock/get_description_interaction()
	description_info = "To ring an airlock's doorbell, hold Alt and click on the airlock with the Left Mouse Button on Green/Help intent.  Doing the same on Harm intent will instead hammer on the airlock." //vorestation edit
	
	var/list/results = list()

	if(can_remove_electronics())
		results += "[desc_panel_image("crowbar")]to remove the airlock electronics."
	else
		results += "[desc_panel_image("crowbar")]to open or close if unpowered/broken, and unbolted."

	if(welded)
		results += "[desc_panel_image("welder")]to unweld, allowing it to open again."
	else
		results += "[desc_panel_image("welder")]to weld, preventing it from opening."

	if(p_open)
		results += "[desc_panel_image("screwdriver")]to close the wire panel."
		results += "[desc_panel_image("wirecutters")]to cut an internal wire while hacking."
		results += "[desc_panel_image("multitool")]to pulse an internal wire while hacking."
	else
		results += "[desc_panel_image("screwdriver")]to open the wire panel, enabling the ability to hack."

	results += ..()

	return results

/obj/machinery/portable_atmospherics/canister/get_description_interaction()
	var/list/results = list()

	results += "[desc_panel_image("wrench")]to connect or disconnect from a connector port below."
	results += "[desc_panel_image("air tank")]to fill the air tank from this canister."

	return results
