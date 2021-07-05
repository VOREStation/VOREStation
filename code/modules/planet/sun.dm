/datum/sun_holder
	var/atom/movable/sun_visuals/sun = new
	var/datum/planet/our_planet

	var/our_color = "#FFFFFF"
	var/our_brightness = 1.0

/datum/sun_holder/New(var/source)
	our_planet = source

/datum/sun_holder/proc/update_color(new_color)
	// Doesn't save much work, but might save a smidge of client work
	if(our_color == new_color)
		return
	
	// Visible change
	sun.color = our_color = new_color

/datum/sun_holder/proc/update_brightness(new_brightness, list/turfs)
	// Doesn't save much work, but might save a smidge of client work
	if(our_brightness == new_brightness)
		return
	
	// Store the old for math
	. = our_brightness
	our_brightness = new_brightness
	
	// Visible change
	sun.alpha = round(CLAMP01(our_brightness)*255,1)
	
	// Update dynamic lumcount so darksight and stuff works
	var/difference = . - our_brightness
	for(var/turf/T as anything in turfs)
		T.dynamic_lumcount -= difference
	
/datum/sun_holder/proc/apply_to_turf(turf/T)
	if(sun in T.vis_contents)
		warning("Was asked to add fake sun to [T.x], [T.y], [T.z] despite already having us in it's vis contents")
		return
	T.vis_contents += sun
	T.dynamic_lumcount += our_brightness
	T.set_luminosity(1, TRUE)

/datum/sun_holder/proc/remove_from_turf(turf/T)
	if(!(sun in T.vis_contents))
		warning("Was asked to remove fake sun from [T.x], [T.y], [T.z] despite it not having us in it's vis contents")
		return
	T.vis_contents -= sun
	T.dynamic_lumcount -= our_brightness
	T.set_luminosity(!IS_DYNAMIC_LIGHTING(T), TRUE)

/datum/sun_holder/proc/rainbow()
	var/end = world.time + 30 SECONDS
	
	var/col_index = 1
	
	var/list/colors = list("#ff5d5d","#ffd17b","#ffff5e","#7eff7e","#6868ff","#b753ff","#d08fff","#ffffff")
	var/original_brightness = sun.alpha/255
	var/original_color = sun.color
	
	update_brightness(0.8)
	
	while(world.time < end)
		update_color(colors[col_index])
		if(++col_index > colors.len)
			col_index = 1
		sleep(3)
	
	update_brightness(original_brightness)
	update_color(original_color)

// Holds a full white icon that can be mutated to make sun on the O_LIGHTING plane
/atom/movable/sun_visuals
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flash"
	plane = PLANE_O_LIGHTING_VISUAL
	mouse_opacity = 0
	alpha = 0
	color = "#FFFFFF"
