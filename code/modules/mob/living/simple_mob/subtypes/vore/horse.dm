/mob/living/simple_mob/vore/horse
	name = "horse"
	desc = "Don't look it in the mouth."
	tt_desc = "Equus ferus caballus"

	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse-dead"
	icon = 'icons/mob/vore.dmi'

	faction = "horse"
	maxHealth = 60
	health = 60

	movement_cooldown = 4 //horses are fast mkay.
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("kicked")

	meat_amount = 4
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_x = 0

	say_list_type = /datum/say_list/horse
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

// Activate Noms!
/mob/living/simple_mob/vore/horse
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/horse/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 0

/mob/living/simple_mob/vore/horse/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/horse/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "With a final few gulps, the horse finishes swallowing you down into its hot, dark gut... and with a slosh, your weight makes the equine's belly hang down slightly like some sort of organic hammock. The thick, humid air is tinged with the smell of half-digested grass, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder."

	B.emote_lists[DM_HOLD] = list(
		"The horse's idle trotting helps its stomach gently churn around you, slimily squelching against your figure.",
		"The equine predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the horse's hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the horse trots about, as if it is showing off its newest catch.")

	B.emote_lists[DM_DIGEST] = list(
		"The horse huffs in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast trots about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
		"You can barely hear the horse let out a pleased nicker as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The horse happily trots around while digesting its meal, almost like it is trying to show off the hanging gut you've given it.")

/datum/say_list/horse
	speak = list("NEHEHEHEHEH","Neh?")
	emote_hear = list("snorts","whinnies")
	emote_see = list("shakes its head", "stamps a hoof", "looks around")
