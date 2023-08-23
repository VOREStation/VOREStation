/datum/category_item/catalogue/fauna/dustjumper
	name = "Alien Wildlife - Dust Jumper"
	desc = "A small, quick creature, the dust jumper is a rare space creature.\
			They have striking similarities to the common mouse, but these creatures are actually most commonly found in space.\
			They are known to make their homes in asteroids, and leap from one to another when food is scarce.\
			Dust jumpers are omnivorous, eating what scraps of organic material they can get their little paws on.\
			They hybernate during long floats through space."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/dustjumper
	name = "dust jumper"
	desc = "A small, unassuming mammal. It looks quite soft and fluffy, and has bright blue eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dustjumper)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "space_mouse"
	icon_living = "space_mouse"
	icon_dead = "space_mouse_dead"

	faction = "space mouse"
	maxHealth = 20
	health = 20
	movement_cooldown = -1

	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "pushes"
	response_harm   = "punches"

	melee_damage_lower = 1
	melee_damage_upper = 2
	attack_sharp = FALSE
	attacktext = list("nipped", "squeaked at", "hopped on", "kicked")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/dustjumper

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900

	speak_emote = list("squeaks")

	say_list_type = /datum/say_list/mouse

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 0
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/mob/living/simple_mob/vore/alienanimals/dustjumper/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You've been packed into the impossibly tight stomach of the dust jumper!!! The broiling heat seeps into you while the walls churn in powerfully, forcing you to curl up in the darkness."
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.digest_brute = 0.5
	B.digest_burn = 0.5
	B.digestchance = 10
	B.absorbchance = 0
	B.escapechance = 25

/mob/living/simple_mob/vore/alienanimals/dustjumper/Life()
	. = ..()
	if(!.)
		return
	if(vore_fullness == 0 && movement_cooldown == 10)
		movement_cooldown = initial(movement_cooldown)

/mob/living/simple_mob/vore/alienanimals/dustjumper/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay)
	. = ..()
	movement_cooldown = 10

/datum/ai_holder/simple_mob/melee/evasive/dustjumper
	hostile = FALSE
	retaliate = TRUE
	destructive = FALSE
	violent_breakthrough = FALSE
	can_flee = TRUE
	flee_when_dying = TRUE
