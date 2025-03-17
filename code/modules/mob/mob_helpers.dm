// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/isxenomorph(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		return istype(H.species, /datum/species/xenos)
	return 0

/proc/issmall(A)
	if(A && isliving(A))
		var/mob/living/L = A
		return L.mob_size <= MOB_SMALL
	return 0

//returns the number of size categories between two mob_sizes, rounded. Positive means A is larger than B
/proc/mob_size_difference(var/mob_size_A, var/mob_size_B)
	return round(log(2, mob_size_A/mob_size_B), 1)

/mob/proc/can_wield_item(obj/item/W)
	if(W.w_class >= ITEMSIZE_LARGE && issmall(src))
		return FALSE //M is too small to wield this
	return TRUE

/proc/istiny(A)
	if(A && isliving(A))
		var/mob/living/L = A
		return L.mob_size <= MOB_TINY
	return 0


/proc/ismini(A)
	if(A && isliving(A))
		var/mob/living/L = A
		return L.mob_size <= MOB_MINISCULE
	return 0

/mob/living/silicon/isSynthetic()
	return 1

/mob/proc/isMonkey()
	return 0

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)

/proc/isdeaf(A)
	if(istype(A, /mob))
		var/mob/M = A
		return (M.sdisabilities & DEAF) || M.ear_deaf
	return 0

/mob/proc/get_ear_protection()
	return 0

/mob/proc/break_cloak()
	return

/mob/proc/is_cloaked()
	return FALSE

/proc/hasorgans(A) // Fucking really??
	return ishuman(A)

/proc/iscuffed(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.handcuffed)
			return 1
	return 0

/proc/hassensorlevel(A, var/level)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode >= level
	return 0

/proc/getsensorlevel(A)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode
	return SUIT_SENSOR_OFF


/proc/is_admin(var/mob/user)
	return check_rights_for(user.client, R_ADMIN|R_EVENT) != 0

/**
 * Moved into its own file as part of port from CHOMP.
 *
/proc/hsl2rgb(h, s, l)
	return //TODO: Implement
*/
/*
	Miss Chance
*/

/proc/check_zone(zone)
	if(!zone)	return BP_TORSO
	switch(zone)
		if(O_EYES)
			zone = BP_HEAD
		if(O_MOUTH)
			zone = BP_HEAD
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
			organ_rel_size[BP_HEAD];   BP_HEAD,
			organ_rel_size[BP_TORSO];  BP_TORSO,
			organ_rel_size[BP_GROIN];  BP_GROIN,
			organ_rel_size[BP_L_ARM];  BP_L_ARM,
			organ_rel_size[BP_R_ARM];  BP_R_ARM,
			organ_rel_size[BP_L_LEG];  BP_L_LEG,
			organ_rel_size[BP_R_LEG];  BP_R_LEG,
			organ_rel_size[BP_L_HAND]; BP_L_HAND,
			organ_rel_size[BP_R_HAND]; BP_R_HAND,
			organ_rel_size[BP_L_FOOT]; BP_L_FOOT,
			organ_rel_size[BP_R_FOOT]; BP_R_FOOT,
		)

	return ran_zone

/// Hit and miss chance is calculated here.
/// Returns: null(miss) or zone(hit)
/// Has a variety of toggles. In short:
/// always_hit: Miss chance is not calculateed. Always hit the zone it's targeting. (Default: FALSE)
/// user_misses: If Player Characters are subjected to RNG hitchance on other Player Characters (Default: FALSE)
/// mob_misses: If mobs are subjected to RNG hitchance on Player Characters (Default: TRUE)
/proc/get_zone_with_miss_chance(zone, mob/target, miss_chance_mod = 0, ranged_attack=0, force_hit = FALSE, mob/living/attacker)
	zone = check_zone(zone)


	/// Toggle for servers that desire to have attacks ALWAYS hit, since force_hit isn't always its default.
	/// NOTE: This means that mobs will ALWAYS hit players and leads to much more punishing combat.
	/// The system as is gives players an edge in PvE, while enabling always_hit gives mobs an edge in PvE.
	var/always_hit = FALSE
	if(always_hit)
		return zone

	if(!ranged_attack)
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.lying)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.state >= GRAB_AGGRESSIVE)
				return zone

	if(force_hit)
		return zone

	//This is done here now, since previously it was just done in a dumb spot that made no sense.
	//Even if you were Neo, anyone could land a blow on you.
	var/has_evasion_chance = FALSE
	if(isliving(target))
		var/mob/living/our_target = target
		var/evasion_chance = our_target.get_evasion()

		if(!evasion_chance && !target.client) //If our target HAS no evasion chance and they're an NPC, we hit.
			return zone
		if(evasion_chance)
			has_evasion_chance = TRUE
			miss_chance_mod += evasion_chance
	//However, get_accuracy_penalty() is also used in eyestab, open-hand clicking someone, and resolve_item_attack()
	//The big one is resolve_item_attack(). It's the 'we are hit in melee combat'
	//We are unable to include it here as it is dependent on the attacker, so we'll let it just continue being calculated where it is.

	if(has_evasion_chance && miss_chance_mod > 0 && prob(miss_chance_mod))
		return null

	if(!target.client) //If the target is an NPC, we will always hit (barring extreme circumstances like mobs having modified evasion, handled above). Removes baymiss against mobs.
		return zone

	/// Toggle for servers that desire to have players able to miss each other.
	/// This is if users are subjected to the same RNG hitchance against other players as mobs are.
	/// By default, this is set to off, as evasion being calculated is (in my eyes) enough for PvP combat.
	/// However, if you wish to enable it so there's miss chance, flip this FALSE to TRUE
	var/user_misses = FALSE
	if(!user_misses && attacker.client)
		return zone

	/// Toggle for servers that desire to have mobs able to miss players.
	/// If toggled on, mobs will have chances to miss players.
	/// If toggled off, mobs will always hit each players, evasion-not-withstanding
	/// This can make PvE combat feel better for players or introduce some randomization with PvP.
	var/mob_misses = TRUE //Toggle to enable mob missing or not.
	if(!mob_misses && !attacker.client) //If mob_misses is disabled, they land their blow on the zone they're targeting.
		return zone

	//However, if a mob IS attacking a player, let's throw in some RNG into the mix to make it feel better for players.
	//If a mob eats hits and dies, people are happy.
	//If you shoot a mob point blank 10 times and every hit misses, people are upset (and rightfully so)



	var/randomization_chance = 10 //This can also be set to 0 to ensure mobs ALWAYS target the limb they're originally targeting.
	/// First, we roll to see if we're going to target a random limb.
	if(randomization_chance) //We got a 10% chance! Randomize where we're targeting!
		zone = pick(base_miss_chance)

	// Second, we make sure to see if the place we are attacking is a valid area.
	if(zone in base_miss_chance)
		randomization_chance = base_miss_chance[zone]

	// Eyes and mouth can be targeted (although typically not by mobs) so we set it to the head.
	else if (zone == "eyes" || zone == "mouth")
		randomization_chance = base_miss_chance["head"]

	// Finally, now that we have our newfound zone, we see if we miss it or not!
	if(prob(randomization_chance)) //If the mob rolled a miss chance?
		return null //No hit! Player escapes unscathed!
	return zone


/proc/stars(n, pr)
	if (pr == null)
		pr = 25
	if (pr < 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	var/intag = 0
	while(p <= n)
		var/char = copytext(te, p, p + 1)
		if (char == "<") //let's try to not break tags
			intag = !intag
		if (intag || char == " " || prob(pr))
			t = text("[][]", t, char)
		else
			t = text("[]*", t)
		if (char == ">")
			intag = !intag
		p++
	return t

/proc/stars_all(list/message_pieces, pr)
	// eugh, we have to clone the list to avoid collateral damage due to the nature of these messages
	. = list()
	for(var/datum/multilingual_say_piece/S in message_pieces)
		. += new /datum/multilingual_say_piece(S.speaking, stars(S.message))

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,9))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			//if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(2,4,6,9)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter=span_bold("[newletter]")
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (ckey(n_letter) in list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")))
			if (prob(10))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		t = text("[t][n_letter]")//since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the next letter will be.
	return sanitize(t)


/proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			var/rand_set = list("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")
			if(p >= 80)
				rand_set += alphabet_uppercase
			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick(rand_set)

		returntext += letter

	return returntext


/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return sanitize(t)


/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || duration < 1)
		return
	var/client/C = M.client
	var/oldx = C.pixel_x
	var/oldy = C.pixel_y
	var/max = strength * world.icon_size
	var/min = -(strength * world.icon_size)

	for(var/i in 0 to duration - 1)
		if(i == 0)
			animate(C, pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1)
		else
			animate(pixel_x = rand(min, max), pixel_y = rand(min, max), time = 1)
	animate(pixel_x = oldx, pixel_y = oldy, time = 1)

/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[msg]"))
			return 1
	return 0


/mob/proc/abiotic(var/full_body = 0)
	return 0

//converts intent-strings into numbers and back
var/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a mob's act-intent. Input the intent as a string such as I_HELP or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(isliving(src) && !isrobot(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src))
		switch(input)
			if(I_HELP)
				a_intent = I_HELP
			if(I_HURT)
				a_intent = I_HURT
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == I_HURT)
				hud_used.action_intent.icon_state = I_HURT
			else
				hud_used.action_intent.icon_state = I_HELP

/proc/is_blind(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & BLIND || C.blinded)
			return 1
	return 0

/proc/mobs_in_area(var/area/A)
	var/list/mobs = list()
	for(var/M in mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs

//Direct dead say used both by emote and say
//It is somewhat messy. I don't know what to do.
//I know you can't see the change, but I rewrote the name code. It is significantly less messy now
/proc/say_dead_direct(var/message, var/mob/subject = null)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(C.mob) //Most of the time this is the dead/observer mob; we can totally use him if there is no better name
			var/mindname
			var/realname = C.mob.real_name
			if(C.mob.mind)
				mindname = C.mob.mind.name
				if(C.mob.mind.original && C.mob.mind.original.real_name)
					realname = C.mob.mind.original.real_name
			if(mindname && mindname != realname)
				name = "[realname] died as [mindname]"
			else
				name = realname

	if(subject && subject.forbid_seeing_deadchat && !subject.client.holder)
		return // Can't talk in deadchat if you can't see it.

	for(var/mob/M in player_list)
		if(M.client && ((!isnewplayer(M) && M.stat == DEAD) || (M.client.holder && check_rights_for(M.client, R_NONE) && M.client?.prefs?.read_preference(/datum/preference/toggle/holder/show_staff_dsay))) && M.client?.prefs?.read_preference(/datum/preference/toggle/show_dsay))
			var/follow
			var/lname
			if(M.forbid_seeing_deadchat && !M.client.holder)
				continue

			if(subject)
				if(M.is_key_ignored(subject.client.key)) // If we're ignored, do nothing.
					continue
				if(subject != M)
					follow = "([ghost_follow_link(subject, M)]) "
				if(M.stat != DEAD && M.client.holder)
					follow = "([admin_jump_link(subject, M.client.holder)]) "
				var/mob/observer/dead/DM
				if(isobserver(subject))
					DM = subject
				if(M.client.holder) 							// What admins see
					lname = "[keyname][(DM && DM.anonsay) ? "*" : (DM ? "" : "^")] ([name])"
				else
					if(DM && DM.anonsay)						// If the person is actually observer they have the option to be anonymous
						lname = "Ghost of [name]"
					else if(DM)									// Non-anons
						lname = "[keyname] ([name])"
					else										// Everyone else (dead people who didn't ghost yet, etc.)
						lname = name
				lname = span_name("[lname]") + " "
			to_chat(M, span_deadsay("" + create_text_tag("dead", "DEAD:", M.client) + " [lname][follow][message]"))

/proc/say_dead_object(var/message, var/obj/subject = null)
	for(var/mob/M in player_list)
		if(M.client && ((!isnewplayer(M) && M.stat == DEAD) || (M.client.holder && check_rights_for(M.client, R_NONE) && M.client?.prefs?.read_preference(/datum/preference/toggle/holder/show_staff_dsay))) && M.client?.prefs?.read_preference(/datum/preference/toggle/show_dsay))
			var/follow
			var/lname = "Game Master"
			if(M.forbid_seeing_deadchat && !M.client.holder)
				continue

			if(subject)
				lname = "[subject.name] ([subject.x],[subject.y],[subject.z])"

			lname = span_name("[lname]") + " "
			to_chat(M, span_deadsay("" + create_text_tag("event_dead", "EVENT:", M.client) + " [lname][follow][message]"))

//Announces that a ghost has joined/left, mainly for use with wizards
/proc/announce_ghost_joinleave(O, var/joined_ghosts = 1, var/message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(istype(O, /mob))
		var/mob/M = O
		if(M.client)
			C = M.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current && M.current.client)
			C = M.current.client
		else if(M.original && M.original.client)
			C = M.original.client

	if(C)
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind && M.mind.name)
				name = M.mind.name
			if(M.real_name && M.real_name != name)
				if(name)
					name += " ([M.real_name])"
				else
					name = M.real_name
		if(!name)
			name = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(joined_ghosts)
			say_dead_direct("The ghost of " + span_name("[name]") + " now [pick("skulks","lurks","prowls","creeps","stalks")] among the dead. [message]")
		else
			say_dead_direct(span_name("[name]") + " no longer [pick("skulks","lurks","prowls","creeps","stalks")] in the realm of the dead. [message]")

/mob/proc/switch_to_camera(var/obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 || machine != src || blinded || !canmove))
		return 0
	check_eye(src)
	return 1

/mob/living/silicon/ai/switch_to_camera(var/obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return 0

	eyeobj.setLoc(C)
	return 1

// Returns true if the mob has a client which has been active in the last given X minutes.
/mob/proc/is_client_active(var/active = 1)
	return client && client.inactivity < active MINUTES

/mob/proc/can_eat()
	return 1

/mob/proc/can_force_feed()
	return 1

#define SAFE_PERP -50
/mob/living/proc/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	if(stat == DEAD)
		return SAFE_PERP

	return 0

/mob/living/carbon/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	if(handcuffed)
		return SAFE_PERP

	return ..()

/mob/living/carbon/human/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	//Agent cards lower threatlevel.
	var/obj/item/card/id/id = GetIdCard()
	if(id && istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		if(istype(l_hand, /obj/item/gun) || istype(l_hand, /obj/item/melee))
			threatcount += 4

		if(istype(r_hand, /obj/item/gun) || istype(r_hand, /obj/item/melee))
			threatcount += 4

		if(istype(belt, /obj/item/gun) || istype(belt, /obj/item/melee))
			threatcount += 2

		if(species.name != SPECIES_HUMAN)
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/data/record/R = find_security_record("name", perpname)
		if(check_records && !R)
			threatcount += 4

		if(check_arrest && R && (R.fields["criminal"] == "*Arrest*"))
			threatcount += 4

	return threatcount

/mob/living/simple_mob/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	if(has_AI() && ai_holder.hostile && faction != "neutral") // Otherwise Runtime gets killed.
		threatcount += 4
	return threatcount

// Beepsky will (try to) only beat 'bad' slimes.
/mob/living/simple_mob/slime/xenobio/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = 0

	if(stat == DEAD)
		return SAFE_PERP

	if(is_justified_to_discipline())
		threatcount += 4
/*
	if(discipline && !rabid)
		if(!target_mob || istype(target_mob, /mob/living/carbon/human/monkey))
			return SAFE_PERP

	if(target_mob)
		threatcount += 4

	if(victim)
		threatcount += 4
*/
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		if(AI.rabid)
			threatcount = 10

	return threatcount

#undef SAFE_PERP


//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
	BP_HEAD = 40,
	BP_TORSO = 10,
	BP_GROIN = 20,
	BP_L_LEG = 20,
	BP_R_LEG = 20,
	BP_L_ARM = 20,
	BP_R_ARM = 20,
	BP_L_HAND = 50,
	BP_R_HAND = 50,
	BP_L_FOOT = 50,
	BP_R_FOOT = 50,
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
	BP_HEAD = 25,
	BP_TORSO = 70,
	BP_GROIN = 30,
	BP_L_LEG = 25,
	BP_R_LEG = 25,
	BP_L_ARM = 25,
	BP_R_ARM = 25,
	BP_L_HAND = 10,
	BP_R_HAND = 10,
	BP_L_FOOT = 10,
	BP_R_FOOT = 10,
)

/mob/proc/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	return

//Recalculates what planes this mob can see using their plane_holder, for humans this is checking slots, for others, could be whatever.
/mob/proc/recalculate_vis()
	return

//General HUD updates done regularly (health puppet things, etc)
/mob/proc/handle_regular_hud_updates()
	return

//Handle eye things like the Byond SEE_TURFS, SEE_OBJS, etc.
/mob/proc/handle_vision()
	return

//Icon is used to occlude things like huds from the faulty byond context menu.
//   http://www.byond.com/forum/?post=2336679
var/global/image/backplane
/hook/startup/proc/generate_backplane()
	backplane = image('icons/misc/win32.dmi')
	backplane.alpha = 0
	backplane.plane = -100
	backplane.layer = MOB_LAYER-0.1
	backplane.mouse_opacity = 0

	return TRUE

/mob/proc/get_sound_env(var/pressure_factor)
	if (pressure_factor < 0.5)
		return SPACE
	else
		var/area/A = get_area(src)
		return A.sound_env

/mob/proc/position_hud_item(var/obj/item/item, var/slot)
	if(!istype(hud_used) || !slot || !LAZYLEN(hud_used.slot_info))
		return

	//They may have hidden their entire hud but the hands
	if(!hud_used.hud_shown && slot > slot_r_hand)
		item.screen_loc = null
		return

	//They may have hidden the icons in the bottom left with the hide button
	if(!hud_used.inventory_shown && slot > slot_r_store)
		item.screen_loc = null
		return

	var/screen_place = hud_used.slot_info["[slot]"]
	if(!screen_place)
		item.screen_loc = null
		return

	item.screen_loc = screen_place

/mob/proc/can_feed()
	return TRUE


/atom/proc/living_mobs_in_view(var/range = world.view, var/count_held = FALSE)
	var/list/viewers = oviewers(src, range)
	if(count_held)
		viewers = viewers(src,range)
	var/list/living = list()
	for(var/mob/living/L in viewers)
		if(L.is_incorporeal())
			continue
		living += L
		if(count_held)
			for(var/obj/item/holder/H in L.contents)
				if(istype(H.held_mob, /mob/living))
					living += H.held_mob
	return living

/proc/censor_swears(t)
	/* Bleeps our swearing */
	var/static/swear_censoring_list = list("fuck",
										"shit",
										"damn",
										"piss",
										"whore",
										"cunt",
										"bitch",
										"bastard",
										"dick",
										"cock",
										"slut",
										"dong",
										"pussy",
										"twat",
										"snatch",
										"schlong",
										"damn",
										"dammit",
										"damnit",
										"ass",
										"tit",
										"douch",
										"prick",
										"hell",
										"crap")
	var/haystack = t
	for(var/filter in swear_censoring_list)
		var/regex/needle = regex(filter, "i")
		while(TRUE)
			var/pos = needle.Find(haystack)
			if(!pos)
				break
			var/partial_start = copytext(haystack,1,pos)
			var/partial_end   = copytext(haystack,pos+length(filter),length(haystack)+1)
			haystack = "[partial_start][pick("BEEP","BLEEP","BOINK","BEEEEEP")][partial_end]"
	return haystack
