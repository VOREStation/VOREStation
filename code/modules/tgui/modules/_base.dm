/*
TGUI MODULES

This allows for datum-based TGUIs that can be hooked into objects.
This is useful for things such as the power monitor, which needs to exist on a physical console in the world, but also as a virtual device the AI can use

Code is pretty much ripped verbatim from nano modules, but with un-needed stuff removed
*/
/datum/tgui_module
	var/name
	var/datum/host
	var/list/using_access

	var/tgui_id
	var/ntos = FALSE

/datum/tgui_module/New(var/host)
	src.host = host
	if(ntos)
		tgui_id = "Ntos" + tgui_id

/datum/tgui_module/tgui_host()
	return host ? host.tgui_host() : src

/datum/tgui_module/tgui_close(mob/user)
	if(host)
		host.tgui_close(user)

/datum/tgui_module/proc/check_eye(mob/user)
	return -1

/datum/tgui_module/proc/can_still_topic(mob/user, datum/tgui_state/state)
	return (tgui_status(user, state) == STATUS_INTERACTIVE)

/datum/tgui_module/proc/check_access(mob/user, access)
	if(!access)
		return 1

	if(using_access)
		if(access in using_access)
			return 1
		else
			return 0

	if(!istype(user))
		return 0

	var/obj/item/weapon/card/id/I = user.GetIdCard()
	if(!I)
		return 0

	if(access in I.access)
		return 1

	return 0

/datum/tgui_module/tgui_static_data()
	. = ..()
	
	var/obj/item/modular_computer/host = tgui_host()
	if(istype(host))
		. += host.get_header_data()

/datum/tgui_module/tgui_act(action, params)
	if(..())
		return TRUE

	var/obj/item/modular_computer/host = tgui_host()
	if(istype(host))
		if(action == "PC_exit")
			host.kill_program()
			return TRUE
		if(action == "PC_shutdown")
			host.shutdown_computer()
			return TRUE
		if(action == "PC_minimize")
			host.minimize_program(usr)
			return TRUE

// Just a nice little default interact in case the subtypes don't need any special behavior here
/datum/tgui_module/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name)
		ui.open()

// This is a helper for anything that wants to render the map.
/datum/tgui_module/proc/get_plane_masters()
	. = list()
	// 'Utility' planes
	. += new /obj/screen/plane_master/fullbright						//Lighting system (lighting_overlay objects)
	. += new /obj/screen/plane_master/lighting							//Lighting system (but different!)
	. += new /obj/screen/plane_master/ghosts							//Ghosts!
	. += new /obj/screen/plane_master{plane = PLANE_AI_EYE}			//AI Eye!

	. += new /obj/screen/plane_master{plane = PLANE_CH_STATUS}			//Status is the synth/human icon left side of medhuds
	. += new /obj/screen/plane_master{plane = PLANE_CH_HEALTH}			//Health bar
	. += new /obj/screen/plane_master{plane = PLANE_CH_LIFE}			//Alive-or-not icon
	. += new /obj/screen/plane_master{plane = PLANE_CH_ID}				//Job ID icon
	. += new /obj/screen/plane_master{plane = PLANE_CH_WANTED}			//Wanted status
	. += new /obj/screen/plane_master{plane = PLANE_CH_IMPLOYAL}		//Loyalty implants
	. += new /obj/screen/plane_master{plane = PLANE_CH_IMPTRACK}		//Tracking implants
	. += new /obj/screen/plane_master{plane = PLANE_CH_IMPCHEM}		//Chemical implants
	. += new /obj/screen/plane_master{plane = PLANE_CH_SPECIAL}		//"Special" role stuff
	. += new /obj/screen/plane_master{plane = PLANE_CH_STATUS_OOC}		//OOC status HUD

	. += new /obj/screen/plane_master{plane = PLANE_ADMIN1}			//For admin use
	. += new /obj/screen/plane_master{plane = PLANE_ADMIN2}			//For admin use
	. += new /obj/screen/plane_master{plane = PLANE_ADMIN3}			//For admin use

	. += new /obj/screen/plane_master{plane = PLANE_MESONS} 			//Meson-specific things like open ceilings.
	. += new /obj/screen/plane_master{plane = PLANE_BUILDMODE}			//Things that only show up while in build mode

	// Real tangible stuff planes
	. += new /obj/screen/plane_master/main{plane = TURF_PLANE}
	. += new /obj/screen/plane_master/main{plane = OBJ_PLANE}
	. += new /obj/screen/plane_master/main{plane = MOB_PLANE}
	. += new /obj/screen/plane_master/cloaked								//Cloaked atoms!

	//VOREStation Add - Random other plane masters
	. += new /obj/screen/plane_master{plane = PLANE_CH_STATUS_R}			//Right-side status icon
	. += new /obj/screen/plane_master{plane = PLANE_CH_HEALTH_VR}			//Health bar but transparent at 100
	. += new /obj/screen/plane_master{plane = PLANE_CH_BACKUP}				//Backup implant status
	. += new /obj/screen/plane_master{plane = PLANE_CH_VANTAG}				//Vore Antags
	. += new /obj/screen/plane_master{plane = PLANE_AUGMENTED}				//Augmented reality
	//VOREStation Add End