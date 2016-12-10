/mob/living/simple_animal/hostile/vore/retaliate/catgirl
	name = "catgirl"
	desc = "Her hobbies are catnaps, knocking things over, and headpats."
	icon_dead = "catgirl-dead"
	icon_living = "catgirl"
	icon_state = "catgirl"
	speed = 5
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10
	picky = 0 // Catgirls just want to eat yoouuu
	speak = list("Meow!","Esp!","Purr!","HSSSSS","Mew?","Nya~")
	speak_emote = list("purrs","meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes her head","shivers")
	eat_chance = 100
	attacktext = "swatted"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/nude
	icon_dead = "catgirlnude-dead"
	icon_living = "catgirlnude"
	icon_state = "catgirlnude"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/bikini
	icon_dead = "catgirlbikini-dead"
	icon_living = "catgirlbikini"
	icon_state = "catgirlbikini"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/rednude
	icon_dead = "catgirlrednude-dead"
	icon_living = "catgirlrednude"
	icon_state = "catgirlrednude"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/redbikini
	icon_dead = "catgirlredbikini-dead"
	icon_living = "catgirlredbikini"
	icon_state = "catgirlredbikini"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/blacknude
	icon_dead = "catgirlblacknude-dead"
	icon_living = "catgirlblacknude"
	icon_state = "catgirlblacknude"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/blackbikini
	icon_dead = "catgirlblackbikini-dead"
	icon_living = "catgirlblackbikini"
	icon_state = "catgirlblackbikini"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brownnude
	icon_dead = "catgirl-deadbrownnude"
	icon_living = "catgirlbrownnude"
	icon_state = "catgirlbrownnude"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brownbikini
	icon_dead = "catgirlbrownbikini-dead"
	icon_living = "catgirlbrownbikini"
	icon_state = "catgirlbrownbikini"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/red
	icon_dead = "catgirlred-dead"
	icon_living = "catgirlred"
	icon_state = "catgirlred"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/black
	icon_dead = "catgirlblack-dead"
	icon_living = "catgirlblack"
	icon_state = "catgirlblack"

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brown
	icon_dead = "catgirlbrown-dead"
	icon_living = "catgirlbrown"
	icon_state = "catgirlbrown"

/obj/random/catgirl
	name = "random catgirl"
	desc = "This is a random catgirl"
	icon_state = "catgirl"
	icon = 'icons/mob/vore.dmi'
	item_to_spawn()
		return pick(/mob/living/simple_animal/hostile/vore/retaliate/catgirl/nude,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/bikini,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/rednude,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/redbikini,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/blacknude,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/blackbikini,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brownnude,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brownbikini,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/red,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/black,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl/brown,
					/mob/living/simple_animal/hostile/vore/retaliate/catgirl)