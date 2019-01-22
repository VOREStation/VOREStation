// Ascian's Tactical Kitten
/obj/item/weapon/holder/cat/fluff/tabiranth
	name = "Spirit"
	desc = "A small, inquisitive feline, who constantly seems to investigate his surroundings."
	gender = MALE
	icon_state = "kitten"
	w_class = ITEMSIZE_SMALL

/mob/living/simple_mob/animal/passive/cat/tabiranth
	name = "Spirit"
	desc = "A small, inquisitive feline, who constantly seems to investigate his surroundings."
	icon = 'icons/mob/custom_items_mob.dmi'
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten" //Teleports out
	gender = MALE
	holder_type = /obj/item/weapon/holder/cat/fluff/tabiranth
	friend_name = "Ascian"
	digestable = 0
	meat_amount = 0
	maxHealth = 50
	health = 50

/mob/living/simple_mob/animal/passive/cat/tabiranth/handle_special()
	. = ..()
	if (has_AI() && friend)
		var/friend_dist = get_dist(src,friend)
		if (friend_dist <= 1)
			if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
				if (prob((friend.stat < DEAD)? 50 : 15))
					var/verb = pick("meows", "mews", "mrowls")
					audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
			else
				if (prob(5))
					visible_emote(pick("nuzzles [friend].",
									"brushes against [friend].",
									"rubs against [friend].",
									"purrs."))
		else if (friend.health <= 50)
			if (prob(10))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote("[verb] anxiously.")

//Emergency teleport - Until a spriter makes something better
/mob/living/simple_mob/animal/passive/cat/tabiranth/death(gibbed, deathmessage = "teleports away!")
	overlays = list()
	icon_state = ""
	flick("kphaseout",src)
	spawn(1 SECOND)
		qdel(src) //Back from whence you came!

	. = ..(FALSE, deathmessage)

