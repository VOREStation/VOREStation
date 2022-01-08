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
	//Note, if you're adding a new plane master, please update code\modules\tgui\modules\camera.dm.

	// 'Utility' planes
	plane_masters[VIS_FULLBRIGHT] 	= new /obj/screen/plane_master/fullbright						//Lighting system (lighting_overlay objects)
	plane_masters[VIS_LIGHTING] 	= new /obj/screen/plane_master/lighting							//Lighting system (but different!)
	plane_masters[VIS_O_LIGHT]		= new /obj/screen/plane_master/o_light_visual					//Object lighting (using masks)
	plane_masters[VIS_EMISSIVE] 	= new /obj/screen/plane_master/emissive							//Emissive overlays
	plane_masters[VIS_OPENSPACE]	= new /obj/screen/plane_master/openspace						//Openspace drop shadows mostly
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

	plane_masters[VIS_STATUS]		= new /obj/screen/plane_master{plane = PLANE_STATUS}			//Status indicators that show over mob heads.

	plane_masters[VIS_ADMIN1] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN1}			//For admin use
	plane_masters[VIS_ADMIN2] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN2}			//For admin use
	plane_masters[VIS_ADMIN3] 		= new /obj/screen/plane_master{plane = PLANE_ADMIN3}			//For admin use

	plane_masters[VIS_MESONS]		= new /obj/screen/plane_master{plane = PLANE_MESONS} 			//Meson-specific things like open ceilings.

	plane_masters[VIS_BUILDMODE]	= new /obj/screen/plane_master{plane = PLANE_BUILDMODE}			//Things that only show up while in build mode

	// Real tangible stuff planes
	plane_masters[VIS_TURFS]	= new /obj/screen/plane_master/main{plane = TURF_PLANE}
	plane_masters[VIS_OBJS]		= new /obj/screen/plane_master/main{plane = OBJ_PLANE}
	plane_masters[VIS_MOBS]		= new /obj/screen/plane_master/main{plane = MOB_PLANE}
	plane_masters[VIS_CLOAKED]	= new /obj/screen/plane_master/cloaked								//Cloaked atoms!

	..()

	for(var/obj/screen/plane_master/PM as anything in plane_masters)
		PM.backdrop(my_mob)

/datum/plane_holder/Destroy()
	my_mob = null
	QDEL_LIST_NULL(plane_masters) //Goodbye my children, be free
	return ..()

/datum/plane_holder/proc/set_vis(var/which = null, var/state = FALSE)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")

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
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.set_desired_alpha(new_alpha)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_vis(which = SP, state = !!new_alpha)

/datum/plane_holder/proc/set_ao(var/which = null, var/enabled = FALSE)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to set_ao [which] in plane_holder on [my_mob]!")
	PM.set_ambient_occlusion(enabled)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_ao(SP, enabled)

/datum/plane_holder/proc/alter_values(var/which = null, var/list/values = null)
	ASSERT(which)
	var/obj/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.alter_plane_values(arglist(values))
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			alter_values(SP, values)


	

////////////////////
// The Plane Master
////////////////////
/obj/screen/plane_master
	screen_loc = "CENTER"
	plane = -100 //Dodge just in case someone instantiates one of these accidentally, don't end up on 0 with plane_master
	appearance_flags = PLANE_MASTER
	vis_flags = NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT	//Normally unclickable
	alpha = 0	//Hidden from view
	var/desired_alpha = 255	//What we go to when we're enabled
	var/invis_toggle = FALSE
	var/list/sub_planes

/obj/screen/plane_master/Initialize()
	. = ..()
	if(loc)
		moveToNullspace() //Never be in anything ever.

/obj/screen/plane_master/proc/backdrop(mob/mymob)

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

/obj/screen/plane_master/lighting/backdrop(mob/mymob)
	/* I'm unconvinced.
	mymob.overlay_fullscreen("lighting_backdrop_lit", /obj/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /obj/screen/fullscreen/lighting_backdrop/unlit)
	*/

/*!
 * This system works by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 */

/obj/screen/plane_master/lighting/Initialize()
	. = ..()
	add_filter("emissives", 1, alpha_mask_filter(render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE))
	add_filter("object_lighting", 2, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE))

/obj/screen/plane_master/o_light_visual
	plane = PLANE_O_LIGHTING_VISUAL
	render_target = O_LIGHTING_VISUAL_RENDER_TARGET
	blend_mode = BLEND_MULTIPLY
	alpha = 255
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR // NO_CLIENT_COLOR because it has some naughty interactions with colorblindness that I can't figure out. Byond bug?

/obj/screen/plane_master/emissive
	plane = PLANE_EMISSIVE
	render_target = EMISSIVE_RENDER_TARGET
	alpha = 255

/obj/screen/plane_master/emissive/Initialize()
	. = ..()
	add_filter("em_block_masking", 1, color_matrix_filter(GLOB.em_mask_matrix))

/////////////////
//Openspace gets some magic filters for layers
/obj/screen/plane_master/openspace
	plane = OPENSPACE_BACKDROP_PLANE
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/obj/screen/plane_master/openspace/Initialize()
	. = ..()
	//add_filter("multiz_lighting_mask", 1, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE)) // Makes fake planet lights not work right
	add_filter("first_stage_openspace", 2, drop_shadow_filter(color = "#04080FAA", size = -10))
	add_filter("second_stage_openspace", 3, drop_shadow_filter(color = "#04080FAA", size = -15))
	//add_filter("third_stage_openspace", 4, drop_shadow_filter(color = "#04080FAA", size = -20)) // TOO dark

/////////////////
//Ghosts has a special alpha level
/obj/screen/plane_master/ghosts
	plane = PLANE_GHOSTS
	desired_alpha = 127 //When enabled, they're like half-transparent

/////////////////
//Cloaked atoms are visible to ghosts (or for other reasons?)
/obj/screen/plane_master/cloaked
	plane = CLOAKED_PLANE
	desired_alpha = 80
	color = "#0000FF"

/////////////////
//The main game planes start normal and visible
/obj/screen/plane_master/main
	alpha = 255
	mouse_opacity = 1
