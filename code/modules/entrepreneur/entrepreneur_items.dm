//Items for the entrepreneurs

/obj/item/entrepreneur
	name = "crystal ball"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "crystal_ball"
	desc = "A perfect sphere that is partially translucent, allowing one to see into it's mysterious depths."

/obj/item/entrepreneur/crystal_ball

/obj/item/entrepreneur/horoscope
	name = "horoscope book"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "horoscope"
	desc = "A book with a years worth of horoscope readings in it, each one perfectly tailored to the phase of the stars and planets for every sign."
	var/list/stars_list = list("Due to Mercuary being in retrograde, you are recieving a powerful energy.",
					"The sun, Sol, of the Sol system, the birthplace of humanity, is your sign right now.",
					"Jupiter is in antegrade, affecting your energy directly.",
					"La luna has swung into virgo, be prepared!",
					"The moon of Earth is lingering in your lazy, hazy twelfth house.",
					"The moon starts the day in your intrepid ninth house!",
					"Menhir hovers about your secluded third house.",
					"Due to how Caledonia is in prograde, you are benefitting from it's energy.",
					"Mercuary hovers in your second house, unfortunately.",
					"Mars lingers in Scorpio now, this has a direct effect on your energy.",
					"Menhir has swung into Leo!",
					"The sun, Virgo-Erigone, lines up just right with Sol today.",
					"Don't let the fact that Mars and Menhir are collaborating affect your day!",
					"The moon is swinging between Cancer and Aries for you today.",
					"Venus holds the key for you, resting right in your fourth house.",
					"The wolftaur home of Elea lingers in Capricorn today.",
					"The Salvoran star, Holloway, glows extra bright for you.",
					"Mohges is caught in retrograde, Unathi are feeling it everywhere.",
					"Qerr'balak is in the prograde of your first house.",
					"Tal hovers above your ninth house.",
					"Creatures from another plane watch you from afar.",
					"Abundance in All Things Serene is in antegrade right now, you aren't benefiting from it any longer.",
					"Paraiso is confiding with you today, you'll do well to bear it.",
					"Sars Mara is no longer in Pisces, this will change your energy from the past few days.",
					"The planet Salthan is bordering on Taurus now.",
					"Procyon glistens for you betwixt the other stars.",
					"Proxima Centauri is edging for you, take heed of it.",
					"Sirius is cusping beyond your tenth house, you're getting a dose of its energy.",
					"Sanctum and Infernum line up for you, chaos will no doubt ensue.",
					"Infernum swings into Cancer for you, expect something firey!",
					"Elysian stars turn their attention away from you now.",
					"The stars of Elysium have caught you in their sights.",
					"The burning planet of Zehtir in the virgo-erigone system twists against Gemini.",
					"The purple soul of Geret Baht hungers for you.")
	var/list/prediction_list = list("This leads you to listen to your own wants above those of others.",
					"Prepare for this to lead you towards dark temptations.",
					"Your soul is being filled with a glorious love for life.",
					"Expect this to boost your confidence for a short while!",
					"This is going to drain your energy and you will need to recover it somehow.",
					"The effect will be strongest in the morning, but will settle down by the evening.",
					"Don't let this get in the way of being your best self.",
					"Consumption is on the menu for today, don't try to deny it.",
					"An undeniable need for enhancement lingers within you.",
					"A sense of adventure may blossom, but you are in danger of over-committing!",
					"The sense of spontaneous spontaneity beats in your heart, don't let it go to waste!",
					"Love is your world, combine with those around you, don't push them away.",
					"Sullen moons make for a quiet day, but it is not as though you can't take advantage of the silence.",
					"Some people are likely to be hidden away, people close to you.",
					"Desire beats with in you, do not deny the call.",
					"Beware of gluttony, it surrounds you today.",
					"Power is unbalanced in your life, seize it for yourself lest others take it from you.",
					"Joy, so much joy, all for yourself and to share with those you love.",
					"You will make a new friend, it is someone you may not expect to encounter.",
					"The universe pleads for you to plunder its riches, take what you deserve.",
					"Punishment will be dished out today, and you are at the centre of it.",
					"Allow yourself to make a real connection with another person today, it can only have good outcomes.",
					"You may find yourself frustrated, but other people can take it from you.",
					"Don't let yourself be consumed, the stars are tempting it.",
					"Hope is on the horizon, chase it down and don't let it get away from you.",
					"You might find yourself feeling drained due to those alignments or other factors in your life.",
					"Pride will be the undoing of you today, but you can still harness it.",
					"Perhaps you are feeling cute? Or perhaps something cute has taken your eye?",
					"You will feel a growing warmth in your very core.",
					"Expect a feeling of intense fulfilment.",
					"There's a high likelyhood of you getting caught up in a sticky situation, one way or another.",
					"Liberty is strong today, but beware it is fleeting for some.")
	var/list/advice_list = list("You will have a lot of compassionate energy today. Use it on a needy friend.",
					"It's wisest if you just admit to any anxieties or insecurities you have up front.",
					"New beginnings are important, but don't lose your appreciation for old connections.",
					"Your creativity could use a nice workout -- the kitchen is the perfect place for it.",
					"Leaving too many questions unanswered will cause someone's imagination to spin in a weird direction.",
					"Where you are going with someone isn't clear, but it's clear you are going together.",
					"It's time to lavish yourself with the attention you deserve. Treat yourself right.",
					"Ride your emotions like a roller coaster with your hands held straight up!",
					"If you want to put one of your innovative ideas into action right now, you have to be open to the possibility of asking for help from someone in a higher position than you.",
					"In any and all confrontations you have today, be sure to take the high road.",
					"Indulge in nourishing meals that fuel your energy while allowing yourself a guilt-free treat every now and then.",
					"Explore new cuisines and flavors to stimulate your taste buds and keep your meals exciting this month.",
					"Whether dining alone or with loved ones, take a moment to appreciate the food on your plate and the hands that prepared it.",
					"Tune into your body's needs and cravings without judgment, allowing yourself the freedom to enjoy food in a way that feels nourishing and satisfying.",
					"Boldly pursue your goals and assert your authority in all endeavors today!",
					"Try releasing control over outcomes and trusting in the universe to guide you towards your highest good.",
					"Surrender to the natural rhythms of life and have faith that everything will unfold according to plan when the time is right.",
					"Nurture your relationships and cultivate deep bonds with those who bring warmth and affection into your life and body.",
					"Take the time to sit back and digest the things that have happened to you lately.",
					"It never hurts to really absorb what you have taken in.",
					"Focus on nurturing trust and intimacy in your relationships rather than letting insecurity devour you.",
					"Keep your communication clear and your words sweet, lest you find yourself eaten alive by misunderstandings.",
					"Remember to take time to savor life's simple pleasures along the way.",
					"Be wary of being consumed by your own ego. Remember to share the spotlight and let others take a bite of the limelight too.",
					"Listen to others reminisce about the past. You will gain some incredible insight.",
					"Recognise your ability to communicate with others, and how this draws others to you.",
					"Going out could be more trouble than it's worth. Protest with your vote or your wallet instead.",
					"Walk side by side with others, eventually you will become one.",
					"Take a break from your usual routine, focus on yourself and treat yourself a little.",
					"This is a good day to get out and make connections with people. Maybe treat them a bit too!")
	var/aries = ""
	var/taurus = ""
	var/gemini = ""
	var/cancer = ""
	var/leo = ""
	var/virgo = ""
	var/libra = ""
	var/scorpio = ""
	var/sagittarius = ""
	var/capricorn = ""
	var/aquarius = ""
	var/pisces = ""
	var/list/zodiacs = list("aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn","aquarius","pisces")

/obj/item/entrepreneur/horoscope/Initialize()
	. = ..()
	var/stars = pick(stars_list)
	var/prediction = pick(prediction_list)
	var/advice = pick(advice_list)
	aries = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	taurus = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	gemini = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	cancer = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	leo = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	virgo = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	libra = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	scorpio = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	sagittarius = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	capricorn = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	aquarius = "[stars] [prediction] [advice]"

	stars = pick(stars_list)
	prediction = pick(prediction_list)
	advice = pick(advice_list)
	pisces = "[stars] [prediction] [advice]"

/obj/item/entrepreneur/horoscope/attack_self(var/mob/user)
	var/zodiac = tgui_input_list(user, "Which of todays zodiacs do you want to read?", "Zodiac", zodiacs)
	if(zodiac)
		switch(zodiac)
			if("aries")
				to_chat(user, "<span class='notice'>Today's reading for Aries: [aries]</span>")
			if("taurus")
				to_chat(user, "<span class='notice'>Today's reading for Taurus: [taurus]</span>")
			if("gemini")
				to_chat(user, "<span class='notice'>Today's reading for Gemini: [gemini]</span>")
			if("cancer")
				to_chat(user, "<span class='notice'>Today's reading for Cancer: [cancer]</span>")
			if("leo")
				to_chat(user, "<span class='notice'>Today's reading for Leo: [leo]</span>")
			if("virgo")
				to_chat(user, "<span class='notice'>Today's reading for Virgo: [virgo]</span>")
			if("libra")
				to_chat(user, "<span class='notice'>Today's reading for Libra: [libra]</span>")
			if("scorpio")
				to_chat(user, "<span class='notice'>Today's reading for Scorpio: [scorpio]</span>")
			if("sagittarius")
				to_chat(user, "<span class='notice'>Today's reading for Sagittarius: [sagittarius]</span>")
			if("capricorn")
				to_chat(user, "<span class='notice'>Today's reading for Capricorn: [capricorn]</span>")
			if("aquarius")
				to_chat(user, "<span class='notice'>Today's reading for Aquarius: [aquarius]</span>")
			if("pisces")
				to_chat(user, "<span class='notice'>Today's reading for Pisces: [pisces]</span>")

///////Dentist tools, basically just fluff for RP

/obj/item/entrepreneur/dentist_mirror
	name = "dental mirror"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "mirror"
	desc = "A small mirror at the end of a short, stainless steel rod."
	w_class = ITEMSIZE_TINY

/obj/item/entrepreneur/dentist_mirror/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		to_chat(user, "<span class='notice'>You use the mirror to get a good look inside of [M]'s mouth.</span>")
		to_chat(M, "<span class='notice'>[user] uses a small mirror to look inside of your mouth.</span>")
		return 0
	..()

/obj/item/entrepreneur/dentist_probe
	name = "dental probe"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "probe"
	desc = "A short stainless steel rod that ends with a narrow pointy bit for poking."
	w_class = ITEMSIZE_TINY

/obj/item/entrepreneur/dentist_probe/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		to_chat(user, "<span class='notice'>You use the probe to poke about inside of [M]'s mouth.</span>")
		to_chat(M, "<span class='notice'>[user] examines the inside of your mouth with a sharp probe, it hurts a little being prodded.</span>")
		return 0
	..()

/obj/item/entrepreneur/dentist_sickle
	name = "dental sickle"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "sickle"
	desc = "A narrow, sharp hook at the end of a short, stainless steel rod."
	w_class = ITEMSIZE_TINY

/obj/item/entrepreneur/dentist_sickle/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		to_chat(user, "<span class='notice'>You loosen some stuck debris from [M]'s mouth with the hook.</span>")
		to_chat(M, "<span class='notice'>[user] uses a hook to scrape out something stuck in your mouth, it's pretty uncomfortable.</span>")
		return 0
	..()

/obj/item/entrepreneur/dentist_scaler
	name = "dental scaler"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "scaler"
	desc = "A flat and thin scraper at the end of a short, stainless steel rod."
	w_class = ITEMSIZE_TINY

/obj/item/entrepreneur/dentist_scaler/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		to_chat(user, "<span class='notice'>You scrape debris out from [M]'s mouth.</span>")
		to_chat(M, "<span class='notice'>[user] scrapes debris from out of your mouth.</span>")
		return 0
	..()

////// Exercise mat, yoga and trainer stuff

/obj/item/bedsheet/pillow/exercise
	name = "exercise mat"
	desc = "A thick, flexible but tough mat designed for people to exercise on."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "exercise_mat"

/obj/item/bedsheet/pillow/exercise/attackby(var/obj/item/component, mob/user as mob)
	return

/obj/item/entrepreneur/dumbbell
	name = "dumbbell"
	desc = "A small but heavy pair of weights connected by a bar, desgined to be held in one hand."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "dumbbell"

/obj/item/entrepreneur/dumbbell/attack_self(var/mob/user)
	var/mob/living/M = user
	if(M.nutrition <= 100)
		to_chat(user, "<span class='notice'>You are too hungry to exercise right now.</span>")
		return 0
	if(!do_after(user, 3 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		return 0
	M.adjust_nutrition(-10)
	to_chat(user, "<span class='notice'>You successfully perform a [src] exercise!</span>")
	if(M.weight > 50)
		M.weight -= 0.5

//////Paranormal Investigator stuff

/obj/item/entrepreneur/emf
	name = "EMF scanner"
	desc = "A handheld device used for detecting disturbances to electromagnetic fields."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "emf"
	var/emf = 5
	var/turf/last_used = 0
	var/emf_change = 0

/obj/item/entrepreneur/emf/attack_self(var/mob/user)
	if(!last_used)
		emf = rand(1,100)
		last_used = get_turf(user)
	var/current_used = get_turf(user)
	var/mob/observer/spooky = locate() in current_used
	if(last_used != current_used)
		if(emf >= 100)
			emf = 100
		if(emf <= 20)
			emf = 20
		if(spooky)
			emf_change = rand(-15,20) //Trend upwards but not by enough to prove ghosts actually exist
		else
			emf_change = rand(-20,15) //Trend downwards
		last_used = get_turf(user)
		emf = (emf + emf_change)
		update_icon()
	to_chat(user, "<span class='notice'>You update the EMF scanner and check the reading. It reads [emf]mG!</span>")

/obj/item/entrepreneur/emf/update_icon()
	switch(emf)
		if(-1000 to 20)
			icon_state = "emf-0"
		if(20 to 40)
			icon_state = "emf-20"
		if(40 to 60)
			icon_state = "emf-40"
		if(60 to 80)
			icon_state = "emf-60"
		if(80 to 1000)
			icon_state = "emf-80"
	return

/obj/item/entrepreneur/spirit_board
	name = "spirit board"
	desc = "A wooden board with an alphabet at numbers on it, used to contact the dead. You need to use a glass to contact the spirit world. (It can be alt-clicked to decide the next letter in the sequence. This item does not canonise ghosts/souls in this setting, it's just a bit of fun!)"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "spirit_board"
	var/list/possible_results = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Yes","No","1","2","3","4","5","6","7","8","9","0","Nothing")
	var/next_result = 0
	var/ghost_enabled = 1

/obj/item/entrepreneur/spirit_board/attackby(obj/item/reagent_containers/food/drinks/W as obj, mob/living/user as mob)
	if(!istype(user))
		return 0
	if(!istype(W))
		to_chat(user, "<span class='notice'>You need some sort of glass, bottle or cup to contact the spirit world.</span>")
		return 0
	var/result = 0
	if(!do_after(user, 3 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		return 0
	if(next_result)
		result = next_result
	else
		result = pick(possible_results)
	src.visible_message("<span class='notice'>[user] slides the [W] over to [result]!</span>")
	next_result = 0

/obj/item/entrepreneur/spirit_board/AltClick(mob/living/carbon/user)
	if(!istype(user)) //admins can be cheeky
		return 0
	next_result = tgui_input_list(user, "What should it land on next?", "Next result", possible_results)

/obj/item/entrepreneur/spirit_board/attack_ghost(var/mob/observer/dead/user)
	if(!ghost_enabled)
		return
	if(jobban_isbanned(user, "GhostRoles"))
		to_chat(user, "<span class='warning'>You cannot interact with this board because you are banned from playing ghost roles.</span>")
		return
	next_result = tgui_input_list(user, "What should it land on next?", "Next result", possible_results)
	if(!is_admin(user)) //admins can bypass this for event stuff
		if(prob(25))
			next_result = 0 //25% chance for the ghost to fail to manipulate the board

// Spirit Healer stuff

/obj/item/entrepreneur/crystal
	name = "healing crystal"
	desc = "A crystal with a powerful energy, apparantly, and is capable of healing the soul, apparantly."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "crystal_pink"
	w_class = ITEMSIZE_TINY

/obj/item/entrepreneur/crystal/Initialize()
	. = ..()
	var/list/colour_choice = list("crystal_pink","crystal_blue","crystal_green","crystal_orange","crystal_dblue","crystal_purple")
	icon_state = pick(colour_choice)
	update_icon()

/obj/item/reagent_containers/glass/bottle/essential_oil
	name = "essential oils"
	desc = "A small bottle of various plant extracts said to improve upon a person's health as an alternative form of medicine."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "oil"
	prefill = list("essential_oil" = 60)

// Masseuse

/obj/item/roller/massage
	name = "massage bed"
	desc = "A collapsed roller massage bed that can be carried around. When deployed, it can be locked in place (with alt-click)."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "folded_rollerbed"
	rollertype = /obj/item/roller/massage
	bedtype = /obj/structure/bed/roller/massage

/obj/structure/bed/roller/massage
	name = "massage bed"
	desc = "A portable bed-on-wheels wish extra padding for getting people comfortable for massages. It can be locked in place (with alt-click)."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "rollerbed"
	rollertype = /obj/item/roller/massage
	bedtype = /obj/structure/bed/roller/massage

/obj/structure/bed/roller/massage/AltClick(mob/living/carbon/user)
	if(anchored)
		anchored = 0
		src.visible_message("<span class='notice'>[user] turns the breaks off on the [src]!</span>")
	else if(!anchored)
		anchored = 1
		src.visible_message("<span class='notice'>[user] turns the breaks on for the [src]!</span>")

/obj/structure/bed/roller/massage/buckle_mob(mob/living/M)
	..()
	M.set_dir(1)

//Magnifying glass

/obj/item/entrepreneur/magnifying_glass
	name = "magnifying glass"
	desc = "A curved lense for looking at things a little closer."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "magnifying_glass"
	w_class = ITEMSIZE_SMALL

/obj/item/entrepreneur/magnifying_glass/afterattack(atom/T, mob/living/user as mob)
	if(!T.desc)
		return
	user.visible_message("<span class='notice'>\The [user] examines the \the [T] with \the [src]!</span>")
	to_chat(user, "<FONT size=4>[T.desc]</FONT>")

// Streamer and influencer

/obj/item/tvcamera/streamer
	name = "streamer camera drone"
	channel = "Virgo Live Stream"

/obj/item/camera/selfie
	name = "selfie stick"
	desc = "A long stick with a camera on the end, designed for taking pictures of one's self, but could awkwardly be turned to take pictures of other things too!"
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "selfie"
	item_state = "selfie"
	icon_on = "selfie"
	icon_off = "selfie_off"

// Containers

/obj/item/storage/box/fortune_teller
	name = "fortune teller kit"
	desc = "A kit containing everything that a fortune teller needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "fortune_teller"
	starts_with = list(/obj/item/entrepreneur/horoscope, /obj/item/deck/tarot, /obj/item/entrepreneur/crystal_ball, /obj/item/ticket_printer/train)

/obj/item/storage/box/dentist
	name = "dentist kit"
	desc = "A kit containing everything that a dentist needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "dentist"
	starts_with = list(/obj/item/entrepreneur/dentist_mirror, /obj/item/entrepreneur/dentist_probe, /obj/item/entrepreneur/dentist_sickle, /obj/item/entrepreneur/dentist_scaler, /obj/item/flashlight/pen, /obj/item/ticket_printer/train)

/obj/item/storage/box/fitness_trainer
	name = "exercise kit"
	desc = "A kit containing everything that a fitness trainer needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "fitness_trainer"
	starts_with = list(/obj/item/bedsheet/pillow/exercise, /obj/item/entrepreneur/dumbbell, /obj/item/entrepreneur/dumbbell, /obj/item/reagent_containers/food/snacks/candy/proteinbar, /obj/item/ticket_printer/train)

/obj/item/storage/box/yoga_teacher
	name = "yoga kit"
	desc = "A kit containing everything that a yoga teacher needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "yoga_teacher"
	starts_with = list(/obj/item/bedsheet/pillow/exercise, /obj/item/bedsheet/pillow/exercise, /obj/item/reagent_containers/food/snacks/fruitbar, /obj/item/ticket_printer/train)

/obj/item/storage/box/paranormal_investigator
	name = "ghost hunting kit"
	desc = "A kit containing everything that a paranormal investigator needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "paranormal_investigator"
	starts_with = list(/obj/item/entrepreneur/emf, /obj/item/entrepreneur/spirit_board, /obj/item/reagent_containers/food/drinks/glass2/shot, /obj/item/ticket_printer/train)

/obj/item/storage/box/spirit_healer
	name = "exercise kit"
	desc = "A kit containing everything that a spirit healer needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "spirit_healer"
	starts_with = list(/obj/item/entrepreneur/crystal, /obj/item/entrepreneur/crystal, /obj/item/entrepreneur/crystal, /obj/item/entrepreneur/crystal, /obj/item/entrepreneur/crystal, /obj/item/reagent_containers/glass/bottle/essential_oil, /obj/item/ticket_printer/train)

/obj/item/storage/box/private_investigator
	name = "investigator kit"
	desc = "A kit containing everything that a private eye needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "private_investigator"
	starts_with = list(/obj/item/taperecorder, /obj/item/tape, /obj/item/tape, /obj/item/camera, /obj/item/sticky_pad, /obj/item/entrepreneur/magnifying_glass, /obj/item/ticket_printer/train)

/obj/item/storage/box/stylist
	name = "stylist kit"
	desc = "A kit containing everything that a stylist needs."
	icon = 'icons/obj/entrepreneur.dmi'
	icon_state = "stylist"
	starts_with = list(/obj/item/makeover, /obj/item/lipstick/random, /obj/item/nailpolish,  /obj/item/nailpolish_remover, /obj/item/haircomb, /obj/item/clothing/head/hairnet, /obj/item/ticket_printer/train)

