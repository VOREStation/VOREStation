/*
A work in progress, lore will go here later.
List of things solar grubs should be able to do:

2. have three stages of growth depending on time. (Or energy drained altho that seems like a hard one to code)
3. be capable of eating people that get knocked out. (also be able to shock attackers that don’t wear insulated gloves.)
5. ((potentially use digested people to reproduce))
6. add glow?
*/

#define SINK_POWER 1

/mob/living/simple_animal/retaliate/solargrub
	name = "juvenile solargrub"
	desc = "A young sparkling solargrub"
	icon = 'icons/mob/vore.dmi' //all of these are placeholders
	icon_state = "solargrub"
	icon_living = "solargrub"
	icon_dead = "solargrub-dead"

	faction = "grubs"
	maxHealth = 50 //grubs can take a lot of harm
	health = 50
	move_to_delay = 5

	melee_damage_lower = 1
	melee_damage_upper = 5

	speak_chance = 1
	emote_see = list("squelches", "squishes")

	speed = 2

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	// solar grubs are not affected by atmos
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	var/poison_per_bite = 5 //grubs cause a shock when they bite someone
	var/poison_type = "shockchem"
	var/poison_chance = 50
	var/datum/powernet/PN            // Our powernet
	var/obj/structure/cable/attached        // the attached cable
	var/emp_chance = 20 // Beware synths

/mob/living/simple_animal/retaliate/solargrub/PunchTarget()
	if(target_mob&& prob(emp_chance))
		target_mob.emp_act(4) //The weakest strength of EMP
		visible_message("<span class='danger'>The grub releases a powerful shock!</span>")
	..()

/mob/living/simple_animal/retaliate/solargrub/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(stance == STANCE_IDLE)
			//first, check for potential cables nearby to powersink
		var/turf/S = loc
		attached = locate() in S
		if(attached)
			if(prob(2))
				src.visible_message("<span class='notice'>\The [src] begins to sink power from the net.</span>")
			if(prob(5))
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(5, 0, get_turf(src))
				sparks.start()
			anchored = 1
			PN = attached.powernet
			PN.draw_power(100000) // previous value 150000
			var/apc_drain_rate = 750 //Going to see if grubs are better as a minimal bother. previous value : 4000
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						var/cur_charge = A.cell.charge / CELLRATE
						var/drain_val = min(apc_drain_rate, cur_charge)
						A.cell.use(drain_val * CELLRATE)
		else if(!attached && anchored)
			anchored = 0
			PN = null

/mob/living/simple_animal/retaliate/solargrub //active noms
	vore_bump_chance = 50
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 0 //grubs only eat incapacitated targets
	vore_default_mode = DM_DIGEST

/mob/living/simple_animal/retaliate/solargrub/PunchTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			if(prob(poison_chance))
				L << "<span class='warning'>You feel a shock rushing through your veins.</span>"
				L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_animal/retaliate/solargrub/death()
	src.anchored = 0
	set_light(0)
	..()

/mob/living/simple_animal/retaliate/solargrub/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_YELLOW)
		return 1
