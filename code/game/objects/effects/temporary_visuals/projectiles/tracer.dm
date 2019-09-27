/datum/beam_components_cache
	var/list/beam_components = list()

/datum/beam_components_cache/Destroy()
	for(var/component in beam_components)
		qdel(component)
	return ..()

/proc/generate_tracer_between_points(datum/point/starting, datum/point/ending, datum/beam_components_cache/beam_components, beam_type, color, qdel_in = 5, light_range = 2, light_color_override, light_intensity = 1, instance_key)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type
	if(isnull(light_color_override))
		light_color_override = color
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	. = PB
	if(isnull(light_intensity) && !isnull(PB.light_power))
		light_intensity = PB.light_power
	if(isnull(light_range) && !isnull(PB.light_range))
		light_range = PB.light_range
	if(isnull(light_color_override) && !isnull(PB.light_color))
		light_color_override = PB.light_color
	if(light_range > 0 && light_intensity > 0)
		var/list/turf/line = getline(starting.return_turf(), ending.return_turf())
		tracing_line:
			for(var/i in line)
				var/turf/T = i
				for(var/obj/effect/projectile_lighting/PL in T)
					if(PL.owner == instance_key)
						continue tracing_line
				beam_components.beam_components += new /obj/effect/projectile_lighting(T, light_color_override, light_range, light_intensity, instance_key)
		line = null
	beam_components.beam_components += PB

/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/obj/projectiles_tracer.dmi'

/obj/effect/projectile/tracer/stun
	icon_state = "stun"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

/obj/effect/projectile/tracer/lightning
	icon_state = "lightning"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/tracer/laser_pulse
	icon_state = "u_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/tracer/emitter
	icon_state = "emitter"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/tracer/darkmatterstun
	icon_state = "darkt"
	light_range = 2
	light_power = 0.5
	light_color = "#8837A3"

/obj/effect/projectile/tracer/laser_omni
	icon_state = "beam_omni"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/tracer/xray
	icon_state = "xray"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/tracer/laser_heavy
	icon_state = "beam_heavy"
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

/obj/effect/projectile/tracer/darkmatter
	icon_state = "darkb"
	light_range = 2
	light_power = 0.5
	light_color = "#8837A3"

/obj/effect/projectile/tracer/inversion
	icon_state = "invert"
	light_range = 2
	light_power = -2
	light_color = "#FFFFFF"

/obj/effect/projectile/tracer/laser
	icon_state = "beam"
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"

/obj/effect/projectile/tracer/laser_blue
	icon_state = "beam_blue"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/tungsten/tracer
	icon_state = "mhd_laser"
	light_range = 4
	light_power = 3
	light_color = "#3300ff"

//VOREStation edit: medigun
/obj/effect/projectile/tracer/medigun
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "medbeam"
	light_range = 2
	light_power = 0.5
	light_color = "#80F5FF"
//VOREStation edit ends