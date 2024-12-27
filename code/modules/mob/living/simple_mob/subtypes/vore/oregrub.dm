/datum/category_item/catalogue/fauna/oregrub
	name = "Oregrub"
	desc = "Some form of mutated space larva, they seem to feed on minerals. This makes them the natural enemy of miners. \
	To make matters worse, these creatures will flee when threatened. More than a few foolhardy miners have met their end chasing down oregrubs after some other hostile creature attacked them. \
	Their guts tend to contain undigested minerals, so miners who are quick (and not afraid to get their hands dirty) can reap some rewards from these leathery lithovores."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/lavagrub
	name = "Lavagrub"
	desc = "Some form of mutated space larva, they seem to feed on minerals. This makes them the natural enemy of miners. \
	To make matters worse, these creatures will flee when threatened. More than a few foolhardy miners have met their end chasing down oregrubs after some other hostile creature attacked them. \
	This particular variant seems to be even tougher and faster than its common brown kin, and its hide is laced with silicates that make it more durable. \
	On the plus side, it's sure to contain even more valuable minerals within its bowels, if you can catch up with it to crack it open..."
	value = CATALOGUER_REWARD_MEDIUM

/datum/ai_holder/simple_mob/oregrub
	hostile = FALSE			//docile, unless you hit them
	retaliate = TRUE		//they *may* bite you...
	can_flee = TRUE			//but they'd rather run away
	dying_threshold = 1		//and ideally, we flee as soon as possible
	flee_when_outmatched = TRUE	//especially when outmatched
	outmatched_threshold = 25	//and we're outmatched by... basically everything!

/datum/ai_holder/simple_mob/oregrub/lava
	outmatched_threshold = 15

/mob/living/simple_mob/vore/oregrub
	name = "juvenile oregrub"
	desc = "A young, leathery oregrub."
	catalogue_data = list(/datum/category_item/catalogue/fauna/oregrub)
	icon = 'icons/mob/vore.dmi' //all of these are placeholders
	icon_state = "oregrub"
	icon_living = "oregrub"
	icon_dead = "oregrub-dead"

	faction = FACTION_GRUBS
	maxHealth = 50 //oregrubs are quite hardy
	health = 50

	melee_damage_lower = 1
	melee_damage_upper = 3	//low damage, they prefer to flee

	movement_cooldown = 3.5

	meat_type = /obj/item/ore/coal

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	ai_holder_type = /datum/ai_holder/simple_mob/oregrub
	say_list_type = /datum/say_list/oregrub

	var/poison_per_bite = 2.5
	var/poison_type = REAGENT_ID_THERMITEV //burn baby burn
	var/poison_chance = 50

	var/min_ore = 4
	var/max_ore = 7

	vore_bump_chance = 0 //disabled for now
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 0 //disabled for now
	vore_capacity = 1
	vore_pounce_chance = 0 //grubs only eat incapacitated targets
	vore_default_mode = DM_DIGEST

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1000
	poison_resist = 1.0

	//these things are resilient, on account of being infused with all the minerals they eat
	armor = list(
				"melee"		= 25,
				"bullet"	= 15,
				"laser"		= 15,
				"energy"	= 0,
				"bomb"		= 25,
				"bio"		= 100,
				"rad"		= 100
				)

	glow_override = TRUE

/mob/living/simple_mob/vore/oregrub/lava
	name = "mature lavagrub"
	desc = "A mature, rocky lavagrub"
	catalogue_data = list(/datum/category_item/catalogue/fauna/lavagrub)
	icon_state = "lavagrub"
	icon_living = "lavagrub"
	icon_dead = "lavagrub-dead"

	movement_cooldown = 2
	maxHealth = 75 //lavagrubs are really hardy
	health = 75
	ai_holder_type = /datum/ai_holder/simple_mob/oregrub/lava
	//lavagrubs have even more armor than oregrubs
	armor = list(
				"melee"		= 50,
				"bullet"	= 25,
				"laser"		= 25,
				"energy"	= 0,
				"bomb"		= 50,
				"bio"		= 100,
				"rad"		= 100
				)

	var/lava_min_ore = 6
	var/lava_max_ore = 10

	poison_per_bite = 5
	poison_chance = 66

/datum/say_list/oregrub
	emote_see = list("burbles", "chitters", "snuffles around for fresh ore")

/mob/living/simple_mob/vore/oregrub/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
		if(L.can_inject(src, null, target_zone))
			inject_poison(L, target_zone)

/mob/living/simple_mob/vore/oregrub/death()
	visible_message(span_warning("\The [src] shudders and collapses, expelling the ores it had devoured!"))
	var/i = rand(min_ore,max_ore)
	while(i>1)
		var/ore = pick(/obj/item/ore/glass,/obj/item/ore/coal,/obj/item/ore/iron,/obj/item/ore/lead,/obj/item/ore/marble,/obj/item/ore/phoron,/obj/item/ore/silver,/obj/item/ore/gold)
		new ore(src.loc)
		i--
	..()

/mob/living/simple_mob/vore/oregrub/lava/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_ORANGE)
		return 1
	else if(is_dead())
		glow_override = FALSE

/mob/living/simple_mob/vore/oregrub/lava/death()
	set_light(0)
	var/p = rand(lava_min_ore,lava_max_ore)
	while(p>1)
		var/ore = pick(/obj/item/ore/osmium,/obj/item/ore/uranium,/obj/item/ore/hydrogen,/obj/item/ore/diamond,/obj/item/ore/verdantium)
		new ore(src.loc)
		p--
	..()

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/oregrub/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel fire running through your veins!"))
		L.reagents.add_reagent(poison_type, poison_per_bite)

//I'm no good at writing this stuff, so I've just left it as placeholders and disabled the chances of them eating you.
/*
/mob/living/simple_mob/vore/oregrub/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "PLACEHOLDER!"

	B.emote_lists[DM_HOLD] = list(
		"PLACEHOLDER!")

	B.emote_lists[DM_DIGEST] = list(
		"PLACEHOLDER!")
*/
