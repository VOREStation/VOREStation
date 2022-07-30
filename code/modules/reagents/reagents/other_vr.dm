/datum/reagent/advmutationtoxin
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin"
	description = "A corruptive toxin produced by slimes. Turns the subject of the chemical into a Promethean."
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/advmutationtoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(M.allow_spontaneous_tf))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name != "Promethean")
			to_chat(M, "<span class='danger'>Your flesh rapidly mutates!</span>")

			var/list/backup_implants = list()
			for(var/obj/item/organ/I in H.organs)
				for(var/obj/item/implant/backup/BI in I.contents)
					backup_implants += BI
			if(backup_implants.len)
				for(var/obj/item/implant/backup/BI in backup_implants)
					BI.forceMove(src)

			H.set_species("Promethean")
			H.shapeshifter_set_colour("#05FF9B") //They can still change their color.

			if(backup_implants.len)
				var/obj/item/organ/external/torso = H.get_organ(BP_TORSO)
				for(var/obj/item/implant/backup/BI in backup_implants)
					BI.forceMove(torso)
					torso.implants += BI

/datum/reagent/nif_repair_nanites
	name = "Programmed Nanomachines"
	id = "nifrepairnanites"
	description = "A thick grey slurry of NIF repair nanomachines."
	taste_description = "metallic"
	reagent_state = LIQUID
	color = "#333333"
	scannable = 1
	affects_robots = TRUE

/datum/reagent/nif_repair_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif)
			var/obj/item/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.repair(removed)

/datum/reagent/firefighting_foam
	name = "Firefighting Foam"
	id = "firefoam"
	description = "A historical fire suppressant. Originally believed to simply displace oxygen to starve fires, it actually interferes with the combustion reaction itself. Vastly superior to the cheap water-based extinguishers found on most NT vessels."
	reagent_state = LIQUID
	color = "#A6FAFF"
	taste_description = "the inside of a fire extinguisher"

/datum/reagent/firefighting_foam/touch_turf(var/turf/T, reac_volume)
	if(reac_volume >= 1)
		var/obj/effect/vfx/foam/firefighting/F = (locate(/obj/effect/vfx/foam/firefighting) in T)
		if(!F)
			F = new(T)
		else if(istype(F))
			F.lifetime = initial(F.lifetime) //reduce object churn a little bit when using smoke by keeping existing foam alive a bit longer

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !isspace(T))
		var/datum/gas_mixture/lowertemp = T.remove_air(T.air.total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * 19000, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if(prob(5))
			T.visible_message("<span class='warning'>The foam sizzles as it lands on \the [T]!</span>")

/datum/reagent/firefighting_foam/touch_obj(var/obj/O, reac_volume)
	O.water_act(reac_volume / 5)

/datum/reagent/firefighting_foam/touch_mob(var/mob/living/M, reac_volume)
	if(istype(M, /mob/living/simple_mob/slime)) //I'm sure foam is water-based!
		var/mob/living/simple_mob/slime/S = M
		S.adjustToxLoss(15 * reac_volume)
		S.visible_message("<span class='warning'>[S]'s flesh sizzles where the foam touches it!</span>", "<span class='danger'>Your flesh burns in the foam!</span>")

	M.adjust_fire_stacks(-reac_volume)
	M.ExtinguishMob()

/datum/reagent/liquid_protean
	name = "Liquid protean"
	id = "liquid_protean"
	description = "This seems to be a small portion of a Protean creature, still slightly wiggling."
	taste_description = "wiggly peanutbutter"
	reagent_state = LIQUID
	color = "#1d1d1d"
	scannable = 0
	metabolism = REM * 0.5
	affects_robots = TRUE

/datum/reagent/liquid_protean/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			chem_effective = 0.5
		M.adjustOxyLoss(-1 * removed * chem_effective)
		M.heal_organ_damage(0.5 * removed, 0.5 * removed * chem_effective)
		M.adjustToxLoss(-0.5 * removed * chem_effective)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif)
			var/obj/item/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.repair(removed*0.1)

//Special toxins for solargrubs
/datum/reagent/grubshock
	name = "200 V" //in other words a painful shock
	id = "shockchem"
	description = "A liquid that quickly dissapates to deliver a painful shock."
	reagent_state = LIQUID
	color = "#E4EC2F"
	metabolism = 2.50
	var/power = 9

/datum/reagent/grubshock/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power * 0.2)
