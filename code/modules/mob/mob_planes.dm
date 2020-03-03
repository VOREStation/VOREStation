//////////////////////////////////////////////
// These planemaster objects are created on mobs when a client logs into them (lazy). We'll use them to adjust the visibility of objects, among other things.
//

/datum/plane_holder
	var/mob/my_mob
	var/list/plane_masters[VIS_COUNT]

/datum/plane_holder/New(mob/this_guy)
	ASSERT(ismob(this_guy))
	my_mob = this_guy

	//It'd be nice to lazy init these but some of them are important to just EXIST. Like without ghost planemaster, you can see ghosts. Go figure.

	// 'Utility' planes
	plane_masters[VIS_FULLBRIGHT] 	= new /obj/screen/plane_master/fullbright						//Lighting system (lighting_overlay objects)
	plane_masters[VIS_LIGHTING] 	= new /obj/screen/plane_master/lighting							//Lighting system (but different!)
	plane_masters[VIS_GHOSTS] 		= new /obj/screen/plane_master/ghosts							//Ghosts!
	plane_masters[VIS_AI_EYE]		= new /obj/screen/plane_master{plane = PLANE_AI_EYE}			//AI Eye!

	plane_masters[VIS_CH_STATUS] 	= new /obj/screen/plane_master{plane = PLANE_CH_STATUS}			//Status is the synth/human icon left side of medhuds
	plane_masters[VIS_CH_HEALTH] 	= new /obj/screen/plane_master{plane = PLANE_CH_HEALTH}			//Health bar
	plane_masters[VIS_CH_LIFE] 		= new /obj/screen/plane_master{plane = PLANE_CH_LIFE}			//Alive-or-not icon
	plane_masters[VIS_CH_ID] 		= new /obj/screen/plane_master{plane = PLANE_CH_ID}				//Job ID icon
	plane_masters[VIS_CH_WANTED] 	= new /obj/screen/plane_master{plane = PLANE_CH_WANTED}			//Wanted status
	plane_masters[VIS_CH_IMPLOYAL] 	= new /obj/screen/plane_master{plane = PLANE_CH_IMPLOYAL}		//Loyalty implants
	plane_masters[VIS_CH_IMPTRACK] 	= new /obj/screen/plane_master{plane = PLANE_CH_IMPTRACK}		//Tracking implants
	plane_masters[VIS_CH_IMPCHEM] 	= new /obj/screen/plane_master{plane = PLANE_CH_IMPCHEM}		//Chemical implants
	plane_masters[VIS_CH_SPECIAL] 	= new /obj/screen/plane_master{plane = PLANE_CH_SPECIAL}		//"Special" role stuff
	plane_masters[VIS_CH_STATUS_OOC]= new /obj/screen/plane_master{plane = PLANE_CH_STATUS_OOC}		//OOC status HUD

	plane_masters[VIS_ADMIN1] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN1}			//For admin use
	plane_masters[VIS_ADMIN2] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN2}			//For admin use
	plane_masters[VIS_ADMIN3] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN3}			//For admin use

	plane_masters[VIS_MESONS]		= new /obj/screen/plane_master{plane = PLANE_MESONS} 			//Meson-specific things like open ceilings.

	plane_masters[VIS_BUILDMODE]	= new /obj/screen/plane_master{plane = PLANE_BUILDMODE}			//Things that only show up while in build mode

	// Real tangible stuff planes
	plane_masters[VIS_TURFS]	= new /obj/screen/plane_master/main{plane = TURF_PLANE}
	plane_masters[VIS_OBJS]		= new /obj/screen/plane_master/main{plane = OBJ_PLANE}
	plane_masters[VIS_MOBS]		= new /obj/screen/plane_master/main{plane = MOB_PLANE}

	..()

/datum/plane_holder/Destroy()
	my_mob = null
	QDEL_LIST_NULL(plane_masters) //Goodbye my children, be free
	return ..()

/datum/plane_holder/proc/set_vis(var/which = null, var/state = FALSE)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		crash_with("Tried to alter [which] in plane_holder on [my_mob]!")

	if(my_mob.alpha <= EFFECTIVE_INVIS)
		state = FALSE

	PM.set_visibility(state)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_vis(which = SP, state = state)
	var/plane = PM.plane
	if(state && !(plane in my_mob.planes_visible))
		LAZYADD(my_mob.planes_visible, plane)
	else if(!state && (plane in my_mob.planes_visible))
		LAZYREMOVE(my_mob.planes_visible, plane)

/datum/plane_holder/proc/set_desired_alpha(var/which = null, var/new_alpha)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		crash_with("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.set_desired_alpha(new_alpha)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_vis(which = SP, new_alpha = new_alpha)

/datum/plane_holder/proc/set_ao(var/which = null, var/enabled = FALSE)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		crash_with("Tried to set_ao [which] in plane_holder on [my_mob]!")
	PM.set_ambient_occlusion(enabled)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_ao(SP, enabled)

/datum/plane_holder/proc/alter_values(var/which = null, var/list/values = null)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		crash_with("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.alter_plane_values(arglist(values))
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			alter_values(SP, values)

////////////////////
// The Plane Master
////////////////////
/obj/screen/plane_master
	screen_loc = "1,1"
	plane = -100 //Dodge just in case someone instantiates one of these accidentally, don't end up on 0 with plane_master
	appearance_flags = PLANE_MASTER
	mouse_opacity = 0	//Normally unclickable
	alpha = 0	//Hidden from view
	var/desired_alpha = 255	//What we go to when we're enabled
	var/invis_toggle = FALSE
	var/list/sub_planes

/obj/screen/plane_master/New()
	..(null) //Never be in anything ever.

/obj/screen/plane_master/proc/set_desired_alpha(var/new_alpha)
	if(new_alpha != alpha && new_alpha > 0 && new_alpha <= 255)
		desired_alpha = new_alpha
		if(alpha) //If we're already visible, update it now.
			alpha = new_alpha

/obj/screen/plane_master/proc/set_visibility(var/want = FALSE)
	//Invisibility-managed
	if(invis_toggle)
		if(want && invisibility)
			invisibility = 0 //Does not need a mouse_opacity toggle because these are for effects
		else if(!want && !invisibility)
			invisibility = 101
	//Alpha-managed
	else
		if(want && !alpha)
			alpha = desired_alpha
			mouse_opacity = 1 //Not bool, don't replace with true/false
		else if(!want && alpha)
			alpha = 0
			mouse_opacity = 0

/obj/screen/plane_master/proc/set_alpha(var/new_alpha = 255)
	if(new_alpha != alpha)
		new_alpha = sanitize_integer(new_alpha, 0, 255, 255)
		alpha = new_alpha

/obj/screen/plane_master/proc/set_ambient_occlusion(var/enabled = FALSE)
	filters -= AMBIENT_OCCLUSION
	if(enabled)
		filters += AMBIENT_OCCLUSION

/obj/screen/plane_master/proc/alter_plane_values()
	return //Stub

////////////////////
// Special masters
////////////////////

/////////////////
//Lighting is weird and has matrix shenanigans. Think of this as turning on/off darkness.
/obj/screen/plane_master/fullbright
	plane = PLANE_LIGHTING
	layer = LAYER_HUD_BASE+1 // This MUST be above the lighting plane_master
	color = null //To break lighting when visible (this is sorta backwards)
	alpha = 0 //Starts full opaque
	invisibility = 101
	invis_toggle = TRUE

/obj/screen/plane_master/lighting
	plane = PLANE_LIGHTING
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/////////////////
//Ghosts has a special alpha level
/obj/screen/plane_master/ghosts
	plane = PLANE_GHOSTS
	desired_alpha = 127 //When enabled, they're like half-transparent

/////////////////
//The main game planes start normal and visible
/obj/screen/plane_master/main
	alpha = 255
	mouse_opacity = 1
