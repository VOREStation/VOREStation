/*****************************Coin********************************/
// fake "toy" version that allows people to have them as trinkets
// without letting them easily get stuff from vending machines

/obj/item/fake_coin
	icon = 'icons/obj/coins.dmi'
	name = "Coin"
	desc = "A simple coin you can flip. The weight doesn't seem quite right..."
	description_fluff = "This isn't a real coin; you can't use it on vending machines."
	icon_state = "coin"
	randpixel = 8
	force = 0.0
	throwforce = 0.0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/sides = 2
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/fake_coin/Initialize(mapload)
	. = ..()
	randpixel_xy()

/obj/item/fake_coin/gold
	name = MAT_GOLD + " coin"
	desc = "A shiny " + MAT_GOLD + " coin. Just like in the old movies with pirates!"
	icon_state = "coin_gold"

/obj/item/fake_coin/silver
	name = MAT_SILVER + " coin"
	desc = "A shiny " + MAT_SILVER + " coin. You can almost see your reflection in it. Unless you're a vampire."
	icon_state = "coin_silver"

/obj/item/fake_coin/copper
	name = MAT_COPPER + " coin"
	desc = "A sturdy " + MAT_COPPER + " coin. The preferred tender of people who like to make other people count a lot."
	icon_state = "coin_copper"

/obj/item/fake_coin/diamond
	name = MAT_DIAMOND + " coin"
	desc = "A coin made of solid " + MAT_DIAMOND + ". Carbon, really, but who's counting?" // me, I'm counting
	icon_state = "coin_diamond"

/obj/item/fake_coin/graphite
	name = MAT_GRAPHITE + " coin"
	desc = "A small pressed plaque of " + MAT_GRAPHITE + ". This seems... impractical. Maybe you could use it as a pencil in a pinch?"
	icon_state = "coin_graphite"

/obj/item/fake_coin/iron
	name = MAT_IRON + " coin"
	desc = "A dull " + MAT_IRON + " coin. Not that it's boring, it's just a bit plain."
	icon_state = "coin_iron"

/obj/item/fake_coin/steel
	name = MAT_STEEL + " coin"
	desc = "A plain " + MAT_STEEL + " coin. You'd think they'd make more coins out of this, considering how plentiful it is."
	icon_state = "coin_steel"

/obj/item/fake_coin/durasteel
	name = MAT_DURASTEEL + " coin"
	desc = "A shiny " + MAT_DURASTEEL + " coin. Keep it in your breast pocket, maybe it'll stop a bullet someday."
	icon_state = "coin_durasteel"

/obj/item/fake_coin/plasteel
	name = MAT_PLASTEEL + " coin"
	desc = "Someone made a coin out of " + MAT_PLASTEEL + ". Now why would they do that?"
	icon_state = "coin_plasteel"

/obj/item/fake_coin/titanium
	name = MAT_TITANIUM + " coin"
	desc = "A shiny " + MAT_TITANIUM + " coin with some commemorative markings."
	icon_state = "coin_titanium"

/obj/item/fake_coin/lead
	name = MAT_LEAD + " coin"
	desc = "A heavy coin indeed. Shame it's worthless as anything other than a paperweight."
	icon_state = "coin_lead"

/obj/item/fake_coin/phoron
	name = "solid " + MAT_PHORON + " coin"
	desc = "Solid " + MAT_PHORON + ", pressed into a coin and laminated for safety. Go ahead, lick it."
	icon_state = "coin_phoron"

/obj/item/fake_coin/uranium
	name = MAT_URANIUM + " coin"
	desc = "A " + MAT_URANIUM + " coin. You probably don't want to store this in your pants pocket..."
	icon_state = "coin_uranium"

/obj/item/fake_coin/platinum
	name = MAT_PLATINUM + " coin"
	desc = "A shiny " + MAT_PLATINUM + " coin. Truth is, the game was rigged from the start."
	icon_state = "coin_platinum"

/obj/item/fake_coin/morphium
	name = MAT_MORPHIUM + " coin"
	desc = "Solid " + MAT_MORPHIUM + ", made into a coin. Extravagant is putting it lightly."
	icon_state = "coin_morphium"

/obj/item/fake_coin/aluminium
	name = MAT_ALUMINIUM + " coin"
	desc = "Someone decided to make a coin out of" + MAT_ALUMINIUM + ". Now your wallet can be lighter than ever."
	icon_state = "coin_aluminium"

/obj/item/fake_coin/verdantium
	name = MAT_VERDANTIUM + " coin"
	desc = "Shiny green " + MAT_VERDANTIUM + ", pressed into a coin. It almost seems to glimmer under starlight."
	icon_state = "coin_verdantium"

/obj/item/fake_coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(span_notice("[user] has thrown \the [src]. It lands on [comment]!"), \
							span_notice("You throw \the [src]. It lands on [comment]!"))
