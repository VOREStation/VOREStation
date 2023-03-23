/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = ITEMSIZE_TINY
	var/sides = 6
	var/result = 6
	var/loaded = null //Set to an integer when the die is loaded
	var/cheater = FALSE //TRUE if the die is able to be weighted by hand
	var/tamper_proof = FALSE //Set to TRUE if the die needs to be unable to be weighted, such as for events
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/attackby(obj/item/weapon/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/weldingtool) || istype(W, /obj/item/weapon/flame/lighter))
		if(cheater)
			to_chat(user, "<span class='warning'>Wait, this [name] is already weighted!</span>")
		else if(tamper_proof)
			to_chat(user, "<span class='warning'>This [name] is proofed against tampering!</span>")
		else
			var/to_weight = input("What should the [name] be weighted towards? You can't undo this later, only change the number!","Set the desired result") as null|num
			if(isnull(to_weight) || (to_weight < 1) || (to_weight > sides)) //You must input a number higher than 0 and no greater than the number of sides
				return 0
			else
				to_chat(user, "You partially melt the [name], weighting it towards [to_weight]...")
				desc = "[initial(desc)] It looks a little misshapen, somehow..."
				loaded = to_weight

/obj/item/weapon/dice/AltClick(mob/user)
	..()
	if(cheater)
		if(!loaded)
			var/to_weight = input("What should the [name] be weighted towards?","Set the desired result") as null|num
			if(isnull(to_weight) || (to_weight < 1) || (to_weight > sides) ) //You must input a number higher than 0 and no greater than the number of sides
				return 0
			else
				to_chat(user, "You sneakily set the [name] to land on [to_weight]...")
				loaded = to_weight
		else
			to_chat(user, "You set the [name] to roll randomly again.")
			loaded = null

/obj/item/weapon/dice/loaded
	description_info = "This is a loaded die! To change the number it's weighted to, alt-click it. To put it back to normal, alt-click it again."
	cheater = TRUE

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
	if(loaded)
		if(cheater)
			if(prob(90))
				result = loaded
		else if(prob(75)) //makeshift weighted dice don't always work
			result = loaded
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
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

/obj/item/weapon/storage/pill_bottle/dice/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/dice( src )

/obj/item/weapon/storage/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

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
