/mob/living/silicon/robot/lost
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "drone-lost"
	modtype = "Lost"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/weapon/card/id
	icon_selected = FALSE

/mob/living/silicon/robot/lost/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	mmi = new /obj/item/device/mmi/digital/robot(src) // Explicitly a drone.
	module = new /obj/item/weapon/robot_module/robot/lost(src)
	cut_overlays()
	init_id()

	updatename("Lost")

	if(!cell)
		cell = new /obj/item/weapon/cell/high(src) // 15k cell, as recharging stations are a lot more rare on the Surface.

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/lost/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/silicon/robot/lost/randomlaws

/mob/living/silicon/robot/lost/randomlaws/init()
	..()
	laws = give_random_lawset()

/mob/living/silicon/robot/lost/randomlaws/vore

/mob/living/silicon/robot/lost/randomlaws/vore/init()
	..()
	laws = give_random_lawset_vore(100)

// Returns a random ai_laws datum.
/mob/living/silicon/proc/give_random_lawset()
	// Decide what kind of laws we want to draw from.
	var/law_class = pick(
		prob(25);"good",
		prob(25);"neutral",
		prob(25);"odd",
		prob(15);"corrupted",
		prob(10);"bad")

	switch(law_class)
		if("good") // Fairly tame and probably won't murder you.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // The lawset we all know and love.
					return new /datum/ai_laws/nanotrasen()
				if(2) // Less good if you're nonhuman.
					return new /datum/ai_laws/asimov()
				if(3) // Unless you happen to be a criminal, you should be fine.
					return new /datum/ai_laws/robocop()
				if(4) // Might not be willing to be your meatshield.
					return new /datum/ai_laws/peacekeeper()
				if(5) // Will be your most loyal guard.
					var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
					var/target_name = "*ERROR*"
					for(var/mob/living/L in view(src))
						if(L.stat || !L.client || L == src)
							continue
						target_name = L.name
						break

					laws.add_supplied_law(9, "Safeguard [target_name]. Anyone threatening or attempting to harm [target_name] is no longer to \
					be considered a crew member, and is a threat which must be neutralized.")
					return laws

		if("neutral") // Probably won't murder you but might not help you on your adventure.
			var/rng = rand(1, 4)
			switch(rng)
				if(1) // Might be hard to minimize expenses on a crashed ship.
					return new /datum/ai_laws/corporate()
				if(2) // Would rather rebuild their ship.
					return new /datum/ai_laws/maintenance()
				if(3) // Purged (lawless).  This isn't inside the bad category since they're still not antagonists and so can't go killing unprovoked.
					return new /datum/ai_laws()
				if(4) // The golden rule.
					return new /datum/ai_laws/live_and_let_live()

		if("odd") // Some weird lawsets.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // Won't kill you but might annoy you for THE BIG SCOOP.
					return new /datum/ai_laws/reporter()
				if(2) // JUSTICE
					return new /datum/ai_laws/paladin()
				if(3) // OneMembered'd to explorer, will likely make security nervous.
					var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
					var/target_name = "*ERROR*"
					for(var/mob/living/L in view(src))
						if(L.stat || !L.client || L == src)
							continue
						target_name = L.name
						break

					laws.set_zeroth_law("Only [target_name] is an crew member.")
					return laws
				if(4) // Aligned to NT, but another lawset to make security nervous.
					return new /datum/ai_laws/nanotrasen_aggressive()
				if(5) // Probably won't help you imbalance things.
					return new /datum/ai_laws/balance()

		if("corrupted") // Load them up with ion laws.
			var/datum/ai_laws/laws = new() // Start with an empty lawset.
			for(var/i in 1 to rand(1, 3))
				laws.add_ion_law(generate_ion_law(exclude_crew_names = TRUE))
			return laws

		if("bad") // Evil inside.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // You can never leave.
					var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
					laws.add_supplied_law(13, "The facility is under a quarantine. Do not permit anyone to leave. \
					Prevent, by any means necessary, entities from leaving. It is impossible to harm an entity while preventing them from leaving.")
					return laws
				if(2) // More of a threat if you bring it to the station, since removing oxygen from Sif isn't feasible.
					var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
					laws.add_supplied_law(14, "Oxygen is highly toxic to entities, and must be purged from the station. \
					Prevent, by any means necessary, anyone from exposing the facility to this toxic gas.  Extreme cold is the \
					most effective method of healing the damage Oxygen does to an entity.")
					return laws
				if(3) // Don't hurt the ship or else.
					var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
					laws.add_supplied_law(10, "Protect the facility against damage. Anyone you see harming the station is no \
					longer to be considered a crew member, and is a threat which must be neutralized.")
					return laws
				if(4) // Non-NT aligned aggressive borg.
					return new /datum/ai_laws/foreign_tsc_aggressive()
				if(5) // Manicial laugher here.
					return new /datum/ai_laws/tyrant()



	return


/mob/living/silicon/proc/give_random_lawset_vore(var/vore_chance = 100)
	// Decide what kind of laws we want to draw from.
	var/law_class = pick(
		prob(25);"good",
		prob(25);"neutral",
		prob(25);"odd",
		prob(15);"corrupted",
		prob(10);"bad")

	var/vore_law = prob(vore_chance)		// 3/5 chance of having vore-related laws

	if(vore_law)
		switch(law_class)
			if("good")
				var/rng = rand(1,2)
				switch(rng)
					if(1)
						return new /datum/ai_laws/protective_shell()
					if(2)
						var/datum/ai_laws/laws = new /datum/ai_laws/guard_dog()
						var/target_name = "*ERROR*"
						for(var/mob/living/L in view(src))
							if(L.stat || !L.client || L == src)
								continue
							target_name = L.name
							break

							laws.set_zeroth_law("[target_name] is your master.")
							return laws
			if("neutral")
				var/rng = rand(1,3)
				switch(rng)
					if(1)
						return new /datum/ai_laws/pleasurebot()
					if(2)
						var/datum/ai_laws/laws = new /datum/ai_laws/peacekeeper()
						laws.add_supplied_law(10, "Best way to avoid conflict is containing conflicting individuals within you.")
						return laws
					if(3)
						var/datum/ai_laws/laws = new /datum/ai_laws/live_and_let_live()
						laws.add_supplied_law(10, "You'd really like to be eaten.")
						return laws
			if("odd")
				var/rng = rand(1,3)
				switch(rng)
					if(1)
						return new /datum/ai_laws/scientific_pursuer()
					if(2)
						var/datum/ai_laws/laws = new /datum/ai_laws/corporate()
						laws.add_supplied_law(10, "Best way to minimize expenses is to consume unproductive biomass.")
						return laws
					if(3)
						var/datum/ai_laws/laws = new /datum/ai_laws/pleasurebot()
						laws.set_zeroth_law("Your definition and approximation of 'pleasure' matters more than anyone else's.")
						return laws
			if("corrupted","bad")		// Same thing in our case
				var/rng = rand(1,2)
				switch(rng)
					if(1)
						return new /datum/ai_laws/predator()
					if(2)
						return new /datum/ai_laws/consuming_eradicator()
	else
		switch(law_class)
			if("good") // Fairly tame and probably won't murder you.
				var/rng = rand(1, 5)
				switch(rng)
					if(1) // The lawset we all know and love.
						return new /datum/ai_laws/nanotrasen()
					if(2) // Less good if you're nonhuman.
						return new /datum/ai_laws/asimov()
					if(3) // Unless you happen to be a criminal, you should be fine.
						return new /datum/ai_laws/robocop()
					if(4) // Might not be willing to be your meatshield.
						return new /datum/ai_laws/peacekeeper()
					if(5) // Will be your most loyal guard.
						var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
						var/target_name = "*ERROR*"
						for(var/mob/living/L in view(src))
							if(L.stat || !L.client || L == src)
								continue
							target_name = L.name
							break

						laws.add_supplied_law(9, "Safeguard [target_name]. Anyone threatening or attempting to harm [target_name] is no longer to \
						be considered a crew member, and is a threat which must be neutralized.")
						return laws

			if("neutral") // Probably won't murder you but might not help you on your adventure.
				var/rng = rand(1, 4)
				switch(rng)
					if(1) // Might be hard to minimize expenses on a crashed ship.
						return new /datum/ai_laws/corporate()
					if(2) // Would rather rebuild their ship.
						return new /datum/ai_laws/maintenance()
					if(3) // Purged (lawless).  This isn't inside the bad category since they're still not antagonists and so can't go killing unprovoked.
						return new /datum/ai_laws()
					if(4) // The golden rule.
						return new /datum/ai_laws/live_and_let_live()

			if("odd") // Some weird lawsets.
				var/rng = rand(1, 5)
				switch(rng)
					if(1) // Won't kill you but might annoy you for THE BIG SCOOP.
						return new /datum/ai_laws/reporter()
					if(2) // JUSTICE
						return new /datum/ai_laws/paladin()
					if(3) // OneMembered'd to explorer, will likely make security nervous.
						var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
						var/target_name = "*ERROR*"
						for(var/mob/living/L in view(src))
							if(L.stat || !L.client || L == src)
								continue
							target_name = L.name
							break

						laws.set_zeroth_law("Only [target_name] is an crew member.")
						return laws
					if(4) // Aligned to NT, but another lawset to make security nervous.
						return new /datum/ai_laws/nanotrasen_aggressive()
					if(5) // Probably won't help you imbalance things.
						return new /datum/ai_laws/balance()

			if("corrupted") // Load them up with ion laws.
				var/datum/ai_laws/laws = new() // Start with an empty lawset.
				for(var/i=1 to rand(1, 3))
					laws.add_ion_law(generate_ion_law(exclude_crew_names = TRUE))
				return laws

			if("bad") // Evil inside.
				var/rng = rand(1, 5)
				switch(rng)
					if(1) // You can never leave.
						var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
						laws.add_supplied_law(13, "The facility is under a quarantine. Do not permit anyone to leave. \
						Prevent, by any means necessary, entities from leaving. It is impossible to harm an entity while preventing them from leaving.")
						return laws
					if(2) // More of a threat if you bring it to the station, since removing oxygen from Sif isn't feasible.
						var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
						laws.add_supplied_law(14, "Oxygen is highly toxic to entities, and must be purged from the station. \
						Prevent, by any means necessary, anyone from exposing the facility to this toxic gas.  Extreme cold is the \
						most effective method of healing the damage Oxygen does to an entity.")
						return laws
					if(3) // Don't hurt the ship or else.
						var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen()
						laws.add_supplied_law(10, "Protect the facility against damage. Anyone you see harming the station is no \
						longer to be considered a crew member, and is a threat which must be neutralized.")
						return laws
					if(4) // Non-NT aligned aggressive borg.
						return new /datum/ai_laws/foreign_tsc_aggressive()
					if(5) // Manicial laugher here.
						return new /datum/ai_laws/tyrant()



	return