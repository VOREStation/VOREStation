//todo, figure out a better place for this
/proc/get_humanoid_displacement_map_image(var/mob/living/carbon/human/target,var/list/discarded_layer_indicies, var/icon/displacement_map, var/outlineWidth = 0, var/render_target = null)

	var/list/to_overlays = target.overlays_standing.Copy()

	for(var/layer_to_kill in discarded_layer_indicies)
		to_overlays[layer_to_kill] = null

	var/image/displacement_render_image = image(icon = null, icon_state = "empty", dir = SOUTH)
	displacement_render_image.appearance_flags = KEEP_TOGETHER
	displacement_render_image.overlays = to_overlays

	displacement_render_image.filters += filter(type = "displace", size = 128, icon=displacement_map) //size is 128 because that's the god given standard. if you're doing something unhinged enough to need a bigger or smaller size, by all means.
	if(outlineWidth)
		displacement_render_image.filters += filter(type="outline", size = outlineWidth)
	if(render_target)
		displacement_render_image.render_target = render_target

	return displacement_render_image
