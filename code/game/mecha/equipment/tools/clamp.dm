/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 10
	var/dam_force = 20
	var/obj/mecha/working/ripley/cargo_holder
	required_type = list(/obj/mecha/working)
	ready_sound = 'sound/mecha/gasdisconnected.ogg'

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/attach(obj/mecha/M as obj)
	..()
	cargo_holder = M

	return

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/action(atom/target)
	if(!action_checks(target)) return
	if(!cargo_holder) return

	//loading
	if(istype(target,/obj))
		var/obj/O = target
		if(O.has_buckled_mobs())
			return
		if(locate(/mob/living) in O)
			occupant_message("<span class='warning'>You can't load living things into the cargo compartment.</span>")
			return
		if(O.anchored)
			if(enable_special)
				if(istype(O, /obj/machinery/door/firedoor))	// I love doors.
					var/obj/machinery/door/firedoor/FD = O
					if(FD.blocked)
						FD.visible_message("<span class='danger'>\The [chassis] begins prying on \the [FD]!</span>")
						if(do_after(chassis.occupant,10 SECONDS,FD))
							playsound(FD.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
							FD.blocked = 0
							FD.update_icon()
							FD.open(1)
							FD.visible_message("<span class='warning'>\The [chassis] tears \the [FD] open!</span>")
					else if(FD.density)
						FD.visible_message("<span class='warning'>\The [chassis] begins forcing \the [FD] open!</span>")
						if(do_after(chassis.occupant, 5 SECONDS,FD))
							playsound(FD.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
							FD.visible_message("<span class='danger'>\The [chassis] forces \the [FD] open!</span>")
							FD.open(1)
					else
						FD.visible_message("<span class='danger'>\The [chassis] forces \the [FD] closed!</span>")
						FD.close(1)
				else if(istype(O, /obj/machinery/door/airlock))	// D o o r s.
					var/obj/machinery/door/airlock/AD = O
					if(AD.locked)
						occupant_message("<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
					else if(!AD.operating)
						if(AD.welded)
							AD.visible_message("<span class='warning'>\The [chassis] begins prying on \the [AD]!</span>")
							if(do_after(chassis.occupant, 15 SECONDS,AD) && chassis.Adjacent(AD))
								AD.welded = FALSE
								AD.update_icon()
								playsound(AD.loc, 'sound/machines/airlock_creaking.ogg', 100, 1)
								AD.visible_message("<span class='danger'>\The [chassis] tears \the [AD] open!</span>")
						if(!AD.welded)
							if(density)
								spawn(0)
									AD.open(1)
							else
								spawn(0)
									AD.close(1)
				return
			else
				occupant_message("<span class='warning'>[target] is firmly secured.</span>")
			return
		if(cargo_holder.cargo.len >= cargo_holder.cargo_capacity)
			occupant_message("<span class='warning'>Not enough room in cargo compartment.</span>")
			return

		occupant_message("You lift [target] and start to load it into cargo compartment.")
		chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		O.anchored = 1
		var/T = chassis.loc
		if(do_after_cooldown(target))
			if(T == chassis.loc && src == chassis.selected)
				cargo_holder.cargo += O
				O.loc = chassis
				O.anchored = 0
				occupant_message("<span class='notice'>[target] succesfully loaded.</span>")
				log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
			else
				occupant_message("<span class='warning'>You must hold still while handling objects.</span>")
				O.anchored = initial(O.anchored)

	//attacking
	else if(istype(target,/mob/living))
		var/mob/living/M = target
		if(M.stat>1) return
		if(chassis.occupant.a_intent == I_HURT || istype(chassis.occupant,/mob/living/carbon/brain)) //No tactile feedback for brains
			M.take_overall_damage(dam_force)
			M.adjustOxyLoss(round(dam_force/2))
			M.updatehealth()
			occupant_message("<span class='warning'>You squeeze [target] with [src.name]. Something cracks.</span>")
			playsound(src.loc, "fracture", 5, 1, -2) //CRACK
			chassis.visible_message("<span class='warning'>[chassis] squeezes [target].</span>")
		else if(chassis.occupant.a_intent == I_DISARM && enable_special)
			playsound(src.loc, 'sound/mecha/hydraulic.ogg', 10, 1, -2)
			M.take_overall_damage(dam_force/2)
			M.adjustOxyLoss(round(dam_force/3))
			M.updatehealth()
			occupant_message("<span class='warning'>You slam [target] with [src.name]. Something cracks.</span>")
			playsound(src.loc, "fracture", 3, 1, -2) //CRACK 2
			chassis.visible_message("<span class='warning'>[chassis] slams [target].</span>")
			M.throw_at(get_step(M,get_dir(src, M)), 14, 1.5, chassis)
		else
			step_away(M,chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1


//This is pretty much just for the death-ripley so that it is harmless
/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/safety
	name = "\improper KILL CLAMP"
	equip_cooldown = 15
	energy_drain = 0
	dam_force = 0

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/safety/action(atom/target)
	if(!action_checks(target)) return
	if(!cargo_holder) return
	if(istype(target,/obj))
		var/obj/O = target
		if(!O.anchored)
			if(cargo_holder.cargo.len < cargo_holder.cargo_capacity)
				chassis.occupant_message("You lift [target] and start to load it into cargo compartment.")
				chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
				set_ready_state(0)
				chassis.use_power(energy_drain)
				O.anchored = 1
				var/T = chassis.loc
				if(do_after_cooldown(target))
					if(T == chassis.loc && src == chassis.selected)
						cargo_holder.cargo += O
						O.loc = chassis
						O.anchored = 0
						chassis.occupant_message("<span class='notice'>[target] succesfully loaded.</span>")
						chassis.log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
					else
						chassis.occupant_message("<span class='warning'>You must hold still while handling objects.</span>")
						O.anchored = initial(O.anchored)
			else
				chassis.occupant_message("<span class='warning'>Not enough room in cargo compartment.</span>")
		else
			chassis.occupant_message("<span class='warning'>[target] is firmly secured.</span>")

	else if(istype(target,/mob/living))
		var/mob/living/M = target
		if(M.stat>1) return
		if(chassis.occupant.a_intent == I_HURT)
			chassis.occupant_message("<span class='danger'>You obliterate [target] with [src.name], leaving blood and guts everywhere.</span>")
			chassis.visible_message("<span class='danger'>[chassis] destroys [target] in an unholy fury.</span>")
		if(chassis.occupant.a_intent == I_DISARM)
			chassis.occupant_message("<span class='danger'>You tear [target]'s limbs off with [src.name].</span>")
			chassis.visible_message("<span class='danger'>[chassis] rips [target]'s arms off.</span>")
		else
			step_away(M,chassis)
			chassis.occupant_message("You smash into [target], sending them flying.")
			chassis.visible_message("[chassis] tosses [target] like a piece of paper.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1