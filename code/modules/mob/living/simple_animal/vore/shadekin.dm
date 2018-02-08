/mob/living/simple_animal/shadekin //Spawn this one only if you're looking for a bad time. Not friendly.
	name = "shadekin"
	desc = "Some sort of fluffer. Big ears, long tail! "
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "dark"
	icon_living = "dark"
	icon_dead = "dead"
	faction = "shadekin"
	maxHealth = 200
	health = 200

	move_to_delay = 3

	investigates = TRUE
	reacts = TRUE
	run_at_them = FALSE
	speak_chance = 2
	cooperative = FALSE

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

	speak = list("Mar.", "Mar?", "Mar!")
	emote_hear = list("chrrrrrs","wurbles", "wrrrrbles")
	emote_see = list("tailtwitches","earflicks")
	say_maybe_target = list("...mar?")
	say_got_target = list("MAR!!!")
	melee_damage_lower = 10
	melee_damage_upper = 20
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = "mauled"
	friendly = list("boops", "pawbs")
	reactions = list("Mar?" = "Marrr.", "Mar!" = "Mar???", "Mar." = "Marrr.")

	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0
	var/eye_state = "e_red"
	var/eye_desc

	vore_active = TRUE
	vore_pounce_chance = 25
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS
	vore_escape_chance = 25

	//None, they stay as their defaults.
	vore_digest_chance = 0
	vore_absorb_chance = 0

/mob/living/simple_animal/shadekin/initialize()
	. = ..()
	icon_living = icon_state
	if(eye_state)
		overlays += image(icon,null,eye_state)
	if(eye_desc)
		desc += "This one has [eye_desc]!"

/mob/living/simple_animal/shadekin/death(gibbed, deathmessage = "phases out!")
	spawn(20)
		qdel(src) //Back from whence you came!

	. = ..(FALSE, deathmessage)

/mob/living/simple_animal/shadekin/Found(var/atom/A)
	if(specific_targets && isliving(A)) //Healing!
		var/mob/living/L = A
		var/health_percent = (L.health/L.maxHealth)*100
		if(health_percent <= 50)
			return A
	. = ..()

/mob/living/simple_animal/shadekin/Life()
	if((. = ..()))
		//Drawing energy from bluespace?
		if(nutrition != initial(nutrition))
			nutrition += nutrition > initial(nutrition) ? -1 : 1

/////////////////////////////////////////////////////////////////
/mob/living/simple_animal/shadekin/red
	eye_state = "e_red"
	hostile = TRUE
	retaliate = TRUE
	stop_when_pulled = FALSE
	destroy_surroundings = TRUE

	eye_desc = "red eyes"
	vore_stomach_flavor = "You slip passed pointy triangle teeth and down the slick, \
	slippery gullet of the creature. It's warm, and the air is thick. You can hear \
	its body squelch and shift around you as you settle into its stomach! Thick digestive \
	enzymes cling to you within that dark space, tingling and stinging immediately! The weight of \
	the doughy walls press in around you instantly, churning you up as you begin to digest!"

/mob/living/simple_animal/shadekin/red/white
	icon_state = "white"
/mob/living/simple_animal/shadekin/red/dark
	icon_state = "dark"
/mob/living/simple_animal/shadekin/red/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_animal/shadekin/blue
	eye_state = "e_blue"
	health = 100
	maxHealth = 100
	hostile = TRUE //Not actually, they eat injured people to heal them. See found()
	retaliate = FALSE
	stop_when_pulled = TRUE
	specific_targets = TRUE //For finding injured people
	destroy_surroundings = FALSE
	vore_default_mode = DM_HEAL
	vore_escape_chance = 75
	vore_bump_chance = 20
	vore_standing_too = 1
	vore_pounce_chance = 80
	swallowTime = 4 SECONDS //A little longer to compensate for the above
	vore_ignores_undigestable = FALSE
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "shoved"

	eye_desc = "blue eyes"
	vore_stomach_flavor = "You slip passed pointy triangle teeth and down the slick, \
	slippery gullet of the creature. It's warm, and the air is thick. You can hear its body \
	squelch and shift around you as you settle into its stomach! It's oddly calm, and very dark. \
	The doughy flesh rolls across your form in gentle waves. The aches and pains across your form slowly begin to \
	diminish, your body is healing much faster than normal! You’re also soon soaked in harmless slime."

/mob/living/simple_animal/shadekin/blue/white
	icon_state = "white"
/mob/living/simple_animal/shadekin/blue/dark
	icon_state = "dark"
/mob/living/simple_animal/shadekin/blue/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_animal/shadekin/purple
	eye_state = "e_purple"
	health = 150
	maxHealth = 150
	hostile = FALSE
	retaliate = TRUE
	stop_when_pulled = FALSE
	destroy_surroundings = TRUE
	vore_default_mode = DM_HOLD
	vore_digest_chance = 25
	vore_absorb_chance = 25

	eye_desc = "purple eyes"
	vore_stomach_flavor = "You slip passed pointy triangle teeth and down the slick, slippery gullet of the creature. \
	It's warm, and the air is thick. You can hear its body squelch and shift around you as you settle into its stomach! \
	It’s relatively calm inside the dark organ. Wet and almost molten for how gooey your surroundings feel. \
	You can feel the doughy walls cling to you posessively... It’s almost like you could sink into them. \
	There is also an ominous gurgling from somewhere nearby..."

/mob/living/simple_animal/shadekin/purple/white
	icon_state = "white"
/mob/living/simple_animal/shadekin/purple/dark
	icon_state = "dark"
/mob/living/simple_animal/shadekin/purple/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_animal/shadekin/yellow
	eye_state = "e_yellow"
	health = 150
	maxHealth = 150
	hostile = FALSE
	retaliate = TRUE
	stop_when_pulled = FALSE
	destroy_surroundings = TRUE
	vore_default_mode = DM_DRAIN
	vore_digest_chance = 5
	vore_ignores_undigestable = FALSE

	eye_desc = "yellow eyes"
	vore_stomach_flavor = "You slip passed pointy triangle teeth and down the slick, slippery gullet \
	of the creature. It's warm, and the air is thick. You can hear its body squelch and shift around you \
	as you settle into its stomach! The doughy walls within cling to you heavily, churning down on you, wearing \
	you out!! There doesn’t appear to be any actual danger here, harmless slime clings to you, but it’s getting \
	harder and harder to move as those walls press in on you insistently!"

/mob/living/simple_animal/shadekin/yellow/white
	icon_state = "white"
/mob/living/simple_animal/shadekin/yellow/dark
	icon_state = "dark"
/mob/living/simple_animal/shadekin/yellow/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
//Fluffy specific fluffer
/mob/living/simple_animal/shadekin/blue/rivyr
	name = "Rivyr"
	desc = "She appears to be a fluffer of some sort. Deep blue eyes and curious attitude."
	icon_state = "rivyr"
	vore_stomach_flavor = "Blue flesh gleams in the fading light as you slip down the little mar’s gullet! \
	Gooey flesh and heat surrounds your form as you’re tucked away into the darkness of her stomach! Thick slimes cling \
	to you, but they seem to be harmless. The organ gently churns around you, clinging to your shape and forcing \
	you to curl up a bit. You can feel her rub at you some through the layers of flesh and fluff, while aches \
	and pains begin to fade away  across your body."
