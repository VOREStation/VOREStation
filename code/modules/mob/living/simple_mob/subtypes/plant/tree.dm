/mob/living/simple_mob/animal/space/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	tt_desc = "X Festivus tyrannus"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"

	mob_class = MOB_CLASS_PLANT

	faction = "plants"
	maxHealth = 250
	health = 250
	poison_resist = 1.0

	response_help = "brushes"
	response_disarm = "pushes"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = list("bitten")
	attack_sound = 'sound/weapons/bite.ogg'

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat

	pixel_x = -16

/mob/living/simple_mob/animal/space/tree/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(15))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

/mob/living/simple_mob/animal/space/tree/death()
	..(null,"is hacked into pieces!")
	playsound(loc, 'sound/effects/woodcutting.ogg', 100, 1)
	new /obj/item/stack/material/wood(loc)
	qdel(src)