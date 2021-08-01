/mob/living/simple_mob/vore/sheep
	name = "sheep"
	desc = "looks warm and wooly!."
	tt_desc = "Ovis aries"

	icon_state = "sheep"
	icon_living = "sheep"
	icon_dead = "sheep-dead"
	icon = 'icons/mob/vore.dmi'

	faction = "sheep"
	maxHealth = 40
	health = 40

	see_in_dark = 2

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("kicked")

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_x = 0

	say_list_type = /datum/say_list/sheep
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate


// Activate Noms!
/mob/living/simple_mob/vore/sheep
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/sheep/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 1.5

/mob/living/simple_mob/vore/sheep/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/sheep/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "With a final few gulps, the sheep finishes swallowing you down into its hot, dark guts… The wool on the outside is doing you no favors with its insulation. The toasty organic flesh kneads and grinds around you with the stank of wet grass. The sheep seems to have already forgotten about you as it lets out a soft BAAH like belch and carries on doing nothing. "
	B.emote_lists[DM_HOLD] = list(
	"The sheep's idle trotting helps its stomach gently churn around you, slimily squelching against your figure.",
	"The equine predator lazily pauses for a moment and flops down encapsulating you in a strange fleshy hug; Before quickly jumping back up in confusion before trotting off.",
	"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
	"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
	"The thick, toasty atmosphere within the sheep's compact belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
	"Your surroundings sway from side to side as the sheep trots about.")
	B.emote_lists[DM_DIGEST] = list(
	"The sheep brays in annoyance clenching those compressed walls even tighter against your form!",
	"As the beast trots about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
	"You’re overcome by the smell of wet grass as hot slime oozes over your head!",
	"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
	"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
	"The sheep trots around while digesting its meal, almost as if its forgotten it even had one.")

/datum/say_list/sheep
	speak = list("EHEHEHEHEH","eh?","BAAAAAAAHHHH")
	emote_hear = list("brays","smacks its lips loudly.")
	emote_see = list("shakes its head", "stamps a foot", "looks around vacantly.")