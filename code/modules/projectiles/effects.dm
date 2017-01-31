/obj/effect/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	layer = 20

/obj/effect/projectile/New(var/turf/location)
	if(istype(location))
		loc = location

/obj/effect/projectile/proc/set_transform(var/matrix/M)
	if(istype(M))
		transform = M

/obj/effect/projectile/proc/activate(var/kill_delay = 5)
	update_light()
	spawn(kill_delay)
		qdel(src)	//see effect_system.dm - sets loc to null and lets GC handle removing these effects

	return

//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser/tracer
	icon_state = "beam"
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"

/obj/effect/projectile/laser/muzzle
	icon_state = "muzzle_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"

/obj/effect/projectile/laser/impact
	icon_state = "impact_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"

//----------------------------
// Blue laser beam
//----------------------------
/obj/effect/projectile/laser_blue/tracer
	icon_state = "beam_blue"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/laser_blue/muzzle
	icon_state = "muzzle_blue"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/laser_blue/impact
	icon_state = "impact_blue"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

//----------------------------
// Omni laser beam
//----------------------------
/obj/effect/projectile/laser_omni/tracer
	icon_state = "beam_omni"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/laser_omni/muzzle
	icon_state = "muzzle_omni"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/laser_omni/impact
	icon_state = "impact_omni"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

//----------------------------
// Xray laser beam
//----------------------------
/obj/effect/projectile/xray/tracer
	icon_state = "xray"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/xray/muzzle
	icon_state = "muzzle_xray"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/xray/impact
	icon_state = "impact_xray"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/effect/projectile/laser_heavy/tracer
	icon_state = "beam_heavy"
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

/obj/effect/projectile/laser_heavy/muzzle
	icon_state = "muzzle_beam_heavy"
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

/obj/effect/projectile/laser_heavy/impact
	icon_state = "impact_beam_heavy"
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

//----------------------------
// Pulse laser beam
//----------------------------
/obj/effect/projectile/laser_pulse/tracer
	icon_state = "u_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/laser_pulse/muzzle
	icon_state = "muzzle_u_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

/obj/effect/projectile/laser_pulse/impact
	icon_state = "impact_u_laser"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

//----------------------------
// Emitter beam
//----------------------------
/obj/effect/projectile/emitter/tracer
	icon_state = "emitter"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/emitter/muzzle
	icon_state = "muzzle_emitter"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

/obj/effect/projectile/emitter/impact
	icon_state = "impact_emitter"
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

//----------------------------
// Stun beam
//----------------------------
/obj/effect/projectile/stun/tracer
	icon_state = "stun"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

/obj/effect/projectile/stun/muzzle
	icon_state = "muzzle_stun"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

/obj/effect/projectile/stun/impact
	icon_state = "impact_stun"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

//----------------------------
// Bullet
//----------------------------
/obj/effect/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

//----------------------------
// Lightning beam
//----------------------------
/obj/effect/projectile/lightning/tracer
	icon_state = "lightning"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/lightning/muzzle
	icon_state = "muzzle_lightning"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

/obj/effect/projectile/lightning/impact
	icon_state = "impact_lightning"
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

//----------------------------
// Dark matter
//----------------------------
/obj/effect/projectile/darkmatter/tracer
	icon_state = "darkb"
	light_range = 2
	light_power = 0.5
	light_color = "#8837A3"

/obj/effect/projectile/darkmatter/muzzle
	icon_state = "muzzle_darkb"
	light_range = 2
	light_power = 0.5
	light_color = "#8837A3"

/obj/effect/projectile/darkmatter/impact
	icon_state = "impact_darkb"
	light_range = 2
	light_power = 0.5
	light_color = "#8837A3"