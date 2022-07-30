/datum/category_item/catalogue/fauna/giant_snake
	name = "Creature - Giant Snake"
	desc = "Classification: Serpentes gigantus\
	<br><br>\
	Snakes are elongated, limbless, carnivorous reptiles of the suborder Serpentes \
	Like all other squamates, snakes are ectothermic, amniote vertebrates covered in overlapping scales. \
	Many species of snakes have skulls with several more joints than their lizard ancestors, \
	enabling them to swallow prey much larger than their heads with their highly mobile jaws. \
	This particular species of snake has likely been mutated by deliberate gene manipulation of some sort and as a \
	result has grown to unnatural size. Biologically this snake is no different than that of the common snake, \
	but this species has been known to have increased hostility towards wildlife. Scientists are still studying \
	this new species for any differences in behavior or biology beyond the increase in size. \
	<br>\
	This species of snake is nonvenomous and use their large bodies to primarily subdue their prey. \
	Nonvenomous snakes either swallow prey alive or kill them by constriction - this is dependant on the prey. \
	<br>\
	This snake is extremely hostile to all wildlife and living beings and should be avoided at all costs. \
	People who spot these creatures are urged to inform the nearest militant entity so that they can be \
	dealt with in a professional manner."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/aggressive/giant_snake
	name = "giant snake"
	desc = "Snakes. Why did it have to be snakes?"
	tt_desc = "Serpentes gigantus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_snake)

	icon_dead = "snake-dead"
	icon_living = "snake"
	icon_state = "snake"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64

	faction = "snake"
	maxHealth = 200
	health = 200

	melee_damage_lower = 5
	melee_damage_upper = 12

	meat_amount = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"

	old_x = -16
	old_y = -16
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16

	ai_holder_type = /datum/ai_holder/simple_mob/melee

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/giant_snake
	vore_active = 1
	vore_pounce_chance = 25
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.

/mob/living/simple_mob/vore/aggressive/giant_snake/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "As the giant snake's closed jaws seal you away from the outside world, you are immediately greeted with a seemingly endless passage of tightly squeezing flesh. Hot and coated in thick, body-clinging slime, the serpent's stomach walls immediately get to work at rhythmically pulsing and contracting against your figure, slowly tugging you deeper into its ravenous clutches."

	B.emote_lists[DM_HOLD] = list(
		"A near-constant string of soft, slick noises drift over you as waves of peristalsis slowly drag you further within the possessive serpent.",
		"The giant snake's stomach suddenly squishes inwards from everywhere at once, wrapping you up in a warm, doughy embrace before easing back again.",
		"A growing sense of relaxed lethargy seeps into your muscles the longer you're massaged over amidst those hot, humid confines.",
		"Slimy, heat-trapping muscles rhythmically ripple over and knead down into your figure, ensuring the snake's new filling was subdued.",
		"The snake occasionally hisses out in satisfaction as it feels your twitching, filling weight bulge out its scales before giving you a compressing squeeze.",
		"Hot, viscous ooze clings to and coats your body as time passes, encouraging you to submit and let the snake do all the serpentine, winding slithering.")

	B.emote_lists[DM_DIGEST] = list(
		"A chorus of sordid, slick sounds fill your senses as another wave of peristalsis ripples over you, tugging you a little deeper into the snake!",
		"The serpent's all-encompassing stomach flesh closes in tight around your figure, testing how much softer you are now before finally relaxing. Slightly!",
		"You find it harder to breathe as time goes on, your dizziness growing as you lack the space to breathe in enough of that acrid, thinning air!",
		"The snake's ample, kneading muscle gradually squeezes the strength and fight from your body with clench after clench!",
		"A pleased hiss rattles out of the giant snake from somewhere behind you, the serpent clearly satisfied with its newest meal!",
		"Your movements grow slower and less effective as the snake's stomach ooze clings to your entire body, working away at it!")
