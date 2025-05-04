/////////////////////////////////////////////////////////////////////////////////////////////////////
// Hallucination events
/////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/hallucinations/proc/event_hudscrew()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//Screwy HUD
	//to_chat(our_human, "Screwy HUD")
	hal_screwyhud = pick(1,2,3,3,4,4)
	addtimer(VARSET_CALLBACK(src, hal_screwyhud , 0), rand(10,25) SECONDS, TIMER_DELETE_ME)

/datum/component/hallucinations/proc/event_fake_item()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//Strange items
	//to_chat(our_human, "Traitor Items")
	if(halitem?.resolve())
		return

	var/list/slots_free = list(ui_lhand,ui_rhand)
	if(our_human.l_hand)
		slots_free -= ui_lhand
	if(our_human.r_hand)
		slots_free -= ui_rhand
	if(!our_human.belt)
		slots_free += ui_belt
	if(!our_human.l_store)
		slots_free += ui_storage1
	if(!our_human.r_store)
		slots_free += ui_storage2

	if(!slots_free.len)
		return

	var/image/client_only/use_screen/CI = new /image/client_only/use_screen()
	CI.screen_loc = pick(slots_free)
	switch(rand(1,6))
		if(1) //revolver
			CI.icon = 'icons/obj/gun.dmi'
			CI.icon_state = "revolver"
			CI.name = "Revolver"
		if(2) //c4
			CI.icon = 'icons/obj/assemblies.dmi'
			CI.icon_state = "plastic-explosive0"
			CI.name = "Mysterious Package"
			if(prob(25))
				CI.icon_state = "c4small_1"
		if(3) //sword
			CI.icon = 'icons/obj/weapons.dmi'
			CI.icon_state = "sword1"
			CI.name = "Sword"
		if(4) //stun baton
			CI.icon = 'icons/obj/weapons.dmi'
			CI.icon_state = "stunbaton"
			CI.name = "Stun Baton"
		if(5) //emag
			CI.icon = 'icons/obj/card.dmi'
			CI.icon_state = "emag"
			CI.name = "Cryptographic Sequencer"
		if(6) //flashbang
			CI.icon = 'icons/obj/grenade.dmi'
			CI.icon_state = "flashbang1"
			CI.name = "Flashbang"

	halitem = WEAKREF(CI)
	CI.append_client(our_human.client)
	QDEL_IN(CI, rand(10,25) SECONDS)

/datum/component/hallucinations/proc/event_strange_sound()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	//Strange audio
	switch(rand(1,12))
		if(1)
			our_human << 'sound/machines/door/old_airlock.ogg'
		if(2)
			if(prob(50))
				our_human << 'sound/effects/Explosion1.ogg'
			else
				our_human << 'sound/effects/Explosion2.ogg'
		if(3)
			our_human << 'sound/effects/explosionfar.ogg'
		if(4)
			our_human << 'sound/effects/Glassbr1.ogg'
		if(5)
			our_human << 'sound/effects/Glassbr2.ogg'
		if(6)
			our_human << 'sound/effects/Glassbr3.ogg'
		if(7)
			our_human << 'sound/machines/twobeep.ogg'
		if(8)
			our_human << 'sound/machines/door/windowdoor.ogg'
		if(9)
			//To make it more realistic, I added two gunshots (enough to kill)
			our_human << 'sound/weapons/Gunshot1.ogg'
			addtimer(CALLBACK(src, PROC_REF(secondary_sound), 'sound/weapons/Gunshot2.ogg'), rand(1,3) SECONDS, TIMER_DELETE_ME)
		if(10)
			our_human << 'sound/weapons/smash.ogg'
		if(11)
			//Same as above, but with tasers.
			our_human << 'sound/weapons/Taser.ogg'
			addtimer(CALLBACK(src, PROC_REF(secondary_sound), 'sound/weapons/Taser.ogg'), rand(1,3) SECONDS, TIMER_DELETE_ME)
	//Rare audio
		if(12)
//These sounds are (mostly) taken from Hidden: Source
			var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
				'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
				'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
				'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
				'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
			our_human << pick(creepyasssounds)

/datum/component/hallucinations/proc/secondary_sound(var/sound_path)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	our_human << sound_path

/datum/component/hallucinations/proc/event_flash_environmental_threats()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//Flashes of danger
	//to_chat(our_human, "Danger Flash")
	if(halimage?.resolve())
		return

	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(our_human,world.view))
		possible_points += F
	if(!possible_points.len)
		return

	var/turf/simulated/floor/target = pick(possible_points)
	var/image/client_only/CI
	switch(rand(1,3))
		if(1)
			//to_chat(our_human, "Space")
			CI = new('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
		if(2)
			//to_chat(our_human, "Fire")
			CI = new('icons/effects/fire.dmi',target,"1",TURF_LAYER)
		if(3)
			//to_chat(our_human, "C4")
			CI = new('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)
	halimage = WEAKREF(CI)
	CI.append_client(our_human.client)
	QDEL_IN(CI, rand(1,5) SECONDS) //Only seen for a brief moment.

/datum/component/hallucinations/proc/event_flash_monsters()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//Flashes of danger
	//to_chat(our_human, "Danger Flash")
	if(halbody?.resolve())
		return

	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(our_human,world.view))
		possible_points += F
	if(!possible_points.len)
		return

	var/turf/simulated/floor/target = pick(possible_points)
	var/image/client_only/CI
	switch(rand(1,4))
		if(1)
			CI = new('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
		if(2,3)
			CI = new('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
		if(4)
			CI = new('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
//		if(5)
//			CI = new('xcomalien.dmi',target,"chryssalid",TURF_LAYER)
	halbody = WEAKREF(CI)
	CI.append_client(our_human.client)
	QDEL_IN(CI, rand(5,8) SECONDS) //Only seen for a brief moment.

/datum/component/hallucinations/proc/event_sleeping()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//Fake death
	//to_chat(our_human, "fake death")
	our_human.SetSleeping(20)
	hal_crit = 1
	hal_screwyhud = 1
	addtimer(CALLBACK(src, PROC_REF(reset_hallucination_sleeping)), rand(5,10) SECONDS, TIMER_DELETE_ME)

/datum/component/hallucinations/proc/reset_hallucination_sleeping()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	our_human.SetSleeping(0)
	hal_crit = 0
	hal_screwyhud = 0

/datum/component/hallucinations/proc/event_attacker()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/attacker = our_human.create_hallucination_attacker(forced_type = /obj/effect/fake_attacker/human/attacker)
	if(attacker)
		QDEL_IN(attacker, rand(25,30) SECONDS)

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Xenochimera feral events
/////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/hallucinations/proc/event_hunger()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//food
	if(halbody?.resolve())
		return

	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(our_human,world.view))
		possible_points += F
	if(!possible_points.len)
		return

	var/turf/simulated/floor/target = pick(possible_points)
	var/image/client_only/CI
	switch(rand(1,10))
		if(1)
			CI = new('icons/mob/animal.dmi',target,"cow",TURF_LAYER)
		if(2)
			CI = new('icons/mob/animal.dmi',target,"chicken",TURF_LAYER)
		if(3)
			CI = new('icons/obj/food.dmi',target,"bigbiteburger",TURF_LAYER)
		if(4)
			CI = new('icons/obj/food.dmi',target,"meatbreadslice",TURF_LAYER)
		if(5)
			CI = new('icons/obj/food.dmi',target,"sausage",TURF_LAYER)
		if(6)
			CI = new('icons/obj/food.dmi',target,"bearmeat",TURF_LAYER)
		if(7)
			CI = new('icons/obj/food.dmi',target,"fishfillet",TURF_LAYER)
		if(8)
			CI = new('icons/obj/food.dmi',target,"meat",TURF_LAYER)
		if(9)
			CI = new('icons/obj/food.dmi',target,"meatstake",TURF_LAYER)
		if(10)
			CI = new('icons/obj/food.dmi',target,"monkeysdelight",TURF_LAYER)

	halbody = WEAKREF(CI)
	CI.append_client(our_human.client)
	QDEL_IN(CI, rand(5,8) SECONDS) //Only seen for a brief moment.

/datum/component/hallucinations/proc/event_hear_voices()
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	//hear voices. Could make the voice pick from nearby creatures, but nearby creatures make feral hallucinations rare so don't bother.
	var/list/hiddenspeakers = list("Someone distant", "A voice nearby","A familiar voice", "An echoing voice", "A cautious voice", "A scared voice", "Someone around the corner", "Someone", "Something", "Something scary", "An urgent voice", "An angry voice")
	var/list/speakerverbs = list("calls out", "yells", "screams", "exclaims", "shrieks", "shouts", "hisses", "snarls")
	var/list/spookyphrases = list("It's over here!","Stop it!", "Hunt it down!", "Get it!", "Quick, over here!", "Anyone there?", "Who's there?", "Catch that thing!", "Stop it! Kill it!", "Anyone there?", "Where is it?", "Find it!", "There it is!")
	to_chat(our_human, span_game(span_say(span_name(pick(hiddenspeakers)) + " [pick(speakerverbs)], \"[pick(spookyphrases)]\"")))
