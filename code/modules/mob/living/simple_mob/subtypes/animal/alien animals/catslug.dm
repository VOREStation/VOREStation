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

	faction = "catslug"
	maxHealth = 50
	health = 50
	movement_cooldown = -1
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	holder_type = /obj/item/weapon/holder/catslug

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

	mobcard_provided = TRUE

	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug
	say_list_type = /datum/say_list/catslug
	player_msg = "You have escaped the foul weather, into this much more pleasant place. You are an intelligent creature capable of more than most think. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds! <br>- - - - -<br> <span class='notice'>Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.</span>"

	has_langs = list(LANGUAGE_SIGN)

	var/picked_color = FALSE

	can_enter_vent_with = list(
		/obj/item/weapon/implant,
		/obj/item/device/radio/borg,
		/obj/item/weapon/holder,
		/obj/machinery/camera,
		/obj/belly,
		/obj/screen,
		/atom/movable/emissive_blocker,
		/obj/item/weapon/material,
		/obj/item/weapon/melee,
		/obj/item/stack/,
		/obj/item/weapon/tool,
		/obj/item/weapon/reagent_containers/food,
		/obj/item/weapon/coin,
		/obj/item/weapon/aliencoin,
		/obj/item/weapon/ore,
		/obj/item/weapon/disk/nuclear,
		/obj/item/toy,
		/obj/item/weapon/card,
		/obj/item/device/radio,
		/obj/item/device/perfect_tele_beacon,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/canvas,
		/obj/item/paint_palette,
		/obj/item/paint_brush,
		/obj/item/device/camera,
		/obj/item/weapon/photo,
		/obj/item/device/camera_film,
		/obj/item/device/taperecorder,
		/obj/item/device/tape
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

/mob/living/simple_mob/vore/alienanimals/catslug/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	verbs += /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color

/mob/living/simple_mob/vore/alienanimals/catslug/attackby(var/obj/item/weapon/reagent_containers/food/snacks/O as obj, var/mob/user as mob)
	if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks))
		return ..()
	if(resting)
		to_chat(user, "<span class='notice'>\The [src] is napping, and doesn't respond to \the [O].</span>")
		return
	if(nutrition >= max_nutrition)
		if(user == src)
			to_chat(src, "<span class='notice'>You're too full to eat another bite.</span>")
			return
		to_chat(user, "<span class='notice'>\The [src] seems too full to eat.</span>")
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
		visible_message("<span class='notice'>\The [src] eats \the [O].</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] takes a bite of \the [O].</span>")
		if(user != src)
			to_chat(src, "<span class='notice'>\The [user] feeds \the [O] to you.</span>")
	playsound(src, 'sound/items/eatfood.ogg', 75, 1)

/mob/living/simple_mob/vore/alienanimals/catslug/attack_hand(mob/living/carbon/human/M as mob)

	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message("<span class='notice'>\The [M.name] shakes \the [src] awake from their nap.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			"<span class='notice'>[M] pats \the [src] on the head.</span>", \
			"<span class='notice'>You pat \the [src] on the head.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src] purrs and leans into [M]'s hand.</span>")
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			"<span class='notice'>[M] shakes \the [src]'s hand.</span>", \
			"<span class='notice'>You shake \the [src]'s hand.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s looks a little confused nibbles at [M]'s hand experimentally.</span>")
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			"<span class='notice'>[M] boops \the [src]'s nose.</span>", \
			"<span class='notice'>You boop \the [src] on the nose.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s eyes widen as they stare at [M]. After a moment they rub their prodded snoot.</span>")
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			"<span class='notice'>[M] rubs \the [src]'s tummy...</span>", \
			"<span class='notice'>You rub \the [src]'s tummy... You feel the danger.</span>", )
		if(client)
			return
		visible_message("<span class='notice'>\The [src] pushes [M]'s hand away from their tummy and furrows their brow!</span>")
		if(prob(5))
			ai_holder.target = M
			ai_holder.track_target_position()
			ai_holder.set_stance(STANCE_FIGHT)
	else
		return ..()

/mob/living/simple_mob/vore/alienanimals/catslug/Login()	//If someone plays as us let's just be a passive mob in case accidents happen if the player D/Cs
	. = ..()
	ai_holder.hostile = FALSE
	ai_holder.wander = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color()
	set name = "Pick Color"
	set category = "Abilities"
	set desc = "You can set your color!"
	if(picked_color)
		to_chat(src, "<span class='notice'>You have already picked a color! If you picked the wrong color, ask an admin to change your picked_color variable to 0.</span>")
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
		addtimer(CALLBACK(src, .proc/consider_awakening), rand(1 MINUTE, 5 MINUTES), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
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

/obj/item/weapon/holder/catslug
	origin_tech = list(TECH_BIO = 2)
	icon = 'icons/mob/alienanimals_x32.dmi'
	item_state = "catslug"

/obj/item/weapon/holder/catslug/Initialize(mapload, mob/held)
	. = ..()
	color = held.color

//Custom Catslugs and the Rascal's Pass bunch

/mob/living/simple_mob/vore/alienanimals/catslug/custom
	desc = "A noodley bodied creature with thin arms and legs, and gloomy dark eyes. You shouldn't ever see this."
	makes_dirt = 0
	digestable = 0
	humanoid_hands = 1	//These should all be ones requiring admin-intervention to play as, so they can get decent tool-usage, as a treat.
	var/siemens_coefficient = 1 		//Referenced later by others.

/mob/living/simple_mob/vore/alienanimals/catslug/custom/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	verbs -= /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color	//Most of these have custom sprites with colour already, so we'll not let them have this.


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
	holder_type = /obj/item/weapon/holder/catslug/custom/spaceslug
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

	player_msg = "You are an intelligent creature capable of more than most think, clad in a spacesuit that protects you from the ravages of vacuum and hostile atmospheres alike. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds! <br>- - - - -<br> <span class='notice'>Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.</span>"

/datum/say_list/catslug/custom/spaceslug
	speak = list("Have any porl?", "What is that?", "What kind of ship is that?", "What are you doing?", "How did you get here?", "Don't take off your helmet.", "SPAAAAAACE!", "WAOW!", "Nice weather we're having, isn't it?")

/mob/living/simple_mob/vore/alienanimals/catslug/custom/spaceslug/attack_hand(mob/living/carbon/human/M as mob)

	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message("<span class='notice'>\The [M.name] shakes \the [src] awake from their nap.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			"<span class='notice'>[M] pats \the [src] on their helmet.</span>", \
			"<span class='notice'>You pat \the [src] on their helmet.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src] purrs and leans into [M]'s hand.</span>")
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			"<span class='notice'>[M] shakes \the [src]'s hand.</span>", \
			"<span class='notice'>You shake \the [src]'s hand.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s looks a little confused and bonks their helmet's faceplate against [M]'s hand experimentally, attempting to nibble at it.</span>")
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			"<span class='notice'>[M] attempts to boop \the [src]'s nose, defeated only by the helmet they wear.</span>", \
			"<span class='notice'>You attempt to boop \the [src] on the nose, stopped only by that helmet they wear.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s eyes widen as they stare at [M]. After a moment they rub at the faint mark [M]'s digit left upon the surface of their helmet's faceplate.</span>")
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			"<span class='notice'>[M] rubs \the [src]'s tummy...</span>", \
			"<span class='notice'>You rub \the [src]'s tummy, accidently pressing a few of the buttons on their chestpiece in the process... You feel the danger.</span>", )
		if(client)
			return
		visible_message("<span class='notice'>\The [src] pushes [M]'s hand away from their tummy and furrows their brow, frantically pressing at the buttons [M] so carelessly pushed!</span>")
		if(prob(5))
			ai_holder.target = M
			ai_holder.track_target_position()
			ai_holder.set_stance(STANCE_FIGHT)
	else
		return ..()

/obj/item/weapon/holder/catslug/custom/spaceslug
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
	holder_type = /obj/item/weapon/holder/catslug/custom/engislug
	say_list_type = /datum/say_list/catslug/custom/engislug
	mobcard_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_construction, access_atmospherics)
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
		M.visible_message("<span class='notice'>\The [M.name] shakes \the [src] awake from their nap.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			"<span class='notice'>[M] pats \the [src] on their helmet.</span>", \
			"<span class='notice'>You pat \the [src] on their helmet.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src] purrs and leans into [M]'s hand.</span>")
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			"<span class='notice'>[M] shakes \the [src]'s hand.</span>", \
			"<span class='notice'>You shake \the [src]'s hand.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s looks a little confused and bonks their helmet's faceplate against [M]'s hand experimentally, attempting to nibble at it.</span>")
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			"<span class='notice'>[M] attempts to boop \the [src]'s nose, defeated only by the helmet they wear.</span>", \
			"<span class='notice'>You attempt to boop \the [src] on the nose, stopped only by that helmet they wear.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s eyes widen as they stare at [M]. After a moment they rub at the faint mark [M]'s digit left upon the surface of their helmet's faceplate.</span>")
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			"<span class='notice'>[M] rubs \the [src]'s tummy...</span>", \
			"<span class='notice'>You rub \the [src]'s tummy... You feel the danger.</span>", )
		if(client)
			return
		visible_message("<span class='notice'>\The [src] pushes [M]'s hand away from their tummy and furrows their brow!</span>")
		if(prob(5))
			ai_holder.target = M
			ai_holder.track_target_position()
			ai_holder.set_stance(STANCE_FIGHT)
	else
		return ..()

/obj/item/weapon/holder/catslug/custom/engislug
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
	holder_type = /obj/item/weapon/holder/catslug/custom/gatslug
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
	mobcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_maint_tunnels)

/datum/say_list/catslug/custom/gatslug
	speak = list("Have any flashbangs?", "Valids!", "Heard spiders?", "What is that?", "Freeze!", "What are you doing?", "How did you get here?", "Red alert means big bangsticks.", "No being naughty now.", "WAOW!", "Who ate all the donuts?")

/obj/item/weapon/holder/catslug/custom/gatslug
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
	holder_type = /obj/item/weapon/holder/catslug/custom/medislug
	say_list_type = /datum/say_list/catslug/custom/medislug
	mobcard_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

/datum/say_list/catslug/custom/medislug
	speak = list("Have any osteodaxon?", "What is that?", "Suit sensors!", "What are you doing?", "How did you get here?", "Put a mask on!", "No smoking!", "WAOW!", "Stop getting blood everywhere!", "WHERE IN MAINT?")

/obj/item/weapon/holder/catslug/custom/medislug
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
	holder_type = /obj/item/weapon/holder/catslug/custom/scienceslug
	say_list_type = /datum/say_list/catslug/custom/scienceslug
	mobcard_access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)


/datum/say_list/catslug/custom/scienceslug
	speak = list("Slimes, squish!", "What is that?", "Smoking in Toxins is not advised.", "What are you doing?", "How did you get here?", "Do not deconstruct the cube!", "WAOW!", "Where are our materials?", "The acid dispenser is not full of juice. Must remember that.")

/obj/item/weapon/holder/catslug/custom/scienceslug
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
	holder_type = /obj/item/weapon/holder/catslug/custom/cargoslug
	say_list_type = /datum/say_list/catslug/custom/cargoslug
	mobcard_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)

/datum/say_list/catslug/custom/cargoslug
	speak = list("Disposals is not for slip and slide.", "What is that?", "Stamp those manifests!", "What are you doing?", "How did you get here?", "Can order pizza crate?", "WAOW!", "Where are all of our materials?", "Got glubbs?")

/obj/item/weapon/holder/catslug/custom/cargoslug
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
	faction = "neutral"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/capslug)
	holder_type = /obj/item/weapon/holder/catslug/custom/capslug
	say_list_type = /datum/say_list/catslug/custom/capslug
	mobcard_access = list(access_maint_tunnels)		//The all_station_access part below adds onto this.

/datum/say_list/catslug/custom/capslug
	speak = list("How open big glass box with shiny inside?.", "What is that?", "Respect my authority!", "What are you doing?", "How did you get here?", "Fax for yellow-shirts!", "WAOW!", "Why is that console blinking and clicking?", "Do we need to call for ERT?", "Have been called comdom before, not sure why they thought I was a balloon.")

/obj/item/weapon/holder/catslug/custom/capslug
	item_state = "capslug"

/mob/living/simple_mob/vore/alienanimals/catslug/custom/capslug/Initialize() 		//This is such an awful proc, but if someone wants it better they're welcome to have a go at it.
	. = ..()
	mob_radio = new /obj/item/device/radio/headset/mob_headset(src)
	mob_radio.frequency = PUB_FREQ
	mob_radio.ks2type = /obj/item/device/encryptionkey/heads/captain 		//Might not be able to speak, but the catslug can listen.
	mob_radio.keyslot2 = new /obj/item/device/encryptionkey/heads/captain(mob_radio)
	mob_radio.recalculateChannels(1)
	mobcard.access |= get_all_station_access()

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
	mobcard_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
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
	mob_radio = new /obj/item/device/radio/headset/mob_headset(src)
	mob_radio.frequency = DTH_FREQ 			//Can't tell if bugged, deathsquad freq in general seems broken
	mobcard.access |= get_all_station_access()

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
	mobcard_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	faction = "syndicate"
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
	mob_radio = new /obj/item/device/radio/headset/mob_headset(src)
	mob_radio.frequency = SYND_FREQ
	mob_radio.syndie = 1
	mob_radio.ks2type = /obj/item/device/encryptionkey/syndicate
	mob_radio.keyslot2 = new /obj/item/device/encryptionkey/syndicate(mob_radio)
	mob_radio.recalculateChannels(1)
	mobcard.access |= get_all_station_access()

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
	mobcard_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
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
	mob_radio = new /obj/item/device/radio/headset/mob_headset(src)
	mob_radio.frequency = ERT_FREQ
	mob_radio.centComm = 1
	mob_radio.ks2type = /obj/item/device/encryptionkey/ert
	mob_radio.keyslot2 = new /obj/item/device/encryptionkey/ert(mob_radio)
	mob_radio.recalculateChannels(1)
	mobcard.access |= get_all_station_access()

//Pilot Catslug

/mob/living/simple_mob/vore/alienanimals/catslug/custom/pilotslug
	name = "Navigator Purrverick"
	desc = "A black-furred noodley bodied creature with thin arms and legs, and gloomy dark eyes. This one exudes an aura of coolness, they're so cool that their pilot's liscense was suspended."
	tt_desc = "Mollusca Felis Mischefterous"
	color = "#2b2b2b"
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/custom/pilotslug)
	say_list_type = /datum/say_list/catslug/custom/pilotslug

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

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/impostor
	is_impostor = TRUE

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/Initialize()
	. = ..()
	verbs += /mob/living/simple_mob/vore/alienanimals/catslug/suslug/proc/assussinate
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
		to_chat(src, "<span class='notice'>You are not an impostor! You can't vent!</span>")
		return FALSE
	.=..()

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/examine(mob/user)
	. = ..()

	if(istype(user, /mob/living/simple_mob/vore/alienanimals/catslug/suslug))
		var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/us = user
		if(us.is_impostor)
			if(src.is_impostor)
				. += "<span class='notice'>They appear to be a fellow impostor!</span>"
			else
				. += "<span class='notice'>They appear to be a filthy innocent!</span>"

/mob/living/simple_mob/vore/alienanimals/catslug/suslug/proc/assussinate()
	set name = "Kill Innocent"
	set category = "Abilities"
	set desc = "Kill an innocent suslug!"
	if(!is_impostor)
		to_chat(src, "<span class='notice'>You are not an impostor! You can't kill like that!</span>")
		return
	if((world.time - kill_cooldown) < 1 MINUTE)
		to_chat(src, "<span class='notice'>You cannot kill so soon after previous kill!</span>")
		return

	var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/target
	var/list/victims = list()
	for(var/mob/living/simple_mob/vore/alienanimals/catslug/suslug/S in range(1))
		if(!S.is_impostor)
			victims += S
	if(!victims || !victims.len)
		to_chat(src, "<span class='warning'>There are no innocent suslugs nearby!</span>")
		return
	if(victims.len == 1)
		target = victims[1]
	else
		target = tgui_input_list(usr, "Kill", "Pick a victim", victims)

	if(target && istype(target))
		target.adjustBruteLoss(3000)
		visible_message("<span class='warning'>\The [src] kills \the [target]!</span>")
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
