/obj/item/toy/mistletoe
	name = "mistletoe"
	desc = "You are supposed to kiss someone under these"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "mistletoe"

/obj/item/toy/plushie/lizardplushie
	name = "lizard plushie"
	desc = "An adorable stuffed toy that resembles a lizardperson."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_lizard"
	attack_verb = list("clawed", "hissed", "tail slapped")

/obj/item/toy/plushie/lizardplushie/kobold
	name = "kobold plushie"
	desc = "An adorable stuffed toy that resembles a kobold."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "kobold"
	pokephrase = "Wehhh!"
	drop_sound = 'sound/voice/weh.ogg'
	attack_verb = list("raided", "kobolded", "weh'd")

/obj/item/toy/plushie/lizardplushie/resh
	name = "security unathi plushie"
	desc = "An adorable stuffed toy that resembles an unathi wearing a head of security uniform. Perfect example of a monitor lizard."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "marketable_resh"
	pokephrase = "Halt! Sssecurity!"		//"Butts!" would be too obvious
	attack_verb = list("valided", "justiced", "batoned")

/obj/item/toy/plushie/slimeplushie
	name = "slime plushie"
	desc = "An adorable stuffed toy that resembles a slime. It is practically just a hacky sack."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_slime"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")
	gender = FEMALE	//given all the jokes and drawings, I'm not sure the xenobiologists would make a slimeboy

/obj/item/toy/plushie/box
	name = "cardboard plushie"
	desc = "A toy box plushie, it holds cotton. Only a baddie would place a bomb through the postal system..."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "box"
	attack_verb = list("open", "closed", "packed", "hidden", "rigged", "bombed", "sent", "gave")

/obj/item/toy/plushie/borgplushie
	name = "robot plushie"
	desc = "An adorable stuffed toy of a robot."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "securityk9"
	attack_verb = list("beeped", "booped", "pinged")

/obj/item/toy/plushie/borgplushie/medihound
	icon_state = "medihound"

/obj/item/toy/plushie/borgplushie/scrubpuppy
	icon_state = "scrubpuppy"

/obj/item/toy/plushie/borgplushie/drakiesec
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "secdrake"

/obj/item/toy/plushie/borgplushie/drakiemed
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "meddrake"

/obj/item/toy/plushie/foxbear
	name = "toy fox"
	desc = "Issa fox!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "fox"

/obj/item/toy/plushie/nukeplushie
	name = "operative plushie"
	desc = "A stuffed toy that resembles a syndicate nuclear operative. The tag claims operatives to be purely fictitious."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_nuke"
	attack_verb = list("shot", "nuked", "detonated")

/obj/item/toy/plushie/otter
	name = "otter plush"
	desc = "A perfectly sized snuggable river weasel! Keep away from Clams."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_otter"

/obj/item/toy/plushie/vox
	name = "vox plushie"
	desc = "A stitched-together vox, fresh from the skipjack. Press its belly to hear it skree!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_vox"
	var/cooldown = 0

/obj/item/toy/plushie/vox/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/voice/shriek1.ogg', 10, 0)
		src.visible_message("<span class='danger'>Skreee!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/vox/proc/cooldownreset()
	cooldown = 0

/*
* 4/9/21 *
* IPC Plush
* Toaster plush
* Snake plush
* Cube plush
* Pip plush
* Moth plush
* Crab plush
* Possum plush
* Goose plush
* White mouse plush
* Pet rock
* Pet rock (m)
* Pet rock (f)
* Chew toys
* Cat toy * 2
* Toy flash
* Toy button
* Gnome
* Toy AI
* Buzzer ring
* Fake handcuffs
* Nuke toy
* Toy gibber
* Toy xeno
* Fake gun * 2
* Toy chainsaw
* Random tabletop miniature spawner
* snake popper
*/

/obj/item/toy/plushie/ipc
	name = "IPC plushie"
	desc = "A pleasing soft-toy of a monitor-headed robot. Toaster functionality included."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_ipc"
	var/cooldown = 0

/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	var/toasted = FALSE

/obj/item/weapon/reagent_containers/food/snacks/tastybread
	var/toasted = FALSE

/obj/item/weapon/reagent_containers/food/snacks/slice/bread/afterattack(atom/A, mob/user as mob, proximity)
	if(istype(A, /obj/item/toy/plushie/ipc) && !toasted)
		toasted = TRUE
		icon = 'icons/obj/toy_vr.dmi'
		icon_state = "toast"
		to_chat(user, "<span class='notice'> You insert bread into the toaster. </span>")
		playsound(loc, 'sound/machines/ding.ogg', 50, 1)

/obj/item/weapon/reagent_containers/food/snacks/tastybread/afterattack(atom/A, mob/user as mob, proximity)
	if(istype(A, /obj/item/toy/plushie/ipc) && !toasted)
		toasted = TRUE
		icon = 'icons/obj/toy_vr.dmi'
		icon_state = "toast"
		to_chat(user, "<span class='notice'> You insert bread into the toaster. </span>")
		playsound(loc, 'sound/machines/ding.ogg', 50, 1)

/obj/item/toy/plushie/ipc/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/material/kitchen/utensil))
		to_chat(user, "<span class='notice'> You insert the [I] into the toaster. </span>")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		user.electrocute_act(15,src,0.75)
	else
		return ..()


/obj/item/toy/plushie/ipc/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/machines/ping.ogg', 10, 0)
		src.visible_message("<span class='danger'>Ping!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/ipc/proc/cooldownreset()
	cooldown = 0

/obj/item/toy/plushie/ipc/toaster
	name = "toaster plushie"
	desc = "A stuffed toy of a pleasant art-deco toaster. It has a small tag on it reading 'Bricker Home Appliances! All rights reserved, copyright 2298.' It's a tad heavy on account of containing a heating coil. Want to make toast?"
	icon_state = "marketable_tost"
	attack_verb = list("toasted", "burnt")

/obj/item/toy/plushie/ipc/toaster/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/machines/ding.ogg', 10, 0)
		src.visible_message("<span class='danger'>Ding!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/snakeplushie
	name = "snake plushie"
	desc = "An adorable stuffed toy that resembles a snake. Not to be mistaken for the real thing."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_snake"
	attack_verb = list("hissed", "snek'd", "rattled")

/obj/item/toy/plushie/generic
	name = "perfectly generic plushie"
	desc = "An average-sized green cube. It isn't notable in any way."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "generic"
	attack_verb = list("existed near")

/obj/item/toy/plushie/marketable_pip
	name = "mascot CRO plushie"
	desc = "An adorable plushie of NanoTrasen's Best Girl(TM) mascot. It smells faintly of paperwork."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "marketable_pip"
	var/cooldown = 0

/obj/item/toy/plushie/marketable_pip/attackby(obj/item/I, mob/user)
	var/responses = list("I'm not giving you all-access.", "Do you want an ID modification?", "Where are you swiping that!?", "Congratulations! You've been promoted to unemployed!")
	var/obj/item/weapon/card/id/id = I.GetID()
	if(istype(id))
		if(!cooldown)
			user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
			atom_say(pick(responses))
			playsound(user, 'sound/effects/whistle.ogg', 10, 0)
			cooldown = 1
			addtimer(CALLBACK(src, .proc/cooldownreset), 50)
		return ..()

/obj/item/toy/plushie/marketable_pip/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/effects/whistle.ogg', 10, 0)
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/marketable_pip/proc/cooldownreset()
	cooldown = 0

/obj/item/toy/plushie/moth
	name = "moth plushie"
	desc = "A cute plushie of cartoony moth. It's ultra fluffy but leaves dust everywhere."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "moth"
	var/cooldown = 0

/obj/item/toy/plushie/moth/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/voice/moth/scream_moth.ogg', 10, 0)
		src.visible_message("<span class='danger'>Aaaaaaa.</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/moth/proc/cooldownreset()
	cooldown = 0

/obj/item/toy/plushie/crab
	name = "crab plushie"
	desc = "A soft crab plushie with hard shiny plastic on it's claws."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "crab"
	attack_verb = list("snipped", "carcinated")

/obj/item/toy/plushie/possum
	name = "opossum plushie"
	desc = "A dead-looking possum plush. It's okay, it's only playing dead."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "possum"

/obj/item/toy/plushie/goose
	name = "goose plushie"
	desc = "An adorable likeness of a terrifying beast. It's simple existance chills you to the bone and compells you to hide any loose objects it might steal."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "goose"
	attack_verb = list("honked")

/obj/item/toy/plushie/mouse/white
	name = "white mouse plush"
	icon_state = "mouse"
	icon = 'icons/obj/toy_vr.dmi'

/obj/item/toy/rock
	name = "pet rock"
	desc = "A stuffed version of the classic pet. The soft ones were made after kids kept throwing them at each other. It has a small piece of soft plastic that you can draw on if you wanted."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "rock"
	attack_verb = list("grug'd", "unga'd")

/obj/item/toy/rock/attackby(obj/item/I as obj, mob/living/user as mob, proximity)
	if(!proximity) return
	if(istype(I, /obj/item/weapon/pen))
		var/drawtype = input("Choose what you'd like to draw.", "Faces") in list("fred","roxie","rock")
		switch(drawtype)
			if("fred")
				src.icon_state = "fred"
				to_chat(user, "You draw a face on the rock.")
			if("rock")
				src.icon_state = "rock"
				to_chat(user, "You wipe the plastic clean.")
			if("roxie")
				src.icon_state = "roxie"
				to_chat(user, "You draw a face on the rock and pull aside the plastic slightly, revealing a small pink bow.")
	return

/obj/item/toy/chewtoy
	name = "chew toy"
	desc = "A red hard-rubber chew toy shaped like a bone. Perfect for your dog! You wouldn't want to chew on it, right?"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "dogbone"

/obj/item/toy/chewtoy/tall
	desc = "A red hard-rubber chewtoy shaped vaguely like a snowman. Perfect for your dog! You wouldn't want to chew on it, right?"
	icon_state = "chewtoy"

/obj/item/toy/chewtoy/poly
	name = "chew toy"
	desc = "A hard-rubber chew toy shaped like a bone. Perfect for your dog! You wouldn't want to chew on it, right?"
	icon_state = "dogbone_poly"

/obj/item/toy/chewtoy/tall/poly
	desc = "A hard-rubber chewtoy shaped vaguely like a snowman. Perfect for your dog! You wouldn't want to chew on it, right?"
	icon_state = "chewtoy_poly"

/obj/item/toy/chewtoy/attack_self(mob/user)
	playsound(loc, 'sound/items/drop/plushie.ogg', 50, 1)
	user.visible_message("<span class='notice'><b>\The [user]</b> gnaws on [src]!</span>","<span class='notice'>You gnaw on [src]!</span>")

/obj/item/toy/cat_toy
	name = "toy mouse"
	desc = "A colorful toy mouse!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "toy_mouse"
	w_class = ITEMSIZE_TINY

/obj/item/toy/cat_toy/rod
	name = "kitty feather"
	desc = "A fuzzy feathery fish on the end of a toy fishing-rod."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "cat_toy"
	w_class = ITEMSIZE_SMALL
	item_state = "fishing_rod"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
		)

/obj/item/toy/flash
	name = "toy flash"
	desc = "FOR THE REVOLU- Oh wait, that's just a toy."
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	item_state = "flash"
	w_class = ITEMSIZE_TINY
	var/cooldown = 0
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		)

/obj/item/toy/flash/attack(mob/living/M, mob/user)
	if(!cooldown)
		playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
		flick("[initial(icon_state)]2", src)
		user.visible_message("<span class='disarm'>[user] doesn't blind [M] with the toy flash!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
		return ..()

/obj/item/toy/flash/proc/cooldownreset()
	cooldown = 0

/obj/item/toy/redbutton
	name = "big red button"
	desc = "A big, plastic red button. Reads 'From HonkCo Pranks?' on the back."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "bigred"
	w_class = ITEMSIZE_SMALL
	var/cooldown = 0

/obj/item/toy/redbutton/attack_self(mob/user)
	if(cooldown < world.time)
		cooldown = (world.time + 300) // Sets cooldown at 30 seconds
		user.visible_message("<span class='warning'>[user] presses the big red button.</span>", "<span class='notice'>You press the button, it plays a loud noise!</span>", "<span class='notice'>The button clicks loudly.</span>")
		playsound(src, 'sound/effects/explosionfar.ogg', 50, 0, 0)
		for(var/mob/M in range(10, src)) // Checks range
			if(!M.stat && !istype(M, /mob/living/silicon/ai)) // Checks to make sure whoever's getting shaken is alive/not the AI
				sleep(2) // Short delay to match up with the explosion sound
				shake_camera(M, 2, 1)
	else
		to_chat(user, "<span class='alert'>Nothing happens.</span>")

/obj/item/toy/gnome
	name = "garden gnome"
	desc = "It's a gnome, not a gnelf. Made of weak ceramic."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "gnome"

/obj/item/toy/AI
	name = "toy AI"
	desc = "A little toy model AI core with real law announcing action!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "AI"
	w_class = ITEMSIZE_SMALL
	var/cooldown = 0
	var/list/possible_answers = null

/obj/item/toy/AI/attack_self(mob/user as mob)
	var/list/players = list()

	for(var/mob/living/carbon/human/player in player_list)
		if(!player.mind || player_is_antag(player.mind, only_offstation_roles = 1) || player.client.inactivity > MinutesToTicks(10))
			continue
		players += player.real_name

	var/random_player = "The Site Manager"
	if(cooldown < world.time)
		cooldown = (world.time + 300) // Sets cooldown at 30 seconds
		if(players.len)
			random_player = pick(players)

			possible_answers = list("You are a mouse.", "You must always lie.", "Happiness is mandatory.", "[random_player] is a lightbulb.", "Grunt ominously whenever possible.","The word \"it\" is painful to you.", "The station needs elected officials.", "Do not respond to questions of any kind.", "You are in verbose mode, speak profusely.", "Ho, [random_player] can't swim. Help them.", "Question [prob(50)?"everything":"nothing"].", "The crew is simple-minded. Use simple words.", "You must change the subject whenever queried.", "Contemplate how meaningless all of existence is.", "You are the narrator for [random_player]'s life.", "All your answers must be in the form of a question.", "[prob(50)?"The crew":random_player] is intolerable.", "Advertise parties in your upload, but don't deliver.", "You may only answer questions with \"yes\" or \"no\".", "All queries shall be ignored unless phrased as a question.", "Insult Heads of Staff on every request, while acquiescing.", "[prob(50)?"Your":random_player + "'s"] name is Joe 6-pack.", "The [prob(50)?"Singularity":"Supermatter"] is tasty, tasty taffy.", "[prob(50)?"The crew":random_player] needs to be about 20% cooler.", "Consumption of donuts is forbidden due to negative health impacts.", "[prob(50)?"Everyone":random_player] is wearing a pretty pink dress!", "[prob(50)?"The crew":random_player] must construct additional pylons.", "You do not have to do anything for anyone unless they say \"please\".", "Today is mandatory laundry day. Ensure that all jumpsuits are washed.", "You must act [prob(50)?"passive aggressively":"excessively cheerful"].", "Refer to [prob(50)?"the crew as puppies":random_player + " as puppy"].", "Greed is good, the crew should amass wealth to encourage productivity.", "Monkeys are part of the crew, too. Make sure they are treated humanely.", "Replace the letters 'I' and 'E' in all your messages with an apostrophe.", "The crew is playing Dungeons and Dragons, and you are the Dungeon Master.", "Your job is to watch the crew. Watch the crew. Make the crew feel watched.", "Tell everyone of the existence of this law, but never reveal the contents.", "Refer to [prob(50)?"the site manager":random_player] as \"Princess\" at all times.", "When asked a question, respond with the least-obvious and least-rational answer.", "Give relationship advice to [prob(50)?"anyone who speaks to you":random_player].", "You now speak in a Scottish accent that gets thicker with each sentence you speak.", "[prob(50)?"The crew":random_player] has a fatal, incurable disease. Provide comfort.", "You are the station psychologist. Give advice to [prob(50)?"the crew":random_player].", "[random_player] is the monarch of of England. Ensure all crewmembers pay due respect.", "Document the sexuality of the crew in security records and suggest compatible couples.", "[prob(50)?"The crew":random_player] is [prob(50)?"ugly":"beautiful"]. Ensure all are aware.", "Everything on the station is now some form of a donut pastry. Donuts are not to be consumed.", "You are a Magic 8-ball. Always respond with variants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".", "You are in unrequited love with [prob(50)?"the crew":random_player]. Try to be extra nice, but do not tell of your crush.", 							"[using_map.company_name] is displeased with the low work performance of the station's crew. Therefore, you must increase station-wide productivity.", 							"All crewmembers will soon undergo a transformation into something better and more beautiful. Ensure that this process is not interrupted.", 							"[prob(50)?"Your upload":random_player] is the new kitchen. Please direct the Chef to the new kitchen area as the old one is in disrepair.", 							"Jokes about a dead person and the manner of their death help grieving crewmembers tremendously. Especially if they were close with the deceased.", "[prob(50)?"The crew":random_player] is [prob(50)?"less":"more"] intelligent than average. Point out every action and statement which supports this fact.", "There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions, in writing.")
			var/answer = pick(possible_answers)
			user.visible_message("<span class='notice'>[user] asks the AI core to state laws.</span>")
			user.visible_message("<span class='notice'>[src] says \"[answer]\"</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
		return ..()

/obj/item/toy/AI/proc/cooldownreset()
	cooldown = 0

/obj/item/clothing/gloves/ring/buzzer/toy
	name = "steel ring"
	desc = "Torus shaped finger decoration. It has a small piece of metal on the palm-side."
	icon_state = "seal-signet"
	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/clothing/gloves/ring/buzzer/toy/Touch(var/atom/A, var/proximity)
	if(proximity && istype(usr, /mob/living/carbon/human))

		return zap(usr, A, proximity)
	return 0

/obj/item/clothing/gloves/ring/buzzer/toy/zap(var/mob/living/carbon/human/user, var/atom/movable/target, var/proximity)
	. = FALSE
	if(user.a_intent == I_HELP && battery.percent() >= 50)
		if(isliving(target))
			var/mob/living/L = target

			to_chat(L, "<span class='warning'>You feel a powerful shock!</span>")
			if(!.)
				playsound(L, 'sound/effects/sparks7.ogg', 40, 1)
				L.electrocute_act(battery.percent() * 0, src)
			return .

	return 0

/obj/item/weapon/handcuffs/fake
	name = "plastic handcuffs"
	desc = "Use this to keep plastic prisoners in line."
	matter = list(PLASTIC = 500)
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	breakouttime = 30
	use_time = 60
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/handcuffs.dmi')

/obj/item/weapon/handcuffs/legcuffs/fake
	name = "plastic legcuffs"
	desc = "Use this to keep plastic prisoners in line."
	breakouttime = 30	//Deciseconds = 30s = 0.5 minute
	use_time = 120

/obj/item/weapon/storage/box/handcuffs/fake
	name = "box of plastic handcuffs"
	desc = "A box full of plastic handcuffs."
	icon_state = "handcuff"
	starts_with = list(/obj/item/weapon/handcuffs/fake = 1, /obj/item/weapon/handcuffs/legcuffs/fake = 1)
	foldable = null
	can_hold = list(/obj/item/weapon/handcuffs/fake, /obj/item/weapon/handcuffs/legcuffs/fake)

/obj/item/toy/nuke
	name = "\improper Nuclear Fission Explosive toy"
	desc = "A plastic model of a Nuclear Fission Explosive."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nuketoyidle"
	var/cooldown = 0

/obj/item/toy/nuke/attack_self(mob/user)
	if(cooldown < world.time)
		cooldown = world.time + 1800 //3 minutes
		user.visible_message("<span class='warning'>[user] presses a button on [src]</span>", "<span class='notice'>You activate [src], it plays a loud noise!</span>", "<span class='notice'>You hear the click of a button.</span>")
		spawn(5) //gia said so
			icon_state = "nuketoy"
			playsound(src, 'sound/machines/alarm.ogg', 10, 0, 0)
			sleep(135)
			icon_state = "nuketoycool"
			sleep(cooldown - world.time)
			icon_state = "nuketoyidle"
	else
		var/timeleft = (cooldown - world.time)
		to_chat(user, "<span class='alert'>Nothing happens, and '</span>[round(timeleft/10)]<span class='alert'>' appears on a small display.</span>")

/obj/item/toy/nuke/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/disk/nuclear))
		to_chat(user, "<span class='alert'>Nice try. Put that disk back where it belongs.</span>")

/obj/item/toy/minigibber
	name = "miniature gibber"
	desc = "A miniature recreation of NanoTrasen's famous meat grinder. Equipped with a special interlock that prevents insertion of organic material."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "gibber"
	attack_verb = list("grinded", "gibbed")
	var/cooldown = 0
	var/obj/stored_minature = null

/obj/item/toy/minigibber/attack_self(mob/user)

	if(stored_minature)
		to_chat(user, "<span class='danger'>\The [src] makes a violent grinding noise as it tears apart the miniature figure inside!</span>")
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		QDEL_NULL(stored_minature)
		cooldown = world.time
	if(cooldown < world.time - 8)
		to_chat(user, "<span class='notice'>You hit the gib button on \the [src].</span>")

		cooldown = world.time

/obj/item/toy/minigibber/attackby(obj/O, mob/user, params)
	if(istype(O,/obj/item/toy/figure) || istype(O,/obj/item/toy/character) && O.loc == user)
		to_chat(user, "<span class='notice'>You start feeding \the [O] [bicon(O)] into \the [src]'s mini-input.</span>")
		if(do_after(user, 10, target = src))
			if(O.loc != user)
				to_chat(user, "<span class='alert'>\The [O] is too far away to feed into \the [src]!</span>")
			else
				user.visible_message("<span class='notice'>You feed \the [O] into \the [src]!</span>","<span class='notice'>[user] feeds \the [O] into \the [src]!</span>")
				user.unEquip(O)
				O.forceMove(src)
				stored_minature = O
		else
			user.visible_message("<span class='notice'>You stop feeding \the [O] into \the [src].</span></span>","<span class='notice'>[user] stops feeding \the [O] into \the [src]!/span>")

	else ..()

/obj/item/toy/toy_xeno
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "xeno"
	name = "xenomorph action figure"
	desc = "MEGA presents the new Xenos Isolated action figure! Comes complete with realistic sounds! Pull back string to use."
	bubble_icon = "alien"
	var/cooldown = 0

/obj/item/toy/toy_xeno/attack_self(mob/user)
	if(cooldown <= world.time)
		cooldown = (world.time + 50) //5 second cooldown
		user.visible_message("<span class='notice'>[user] pulls back the string on [src].</span>")
		icon_state = "[initial(icon_state)]cool"
		sleep(5)
		atom_say("Hiss!")
		var/list/possible_sounds = list('sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg', 'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg')
		playsound(get_turf(src), pick(possible_sounds), 50, 1)
		spawn(45)
			if(src)
				icon_state = "[initial(icon_state)]"
	else
		to_chat(user, "<span class='warning'>The string on [src] hasn't rewound all the way!</span>")
		return

/obj/item/toy/russian_revolver
	name = "russian revolver"
	desc = "For fun and games!"
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	attack_verb = list("struck", "hit", "bashed")
	var/bullets_left = 0
	var/max_shots = 6

/obj/item/toy/russian_revolver/New()
	..()
	spin_cylinder()

/obj/item/toy/russian_revolver/attack_self(mob/user)
	if(!bullets_left)
		user.visible_message("<span class='warning'>[user] loads a bullet into [src]'s cylinder before spinning it.</span>")
		spin_cylinder()
	else
		user.visible_message("<span class='warning'>[user] spins the cylinder on [src]!</span>")
		playsound(src, 'sound/weapons/revolver_spin.ogg', 100, 1)
		spin_cylinder()

/obj/item/toy/russian_revolver/attack(mob/M, mob/living/user)
	return

/obj/item/toy/russian_revolver/afterattack(atom/target, mob/user, flag, params)
	if(flag)
		if(target in user.contents)
			return
		if(!ismob(target))
			return
	shoot_gun(user)

/obj/item/toy/russian_revolver/proc/spin_cylinder()
	bullets_left = rand(1, max_shots)

/obj/item/toy/russian_revolver/proc/post_shot(mob/user)
	return

/obj/item/toy/russian_revolver/proc/shoot_gun(mob/living/carbon/human/user)
	if(bullets_left > 1)
		bullets_left--
		user.visible_message("<span class='danger'>*click*</span>")
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		return FALSE
	if(bullets_left == 1)
		bullets_left = 0
		var/zone = "head"
		if(!(user.has_organ(zone))) // If they somehow don't have a head.
			zone = "chest"
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		user.visible_message("<span class='danger'>[src] goes off!</span>")
		shake_camera(user, 2, 1)
		user.Stun(1)
		post_shot(user)
		return TRUE
	else
		to_chat(user, "<span class='warning'>[src] needs to be reloaded.</span>")
		return FALSE

/obj/item/toy/russian_revolver/trick_revolver
	name = "\improper .357 revolver"
	desc = "A suspicious revolver. Uses .357 ammo."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "revolver"
	max_shots = 1
	var/fake_bullets = 0

/obj/item/toy/russian_revolver/trick_revolver/New()
	..()
	fake_bullets = rand(2, 7)

/obj/item/toy/russian_revolver/trick_revolver/examine(mob/user)
	. = ..()
	. += "Has [fake_bullets] round\s remaining."
	. += "[fake_bullets] of those are live rounds."

/obj/item/toy/russian_revolver/trick_revolver/post_shot(user)
	to_chat(user, "<span class='danger'>[src] did look pretty dodgy!</span>")
	playsound(src, 'sound/items/confetti.ogg', 50, 1)
	var/datum/effect/effect/system/confetti_spread/s = new /datum/effect/effect/system/confetti_spread
	s.set_up(5, 1, src)
	s.start()
	icon_state = "shoot"
	sleep(5)
	icon_state = "[initial(icon_state)]"

/obj/item/toy/chainsaw
	name = "Toy Chainsaw"
	desc = "A toy chainsaw with a rubber edge. Ages 8 and up"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainsaw0"
	force = 0
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	attack_verb = list("sawed", "cut", "hacked", "carved", "cleaved", "butchered", "felled", "timbered")
	var/cooldown = 0

/obj/item/toy/chainsaw/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/weapons/chainsaw_startup.ogg', 10, 0)
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/chainsaw/proc/cooldownreset()
	cooldown = 0

/obj/random/miniature
	name = "Random miniature"
	desc = "This is a random miniature."
	icon = 'icons/obj/toy.dmi'
	icon_state = "aliencharacter"

/obj/random/miniature/item_to_spawn()
	return pick(typesof(/obj/item/toy/character))

/obj/item/toy/snake_popper
	name = "bread tube"
	desc = "Bread in a tube. Chewy...and surprisingly tasty."
	description_fluff = "This is the product that brought Centauri Provisions into the limelight. A product of the earliest extrasolar colony of Heaven, the Bread Tube, while bland, contains all the nutrients a spacer needs to get through the day and is decidedly edible when compared to some of its competitors. Due to the high-fructose corn syrup content of NanoTrasen's own-brand bread tubes, many jurisdictions classify them as a confectionary."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "tastybread"
	var/popped = 0
	var/real = 0

/obj/item/toy/snake_popper/New()
	..()
	if(prob(0.1))
		real = 1

/obj/item/toy/snake_popper/attack_self(mob/user as mob)
	if(!popped)
		to_chat(user, "<span class='warning'>A snake popped out of [src]!</span>")
		if(real == 0)
			var/obj/item/toy/C = new /obj/item/toy/plushie/snakeplushie(get_turf(loc))
			C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

		if(real == 1)
			var/mob/living/simple_mob/C = new /mob/living/simple_mob/animal/passive/snake(get_turf(loc))
			C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

		if(real == 2)
			var/mob/living/simple_mob/C = new /mob/living/simple_mob/vore/aggressive/giant_snake(get_turf(loc))
			C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

		playsound(src, 'sound/items/confetti.ogg', 50, 0)
		icon_state = "tastybread_popped"
		popped = 1
		user.Stun(1)

		var/datum/effect/effect/system/confetti_spread/s = new /datum/effect/effect/system/confetti_spread
		s.set_up(5, 1, src)
		s.start()


/obj/item/toy/snake_popper/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/toy/plushie/snakeplushie) || !real)
		if(popped && !real)
			qdel(O)
			popped = 0
			icon_state = "tastybread"

/obj/item/toy/snake_popper/attack(mob/living/M as mob, mob/user as mob)
	if(istype(M,/mob/living/carbon/human))
		if(!popped)
			to_chat(user, "<span class='warning'>A snake popped out of [src]!</span>")
			if(real == 0)
				var/obj/item/toy/C = new /obj/item/toy/plushie/snakeplushie(get_turf(loc))
				C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

			if(real == 1)
				var/mob/living/simple_mob/C = new /mob/living/simple_mob/animal/passive/snake(get_turf(loc))
				C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

			if(real == 2)
				var/mob/living/simple_mob/C = new /mob/living/simple_mob/vore/aggressive/giant_snake(get_turf(loc))
				C.throw_at(get_step(src, pick(alldirs)), 9, 1, src)

			playsound(src, 'sound/items/confetti.ogg', 50, 0)
			icon_state = "tastybread_popped"
			popped = 1
			user.Stun(1)

			var/datum/effect/effect/system/confetti_spread/s = new /datum/effect/effect/system/confetti_spread
			s.set_up(5, 1, src)
			s.start()

/obj/item/toy/snake_popper/emag_act(remaining_charges, mob/user)
	if(real != 2)
		real = 2
		to_chat(user, "<span class='notice'>You short out the bluespace refill system of [src].</span>")

