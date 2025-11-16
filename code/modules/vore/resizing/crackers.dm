//A bluespace cracker item that can be pulled between two characters.
//The winner of the pull has an effect applied to them.
//Crackers do already exist, but these ones are a more memey scene item.

#define SHRINKING_CRACKER "shrinking"
#define GROWING_CRACKER "growing"
#define DRUGGED_CRACKER "drugged"
#define INVISIBLE_CRACKER "invisibility"
#define FALLING_CRACKER "knockdown"
#define TELEPORTING_CRACKER "teleport"
#define WEALTHY_CRACKER "wealth"

/obj/item/cracker
	name = "bluespace cracker" //I have no idea why this was called shrink ray when this increased and decreased size.
	desc = "A celebratory little game with a bluespace twist! Pull it between two people until it snaps, and the person who recieves the larger end gets a prize!"
	icon = 'icons/obj/crackers.dmi'
	icon_state = "blue"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cracker.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cracker.dmi',
		)
	item_state = "blue"
	var/rigged = 0 //So that they can be rigged by varedits to go one way or the other. positive values mean holder always wins, negative values mean target always wins.
	var/prize //What prize we have loaded
	var/joke //What joke we have loaded

/obj/item/cracker/Initialize(mapload)
	. = ..()
	var/style = pick("blue","green","yellow","red","heart","hazard")
	icon_state = style
	item_state = style
	if(!prize)
		prize = pick(SHRINKING_CRACKER,GROWING_CRACKER,GROWING_CRACKER,INVISIBLE_CRACKER,FALLING_CRACKER,TELEPORTING_CRACKER,WEALTHY_CRACKER)
	if(!joke)
		joke = pick("When is a boat just like snow? When it's adrift.",
					"What happens to naughty elves? Santa gives them the sack.",
					"What do you call an old snowman? Water.",
					"Why has Santa been banned from sooty chimneys? Carbon footprints.",
					"What goes down but doesn't come up? A yo.",
					"What's green and fuzzy, has four legs and would kill you if it fell from a tree? A pool table.",
					"Why did the blind man fall into the well? Because he couldn't see that well.",
					"What did the pirate get on his report card? Seven Cs",
					"What do you call a fish with no eyes? Fsh",
					"How do you make an egg roll? You push it.",
					"What do you call a deer with no eyes? NO EYED DEER!",
					"What's red, and smells like blue paint? Red paint.",
					"Where do cows go to dance? A meat ball.",
					"What do you call a person who steals all your toenail clippings? A cliptoemaniac.",
					"What's brown and sticky? A stick.",
					"What's the best way to kill a circus? Go for the juggler.",
					"What do you call a cow with no legs? Ground Beef.",
					"Why'd the scarecrow win the Nobel prize? He was outstanding in his field.")

/obj/item/cracker/attack(atom/A, mob/living/user, adjacent, params)
	var/mob/living/carbon/human/target = A
	if(!istype(target))
		return
	if(target.stat)
		return
	if(target == user)
		to_chat(user, span_notice("You can't pull \the [src] by yourself, that would just be sad!"))
		return
	to_chat(user, span_notice("You offer \the [src] to \the [target] to pull and wait to see how whether they do."))
	var/check_pull = tgui_alert(target, "\The [user] is offering to pull \the [src] with you, do you want to pull it?", "Pull Cracker", list("Yes", "No"))
	if(!check_pull || check_pull == "No")
		to_chat(user, span_notice("\The [target] chose not to pull \the [src]!"))
		return
	if(!adjacent)
		to_chat(user, span_notice("\The [target] is not standing close enough to pull \the [src]!"))
		return
	var/obj/item/check_hand = user.get_active_hand()
	if(check_hand != src)
		to_chat(user, span_notice("\The [src] is no longer in-hand!"))
		to_chat(target, span_notice("\The [src] is no longer in-hand!"))
		return
	var/mob/living/carbon/human/winner
	var/mob/living/carbon/human/loser
	if(!rigged)
		if(prob(50))
			winner = user
			loser = target
		else
			winner = target
			loser = user
	else
		if(rigged > 0)
			winner = user
			loser = target
		else
			winner = target
			loser = user
	if(HAS_TRAIT(loser, TRAIT_UNLUCKY) && prob(66))
		if(prize == (SHRINKING_CRACKER || GROWING_CRACKER || FALLING_CRACKER || TELEPORTING_CRACKER)) //If we're unlucky and the prize is bad, chance for us to get it!
			var/former_winner = winner
			winner = loser
			loser = former_winner

	var/spawnloc = get_turf(winner)

	winner.visible_message(span_notice("\The [winner] wins the cracker prize!"),span_notice("You win the cracker prize!"))
	switch(prize)
		if(SHRINKING_CRACKER)
			winner.resize(0.25)
			winner.visible_message(span_bold("\The [winner]") + " shrinks suddenly!")
		if(GROWING_CRACKER)
			winner.resize(2)
			winner.visible_message(span_bold("\The [winner]") + " grows in height suddenly.")
		if(GROWING_CRACKER)
			winner.druggy = max(winner.druggy, 50)
		if(INVISIBLE_CRACKER)
			if(!winner.cloaked)
				winner.visible_message(span_bold("\The [winner]") + " vanishes from sight.")
				winner.cloak()
			spawn(600)
				if(winner.cloaked)
					winner.uncloak()
					winner.visible_message(span_bold("\The [winner]") + " appears as if from thin air.")
		if(FALLING_CRACKER)
			winner.visible_message(span_bold("\The [winner]") + " is suddenly knocked to the ground.")
			winner.SetWeakened(max(winner.weakened,50))
		if(TELEPORTING_CRACKER)
			if(can_spontaneous_vore(loser, winner))
				winner.visible_message(span_bold("\The [winner]") + " is teleported to somewhere nearby...")
				var/datum/effect/effect/system/spark_spread/spk
				spk = new(winner)

				var/T = get_turf(winner)
				spk.set_up(5, 0, winner)
				spk.attach(winner)
				playsound(T, "sparks", 50, 1)
				anim(T,winner,'icons/mob/mob.dmi',,"phaseout",,winner.dir)
				winner.forceMove(loser.vore_selected)
		if(WEALTHY_CRACKER)
			new /obj/random/cash/huge(spawnloc)
			new /obj/random/cash/huge(spawnloc)
			winner.visible_message(span_bold("\The [winner]") + " has a whole load of cash fall at their feet!")

	playsound(user, 'sound/effects/snap.ogg', 50, 1)
	user.drop_item(src)
	new /obj/random/toy(spawnloc)
	new /obj/item/clothing/head/paper_crown(spawnloc)
	var/obj/item/paper/cracker_joke/J = new(spawnloc)
	J.info = joke
	qdel(src)

/obj/item/cracker/shrinking
	name = "shrinking bluespace cracker"
	prize = SHRINKING_CRACKER

/obj/item/cracker/growing
	name = "growing bluespace cracker"
	prize = GROWING_CRACKER

/obj/item/cracker/invisibility
	name = "cloaking bluespace cracker"
	prize = INVISIBLE_CRACKER

/obj/item/cracker/drugged
	name = "psychedelic bluespace cracker"
	prize = GROWING_CRACKER

/obj/item/cracker/knockover
	name = "forceful bluespace cracker"
	prize = FALLING_CRACKER

/obj/item/cracker/vore
	name = "teleporting bluespace cracker"
	prize = TELEPORTING_CRACKER

/obj/item/cracker/money
	name = "fortuitous bluespace cracker"
	prize = WEALTHY_CRACKER

/obj/item/clothing/head/paper_crown
	name = "paper crown"
	icon_state = "paper_crown_blue"
	item_state = "paper_crown_blue"
	item_icons = list(slot_head_str = 'icons/inventory/head/mob.dmi')
	desc = "A paper crown so thin that you can see through it."
	flags_inv = 0
	body_parts_covered = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/paper_crown/Initialize(mapload)
	var/list/styles = list("paper_crown_blue","paper_crown_green","paper_crown_yellow","paper_crown_red","paper_crown_pink")
	var/style = pick(styles)
	icon_state = style
	item_state = style
	. = ..()

/obj/item/paper/cracker_joke
	name = "joke"
	icon_state = "joke"

/obj/item/paper/cracker_joke/update_icon()
	return

#undef SHRINKING_CRACKER
#undef GROWING_CRACKER
#undef DRUGGED_CRACKER
#undef INVISIBLE_CRACKER
#undef FALLING_CRACKER
#undef TELEPORTING_CRACKER
#undef WEALTHY_CRACKER
