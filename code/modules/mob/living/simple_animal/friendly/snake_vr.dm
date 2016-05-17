/mob/living/simple_animal/snake
	name = "Snake"
	desc = "A big thick snake."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	speak_emote = list("hisses")
	health = 20
	maxHealth = 20
	attacktext = "bites"
	melee_damage_lower = 3
	melee_damage_upper = 5
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "kicks"
	turns_per_move = 8 // SLOW-ASS MUTHAFUCKA

//NOODLE IS HERE! SQUEEEEEEEE~
/mob/living/simple_animal/snake/Noodle
	name = "Noodle"
	desc = "This snake is particularly chubby and demands nothing but the finest of treats."
	isPredator = 1

//Special snek-snax for Noodle!
obj/item/weapon/reagent_containers/food/snacks/snakesnack
	name = "Sugar mouse"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these!"
	var/snack_colour
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snack_yellow"

obj/item/weapon/reagent_containers/food/snacks/snakesnack/New()
	..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."

obj/item/weapon/storage/box/fluff/snakesnackbox
	name = "Box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7
	New()
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		..()
		return