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
	var/body_icon

/mob/living/simple_animal/hostile/vore/retaliate/catgirl/New()
	..()
	if(!body_icon)
		body_icon = pick(list("default","brown","black","red","brownbikini","brownnude","blackbikini","blacknude","redbikini","rednude","bikini","nude"))
	if(body_icon != "default"
		icon_state = "catgirl[body_icon]"
		icon_living = "catgirl[body_icon]"
		icon_dead = "catgirl[body_icon]-dead"