/datum/disease/magnitis
	name = "Magnitis"
	max_stages = 4
	spread_text = "Airbone"
	cure_text = "Iron"
	cures = list(REAGENT_ID_IRON)
	agent = "Fukkos Miracos"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "This disease disrupts the magnetic field of your body, making it act as if a powerful magnet. Injections of iron help stabilize the field."
	severity = MINOR

/datum/disease/magnitis/stage_act()
	if(!..())
		return FALSE
	switch(stage)
		if(2)
			if(prob(2))
				to_chat(affected_mob, span_danger("You feel a slight shock course through your body."))
			if(prob(2))
				for(var/obj/M in orange(2, affected_mob))
					if(!M.anchored && prob(5))
						INVOKE_ASYNC(M, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
				for(var/mob/living/silicon/S in orange(2, affected_mob))
					if(isAI(S)) continue
					INVOKE_ASYNC(S, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
		if(3)
			if(prob(2))
				to_chat(affected_mob, span_danger("You feel a strong shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, span_danger("You feel like clowning aound."))
			if(prob(4))
				for(var/obj/M in orange(4, affected_mob))
					if(!M.anchored && prob(5))
						var/i
						var/iter = rand(1,2)
						for(i=0,i<iter,i++)
							INVOKE_ASYNC(M, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
				for(var/mob/living/silicon/S in orange(4, affected_mob))
					if(isAI(S)) continue
					var/i
					var/iter = rand(1,2)
					for(i=0,i<iter,i++)
						INVOKE_ASYNC(S, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
		if(4)
			if(prob(2))
				to_chat(affected_mob, span_danger("You feel a powerful shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, span_danger("You query upon the nature of miracles"))
			if(prob(8))
				for(var/obj/M in orange(6, affected_mob))
					if(!M.anchored && prob(5))
						var/i
						var/iter = rand(1,3)
						for(i=0,i<iter,i++)
							INVOKE_ASYNC(M, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
				for(var/mob/living/silicon/S in orange(6, affected_mob))
					if(isAI(S)) continue
					var/i
					var/iter = rand(1,3)
					for(i=0,i<iter,i++)
						INVOKE_ASYNC(S, TYPE_PROC_REF(/atom/movable, throw_at), affected_mob, rand(3, 10), rand(1, 3), src)
	return
