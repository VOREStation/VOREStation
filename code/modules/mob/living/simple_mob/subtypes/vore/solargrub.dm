/*
A work in progress, lore will go here later.
List of things solar grubs should be able to do:

2. have three stages of growth depending on time. (Or energy drained altho that seems like a hard one to code)
3. be capable of eating people that get knocked out. (also be able to shock attackers that don’t wear insulated gloves.)
5. ((potentially use digested people to reproduce))
6. add glow?
*/

/datum/category_item/catalogue/fauna/solargrub		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Solargrub"
	desc = "Some form of mutated space larva, they seem to crop up on space stations wherever there is power. \
	They seem to have the chance to cocoon and mutate if left alone, but no recorded instances of this have happened yet. \
	Therefore, if you see the grubs, kill them while they're small, or things might escalate." // TODO: PORT SOLAR MOTHS - Rykka
	value = CATALOGUER_REWARD_EASY

#define SINK_POWER 1

/mob/living/simple_mob/vore/solargrub
	name = "juvenile solargrub"
	desc = "A young sparkling solargrub"
	catalogue_data = list(/datum/category_item/catalogue/fauna/solargrub)
	icon = 'icons/mob/vore.dmi' //all of these are placeholders
	icon_state = "solargrub"
	icon_living = "solargrub"
	icon_dead = "solargrub-dead"

	faction = "grubs"
	maxHealth = 50 //grubs can take a lot of harm
	health = 50

	melee_damage_lower = 1
	melee_damage_upper = 3	//low damage, but poison and stuns are strong

	movement_cooldown = 8

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/solargrub
	say_list_type = /datum/say_list/solargrub

	var/poison_per_bite = 5 //grubs cause a shock when they bite someone
	var/poison_type = "shockchem"
	var/poison_chance = 50
	var/datum/powernet/PN            // Our powernet
	var/obj/structure/cable/attached        // the attached cable
	var/shock_chance = 10 // Beware

/datum/say_list/solargrub
	emote_see = list("squelches", "squishes")

/mob/living/simple_mob/vore/solargrub/New()
	existing_solargrubs += src
	..()

/mob/living/simple_mob/vore/solargrub/Life()
	. = ..()
	if(!.) return

	if(!ai_holder.target)
			//first, check for potential cables nearby to powersink
		var/turf/S = loc
		attached = locate(/obj/structure/cable) in S
		if(attached)
			set_AI_busy(TRUE)
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

/mob/living/simple_mob/vore/solargrub //active noms
	vore_bump_chance = 50
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 0 //grubs only eat incapacitated targets
	vore_default_mode = DM_DIGEST

/mob/living/simple_mob/vore/solargrub/apply_melee_effects(var/atom/A)
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
			visible_message("<span class='danger'>The grub releases a powerful shock!</span>")
		else
			if(L.reagents)
				var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
				if(L.can_inject(src, null, target_zone))
					inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/solargrub/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel a small shock rushing through your veins.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/vore/solargrub/death()
	src.anchored = 0
	set_light(0)
	..()

/mob/living/simple_mob/vore/solargrub/Destroy()
	existing_solargrubs -= src
	..()

/mob/living/simple_mob/vore/solargrub/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_YELLOW)
		return 1

/mob/living/simple_mob/vore/solargrub/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Through either grave error, overwhelming willingness, or some other factor, you find yourself lodged halfway past the solargrub's mandibles. While it had initially hissed and chittered in glee at the prospect of a new meal, it is clearly more versed in suckling on power cables; inch by inch, bit by bit, it undulates forth to slowly, noisily gulp you down its short esophagus... and right into its extra-cramped, surprisingly hot stomach. As the rest of you spills out into the plush-walled chamber, the grub's soft body bulges outwards here and there with your compressed figure. Before long, a thick slime oozes out from the surrounding stomach walls; only time will tell how effective it is on something solid like you..."

	B.emote_lists[DM_HOLD] = list(
		"The air trapped within the solargrub is hot, humid, and tinged with ozone, but otherwise mercifully harmless to you aside from being heavy on the lungs.",
		"Your doughy, squishy surroundings heavily pulse around your body as the solargrub attempts to wriggle elsewhere, its solid prey weighing it down quite a bit.",
		"Suddenly, an arc of electricity harmlessly jumps through the grub's stomach, briefly illuminating your slimy, glistening surroundings in a flash of yellow.",
		"With all the power coursing through the solargrub's body, its inner muscles are in a constant state of vibrating all over you, adding an extra element to your full-body massage.",
		"For a moment, the solargrub's stomach walls clench down even more firmly than before, working its subtle inner vibrations into your muscles, steadily relaxing them down.",
		"The incredible heat trapped within the solargrub helps daze and disorient you, ensuring that its new filling wouldn't interfere in its power-draining.")

	B.emote_lists[DM_DIGEST] = list(
		"Every breath taken inside the solargrub is swelteringly hot, painfully thick, and more than subtly caustic, worsening with every passing moment spent inside!",
		"As the solargrub wriggles off somewhere quiet to digest its meal, the resulting undulations help crush you down into a more compact, easier to handle morsel!",
		"From time to time, additional jolts of electricity unpleasantly course through your body, helping ensure that the solargrub's food was thoroughly paralyzed!",
		"With how incredibly charged the solargrub is, its constant internal vibrating adds an additional layer of processing to its stomach's slow, steady churning, helping break you down faster!",
		"The solargrub chitters in irritation at your continued solidity, followed by a string of crushingly tight stomach clenches that grind its caustic stomach ooze into your body!",
		"The deceptively severe heat trapped within the solargrub works in tandem with its inner muscles and your tingling, prickling stomach juice bath to weaken you!")

/datum/ai_holder/simple_mob/retaliate/solargrub/react_to_attack(atom/movable/attacker)
	holder.anchored = 0
	holder.set_AI_busy(FALSE)
	..()