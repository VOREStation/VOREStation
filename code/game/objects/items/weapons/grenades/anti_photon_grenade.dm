/obj/item/grenade/anti_photon
	desc = "An experimental device for temporarily removing light in a limited area."
	name = "photon disruption grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "emp"
	det_time = 20
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	var/light_sound = 'sound/effects/phasein.ogg'
	var/blast_sound = 'sound/effects/bang.ogg'

/obj/item/grenade/anti_photon/detonate(var/parent_callback = FALSE)
	if(parent_callback) // An awful way to do this, but the spawn() setup left me no choice when porting to timers
		..()
		return
	playsound(src, light_sound, 50, 1, 5)
	set_light(10, -10, "#FFFFFF")

	var/extra_delay = rand(0,90)
	addtimer(CALLBACK(src, PROC_REF(grenade_light),extra_delay), 200 + extra_delay, TIMER_DELETE_ME)

/obj/item/grenade/anti_photon/proc/grenade_light(var/extra_delay)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(prob(10+extra_delay))
		set_light(10, 10, "#[num2hex(rand(64,255))][num2hex(rand(64,255))][num2hex(rand(64,255))]")
	addtimer(CALLBACK(src, PROC_REF(grenade_blast)), 10, TIMER_DELETE_ME)

/obj/item/grenade/anti_photon/proc/grenade_blast()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	detonate(TRUE) // See above for this sinful choice
	playsound(src, blast_sound, 50, 1, 5)
	qdel(src)
