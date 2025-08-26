/datum/category_item/catalogue/fauna/solarmoth		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Solarmoth"
	desc = "An adult variation of a solargrub, these winged critters are very deadly. They seem to heat up everything nearby, \
	turning ordinary rooms into infernos, and causing malfunctions across the station. They are so hot that laser weaponry is like throwing an ice cube at them. \
	Bullets will melt in the face of them and only cause minor damage from the melted matter. \
	Melee seems to be thier weakness as long as the user has appropriate heat protection or if you're quick enough to respond before needing protection. Approach with caution."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/solarmoth
	name = "solarmoth"
	desc = "A majestic sparkling solarmoth. Also a slight engineering hazard known to heat rooms equal to temperatures of a white dwarf."
	catalogue_data = list(/datum/category_item/catalogue/fauna/solarmoth)
	icon = 'icons/mob/solarmoth.dmi' //all of these are placeholders
	icon_state = "solarmoth"
	icon_living = "solarmoth"
	icon_dead = "solarmoth-dead"

	var/mycolour = COLOR_BLUE //Variable Lighting colours
	var/original_temp = null //Value to remember temp
	var/set_temperature = T0C + 10000	//Sets the target point of 10k degrees celsius
	var/heating_power = 100000		//This controls the strength at which it heats the environment.
	var/emp_heavy = 2
	var/emp_med = 4
	var/emp_light = 7
	var/emp_long = 10

	faction = "grubs"
	maxHealth = 400 // Tanky fuckers.
	health = 400 // Tanky fuckers.

	melee_damage_lower = 1
	melee_damage_upper = 5

	movement_cooldown = 5

	meat_type = /obj/item/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate
	say_list_type = /datum/say_list/solarmoth

	var/poison_per_bite = 5 //grubs cause a shock when they bite someone
	var/poison_type = REAGENT_ID_SHOCKCHEM
	var/poison_chance = 50
	var/shock_chance = 20 // Beware synths

	// solar moths are not affected by atmos
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	heat_damage_per_tick = 0 //Even if the atmos stuff doesn't work, at least it won't take any damage.

	armor = list(
				"melee" = 0,
				"bullet" = 90,
				"laser" = 100,
				"energy" = 100,
				"bomb" = 100,
				"bio" = 100,
				"rad" = 100)

	can_be_drop_prey = FALSE

	glow_override = TRUE

/datum/say_list/solarmoth
	emote_see = list("flutters")

/mob/living/simple_mob/vore/solarmoth/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(shock_chance))
			A.emp_act(4) //The weakest strength of EMP
			playsound(src, 'sound/weapons/Egloves.ogg', 75, 1)
			L.Weaken(4)
			L.Stun(4)
			L.stuttering = max(L.stuttering, 4)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, L)
			s.start()
			visible_message(span_danger("The moth releases a powerful shock!"))
		else
			if(L.reagents)
				var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
				if(L.can_inject(src, null, target_zone))
					inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/solarmoth/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel a small shock rushing through your veins."))
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/vore/solarmoth/Life()
	. = ..()
	if(icon_state != icon_dead) //I mean on death() Life() should disable but i guess doesnt hurt to make sure -shark
		var/turf/moth_loc = get_turf(src)
		if(isturf(moth_loc) && moth_loc.air)
			var/datum/gas_mixture/env = moth_loc.return_air() //Gets all the information on the local air.
			var/transfer_moles = 0.25 * env.total_moles //The bigger the room, the harder it is to heat the room.
			var/datum/gas_mixture/removed = env.remove(transfer_moles)
			var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
			if(heat_transfer > 0 && env.temperature < T0C + 200)	//This should start heating the room at a moderate pace up to 200 degrees celsius.
				heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater
				removed.add_thermal_energy(heat_transfer)

			else if(heat_transfer > 0 && env.temperature < set_temperature) //Set temperature is 10,000 degrees celsius. So this thing will start cooking crazy hot between the temperatures of 200C and 10,000C.
				heating_power = original_temp*100 //Changed to work variable -shark //FLAME ON! This will make the moth heat up the room at an incredible rate.
				heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater. Except it's hot, so yeah.
				removed.add_thermal_energy(heat_transfer)

			else
				return

			env.merge(removed)



	//Since I'm changing hyper mode to be variable we need to store old power
	original_temp = heating_power //We remember our old goal, for use in non perpetual heating level increase

/mob/living/simple_mob/vore/solarmoth/proc/explode()
	src.anchored = 0
	set_light(0)
	GLOB.moth_amount = clamp(GLOB.moth_amount - 1, 0, 1)
	if(empulse(src, emp_heavy, emp_med, emp_light, emp_long))
		qdel(src)
	return

/mob/living/simple_mob/vore/solarmoth/death()
	explode()
	..()

/mob/living/simple_mob/vore/solarmoth/gib() //This baby will explode no matter what you do to it.
	explode()
	..()



/mob/living/simple_mob/vore/solarmoth/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(9.5, 1, mycolour) //9.5 makes the brightness range super huge.
		return 1
	else if(is_dead())
		glow_override = FALSE


/mob/living/simple_mob/vore/solarmoth //active noms
	vore_bump_chance = 50
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 0 //moths only eat incapacitated targets. It's too lazy burning you to a crisp to try to pounce you
	vore_default_mode = DM_DIGEST

/mob/living/simple_mob/vore/solarmoth/lunarmoth
	name = "lunarmoth"
	desc = "A majestic sparkling lunarmoth. Also a slight engineering hazard."

	var/nospampls = 0

	cold_damage_per_tick = 0
	//ATMOS
	set_temperature = T0C - 10000
	heating_power = -100000
	//light
	mycolour = COLOR_WHITE

/mob/living/simple_mob/vore/solarmoth/lunarmoth/proc/chilltheglass() //Why does a coldfusion moth do this? science -shark
	nospampls = 1
	if(prob(25))
		for(var/obj/machinery/light/light in range(5, src))
			if(prob(50))
				light.broken()
	if(prob(10))
		for(var/obj/structure/window/window in range(5, src))
			if(prob(50))
				window.shatter()
	if(prob(20))
		for(var/obj/machinery/door/firedoor/door in range(14, src)) //double viewrange
			if(prob(5))
				visible_message(span_danger("Emergency Shutter malfunction!"))
				door.blocked = 0
				door.open(1)

	VARSET_IN(src, nospampls, 0, 10 SECONDS)

/mob/living/simple_mob/vore/solarmoth/lunarmoth/Life()
	..()
	if(!nospampls)
		chilltheglass() //shatter and broken calls for glass and lights. Also some special thing.
