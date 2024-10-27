////////////////////////////////////////
// Vars and Default tesla_act behavior
////////////////////////////////////////

/obj
	var/being_shocked = FALSE

/obj/proc/tesla_act(var/power)
	being_shocked = TRUE
	var/power_bounced = power / 2
	tesla_zap(src, 3, power_bounced)
	//addtimer(CALLBACK(src, PROC_REF(reset_shocked)), 10)
	//schedule_task_with_source_in(10, src, PROC_REF(reset_shocked))
	spawn(10) reset_shocked()

/obj/proc/reset_shocked()
	being_shocked = FALSE

// Overrides for behavior on specific types

/obj/structure/blob/tesla_act(power)
	..()
	adjust_integrity(-power/400)

/obj/machinery/nuclearbomb/tesla_act(power, explosive)
	..()
	if(explosive)
		qdel(src)//like the singulo, tesla deletes it. stops it from exploding over and over

/obj/machinery/tesla_act(power, explosive = FALSE)
	..()
	if(prob(85) && explosive)
		explosion(loc, 0, 2, 4, /*flame_range = 2,*/ adminlog = FALSE/*, smoke = FALSE*/) // VOREStation Edit - No devastation range
	else if(prob(50))
		emp_act(2)
	else
		ex_act(2)

/obj/machinery/camera/tesla_act(var/power)//EMP proof upgrade also makes it tesla immune
	if(isEmpProof())
		return
	..()
	qdel(src) //to prevent bomb testing camera from exploding over and over forever

/obj/machinery/light/tesla_act(power, explosive = FALSE)
	if(explosive)
		explosion(loc, 0, 0, 0/*, flame_range = 5*/, adminlog = FALSE)
		qdel(src)
		return
	on = TRUE
	broken()

/obj/structure/closet/tesla_act(var/power)
	..() //extend the zap
	visible_message(span_danger("[src] is blown apart by the bolt of electricity!"), span_danger("You hear a metallic screeching sound."))
	dump_contents()
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/tesla_act()
	..() //extend the zap
	explode()

/obj/mecha/tesla_act(power)
	..()
	take_damage(power / 200, "energy") // A surface lightning strike will do 100 damage.
