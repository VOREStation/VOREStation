/obj/machinery/contraband_scanner
	name = "contraband scanner"
	gender = PLURAL
	icon = 'icons/obj/atm_fieldgen.dmi'
	icon_state = "arfg_off"
	desc = "A simple scanner that analyzes those who pass over it, and sounds an alarm if it detects any items that are programmed into its contraband list."
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 250

	var/deep_scan = TRUE		//check more than just their hands/pockets?
	var/contraband_count = 0	//how many items have we detected? only one actually needs to be found to set off the alarm
	var/area_lockdown 	= TRUE	//do we set off the fire alarm for our area when triggered?
	var/close_blastdoors 	= TRUE	//close all blast doors in the area when triggered?
	var/power_fields	= TRUE	//do we activate all ARFs when triggered? use w/ impassable fieldgens. requires area_lockdown = TRUE to do anything.

	var/last_trigger			//when were we last triggered? combined with the cooldown below for sanity reasons
	var/cooldown		= 15 SECONDS	//minimum time between retriggers, so people can't spam trigger the scanner to be obnoxious
	var/auto_cancel		= TRUE	//automatically cancel alarm states after a delay? same duration as the cooldown for sanity
	var/trigger_message	=	"The contraband scanner has been tripped!"
	var/trigger_sound	=	'sound/machines/airalarm.ogg'	//sound that plays when we're set off

	var/list/contraband = list(/obj/item/melee,/obj/item/gun,/obj/item/material)

/obj/machinery/contraband_scanner/Crossed(mob/living/M as mob)
	if(M.is_incorporeal())
		return
	if(isliving(M))
		var/area/A = src.loc.loc
		if(last_trigger > world.time - cooldown)
			return
		for(var/obj/O in M.contents)
			if(is_type_in_list(O,contraband))
				contraband_count++
			if(deep_scan)
				for(var/obj/O2 in O.contents)	//one layer deep is fine for now I think
					if(is_type_in_list(O2,contraband))
						contraband_count++
		if(contraband_count && last_trigger < world.time - cooldown)
			visible_message(span_danger(trigger_message))
			playsound(src, trigger_sound, 25, 0, 4, volume_channel = VOLUME_CHANNEL_ALARMS)
			for(var/obj/machinery/contraband_scanner/CS in A)
				CS.last_trigger = world.time	//set everyone's trigger time at once, to cut down on spam
				CS.contraband_count = 0		//clear all our contraband counts too
			if(area_lockdown)
				if(close_blastdoors)
					for(var/obj/machinery/door/blast/B in A)
						if(!B.density)
							spawn(0)
								B.close()
				if(power_fields)
					A.arfgs_activate()
				if(auto_cancel)
					spawn(cooldown)
						if(close_blastdoors)
							for(var/obj/machinery/door/blast/B in A)
								if(B.density)
									spawn(0)
										B.open()
						if(power_fields)
							A.arfgs_deactivate()

	..()
