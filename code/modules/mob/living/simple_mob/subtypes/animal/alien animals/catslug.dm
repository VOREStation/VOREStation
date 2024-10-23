//No relation to slugcat :)

/datum/category_item/catalogue/fauna/catslug
	name = "Alien Wildlife - Catslug"
	desc = "The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/catslug
	name = "catslug"
	desc = "A noodley bodied creature with thin arms and legs, and gloomy dark eyes."
	tt_desc = "Mollusca Feline"
	icon_state = "catslug"
	icon_living = "catslug"
	icon_dead = "catslug_dead"
	icon_rest = "catslug_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'

	faction = FACTION_CATSLUG
	maxHealth = 50
	health = 50
	movement_cooldown = -1
	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	holder_type = /obj/item/holder/catslug

	response_help = "hugs"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 5

	has_hands = TRUE
	mob_size = MOB_SMALL
	friendly = list("hugs")
	see_in_dark = 8
	can_climb = TRUE
	climbing_delay = 2.0

	ID_provided = TRUE

	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug
	say_list_type = /datum/say_list/catslug
	player_msg = "You have escaped the foul weather, into this much more pleasant place. You are an intelligent creature capable of more than most think. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds!<br>- - - - -<br>" + span_notice("Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.")

	has_langs = list(LANGUAGE_SIGN)

	var/obj/item/clothing/head/hat = null // Scughat.
	var/can_wear_hat = TRUE				  // Some have inbuilt hats

	var/picked_color = FALSE

	allow_mind_transfer = TRUE

	can_enter_vent_with = list(
		/obj/item/implant,
		/obj/item/radio/borg,
		/obj/item/holder,
		/obj/machinery/camera,
		/obj/belly,
		/obj/screen,
		/atom/movable/emissive_blocker,
		/obj/item/material,
		/obj/item/melee,
		/obj/item/stack/,
		/obj/item/tool,
		/obj/item/reagent_containers/food,
		/obj/item/coin,
		/obj/item/aliencoin,
		/obj/item/ore,
		/obj/item/disk/nuclear,
		/obj/item/toy,
		/obj/item/card,
		/obj/item/radio,
		/obj/item/perfect_tele_beacon,
		/obj/item/clipboard,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/canvas,
		/obj/item/paint_palette,
		/obj/item/paint_brush,
		/obj/item/camera,
		/obj/item/photo,
		/obj/item/camera_film,
		/obj/item/taperecorder,
		/obj/item/rectape
		)

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DIGEST
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/datum/say_list/catslug	//Quiet quiet, no noise! We speak in sign so only people with sign will understand our questions.
	speak = list("Have any porl?", "What is that?", "Where is this?", "What are you doing?", "How did you get here?", "Don't go into the rain.")
	emote_hear = list()
	emote_see = list("turns their head.", "looks at you.", "watches something unseen.", "sways its tail.", "flicks its ears.", "stares at you.", "gestures an unintelligible message.", "points into the distance!")
	say_maybe_target = list()
	say_got_target = list()

/mob/living/simple_mob/vore/alienanimals/catslug/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The hot slick gut of a catslug!! Copious slime smears over you as you’re packed away into the gloom and oppressive humidity of this churning gastric sac. The pressure around you is intense, the squashy flesh bends and forms to your figure, clinging to you insistently! There’s basically no free space at all as your ears are filled with the slick slide of flesh against flesh and the burbling of gastric juices glooping all around you. The thumping of a heart booms from somewhere nearby, making everything pulse in against you in time with it! This is it! You’ve been devoured by a catslug!!!"
	B.mode_flags = 40
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 0.5
	B.digest_burn = 0.5
	B.digestchance = 10
	B.absorbchance = 1
	B.escapechance = 15

/datum/ai_holder/simple_mob/melee/evasive/catslug
	hostile = FALSE
	cooperative = FALSE
	retaliate = TRUE
	speak_chance = 0.5
	wander = TRUE
	belly_attack = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)
	add_verb(src, /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color)

/mob/living/simple_mob/vore/alienanimals/catslug/Destroy()
	if(hat)
		drop_hat()
	return ..()

/mob/living/simple_mob/vore/alienanimals/catslug/attackby(var/obj/item/reagent_containers/food/snacks/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(O, user)
		return
	else if(!istype(O, /obj/item/reagent_containers/food/snacks))
		return ..()
	if(resting)
		to_chat(user, span_notice("\The [src] is napping, and doesn't respond to \the [O]."))
		return
	if(nutrition >= max_nutrition)
		if(user == src)
			to_chat(src, span_notice("You're too full to eat another bite."))
			return
		to_chat(user, span_notice("\The [src] seems too full to eat."))
		return
	var/nutriment_amount = O.reagents?.get_reagent_amount("nutriment") //does it have nutriment, if so how much?
	var/protein_amount = O.reagents?.get_reagent_amount("protein") //does it have protein, if so how much?
	var/glucose_amount = O.reagents?.get_reagent_amount("glucose") //does it have glucose, if so how much?
	var/yum = nutriment_amount + protein_amount + glucose_amount
	if(yum)
		yum = (yum * 20) / 3
		adjust_nutrition(yum) //add the nutriment!
	O.bitecount ++
	if(O.bitecount >= 3)
		user.drop_from_inventory(O)
		qdel(O)
		visible_message(span_notice("\The [src] eats \the [O]."))
	else
		to_chat(user, span_notice("\The [src] takes a bite of \the [O]."))
		if(user != src)
			to_chat(src, span_notice("\The [user] feeds \the [O] to you."))
	playsound(src, 'sound/items/eatfood.ogg', 75, 1)

/mob/living/simple_mob/vore/alienanimals/catslug/attack_hand(mob/living/carbon/human/M as mob)

	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		if(M.a_intent == I_GRAB && hat)
			remove_hat(M)
			return
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message(span_notice("\The [M.name] shakes \the [src] awake from their nap."),span_notice("You shake \the [src] awake!"))
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			span_notice("[M] pats \the [src] on the head."), \
			span_notice("You pat \the [src] on the head."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src] purrs and leans into [M]'s hand."))
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			span_notice("[M] shakes \the [src]'s hand."), \
			span_notice("You shake \the [src]'s hand."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s looks a little confused nibbles at [M]'s hand experimentally."))
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			span_notice("[M] boops \the [src]'s nose."), \
			span_notice("You boop \the [src] on the nose."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s eyes widen as they stare at [M]. After a moment they rub their prodded snoot."))
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			span_notice("[M] rubs \the [src]'s tummy..."), \
			span_notice("You rub \the [src]'s tummy... You feel the danger."), )
		if(client)
			return
		visible_message(span_notice("\The [src] pushes [M]'s hand away from their tummy and furrows their brow!"))
		if(prob(5))
			ai_holder.give_target(M, urgent = TRUE)
	else
		return ..()

/mob/living/simple_mob/vore/alienanimals/catslug/update_icon()
	..()

	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/inventory/head/mob.dmi', src, hat_state)
		I.pixel_y = -7
		I.color = hat.color
		I.appearance_flags = RESET_COLOR | KEEP_APART
		I.blend_mode = BLEND_OVERLAY
		add_overlay(I)

/mob/living/simple_mob/vore/alienanimals/catslug/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
	if(!istype(new_hat))
		to_chat(user, span_warning("\The [new_hat] isn't a hat."))
		return
	if(hat)
		to_chat(user, span_warning("\The [src] is already wearing \a [hat]."))
		return
	else if(!can_wear_hat)
		to_chat(user, span_warning("\The [src] is unable to wear \a [hat]."))
	else
		user.drop_item(new_hat)
		hat = new_hat
		new_hat.forceMove(src)
		to_chat(user, span_notice("You place \a [new_hat] on \the [src]. How adorable!"))
		update_icon()
		return

/mob/living/simple_mob/vore/alienanimals/catslug/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, span_warning("\The [src] doesn't have a hat to remove."))
	else
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, span_warning("You take away \the [src]'s [hat.name]. How mean."))
		hat = null
		update_icon()

/mob/living/simple_mob/vore/alienanimals/catslug/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()

/mob/living/simple_mob/vore/alienanimals/catslug/Login()	//If someone plays as us let's just be a passive mob in case accidents happen if the player D/Cs
	. = ..()
	if(ai_holder)
		ai_holder.hostile = FALSE
		ai_holder.wander = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color()
	set name = "Pick Color"
	set category = "Abilities"
	set desc = "You can set your color!"
	if(picked_color)
		to_chat(src, span_notice("You have already picked a color! If you picked the wrong color, ask an admin to change your picked_color variable to 0."))
		return
	var/newcolor = input(usr, "Choose a color.", "", color) as color|null
	if(newcolor)
		color = newcolor
		picked_color = TRUE
	update_icon()

/datum/ai_holder/simple_mob/melee/evasive/catslug/proc/consider_awakening()
	if(holder.resting)
		holder.lay_down()
		go_wake()

/datum/ai_holder/simple_mob/melee/evasive/catslug/handle_wander_movement()
	if(holder.client || holder.resting)
		return
	else if(prob(0.5))
		holder.lay_down()
		go_sleep()
		addtimer(CALLBACK(src, PROC_REF(consider_awakening)), rand(1 MINUTE, 5 MINUTES), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	else
		return ..()


/datum/ai_holder/simple_mob/melee/evasive/catslug/on_hear_say(mob/living/speaker, message)
	if(holder.client || !speaker.client)
		return
	if(findtext(message, "psps") && stance == STANCE_IDLE)
		set_follow(speaker, follow_for = 5 SECONDS)

	if(holder.stat || !holder.say_list || !message || speaker == holder)	//Copied from parrots
		return
	var/datum/say_list/S = holder.say_list
	S.speak |= message


/mob/living/simple_mob/vore/alienanimals/catslug/horrible
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug/horrible

/datum/ai_holder/simple_mob/melee/evasive/catslug/horrible/on_hear_say(mob/living/speaker, message)	//this was an accident originally but it was very funny so here you go
	if(holder.client || !speaker.client)
		return
	if(findtext(message, "psps") || stance == STANCE_IDLE)
		set_follow(speaker, follow_for = 5 SECONDS)

	if(holder.stat || !holder.say_list || !message || speaker == holder)	//Copied from parrots
		return
	var/datum/say_list/S = holder.say_list
	S.speak |= message

/obj/item/holder/catslug
	origin_tech = list(TECH_BIO = 2)
	icon = 'icons/mob/alienanimals_x32.dmi'
	item_state = "catslug"

/obj/item/holder/catslug/Initialize(mapload, mob/held)
	. = ..()
	color = held.color

//Custom Catslugs and the Rascal's Pass bunch

/mob/living/simple_mob/vore/alienanimals/catslug/custom
	desc = "A noodley bodied creature with thin arms and legs, and gloomy dark eyes. You shouldn't ever see this."
	makes_dirt = 0
	digestable = 0
	humanoid_hands = 1	//These should all be ones requiring admin-intervention to play as, so they can get decent tool-usage, as a treat.
	var/siemens_coefficient = 1 		//Referenced later by others.
	can_wear_hat = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/custom/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)
	remove_verb(src, /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color)	//Most of these have custom sprites with colour already, so we'll not let them have this.


/datum/category_item/catalogue/fauna/catslug/custom/spaceslug
	name = "Alien Wildlife - Catslug - Miros"
	desc = "This catslug serves as the Fuel Depots resident attendant,\
	despite the facility being fully automated and self-serve. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_MEDIUM	//Should offer a measure of incentive for people to visit the depot more often.

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug
	name = "Miros"
	desc = "Looks like catslugs can into space after all! This little chap seems to have gotten their mitts on a tiny spacesuit, there's a nametag on it that reads \"Miros\" alongside the Aether Atmospherics logo."
	tt_desc = "Mollusca Felis Stellaris"
	icon_state = "spaceslug"
	icon_living = "spaceslug"
	icon_rest = "spaceslug_rest"
	icon_dead = "spaceslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/spaceslug)
	holder_type = /obj/item/holder/catslug/custom/spaceslug
	say_list_type = /datum/say_list/catslug/custom/spaceslug

	minbodytemp = 0				// Shamelessly stolen temp & atmos tolerances from the space cat.
	maxbodytemp = 900
	heat_damage_per_tick = 3
	cold_damage_per_tick = 2

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	player_msg = "You are an intelligent creature capable of more than most think, clad in a spacesuit that protects you from the ravages of vacuum and hostile atmospheres alike. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds!<br>- - - - -<br>" + span_notice("Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.")

/datum/say_list/catslug/custom/spaceslug
	speak = list("Have any porl?", "What is that?", "What kind of ship is that?", "What are you doing?", "How did you get here?", "Don't take off your helmet.", "SPAAAAAACE!", "WAOW!", "Nice weather we're having, isn't it?")

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/attack_hand(mob/living/carbon/human/M as mob)

	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message(span_notice("\The [M.name] shakes \the [src] awake from their nap."),span_notice("You shake \the [src] awake!"))
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			span_notice("[M] pats \the [src] on their helmet."), \
			span_notice("You pat \the [src] on their helmet."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src] purrs and leans into [M]'s hand."))
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			span_notice("[M] shakes \the [src]'s hand."), \
			span_notice("You shake \the [src]'s hand."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s looks a little confused and bonks their helmet's faceplate against [M]'s hand experimentally, attempting to nibble at it."))
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			span_notice("[M] attempts to boop \the [src]'s nose, defeated only by the helmet they wear."), \
			span_notice("You attempt to boop \the [src] on the nose, stopped only by that helmet they wear."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s eyes widen as they stare at [M]. After a moment they rub at the faint mark [M]'s digit left upon the surface of their helmet's faceplate."))
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			span_notice("[M] rubs \the [src]'s tummy..."), \
			span_notice("You rub \the [src]'s tummy, accidently pressing a few of the buttons on their chestpiece in the process... You feel the danger."), )
		if(client)
			return
		visible_message(span_notice("\The [src] pushes [M]'s hand away from their tummy and furrows their brow, frantically pressing at the buttons [M] so carelessly pushed!"))
		if(prob(5))
			ai_holder.give_target(M, urgent = TRUE)
	else
		return ..()

/obj/item/holder/catslug/custom/spaceslug
	item_state = "spaceslug"

//Engineer catslug
/datum/category_item/catalogue/fauna/catslug/custom/engislug
	name = "Alien Wildlife - Catslug - Engineer O'Brimn"
	desc = "A resident worker at the NSB Rascal's Pass, Engineer O'Brimn \
	keeps the facilities pipework and machinery maintained between shifts, as \
	well as \"fixing\" the engine back to it's original configuration. \
	Reportedly the cause for numerous phoron-based conflagrations. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/engislug
	name = "Engineer O'Brimn"
	desc = "A yellow-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one seems to be wearing a too-big high visibility vest and a full-face hardhat."
	tt_desc = "Mollusca Felis Munitor"
	icon_state = "engislug"
	icon_living = "engislug"
	icon_rest = "engislug_rest"
	icon_dead = "engislug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/engislug)
	holder_type = /obj/item/holder/catslug/custom/engislug
	say_list_type = /datum/say_list/catslug/custom/engislug
	myid_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_construction, access_atmospherics)
	siemens_coefficient = 0 		//Noodly fella's gone and built up an immunity from many small shocks

	minbodytemp = 200
	maxbodytemp = 600		//engislug can survive a little heat, as a treat
	heat_damage_per_tick = 1
	cold_damage_per_tick = 2

	min_oxy = 16 			//Require atleast 16kPA oxygen
	max_oxy = 0
	min_tox = 0		//should still suffer hypoxia, but the mask ought to filter out not-nice gases for them
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/datum/say_list/catslug/custom/engislug
	speak = list("Have any porl?", "What is that?", "Phoroncheck!", "Thump is mean work fine!", "What are you doing?", "How did you get here?", "Don't breathe in the spicy purple.", "Zap-zap ball bad.", "WAOW!", "The pipes make sense.")

/mob/living/simple_mob/vore/alienanimals/catslug/custom/engislug/attack_hand(mob/living/carbon/human/M as mob)

	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message(span_notice("\The [M.name] shakes \the [src] awake from their nap."),span_notice("You shake \the [src] awake!"))
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			span_notice("[M] pats \the [src] on their helmet."), \
			span_notice("You pat \the [src] on their helmet."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src] purrs and leans into [M]'s hand."))
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			span_notice("[M] shakes \the [src]'s hand."), \
			span_notice("You shake \the [src]'s hand."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s looks a little confused and bonks their helmet's faceplate against [M]'s hand experimentally, attempting to nibble at it."))
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			span_notice("[M] attempts to boop \the [src]'s nose, defeated only by the helmet they wear."), \
			span_notice("You attempt to boop \the [src] on the nose, stopped only by that helmet they wear."), )
		if(client)
			return
		if(prob(10))
			visible_message(span_notice("\The [src]'s eyes widen as they stare at [M]. After a moment they rub at the faint mark [M]'s digit left upon the surface of their helmet's faceplate."))
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			span_notice("[M] rubs \the [src]'s tummy..."), \
			span_notice("You rub \the [src]'s tummy... You feel the danger."), )
		if(client)
			return
		visible_message(span_notice("\The [src] pushes [M]'s hand away from their tummy and furrows their brow!"))
		if(prob(5))
			ai_holder.give_target(M, urgent = TRUE)
	else
		return ..()

/obj/item/holder/catslug/custom/engislug
	item_state = "engislug"

//Security catslug
/datum/category_item/catalogue/fauna/catslug/custom/gatslug
	name = "Alien Wildlife - Catslug - Officer Gatslug"
	desc = "A resident worker at the NSB Rascal's Pass, Officer Gatslug \
	served with distinction during upheaval at the NSB Adephagia in 2321. \
	After their recovery from the wreckage afterwards, they were awarded \
	several commendations and an offer to serve aboard the latest NT venture \
	in the Virgo-Erigone system. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/gatslug
	name = "Officer Gatslug"
	desc = "A light red-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one seems to be wearing a security cap, bandolier and holobadge."
	tt_desc = "Mollusca Felis Magistratus"
	icon_state = "gatslug"
	icon_living = "gatslug"
	icon_rest = "gatslug_rest"
	icon_dead = "gatslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/gatslug)
	holder_type = /obj/item/holder/catslug/custom/gatslug
	maxHealth = 75
	health = 75
	say_list_type = /datum/say_list/catslug/custom/gatslug
	melee_damage_lower = 5
	melee_damage_upper = 10		//"Trained" security member, so they can hit that little bit harder
	taser_kill = 0		//Shouldn't be weak to accidental friendly fire from other officers
	armor = list(
		"melee" = 15,
		"bullet" = 0,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0
		)		//Similarly, \some\ armour values for a smidge more survivability compared to other catslugs.
	myid_access = list(access_security, access_sec_doors, access_forensics_lockers, access_maint_tunnels)

/datum/say_list/catslug/custom/gatslug
	speak = list("Have any flashbangs?", "Valids!", "Heard spiders?", "What is that?", "Freeze!", "What are you doing?", "How did you get here?", "Red alert means big bangsticks.", "No being naughty now.", "WAOW!", "Who ate all the donuts?")

/obj/item/holder/catslug/custom/gatslug
	item_state = "gatslug"

//Medical catslug
/datum/category_item/catalogue/fauna/catslug/custom/medislug
	name = "Alien Wildlife - Catslug - Doctor Mlemulon"
	desc = "A resident worker at the NSB Rascal's Pass, Doctor Mlemulon \
	works hard to drink and eat all the remaining medicine stocks in \
	the smartfridge after the end of a shift. Rumour has it they have \
	a side business of trading advanced surgical tools for \"tasty yummers\" too. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/medislug
	name = "Doctor Mlemulon"
	desc = "A pale blue-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one appears to have a nurses hat perched upon it's head and a medi-hud."
	tt_desc = "Mollusca Felis Medicus"
	icon_state = "medislug"
	icon_living = "medislug"
	icon_rest = "medislug_rest"
	icon_dead = "medislug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/medislug)
	holder_type = /obj/item/holder/catslug/custom/medislug
	say_list_type = /datum/say_list/catslug/custom/medislug
	myid_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

/datum/say_list/catslug/custom/medislug
	speak = list("Have any osteodaxon?", "What is that?", "Suit sensors!", "What are you doing?", "How did you get here?", "Put a mask on!", "No smoking!", "WAOW!", "Stop getting blood everywhere!", "WHERE IN MAINT?")

/obj/item/holder/catslug/custom/medislug
	item_state = "medislug"

//Science catslug
/datum/category_item/catalogue/fauna/catslug/custom/scienceslug
	name = "Alien Wildlife - Catslug - Professor Nubbins"
	desc = "A resident worker at the NSB Rascal's Pass, Professor Nubbins \
	is tasked with the periodic maintenance of the R&D servers. \
	Unfortunately, they take this to mean \"wipe all stored research\". - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/scienceslug
	name = "Professor Nubbins"
	desc = "A purple-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one looks to be wearing a swanky white science beret, as well as a pair of goggles."
	tt_desc = "Mollusca Felis Inquisitorem"
	icon_state = "scienceslug"
	icon_living = "scienceslug"
	icon_rest = "scienceslug_rest"
	icon_dead = "scienceslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/scienceslug)
	holder_type = /obj/item/holder/catslug/custom/scienceslug
	say_list_type = /datum/say_list/catslug/custom/scienceslug
	myid_access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)


/datum/say_list/catslug/custom/scienceslug
	speak = list("Slimes, squish!", "What is that?", "Smoking in Toxins is not advised.", "What are you doing?", "How did you get here?", "Do not deconstruct the cube!", "WAOW!", "Where are our materials?", "The acid dispenser is not full of juice. Must remember that.")

/obj/item/holder/catslug/custom/scienceslug
	item_state = "scienceslug"

//Cargo catslug
/datum/category_item/catalogue/fauna/catslug/custom/cargoslug
	name = "Alien Wildlife - Catslug - Technician Nermley"
	desc = "A resident worker at the NSB Rascal's Pass, Technician Nermley \
	is something of a mystery. No one is sure where they came from, \
	local scuttlebutt is that they just turned up one day and started \
	moving crates around. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/cargoslug
	name = "Technician Nermley"
	desc = "A brown-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one has a flipped-round baseball cap on their head and a pair of black mittens."
	tt_desc = "Mollusca Felis Quisquiliae"
	icon_state = "cargoslug"
	icon_living = "cargoslug"
	icon_rest = "cargoslug_rest"
	icon_dead = "cargoslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/cargoslug)
	holder_type = /obj/item/holder/catslug/custom/cargoslug
	say_list_type = /datum/say_list/catslug/custom/cargoslug
	myid_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)

/datum/say_list/catslug/custom/cargoslug
	speak = list("Disposals is not for slip and slide.", "What is that?", "Stamp those manifests!", "What are you doing?", "How did you get here?", "Can order pizza crate?", "WAOW!", "Where are all of our materials?", "Got glubbs?")

/obj/item/holder/catslug/custom/cargoslug
	item_state = "cargoslug"

//Command catslug
/datum/category_item/catalogue/fauna/catslug/custom/capslug
	name = "Alien Wildlife - Catslug - Captain Crumsh"
	desc = "A resident worker at the NSB Rascal's Pass, Captain Crumsh \
	comes from a long line of catslug leaders, maintaining the family tradition \
	for numerous years now. After a long tenure serving at Central Command, they \
	requested transfer to a more \"front-facing\" facility, ending up shipped across \
	to the facilty recently set up on Virgo 3C. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Local catslugs worth less than rarer ones

/mob/living/simple_mob/vore/alienanimals/catslug/custom/capslug
	name = "Captain Crumsh"
	desc = "A regal-blue furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one wears an impressive tower of hats upon it's head. Exudes a sense of superiority, clearly this 'slug has more porl than you."
	tt_desc = "Mollusca Felis Praefectus"
	icon_state = "capslug"
	icon_living = "capslug"
	icon_rest = "capslug_rest"
	icon_dead = "capslug_dead"
	faction = FACTION_NEUTRAL
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/capslug)
	holder_type = /obj/item/holder/catslug/custom/capslug
	say_list_type = /datum/say_list/catslug/custom/capslug
	myid_access = list(access_heads, access_keycard_auth)		//Same access as a bridge secretary.

/datum/say_list/catslug/custom/capslug
	speak = list("How open big glass box with shiny inside?.", "What is that?", "Respect my authority!", "What are you doing?", "How did you get here?", "Fax for yellow-shirts!", "WAOW!", "Why is that console blinking and clicking?", "Do we need to call for ERT?", "Have been called comdom before, not sure why they thought I was a balloon.")

/obj/item/holder/catslug/custom/capslug
	item_state = "capslug"

/mob/living/simple_mob/vore/alienanimals/catslug/custom/capslug/Initialize() 		//This is such an awful proc, but if someone wants it better they're welcome to have a go at it.
	. = ..()
	mob_radio = new /obj/item/radio/headset/mob_headset(src)
	mob_radio.frequency = PUB_FREQ
	mob_radio.ks2type = /obj/item/encryptionkey/heads/captain 		//Might not be able to speak, but the catslug can listen.
	mob_radio.keyslot2 = new /obj/item/encryptionkey/heads/captain(mob_radio)
	mob_radio.recalculateChannels(1)

//=============================================================================
//Admin-spawn only catslugs below - Expect overpowered things & silliness below
//=============================================================================

//Deathsquad catslug
/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/deathslug
	name = "Asset Purrtection"
	desc = "What are you doing staring at this angry little fella? <b>Run.</b>"
	tt_desc = "Mollusca Felis Eversor"
	icon_state = "deathslug"
	icon_living = "deathslug"
	icon_rest = "deathslug_rest"
	icon_dead = "deathslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug) 			//So they don't get the spaceslug's cataloguer entry
	say_list_type = /datum/say_list/catslug 			//Similarly, so they don't get the spaceslug's speech lines.
	myid_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	maxHealth = 100		//Tough noodles
	health = 100
	taser_kill = 0
	mob_size = MOB_MEDIUM		//As funny as picking up deathslugs & throwing them at people to be merked would be, I'm not willing to sprite their holders. Something something hardsuit heavy can be the "IC" reason for this.
	siemens_coefficient = 0
	armor = list(
		"melee" = 60,
		"bullet" = 50,
		"laser" = 50,
		"energy" = 40,
		"bomb" = 40,
		"bio" = 100,
		"rad" = 100
		)

	minbodytemp = 0
	maxbodytemp = 5000

	player_msg = "You work in the service of corporate Asset Protection, answering directly to the Board of Directors and Asset Protection Commandos."

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/deathslug/Initialize()
	. = ..()
	mob_radio = new /obj/item/radio/headset/mob_headset(src)
	mob_radio.frequency = DTH_FREQ 			//Can't tell if bugged, deathsquad freq in general seems broken
	myid.access |= get_all_station_access()

//Syndicate catslug
/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/syndislug
	name = "Mercenyary"
	desc = "What are you doing staring at this crimson-hardsuit wearing angry little fella? <b>Run.</b>"
	tt_desc = "Mollusca Felis Mors"
	icon_state = "syndislug"
	icon_living = "syndislug"
	icon_rest = "syndislug_rest"
	icon_dead = "syndislug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	say_list_type = /datum/say_list/catslug
	myid_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	faction = FACTION_SYNDICATE
	maxHealth = 100		//Tough noodles
	health = 100
	taser_kill = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	mob_size = MOB_MEDIUM		//Something something hardsuits are heavy.
	siemens_coefficient = 0
	armor = list(
		"melee" = 80,
		"bullet" = 65,
		"laser" = 50,
		"energy" = 15,
		"bomb" = 80,
		"bio" = 100,
		"rad" = 60
		)

	minbodytemp = 0
	maxbodytemp = 5000

	player_msg = "You are in the employ of a criminal syndicate hostile to corporate interests. Follow the Mercenary or Commando's orders and assist them in their goals by any means available."

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/syndislug/Initialize()
	. = ..()
	mob_radio = new /obj/item/radio/headset/mob_headset(src)
	mob_radio.frequency = SYND_FREQ
	mob_radio.syndie = 1
	mob_radio.ks2type = /obj/item/encryptionkey/syndicate
	mob_radio.keyslot2 = new /obj/item/encryptionkey/syndicate(mob_radio)
	mob_radio.recalculateChannels(1)
	myid.access |= get_all_station_access()

//ERT catslug
/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/responseslug
	name = "Emeowgency Responder"
	desc = "The cavalry has arrived."
	tt_desc = "Mollusca Felis Salvator"
	icon_state = "responseslug"
	icon_living = "responseslug"
	icon_rest = "responseslug_rest"
	icon_dead = "responseslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	say_list_type = /datum/say_list/catslug
	myid_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	maxHealth = 100		//Tough noodles
	health = 100
	taser_kill = 0
	mob_size = MOB_MEDIUM		//Something something hardsuits are heavy.
	siemens_coefficient = 0
	armor = list(
		"melee" = 60,
		"bullet" = 50,
		"laser" = 30,
		"energy" = 15,
		"bomb" = 30,
		"bio" = 100,
		"rad" = 100
		)

	minbodytemp = 0
	maxbodytemp = 5000

	player_msg = "You are an <b>anti</b> antagonist! Within the rules, try to save the station and its inhabitants from the ongoing crisis. Try to make sure other players have <i>fun</i>! \
	If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! \
	Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to the ERT.</b>"

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/responseslug/Initialize()
	. = ..()
	mob_radio = new /obj/item/radio/headset/mob_headset(src)
	mob_radio.frequency = ERT_FREQ
	mob_radio.centComm = 1
	mob_radio.ks2type = /obj/item/encryptionkey/ert
	mob_radio.keyslot2 = new /obj/item/encryptionkey/ert(mob_radio)
	mob_radio.recalculateChannels(1)
	myid.access |= get_all_station_access()

//Pilot Catslug

/mob/living/simple_mob/vore/alienanimals/catslug/custom/pilotslug
	name = "Navigator Purrverick"
	desc = "A black-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one exudes an aura of coolness, they're so cool that their pilot's liscense was suspended."
	tt_desc = "Mollusca Felis Mischefterous"
	color = "#2b2b2b"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/pilotslug)
	say_list_type = /datum/say_list/catslug/custom/pilotslug

	can_wear_hat = TRUE

/mob/living/simple_mob/vore/alienanimals/catslug/custom/pilotslug/Initialize()
	. = ..()
	if(prob(25))
		var/list/possible_targets = list()
		for(var/obj/machinery/computer/ship/helm/h in world)
			if(h.z in using_map.player_levels)
				possible_targets |= h
		var/final = pick(possible_targets)
		forceMove(get_turf(final))
		ghostjoin = TRUE

/datum/category_item/catalogue/fauna/catslug/custom/pilotslug
	name = "Alien Wildlife - Catslug - Navigator Purrverick"
	desc = "A resident at NSB Rascal's Pass, Navigator Purrverick \
	is a catslug who is known to dream big and seek the sky.\
	Purrverick has proved to be quite capable of utilizing shuttle\
	controls with excellent grace and skill. Purrverick can however\
	be rather self assured, which has on more than one occasion\
	lead to unfortunate mistakes and incidents.\
	Purrverick's provisionary piloting liscense is marked as suspended.\
	There are however still more records of the catslug's piloting escapades\
	dated afer their suspension.\
	\
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/say_list/catslug/custom/pilotslug
	speak = list("In the pipe, five my five.","Kick the tires and light the fires!","Bogeys on my tail!","GOOSE!","I'm really good at the stick.","I'm not doing nothing.","Heh.","Can you keep up?","Can't keep the sky from me.")

//Royal slug

/mob/living/simple_mob/vore/alienanimals/catslug/custom/royalslug
	name = "Ruler Purrton"
	desc = "A golden-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one is adorned with a crown and red cloak, very fancy."
	tt_desc = "Mollusca Felis Royallis"
	icon_state = "catslugking"
	icon_living = "catslugking"
	icon_rest = "catslugking_rest"
	icon_dead = "catslugking_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/royalslug)
	say_list_type = /datum/say_list/catslug/custom/royalslug

/datum/category_item/catalogue/fauna/catslug/custom/royalslug
	name = "Alien Wildlife - Catslug - Ruler Purrton"
	desc = "Found in a castle beyond the redgate, Ruler Purrton\
	is a catslug who spends their days presiding over this low \
	technology town, living a life of luxury. Always seen with \
	their trademark crown and cloak, this litter critter seems \
	to just exude raw confidence and superiority. \
	\
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/say_list/catslug/custom/royalslug
	speak = list("Let them eat cake. Lots and lots of cake.", "Fetch my good cloak.", "I myself prefer my ancient eggs for breakfast!", "Have you come to pay tribute?", "How dare you intrude?", "Bring me the finest of fine finery.", "HARK!", "With great power comes great dinner.")

//crypt slug

/mob/living/simple_mob/vore/alienanimals/catslug/custom/cryptslug
	name = "Keeper Sluguloth"
	desc = "A dark-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one is adorned with a dark cloak that obscures most of it's body."
	tt_desc = "Mollusca Felis Necrosis"
	icon_state = "cryptslug"
	icon_living = "cryptslug"
	icon_rest = "cryptslug_rest"
	icon_dead = "cryptslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/cryptslug)
	say_list_type = /datum/say_list/catslug/custom/cryptslug

/datum/category_item/catalogue/fauna/catslug/custom/cryptslug
	name = "Alien Wildlife - Catslug - Keeper Sluguloth"
	desc = "Found in a deep beneath a town beyond the redgate, Sluguloth\
	is a catslug who spends their days lurking within dark dungeons \
	alongside monstrous beings of all sorts. Always seen within \
	their dark cloak, obscuring them, this litter critter seems \
	to just exude pure menance and up-to-no-goodness. \
	\
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/say_list/catslug/custom/cryptslug
	speak = list("I have a lot of nasty friends.", "Do not test me.", "I shall rise again!", "How dare you step foot in my domain?", "Dare you indluge in dark desires?", "I am become death, one day.", "Foul creature!", "I used to think my life was a tragedy, but now I realize it's kind of okay actually.")

//jungle slug

/mob/living/simple_mob/vore/alienanimals/catslug/custom/exploslug
	name = "Explorer Pawdiana"
	desc = "A green-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one is adorned with an explorers hat and vest."
	tt_desc = "Mollusca Felis Exploris"
	icon_state = "exploslug"
	icon_living = "exploslug"
	icon_rest = "exploslug_rest"
	icon_dead = "exploslug_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/exploslug)
	say_list_type = /datum/say_list/catslug/custom/exploslug

/datum/category_item/catalogue/fauna/catslug/custom/exploslug
	name = "Alien Wildlife - Catslug - Explorer Pawdiana"
	desc = "Found in the depths of an arugably magical jungle, Pawdiana\
	is a catslug who spends their days treking through the dense foliage \
	of the dangerous wild. Always seen within \
	their fancy explorers kit, they are always ready to brave \
	the hazards of unknown lands. \
	\
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/say_list/catslug/custom/exploslug
	speak = list("Fortune and porls, kid. Fortune and porls.", "Lizards, why'd it have to be lizards.", "That thingy is an important artifact. It belongs in a museum!", "Everything lost is meant to be found. By me.", "I swear I've seen that stone before...", "I should have packed more jellyfishes.", "I better get back before nightfall!", "A comfy bed? Hah! I sleep under the stars!")


//=============================
//Admin-spawn only catslugs end
//=============================

//Suslug's below

/mob/living/simple_mob/vore/alienanimals/catslug/suslug
	name = "suslug"
	desc = "A noodley bodied creature wearing a colorful space suit. Suspicious..."
	tt_desc = "Mollusca Felis Amogus"
	icon_state = "suslug"
	icon_living = "suslug"
	icon_rest = "suslug_rest"
	icon_dead = "suslug_dead"
	var/image/eye_image
	var/is_impostor = FALSE
	var/kill_cooldown
	can_wear_hat = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/impostor
	is_impostor = TRUE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/Initialize()
	. = ..()
	add_verb(src, /mob/living/simple_mob/vore/alienanimals/catslug/suslug/proc/assussinate)
	update_icon()

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/update_icon()
	..()
	update_suslug_eyes()

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/proc/update_suslug_eyes()
	cut_overlay(eye_image)
	eye_image = image(icon,null,"[icon_state]-eyes")
	eye_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
	add_overlay(eye_image)

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/can_ventcrawl()
	if(!is_impostor)
		to_chat(src, span_notice("You are not an impostor! You can't vent!"))
		return FALSE
	.=..()

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/examine(mob/user)
	. = ..()

	if(istype(user, /mob/living/simple_mob/vore/alienanimals/catslug/suslug))
		var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/us = user
		if(us.is_impostor)
			if(src.is_impostor)
				. += span_notice("They appear to be a fellow impostor!")
			else
				. += span_notice("They appear to be a filthy innocent!")

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/proc/assussinate()
	set name = "Kill Innocent"
	set category = "Abilities"
	set desc = "Kill an innocent suslug!"
	if(!is_impostor)
		to_chat(src, span_notice("You are not an impostor! You can't kill like that!"))
		return
	if((world.time - kill_cooldown) < 1 MINUTE)
		to_chat(src, span_notice("You cannot kill so soon after previous kill!"))
		return

	var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/target
	var/list/victims = list()
	for(var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/S in range(1))
		if(!S.is_impostor)
			victims += S
	if(!victims || !victims.len)
		to_chat(src, span_warning("There are no innocent suslugs nearby!"))
		return
	if(victims.len == 1)
		target = victims[1]
	else
		target = tgui_input_list(usr, "Kill", "Pick a victim", victims)

	if(target && istype(target))
		target.adjustBruteLoss(3000)
		visible_message(span_warning("\The [src] kills \the [target]!"))
		kill_cooldown = world.time

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color
	picked_color = TRUE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/white
	color = COLOR_WHITE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/red
	color = COLOR_RED

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/blue
	color = COLOR_BLUE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/lime
	color = COLOR_LIME

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/cyan
	color = COLOR_CYAN

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/pink
	color = COLOR_PINK

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/yellow
	color = COLOR_YELLOW

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/orange
	color = COLOR_ORANGE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/green
	color = COLOR_GREEN

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/violet
	color = COLOR_VIOLET

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/orange
	color = COLOR_ORANGE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/brown
	color = COLOR_DARK_BROWN

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/grey
	color = COLOR_GRAY

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/black
	color = COLOR_DARK_GRAY

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/beige
	color = COLOR_BEIGE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/maroon
	color = COLOR_MAROON

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/navy
	color = COLOR_NAVY

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/light_pink
	color = COLOR_LIGHT_PINK

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/color/light_yellow
	color = COLOR_WHEAT
