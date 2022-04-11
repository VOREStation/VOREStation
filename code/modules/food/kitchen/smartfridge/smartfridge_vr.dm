/obj/machinery/smartfridge
	var/expert_job = "Chef"
/obj/machinery/smartfridge/seeds
	expert_job = "Botanist"
/obj/machinery/smartfridge/secure/extract
	expert_job = "Xenobiologist"
/obj/machinery/smartfridge/secure/medbay
	expert_job = "Chemist"
/obj/machinery/smartfridge/secure/virology
	expert_job = "Medical Doctor" //Virologist is an alt-title unfortunately
/obj/machinery/smartfridge/chemistry
	expert_job = "Chemist" //Unsure what this one is used for, actually
/obj/machinery/smartfridge/drinks
	expert_job = "Bartender"

// Allow thrown items into smartfridges
/obj/machinery/smartfridge/hitby(var/atom/movable/A, speed)
	. = ..()
	if(accept_check(A) && A.thrower)
		//Try to find what job they are via ID
		var/obj/item/weapon/card/id/thrower_id
		if(ismob(A.thrower))
			var/mob/T = A.thrower
			thrower_id = T.GetIdCard()

		//98% chance the expert makes it
		if(expert_job && thrower_id && thrower_id.rank == expert_job && prob(98))
			stock(A)

		//20% chance a non-expert makes it
		else if(prob(20))
			stock(A)

//Chemistry 'chemavator'
/obj/machinery/smartfridge/chemistry/chemvator
	name = "\improper Smart Chemavator - Upper"
	desc = "A refrigerated storage unit for medicine and chemical storage. Now sporting a fancy system of pulleys to lift bottles up and down."
	var/obj/machinery/smartfridge/chemistry/chemvator/attached

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
		to_chat(world,"<span class='danger'>[src] at [x],[y],[z] cannot find the unit above it!</span>")
