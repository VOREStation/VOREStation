/datum/reagent/blood
	data = new/list("donor" = null, "viruses" = null, "species" = "Human", "blood_DNA" = null, "blood_type" = null, "blood_colour" = "#A10808", "resistances" = null, "trace_chem" = null, "antibodies" = list())
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = LIQUID
	metabolism = REM * 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#C80000"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/initialize_data(var/newdata)
	..()
	if(data && data["blood_colour"])
		color = data["blood_colour"]
	return

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	if(t["virus2"])
		var/list/v = t["virus2"]
		t["virus2"] = v.Copy()
	return t

/datum/reagent/blood/touch_turf(var/turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	if(!data["donor"] || istype(data["donor"], /mob/living/carbon/human))
		blood_splatter(T, src, 1)
	else if(istype(data["donor"], /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	var/effective_dose = dose
	if(issmall(M)) effective_dose *= 2

	var/is_vampire = 0 //VOREStation Edit START
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.gets_food_nutrition == 0)
			H.nutrition += removed
			is_vampire = 1 //VOREStation Edit END

	if(effective_dose > 5)
		if(is_vampire == 0) //VOREStation Edit.
			M.adjustToxLoss(removed) //VOREStation Edit.
	if(effective_dose > 15)
		if(is_vampire == 0) //VOREStation Edit.
			M.adjustToxLoss(removed) //VOREStation Edit.
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())
	if(data && data["antibodies"])
		M.antibodies |= data["antibodies"]

/datum/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.inject_blood(src, volume)
	remove_self(volume)

// pure concentrated antibodies
/datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	taste_description = "slime"
	id = "antibodies"
	reagent_state = LIQUID
	color = "#0050F0"
	mrate_static = TRUE

/datum/reagent/antibodies/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(src.data)
		M.antibodies |= src.data["antibodies"]
	..()

#define WATER_LATENT_HEAT 19000 // How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
/datum/reagent/water
	name = "Water"
	id = "water"
	taste_description = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064C877"
	metabolism = REM * 10
	mrate_static = TRUE

	glass_name = "water"
	glass_desc = "The father of all refreshments."

/datum/reagent/water/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		T.wet_floor(1)

/datum/reagent/water/touch_obj(var/obj/O)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		// First, kill slimes.
		if(istype(L, /mob/living/simple_animal/slime))
			var/mob/living/simple_animal/slime/S = L
			S.adjustToxLoss(15 * amount)
			S.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")

		// Then extinguish people on fire.
		var/needed = L.fire_stacks * 5
		if(amount > needed)
			L.ExtinguishMob()
		L.adjust_fire_stacks(-(amount / 5))
		remove_self(needed)

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	taste_description = "gross metal"
	reagent_state = LIQUID
	color = "#660000"

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/touch_turf(var/turf/T, var/amount)
	new /obj/effect/decal/cleanable/liquid_fuel(T, amount)
	remove_self(amount)
	return

/datum/reagent/fuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(issmall(M)) removed *= 2
	M.adjustToxLoss(4 * removed)

/datum/reagent/fuel/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
