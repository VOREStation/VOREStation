
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and brown, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"

	faction = "spiders"
	intelligence_level = SA_ANIMAL
	maxHealth = 200
	health = 200
	pass_flags = PASSTABLE
	move_to_delay = 6
	speed = 3

	stop_when_pulled = 0
	turns_per_move = 5
	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	melee_damage_lower = 15
	melee_damage_upper = 20
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20

	speak_chance = 5
	speak_emote = list("chitters")
	emote_hear = list("chitters")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat

	var/busy = 0
	var/poison_per_bite = 5
	var/poison_chance = 10
	var/poison_type = "spidertoxin"
	var/image/eye_layer = null

/mob/living/simple_animal/hostile/giant_spider/proc/add_eyes()
	if(!eye_layer)
		eye_layer = image(icon, "[icon_state]-eyes")
		eye_layer.plane = PLANE_LIGHTING_ABOVE

	overlays += eye_layer

/mob/living/simple_animal/hostile/giant_spider/proc/remove_eyes()
	overlays -= eye_layer

/*
Nurse Family
*/

//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "Furry and beige, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"

	maxHealth = 40
	health = 40

	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 7
	poison_type = "spidertoxin"  // VOREStation edit, original is stoxin. (sleep toxins)

	var/fed = 0
	var/atom/cocoon_target
	var/egg_inject_chance = 5

/mob/living/simple_animal/hostile/giant_spider/nurse/queen
	desc = "Absolutely gigantic, this creature is horror itself."
	icon = 'icons/mob/64x64.dmi'
	icon_state = "spider_queen"
	icon_living = "spider_queen"
	icon_dead = "spider_queen_dead"

	maxHealth = 320
	health = 320

	melee_damage_lower = 15
	melee_damage_upper = 25
	poison_per_bite = 10

	egg_inject_chance = 10

	pixel_x = -16
	pixel_y = -16
	old_x = -16
	old_y = -16

/mob/living/simple_animal/hostile/giant_spider/webslinger
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes, and a cloak of web."
	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"

	maxHealth = 90
	health = 90

	projectilesound = 'sound/weapons/thudswoosh.ogg'
	projectiletype = /obj/item/projectile/bola
	ranged = 1
	firing_lines = 1
	cooperative = 1
	shoot_range = 5

	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 2
	poison_type = "psilocybin"

	spattack_prob = 15
	spattack_min_range = 0
	spattack_max_range = 5

/mob/living/simple_animal/hostile/giant_spider/webslinger/AttackTarget() //One day.
	var/mob/living/carbon/human/victim = null //Webslinger needs to know if its target is human later.
	if(ishuman(target_mob))
		victim = target_mob
		if(!victim.legcuffed)
			projectiletype = /obj/item/projectile/bola
			shoot_range = 7
		else
			projectiletype = /obj/item/projectile/webball
			shoot_range = 5
	else
		projectiletype = /obj/item/projectile/webball
		shoot_range = 5
	return ..()

/mob/living/simple_animal/hostile/giant_spider/carrier
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes."
	icon_state = "carrier"
	icon_living = "carrier"
	icon_dead = "carrier_dead"

	maxHealth = 100
	health = 100

	melee_damage_lower = 5
	melee_damage_upper = 20

	poison_per_bite = 3
	poison_type = "chloralhydrate"

	var/spiderling_count = 0
	var/spiderling_type = /obj/effect/spider/spiderling
	var/swarmling_type = /mob/living/simple_animal/hostile/giant_spider/hunter
	var/swarmling_faction = "spiders"

/mob/living/simple_animal/hostile/giant_spider/carrier/New()
	spiderling_count = rand(5,10)
	adjust_scale(1.2)
	..()

/mob/living/simple_animal/hostile/giant_spider/carrier/death()
	visible_message("<span class='notice'>\The [src]'s abdomen splits as it rolls over, spiderlings crawling from the wound.</span>")
	spawn(1)
		for(var/I = 1 to spiderling_count)
			if(prob(10) && src)
				var/mob/living/simple_animal/hostile/giant_spider/swarmling = new swarmling_type(src.loc)
				var/swarm_health = Floor(swarmling.maxHealth * 0.4)
				var/swarm_dam_lower = Floor(melee_damage_lower * 0.4)
				var/swarm_dam_upper = Floor(melee_damage_upper * 0.4)
				swarmling.name = "spiderling"
				swarmling.maxHealth = swarm_health
				swarmling.health = swarm_health
				swarmling.melee_damage_lower = swarm_dam_lower
				swarmling.melee_damage_upper = swarm_dam_upper
				swarmling.faction = swarmling_faction
				swarmling.adjust_scale(0.75)
			else if(src)
				var/obj/effect/spider/spiderling/child = new spiderling_type(src.loc)
				child.skitter()
			else
				break
	return ..()

/mob/living/simple_animal/hostile/giant_spider/carrier/recursive
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes. You have a distinctly <font face='comic sans ms'>bad</font> feeling about this."

	swarmling_type = /mob/living/simple_animal/hostile/giant_spider/carrier/recursive

/*
Hunter Family
*/

//hunters have the most poison and move the fastest, so they can find prey

/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"

	maxHealth = 120
	health = 120
	move_to_delay = 4

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_per_bite = 5

/mob/living/simple_animal/hostile/giant_spider/lurker
	desc = "Translucent and white, it makes you shudder to look at it. This one has incandescent red eyes."
	icon_state = "lurker"
	icon_living = "lurker"
	icon_dead = "lurker_dead"
	alpha = 45

	maxHealth = 100
	health = 100
	move_to_delay = 4

	melee_damage_lower = 5
	melee_damage_upper = 20


	poison_chance = 20
	poison_type = "cryptobiolin"
	poison_per_bite = 2

/mob/living/simple_animal/hostile/giant_spider/lurker/death()
	alpha = 255
	return ..()

/mob/living/simple_animal/hostile/giant_spider/tunneler
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"

	maxHealth = 120
	health = 120
	move_to_delay = 4

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "serotrotium_v"

/mob/living/simple_animal/hostile/giant_spider/tunneler/death()
	spawn(1)
		for(var/I = 1 to rand(3,6))
			if(src)
				new/obj/item/weapon/ore/glass(src.loc)
			else
				break
	return ..()

/*
Guard Family
*/

/mob/living/simple_animal/hostile/giant_spider/pepper
	desc = "Red and brown, it makes you shudder to look at it. This one has glinting red eyes."
	icon_state = "pepper"
	icon_living = "pepper"
	icon_dead = "pepper_dead"

	maxHealth = 210
	health = 210

	melee_damage_lower = 5
	melee_damage_upper = 10

	poison_chance = 20
	poison_per_bite = 5
	poison_type = "condensedcapsaicin_v"

/mob/living/simple_animal/hostile/giant_spider/pepper/New()
	adjust_scale(1.1)
	..()

/mob/living/simple_animal/hostile/giant_spider/thermic
	desc = "Mirage-cloaked and orange, it makes you shudder to look at it. This one has simmering orange eyes."
	icon_state = "pit"
	icon_living = "pit"
	icon_dead = "pit_dead"

	maxHealth = 175
	health = 175

	melee_damage_lower = 5
	melee_damage_upper = 15

	poison_chance = 30
	poison_per_bite = 1
	poison_type = "thermite_v"

/mob/living/simple_animal/hostile/giant_spider/electric
	desc = "Spined and yellow, it makes you shudder to look at it. This one has flickering gold eyes."
	icon_state = "spark"
	icon_living = "spark"
	icon_dead = "spark_dead"

	maxHealth = 210
	health = 210
	taser_kill = 0 //It -is- the taser.

	melee_damage_lower = 5
	melee_damage_upper = 10

	ranged = 1
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/stun/weak
	firing_lines = 1
	cooperative = 1

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "stimm"

/mob/living/simple_animal/hostile/giant_spider/phorogenic
	desc = "Crystalline and purple, it makes you shudder to look at it. This one has haunting purple eyes."
	icon_state = "phoron"
	icon_living = "phoron"
	icon_dead = "phoron_dead"

	maxHealth = 225
	health = 225
	taser_kill = 0 //You will need more than a peashooter to kill the juggernaut.

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_chance = 30
	poison_per_bite = 0.5
	poison_type = "phoron"

	var/exploded = 0

/mob/living/simple_animal/hostile/giant_spider/phorogenic/New()
	adjust_scale(1.25)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/phorogenic/death()
	visible_message("<span class='danger'>\The [src]'s body begins to rupture!</span>")
	spawn(rand(1,5))
		if(src && !exploded)
			visible_message("<span class='critical'>\The [src]'s body detonates!</span>")
			exploded = 1
			explosion(src.loc, 1, 2, 4, 6)
	return ..()

/mob/living/simple_animal/hostile/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."
	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	melee_damage_lower = 15
	melee_damage_upper = 20

	poison_per_bite = 5
	poison_type = "cryotoxin"

/*
Spider Procs
*/

/mob/living/simple_animal/hostile/giant_spider/New(var/location, var/atom/parent)
	get_light_and_color(parent)
	add_eyes()
	..()

/mob/living/simple_animal/hostile/giant_spider/death()
	remove_eyes()
	..()

/mob/living/simple_animal/hostile/giant_spider/DoPunch(var/atom/A)
	. = ..()
	if(.) // If we succeeded in hitting.
		if(isliving(A))
			var/mob/living/L = A
			if(L.reagents)
				var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
				if(L.can_inject(src, null, target_zone))
					L.reagents.add_reagent(poison_type, poison_per_bite)
					if(prob(poison_chance))
						to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
						L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_animal/hostile/giant_spider/nurse/DoPunch(var/atom/A)
	. = ..()
	if(.) // If we succeeded in hitting.
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(prob(egg_inject_chance))
				var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
				if(H.can_inject(src, null, target_zone))
					var/obj/item/organ/external/O = H.get_organ(target_zone)
					var/eggcount
					for(var/obj/I in O.implants)
						if(istype(I, /obj/effect/spider/eggcluster))
							eggcount ++
					if(!eggcount)
						var/eggs = new /obj/effect/spider/eggcluster/small(O, src)
						O.implants += eggs
						to_chat(H, "<font size='3'><span class='warning'>\The [src] injects something into your [O.name]!</span></font>")

/mob/living/simple_animal/hostile/giant_spider/webslinger/DoPunch(var/atom/A)
	. = ..()
	if(.) // If we succeeded in hitting.
		if(isliving(A))
			var/mob/living/L = A
			var/obj/effect/spider/stickyweb/W = locate() in get_turf(L)
			if(!W && prob(75))
				visible_message("<span class='danger'>\The [src] throws a layer of web at \the [L]!</span>")
				new /obj/effect/spider/stickyweb(L.loc)

/mob/living/simple_animal/hostile/giant_spider/handle_stance()
	. = ..()
	if(ai_inactive) return

	switch(stance)
		if(STANCE_IDLE)
		//1% chance to skitter madly away
			if(!busy && prob(1))
				/*var/list/move_targets = list()
				for(var/turf/T in orange(20, src))
					move_targets.Add(T)*/
				stop_automated_movement = 1
				walk_to(src, pick(orange(20, src)), 1, move_to_delay)
				spawn(5 SECONDS)
					stop_automated_movement = 0
					walk(src,0)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(10 SECONDS)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(stance == STANCE_IDLE)
		var/list/can_see = view(src, 10)
		//30% chance to stop wandering and do something
		if(!busy && prob(30))
			//first, check for potential food nearby to cocoon
			for(var/mob/living/C in can_see)
				if(C.stat)
					cocoon_target = C
					busy = MOVING_TO_TARGET
					walk_to(src, C, 1, move_to_delay)
					//give up if we can't reach them after 10 seconds
					GiveUp(C)
					return

			//second, spin a sticky spiderweb on this tile
			var/obj/effect/spider/stickyweb/W = locate() in get_turf(src)
			if(!W)
				busy = SPINNING_WEB
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance.</span>")
				stop_automated_movement = 1
				spawn(40)
					if(busy == SPINNING_WEB)
						new /obj/effect/spider/stickyweb(src.loc)
						busy = 0
						stop_automated_movement = 0
			else
				//third, lay an egg cluster there
				var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
				if(!E && fed > 0)
					busy = LAYING_EGGS
					src.visible_message("<span class='notice'>\The [src] begins to lay a cluster of eggs.</span>")
					stop_automated_movement = 1
					spawn(50)
						if(busy == LAYING_EGGS)
							E = locate() in get_turf(src)
							if(!E)
								new /obj/effect/spider/eggcluster(loc, src)
								fed--
							busy = 0
							stop_automated_movement = 0
				else
					//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
					for(var/obj/O in can_see)

						if(O.anchored)
							continue

						if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
							cocoon_target = O
							busy = MOVING_TO_TARGET
							stop_automated_movement = 1
							walk_to(src, O, 1, move_to_delay)
							//give up if we can't reach them after 10 seconds
							GiveUp(O)

		else if(busy == MOVING_TO_TARGET && cocoon_target)
			if(get_dist(src, cocoon_target) <= 1)
				busy = SPINNING_COCOON
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance around \the [cocoon_target].</span>")
				stop_automated_movement = 1
				walk(src,0)
				spawn(50)
					if(busy == SPINNING_COCOON)
						if(cocoon_target && istype(cocoon_target.loc, /turf) && get_dist(src,cocoon_target) <= 1)
							var/obj/effect/spider/cocoon/C = new(cocoon_target.loc)
							var/large_cocoon = 0
							C.pixel_x = cocoon_target.pixel_x
							C.pixel_y = cocoon_target.pixel_y
							for(var/mob/living/M in C.loc)
								if(istype(M, /mob/living/simple_animal/hostile/giant_spider))
									continue
								large_cocoon = 1
								fed++
								src.visible_message("<span class='warning'>\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out.</span>")
								M.forceMove(C)
								C.pixel_x = M.pixel_x
								C.pixel_y = M.pixel_y
								break
							for(var/obj/item/I in C.loc)
								I.forceMove(C)
							for(var/obj/structure/S in C.loc)
								if(!S.anchored)
									S.forceMove(C)
									large_cocoon = 1
							for(var/obj/machinery/M in C.loc)
								if(!M.anchored)
									M.forceMove(C)
									large_cocoon = 1
							if(large_cocoon)
								C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
						busy = 0
						stop_automated_movement = 0

	else
		busy = 0
		stop_automated_movement = 0


#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
