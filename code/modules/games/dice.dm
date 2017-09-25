/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = ITEMSIZE_TINY
	var/sides = 6
	var/result = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/d4
	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4
	result = 4

/obj/item/weapon/dice/d8
	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8
	result = 8

/obj/item/weapon/dice/d10
	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10
	result = 10

/obj/item/weapon/dice/d12
	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12
	result = 12

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20
	result = 20

/obj/item/weapon/dice/d100
	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10
	result = 10

/obj/item/weapon/dice/attack_self(mob/user as mob)
	rollDice(user, 0)

/obj/item/weapon/dice/proc/rollDice(mob/user as mob, var/silent = 0)
	result = rand(1, sides)
	icon_state = "[name][result]"

	if(!silent)
		var/comment = ""
		if(sides == 20 && result == 20)
			comment = "Nat 20!"
		else if(sides == 20 && result == 1)
			comment = "Ouch, bad luck."

		user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [result]. [comment]</span>", \
							 "<span class='notice'>You throw [src]. It lands on a [result]. [comment]</span>", \
							 "<span class='notice'>You hear [src] landing on a [result]. [comment]</span>")

/*
 * Dice packs
 */

/obj/item/weapon/storage/pill_bottle/dice	//7d6
	name = "bag of dice"
	desc = "It's a small bag with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

/obj/item/weapon/storage/pill_bottle/dice/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/dice( src )

/obj/item/weapon/storage/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"

/obj/item/weapon/storage/pill_bottle/dice_nerd/New()
	..()
	new /obj/item/weapon/dice/d4( src )
	new /obj/item/weapon/dice( src )
	new /obj/item/weapon/dice/d8( src )
	new /obj/item/weapon/dice/d10( src )
	new /obj/item/weapon/dice/d12( src )
	new /obj/item/weapon/dice/d20( src )
	new /obj/item/weapon/dice/d100( src )

/*
 *Liar's Dice cup
 */

/obj/item/weapon/storage/dicecup
	name = "dice cup"
	desc = "A cup used to conceal and hold dice."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicecup"
	w_class = ITEMSIZE_SMALL
	storage_slots = 5
	can_hold = list(
		/obj/item/weapon/dice,
		)

/obj/item/weapon/storage/dicecup/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] shakes [src].</span>", \
							 "<span class='notice'>You shake [src].</span>", \
							 "<span class='notice'>You hear dice rolling.</span>")
	rollCup(user)

/obj/item/weapon/storage/dicecup/proc/rollCup(mob/user as mob)
	for(var/obj/item/weapon/dice/I in src.contents)
		var/obj/item/weapon/dice/D = I
		D.rollDice(user, 1)

/obj/item/weapon/storage/dicecup/proc/revealDice(var/mob/viewer)
	for(var/obj/item/weapon/dice/I in src.contents)
		var/obj/item/weapon/dice/D = I
		to_chat(viewer, "The [D.name] shows a [D.result].")

/obj/item/weapon/storage/dicecup/verb/peekAtDice()
	set category = "Object"
	set name = "Peek at Dice"
	set desc = "Peek at the dice under your cup."

	revealDice(usr)

/obj/item/weapon/storage/dicecup/verb/revealDiceHand()

	set category = "Object"
	set name = "Reveal Dice"
	set desc = "Reveal the dice hidden under your cup."

	for(var/mob/living/player in viewers(3))
		to_chat(player, "[usr] reveals their dice.")
		revealDice(player)


/obj/item/weapon/storage/dicecup/loaded/New()
	..()
	for(var/i = 1 to 5)
		new /obj/item/weapon/dice( src )