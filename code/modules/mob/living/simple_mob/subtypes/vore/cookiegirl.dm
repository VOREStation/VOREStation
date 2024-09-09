/mob/living/simple_mob/vore/cookiegirl
	name = "cookiegirl"
	desc = "A woman made with a combination of, well... Whatever you put in a cookie. What were the chefs thinking?"

	icon_state = "cookiegirl"
	icon_living = "cookiegirl"
	icon_rest = "cookiegirl_rest"
	icon_dead = "cookiegirl-dead"
	icon = 'icons/mob/vore.dmi'

	maxHealth = 10
	health = 10

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 5

	meat_amount = 10
	meat_type = /obj/item/reagent_containers/food/snacks/cookie

	say_list_type = /datum/say_list/cookiegirl
	ai_holder_type = /datum/ai_holder/simple_mob/passive/cookiegirl

	faction = "cookiegirl"

	// Activate Noms!
/mob/living/simple_mob/vore/cookiegirl
	vore_active = 1
	vore_bump_chance = 2
	vore_pounce_chance = 25
	vore_standing_too = 1
	vore_ignores_undigestable = 0 // Do they look like they care?
	vore_default_mode = DM_HOLD // They're cookiepeople, what do you expect?
	vore_digest_chance = 10 // Gonna become as sweet as sugar, soon.
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/ai_holder/simple_mob/passive/cookiegirl/on_hear_say(mob/living/speaker, message)

	if(!speaker.client)
		return

	if(findtext(message, "Can I eat you?"))
		delayed_say(pick("Do you really wanna eat someone as sweet as me~?"), speaker)

	if(findtext(message, "You look tasty."))
		delayed_say(pick("Awww, thank you~!"), speaker)

	if(findtext(message, "Can I serve you to the crew?"))
		delayed_say(pick("If I have a backup, sure!"), speaker)

/datum/say_list/cookiegirl
	speak = list("Hi!","Are you hungry?","Got milk~?","What to do, what to do...")
	emote_hear = list("hums","whistles")
	emote_see = list("shakes her head","shivers", "picks a bit of crumb off of her body and sticks it in her mouth.")

/datum/ai_holder/simple_mob/passive/cookiegirl
	base_wander_delay = 8
	intelligence_level = AI_NORMAL //not sure why we have this, but I'm just porting.