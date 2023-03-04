
/obj/item/mecha_parts/mecha_equipment/tool/jumpjet
	name = "jumpjet"
	desc = "A jumpjet harness typically used for exosuit mobility in urban environments to limit structural damage from climbing."
	icon_state = "jumpjet"
	equip_cooldown = 10 SECONDS
	energy_drain = 100
	equip_type = EQUIP_HULL
	range = RANGED
	step_delay = 0.2 SECONDS

	required_type = list(/obj/mecha/working/hoverpod, /obj/mecha/medical/serenity, /obj/mecha/combat/marauder)

	var/hover_sound = 'sound/machines/generator/generator_end.ogg'

	var/enabled = FALSE

	var/hoverloop = 0

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/action_checks(var/atom/target)
	if(!target)
		return FALSE
	if(!chassis)
		return FALSE
	if(!equip_ready)
		return FALSE
	if(energy_drain && !chassis.has_charge(energy_drain * 20))
		return FALSE
	if(enabled)
		occupant_message("Exosuit thrusters presently in hover mode. Please enter rest mode to prime for jump.")
		return FALSE
	return TRUE

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/action(var/atom/target)
	if(!action_checks(target)) return
	var/turf/T = get_turf(target)
	if(T)
		set_ready_state(FALSE)
		chassis.use_power(energy_drain * 20)
		do_jump(T)
		do_after_cooldown()
	return

// Da jump.
/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/proc/do_jump(var/turf/Target)
	if(chassis)
		var/launch_height = min(1, get_dist(chassis, Target) / 3) * 80
		chassis.flying = TRUE
		if(!enable_special)
			visible_message(SPAN_DANGER("\The [chassis]'s jumpjets roar, hurling it violently into the sky toward \the [Target]!"))
			playsound(get_turf(src), 'sound/effects/explosionfar.ogg', 70, 1)
			explosion(get_turf(src), -1, -1, 2, 5)
		else
			playsound(get_turf(src), hover_sound, 70, 1)
			visible_message(SPAN_WARNING("\The [chassis]'s jumpjets bark, launching it toward \the [Target]."))
		chassis.throw_at(Target, 7, 0.4, src, launch_height)


/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/proc/toggle(var/forcestate)
	enabled = !isnull(forcestate) ? forcestate : !enabled

	hoverloop = 0

	if(enabled)
		START_PROCESSING(SSfastprocess, src)
		step_delay = 0.5 SECONDS
		chassis.pixel_z = 10
		chassis.stomp_sound = hover_sound

	else
		STOP_PROCESSING(SSfastprocess, src)
		chassis.fall()	// Like a brick.
		step_delay = 0.2 SECONDS
		chassis.pixel_z = 0
		chassis.stomp_sound = initial(chassis.stomp_sound)

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/process()
	if(chassis && chassis.has_charge(energy_drain))
		chassis.use_power(energy_drain)
		chassis.pixel_z = 3 * sin(hoverloop) + 10
		hoverloop += 30
		hoverloop %= 360

		playsound(src,hover_sound,20,1)

	else
		toggle(FALSE)

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/attach(var/obj/mecha/M)
	..(M)

	if(chassis)	// Stabilized launching, courtesy of Da Jump.
		chassis.does_spin = FALSE

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/detach(atom/moveto)
	if(chassis.throwing)	// Can't do that, sir. We're flying mid-air with you.
		return

	toggle(FALSE)
	chassis.does_spin = initial(chassis.does_spin)
	..(moveto)

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/get_equip_info()
	if(!chassis) return
	. = "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"] \[<a href=\"?src=\ref[src];toggle=1\">Toggle</a>\]"
	return

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/Topic(href,href_list)
	..()
	if(href_list["toggle"])
		toggle()

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/check_ztravel()
	return enabled

/obj/item/mecha_parts/mecha_equipment/tool/jumpjet/check_hover()
	return enabled
