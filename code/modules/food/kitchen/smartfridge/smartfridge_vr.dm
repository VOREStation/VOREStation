/*
 * Expert Jobs
 */
/obj/machinery/smartfridge
	var/expert_job = JOB_CHEF
/obj/machinery/smartfridge/seeds
	expert_job = JOB_BOTANIST
/obj/machinery/smartfridge/secure/extract
	expert_job = JOB_XENOBIOLOGIST
/obj/machinery/smartfridge/secure/medbay
	expert_job = JOB_CHEMIST
/obj/machinery/smartfridge/secure/chemistry
	expert_job = JOB_CHEMIST
/obj/machinery/smartfridge/secure/virology
	expert_job = JOB_MEDICAL_DOCTOR //Virologist is an alt-title unfortunately
/obj/machinery/smartfridge/drinks
	expert_job = JOB_BARTENDER

/*
 * Allow thrown items into smartfridges
 */
/obj/machinery/smartfridge/hitby(var/atom/movable/A, speed)
	. = ..()
	if(accept_check(A) && A.thrower)
		//Try to find what job they are via ID
		var/obj/item/card/id/thrower_id
		if(ismob(A.thrower))
			var/mob/T = A.thrower
			thrower_id = T.GetIdCard()

		//98% chance the expert makes it
		if(expert_job && thrower_id && thrower_id.rank == expert_job && prob(98))
			stock(A)

		//20% chance a non-expert makes it
		else if(prob(20))
			stock(A)

/*
 * Chemistry 'chemavator' (multi-z chem storage)
 */
/obj/machinery/smartfridge/chemistry/chemvator
	name = "\improper Smart Chemavator - Upper"
	desc = "A refrigerated storage unit for medicine and chemical storage. Now sporting a fancy system of pulleys to lift bottles up and down."
	expert_job = JOB_CHEMIST
	var/obj/machinery/smartfridge/chemistry/chemvator/attached

/obj/machinery/smartfridge/chemistry/chemvator/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/storage/pill_bottle) || istype(O,/obj/item/reagent_containers) || istype(O,/obj/item/reagent_containers/glass/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/chemvator/down/Destroy()
	attached = null
	return ..()

/obj/machinery/smartfridge/chemistry/chemvator/down
	name = "\improper Smart Chemavator - Lower"

/obj/machinery/smartfridge/chemistry/chemvator/down/Initialize()
	. = ..()
	var/obj/machinery/smartfridge/chemistry/chemvator/above = locate(/obj/machinery/smartfridge/chemistry/chemvator,get_zstep(src,UP))
	if(istype(above))
		above.attached = src
		attached = above
		item_records = attached.item_records
	else
		to_chat(world,span_danger("[src] at [x],[y],[z] cannot find the unit above it!"))
