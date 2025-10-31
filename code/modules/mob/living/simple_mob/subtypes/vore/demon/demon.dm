/mob/living/simple_mob/vore/demon
	name = "Rift Walker"
	desc = "A large bipedal creature, its body has a mixture of dark fur and scales. Marks on the creature's body pulse slowly with red light."

	icon_state = "boxfox"
	icon_living = "boxfox"
	icon_dead = "boxfox_dead"
	icon_rest = "boxfox_rest"
	icon = 'icons/mob/demon_vr.dmi'
	vis_height = 47

	faction = FACTION_DEMON
	maxHealth = 200
	health = 200
	movement_cooldown = 0

	see_in_dark = 10
	has_hands = TRUE
	seedarkness = FALSE
	attack_sound = 'sound/misc/demonattack.ogg'
	has_langs = list(LANGUAGE_GALCOM,LANGUAGE_DAEMON,LANGUAGE_SHADEKIN,LANGUAGE_CULT)

	melee_damage_lower = 20
	melee_damage_upper = 15
	var/poison_chance = 50
	var/poison_type = REAGENT_ID_MINDBREAKER
	var/poison_per_bite = 3

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 323

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	attacktext = list("mauled","slashed","clawed")
	friendly = list("pokes", "scratches", "rurrs softly at", "sniffs on")

	vore_active = TRUE
	swallowTime = 2 SECOND
	vore_pounce_chance = 15
	vore_icons = SA_ICON_LIVING
	vore_escape_chance = 25

	var/shifted_out = FALSE
	var/shift_state = AB_SHIFT_NONE
	var/last_shift = 0
	var/blood_spawn = 0
	var/is_shifting = FALSE

	var/enable_autolaugh = FALSE //Whether user controlled mob will laugh when interacting automatically.
	var/laugh = 'sound/misc/demonlaugh.ogg' //Yknow maybe someone wants a custom laugh, you never know.
	injury_enrages = TRUE

	var/list/alt_demon_appearances = list("boxfox","eater","engorge","wendigo","zellic","avarn","covern","ira","ire","laxel","lutra","brutola","ignia") // Allow extra decals

/mob/living/simple_mob/vore/demon/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "You slide down the slick, slippery gullet of the creature. It's warm, and the air is thick. You can feel the doughy walls of the creatures gut push and knead into your form! Slimy juices coat your form stinging against your flesh as they waste no time to start digesting you. The creature's heartbeat and the gurgling of their stomach are all you can hear as your jostled about, treated like nothing but food."

/mob/living/simple_mob/vore/demon/UnarmedAttack()
	if(shifted_out)
		return FALSE
	. = ..()

/mob/living/simple_mob/vore/demon/can_fall()
	if(shifted_out)
		return FALSE
	. = ..()

/mob/living/simple_mob/vore/demon/zMove(direction)
	if(shifted_out)
		var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
		if(destination)
			forceMove(destination)
		return TRUE
	. = ..()

/mob/living/simple_mob/vore/demon/Life()
	. = ..()
	if(shifted_out)
		density = FALSE

/mob/living/simple_mob/vore/demon/handle_environment(datum/gas_mixture/environment) // TODO - Refactor demons to use is_incorporeal()
	if(shifted_out)
		return
	. = ..()

/mob/living/simple_mob/vore/demon/update_canmove()
	if(is_shifting)
		canmove = FALSE
		return canmove
	. = ..()

/mob/living/simple_mob/vore/demon/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

/mob/living/simple_mob/vore/demon/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel a tiny prick."))
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/vore/demon/death()
	laugh()
	..()

/mob/living/simple_mob/vore/demon/bullet_act()
	laugh()
	..()

/mob/living/simple_mob/vore/demon/attack_hand()
	laugh()
	..()

/mob/living/simple_mob/vore/demon/hitby()
	laugh()
	..()

/mob/living/simple_mob/vore/demon/attackby()
	laugh()
	..()
//This below proc could be improved by 1. add a bool for overriding the check (if we directly call the proc for example)
//and possibly adding a switch that checks a string given by the above procs so that we can have uniwue sounds if needed
/mob/living/simple_mob/vore/demon/proc/laugh()
	if(!src.ckey || enable_autolaugh)
		playsound(src, laugh, 50, 1)

//Fire heals demons instead.
//This should include all fire sources assuming they dont weirdly make their own damage handling.
//Yes this also means that negative fire is bad for them...
/mob/living/simple_mob/vore/demon/adjustFireLoss(amount,include_robo = TRUE)
	amount = 0 - amount
	src.adjustBruteLoss(amount)
	..()


/mob/living/simple_mob/vore/demon/verb/alt_appearance()
	set name = "Toggle Alernate Appearance"
	set desc = "Change your sprite to an alternative one."
	set category = "Abilities.Demon"

	if(!LAZYLEN(alt_demon_appearances))
		to_chat(src, span_warning("There are no alternative apperances selectable!"))
		return

	var/alternate_selection = tgui_input_list(src, "Please select which alternate appearance you want to swap to.", "Variant Sprite", alt_demon_appearances)
	if(!alternate_selection)
		return

	alternate_selection = lowertext(alternate_selection)

	//Change the all the icon info.
	icon = 'icons/mob/demon_vr.dmi' //Mass majority of the sprites use this icon
	icon_state = "[alternate_selection]"
	icon_living = "[alternate_selection]"
	icon_dead = "dead"
	icon_rest = "[alternate_selection]_rest"
	vis_height = 47 //Mass majority of sprites use vis_height = 47. If its different, its done below.
	pixel_x = 0
	vore_icons = FALSE //No stomach sprites unless specifically specified!
	//This is where we handle the special ones!
	switch(alternate_selection)
		if("boxfox")
			vore_icons = SA_ICON_LIVING
			vore_capacity = 1

		if("wendigo")
			vore_icons = SA_ICON_LIVING
			vore_capacity = 1
			icon_dead = "[alternate_selection]_dead"

		//These are the larger variants, so we do some different stuff here!
		if("brutola")
			pixel_x = -8
			vis_height = 64
			vore_icons = SA_ICON_LIVING | SA_ICON_REST
			vore_capacity = 2
			icon_dead = "[alternate_selection]_dead"
			icon = 'icons/mob/demon_alt.dmi'

		if("ignia")
			pixel_x = -8
			vis_height = 64
			vore_icons = SA_ICON_LIVING
			vore_capacity = 2
			icon_dead = "[alternate_selection]_dead"
			icon = 'icons/mob/demon_alt.dmi'
	update_icon()
