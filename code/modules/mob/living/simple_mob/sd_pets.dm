/mob/living/simple_mob/animal/passive/fox/syndicate/aipet
	name = "R3N4-ULT"
	desc = "A curiously devious robotic fox!"
	devourable = 0
	digestable = 0

/datum/category_item/catalogue/fauna/catslug/tulidaan
	name = "Alien Wildlife - Catslug - Tulidaan"
	desc = "A resident of the Stellar Delight. Tulidaan usually\
	inhabits the reading rooms. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_TRIVIAL	//Worth less points since it lives on the ship

/mob/living/simple_mob/vore/alienanimals/catslug/tulidaan
	name = "Tulidaan"
	desc = "Watcher of the Seven. Thinker, knower."
	icon_state = "tulidaan"
	icon_living = "tulidaan"
	icon_rest = "tulidaan_rest"
	icon_dead = "tulidaan_dead"
	digestable = 0
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/tulidaan)
	holder_type = /obj/item/holder/catslug/tulidaan

/obj/item/holder/catslug/tulidaan
	item_state = "tulidaan"

/mob/living/simple_mob/animal/passive/mouse/jerboa/leggy
	name = "Leggy"
	desc = "Don't make fun, they have a condition."
	digestable = 0

/mob/living/simple_mob/animal/passive/mouse/jerboa/leggy/New()
	..()
	name = initial(name)
	desc = initial(desc)

/mob/living/simple_mob/animal/passive/mouse/brown/feivel
	name = "Feivel"
	desc = "Heading out west wasn't far enough, so he's going to space!"
	digestable = 0

/mob/living/simple_mob/animal/passive/mouse/brown/feivel/New()
	..()
	name = initial(name)
	desc = initial(desc)

/mob/living/simple_mob/animal/passive/cat/jones
	name = "Jones"
	desc = "A polite, well groomed patchy colored feline. Doesn't like his cat carrier."
	devourable = 0
	digestable = 0
	holder_type = /obj/item/holder/cat/jones

/obj/item/holder/cat/jones
	item_state = "cat2"


/mob/living/simple_mob/animal/passive/dog/void_puppy/nulle
	name = "Nulle"
	desc = "A guiding light through the black!"
	devourable = 0
	digestable = 0

/mob/living/simple_mob/animal/passive/tindalos/twigs
	name = "Twigs"
	desc = "Its eyes gleam with untold knowings..."
	devourable = 0
	digestable = 0

/mob/living/simple_mob/animal/passive/bird/azure_tit/iceman
	name = "Iceman"
	desc = "You wanna know who the best is? That's him. Iceman. Ice cold, no mistakes."
	devourable = 0
	digestable = 0

/mob/living/simple_mob/animal/passive/mimepet/gregory
	name = "Gregory XXVI Esq."
	desc = "It looks very distinguished."
	devourable = 0
	digestable = 0

/mob/living/simple_mob/vore/fennec/bridgette
	name = "Bridgette"
	desc = "Bridgette the brig fox! She glares at you like you did something wrong!"
	devourable = 0
	digestable = 0

/datum/category_item/catalogue/fauna/otie/cocoa
	name = "Creature - Otie - Cocoa"
	desc = "A resident of the Stellar Delight. Cocoa usually inhabits the bar, and is very friendly. - \
	A bioengineered longdog, the otie is very long, and very cute, depending on if you like dogs, \
	especially long ones. They are black-and-grey furred, typically, and tanky, hard to kill. \
	They seem hostile at first, but are also tame-able if you can approach one. Nipnipnip-ACK \
	**the catalogue entry ends here.**"
	value = CATALOGUER_REWARD_TRIVIAL	//Worth less points since it lives on the ship


/mob/living/simple_mob/otie/red/chubby/cocoa
	name = "Cocoa"
	desc = "A good boi, eats the scraps when you're not looking."
	devourable = 0
	digestable = 0
	faction = "bar"
	mob_bump_flag = 32
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/otie/cocoa
	catalogue_data = list(/datum/category_item/catalogue/fauna/otie/cocoa)


/datum/ai_holder/simple_mob/melee/evasive/otie/cocoa
	hostile = 0
	retaliate = 0
	violent_breakthrough = 0
