/mob/living/carbon/human/proc/reagent_purge()
	set name = "Purge Reagents"
	set desc = "Empty yourself of any reagents you may have consumed or come into contact with."
	set category = "IC.Game"

	if(stat == DEAD) return

	to_chat(src, span_notice("Performing reagent purge, please wait..."))
	sleep(50)
	src.bloodstr.clear_reagents()
	src.ingested.clear_reagents()
	src.touching.clear_reagents()
	to_chat(src, span_notice("Reagents purged!"))

	return TRUE

/mob/living/carbon/human/verb/toggle_eyes_layer()
	set name = "Switch Eyes/Monitor Layer"
	set desc = "Toggle rendering of eyes/monitor above markings."
	set category = "IC.Settings"

	if(stat)
		to_chat(src, span_warning("You must be awake and standing to perform this action!"))
		return
	var/obj/item/organ/external/head/H = organs_by_name[BP_HEAD]
	if(!H)
		to_chat(src, span_warning("You don't seem to have a head!"))
		return

	H.eyes_over_markings = !H.eyes_over_markings
	update_icons_body()

	if(H.robotic)
		var/datum/robolimb/robohead = all_robolimbs[H.model]
		if(robohead.monitor_styles && robohead.monitor_icon)
			to_chat(src, span_notice("You reconfigure the rendering order of your facial display."))

	return TRUE

//////////// Hand games that can be played by people next to each other, or over a small table.

/mob/living/carbon/human/verb/hand_games()
	set name = "Play Hand Games"
	set desc = "Choose from a variety of hand games to play with someone next to you or across a small table."
	set category = "IC.Game"

	if(stat)
		return

	var/obj/item/organ/external/l_hand = get_organ(BP_L_HAND)
	var/obj/item/organ/external/r_hand = get_organ(BP_R_HAND)
	if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
		to_chat(src, span_warning("You have no hands to play games with!"))
		return

	var/list/nearby = list()
	for(var/mob/living/carbon/human/H in range(src,1))
		if(H.stat)
			continue
		if(H == src)
			continue
		var/obj/item/organ/external/l_hand2 = H.get_organ(BP_L_HAND)
		var/obj/item/organ/external/r_hand2 = H.get_organ(BP_R_HAND)
		if((!l_hand2 || l_hand2.is_stump()) && (!r_hand2 || r_hand2.is_stump()))
			continue
		nearby |= H
	for(var/obj/structure/table/T in range(src, 1))
		for(var/mob/living/carbon/human/H in range(T,1))
			if(H.stat)
				continue
			if(H == src)
				continue
			var/obj/item/organ/external/l_hand2 = H.get_organ(BP_L_HAND)
			var/obj/item/organ/external/r_hand2 = H.get_organ(BP_R_HAND)
			if((!l_hand2 || l_hand2.is_stump()) && (!r_hand2 || r_hand2.is_stump()))
				continue
			nearby |= H

	if(!nearby.len)
		to_chat(src, span_warning("There is nobody nearby to play games with!"))

	var/partner = tgui_input_list(src, "Choose a game partner:", "Hand games", nearby)
	if(!partner)
		return
	var/choose_game = tgui_alert(src, "Choose a game to play with [partner]?", "Hand games", list("Rock, Paper, Scissors", "Arm Wrestling", "Slap Hands", "Thumb Wars", "Cancel"))

	if(!choose_game || (choose_game == "Cancel"))
		return

	if(choose_game == "Rock, Paper, Scissors")
		game_rps(src,partner)

	if(choose_game == "Arm Wrestling")
		game_armwrestle(src,partner)

	if(choose_game == "Slap Hands")
		game_slaphands(src,partner)

	if(choose_game == "Thumb Wars")
		game_thumbwars(src,partner)

// Checks to make sure everything is fine to continue playing.

/mob/living/carbon/human/proc/hand_games_check(var/mob/living/carbon/human/player1, var/mob/living/carbon/human/player2)
	if(!istype(player1) || !istype(player2))
		return 0
	if(player1.stat || player2.stat) //Make sure they're still standing
		return 0
	if(!(player2 in range(player1,2))) //Just make sure they're within 2 spaces still.
		return 0

	return 1

///// A simple game of rock paper scissors, each player chooses an option and the choices are declared simultaneously.

/mob/living/carbon/human/proc/game_rps(var/mob/living/carbon/human/player1, var/mob/living/carbon/human/player2)
	if(!hand_games_check(player1,player2))
		return
	to_chat(player1, span_notice("Asking [player2] if they want to play Rock, Paper, Scissors!"))
	var/playgame = tgui_alert(player2, "[player1] wants to play Rock, Paper, Scissors.", "Rock, Paper, Scissors", list("Play", "Refuse"))
	if(!playgame || (playgame == "Refuse"))
		to_chat(player1, span_warning("[player2] declines to play the game."))
		return
	else
		player1.visible_message(span_notice("[player1] challenges [player2] to Rock, Paper, Scissors!"))
		to_chat(player2, span_warning("[player1] is deciding."))
		var/choice1 = tgui_alert(player1, "Choose your attack!", "Rock, Paper, Scissors", list("Rock", "Paper", "Scissors", "Cancel"))
		if(choice1 == "Cancel")
			player1.visible_message(span_notice("[player1] chickens out!"))
		if(!hand_games_check(player1,player2))
			return
		to_chat(player1, span_warning("[player2] is deciding."))
		var/choice2 = tgui_alert(player2, "Choose your attack!", "Rock, Paper, Scissors", list("Rock", "Paper", "Scissors", "Cancel"))
		if(choice2 == "Cancel")
			player2.visible_message(span_notice("[player2] chickens out!"))
		if(!hand_games_check(player1,player2))
			return
		if(choice1 == choice2)
			player1.visible_message(span_notice("[player1] and [player2] both choose [choice1], it's a draw!"))
		else
			player1.visible_message(span_notice("[player1] chooses [choice1]!"))
			player2.visible_message(span_notice("[player2] chooses [choice2]!"))

/////// Arm wrestling! Each player gets a modifier based on their size and can choose the strength of their character, then a weighted roll is made.

/mob/living/carbon/human/proc/game_armwrestle(var/mob/living/carbon/human/player1, var/mob/living/carbon/human/player2)
	if(!hand_games_check(player1,player2))
		return
	to_chat(player1, span_notice("Asking [player2] if they want to play Arm Wrestling!"))
	var/playgame = tgui_alert(player2, "[player1] wants to play Arm Wrestling.", "Arm Wrestling", list("Play", "Refuse"))
	if(!playgame || (playgame == "Refuse"))
		to_chat(player1, span_warning("[player2] declines to play the game."))
		return
	else
		if(!hand_games_check(player1,player2))
			return
		player1.visible_message(span_notice("[player1] challenges [player2] to Arm Wrestling!"))
		var/scale1 = player1.size_multiplier
		var/scale2 = player2.size_multiplier
		to_chat(player2, span_warning("[player1] is getting ready."))
		var/strength1 = tgui_input_number(player1, "How strong is your character on a scale of 1 to 10 (1 being a weakling, 10 being very strong).", "Strength")
		strength1 = clamp(strength1, 1, 10)
		if(!strength1)
			player1.visible_message(span_notice("[player1] chickens out!"))
		if(!hand_games_check(player1,player2))
			return
		to_chat(player1, span_warning("[player2] is getting ready."))
		var/strength2 = tgui_input_number(player2, "How strong is your character on a scale of 1 to 10 (1 being a weakling, 10 being very strong).", "Strength")
		strength2 = clamp(strength2, 1, 10)
		if(!strength2)
			player2.visible_message(span_notice("[player2] chickens out!"))
		if(!hand_games_check(player1,player2))
			return

		var/score1 = (scale1 * strength1)
		var/score2 = (scale2 * strength2)

		var/competition = pick(score1;player1, score2;player2)
		if(!do_after(player1, 50, player2, exclusive = TASK_USER_EXCLUSIVE))
			player2.visible_message(span_notice("The players cancelled their competition!"))
			return 0
		if(!hand_games_check(player1,player2))
			return
		if(competition == player1)
			player1.visible_message(span_notice("[player1] manages to overpower [player2] and pin their arm down!"))
		else
			player2.visible_message(span_notice("[player2] manages to overpower [player1] and pin their arm down!"))

/////// Slap Hands! Each player gets a modifier based on their size and can choose the reaction time of their character, then a weighted roll is made. This one gives the advantage to smaller players.

/mob/living/carbon/human/proc/game_slaphands(var/mob/living/carbon/human/player1, var/mob/living/carbon/human/player2)
	if(!hand_games_check(player1,player2))
		return
	to_chat(player1, span_notice("Asking [player2] if they want to play Slap Hands!"))
	var/playgame = tgui_alert(player2, "[player1] wants to play Slap Hands.", "Slap Hands", list("Play", "Refuse"))
	if(!playgame || (playgame == "Refuse"))
		to_chat(player1, span_warning("[player2] declines to play the game."))
		return
	else
		if(!hand_games_check(player1,player2))
			return
		player1.visible_message(span_notice("[player1] challenges [player2] to Slap Hands!"))
		var/scale1 = (2.25 - player1.size_multiplier)
		scale1 = clamp(scale1, 0.1, 3)
		var/scale2 = (2.25 - player2.size_multiplier)
		scale2 = clamp(scale2, 0.1, 3)
		to_chat(player2, span_warning("[player1] is getting ready."))
		var/strength1 = tgui_input_number(player1, "How fast are your character's reaction times on a scale of 1 to 10 (1 being slow, 10 being very fast).", "Speed")
		strength1 = clamp(strength1, 1, 10)
		if(!strength1)
			player1.visible_message(span_notice("[player1] chickens out!"))
		if(!hand_games_check(player1,player2))
			return
		to_chat(player1, span_warning("[player2] is getting ready."))
		var/strength2 = tgui_input_number(player2, "How fast are your character's reaction times on a scale of 1 to 10 (1 being slow, 10 being very fast).", "Speed")
		strength2 = clamp(strength2, 1, 10)
		if(!strength2)
			player2.visible_message(span_notice("[player2] chickens out!"))
		if(!hand_games_check(player1,player2))
			return

		var/score1 = (scale1 * strength1)
		var/score2 = (scale2 * strength2)

		var/competition = pick(score1;player1, score2;player2)
		if(!do_after(player1, 10, player2, exclusive = TASK_USER_EXCLUSIVE))
			player2.visible_message(span_notice("The players cancelled their competition!"))
			return 0
		if(!hand_games_check(player1,player2))
			return
		playsound(player1, 'sound/effects/snap.ogg', 30, 1)
		if(competition == player1)
			player1.visible_message(span_notice("[player1] manages to slap [player2]'s hand before they can react!"))
		else
			player2.visible_message(span_notice("[player2] manages to slap [player1]'s hand before they can react!"))

///// Thumb wars! This one is just pure chance to allow people to do just quick RNG.

/mob/living/carbon/human/proc/game_thumbwars(var/mob/living/carbon/human/player1, var/mob/living/carbon/human/player2)
	if(!hand_games_check(player1,player2))
		return
	to_chat(player1, span_notice("Asking [player2] if they want to play Thumb Wars!"))
	var/playgame = tgui_alert(player2, "[player1] wants to play Thumb Wars.", "Thumb Wars", list("Play", "Refuse"))
	if(!playgame || (playgame == "Refuse"))
		to_chat(player1, span_warning("[player2] declines to play the game."))
		return
	else
		if(!hand_games_check(player1,player2))
			return
		player1.visible_message(span_notice("[player1] challenges [player2] to a thumb war!"))
		if(!do_after(player1, 50, player2, exclusive = TASK_USER_EXCLUSIVE))
			player2.visible_message(span_notice("The players cancelled their thumb war!"))
			return 0
		if(!hand_games_check(player1,player2))
			return
		if(prob(50))
			player1.visible_message(span_notice("After a gruelling battle, [player1] eventually manages to subdue the thumb of [player2]!"))
		else
			player2.visible_message(span_notice("After a gruelling battle, [player2] eventually manages to subdue the thumb of [player1]!"))
