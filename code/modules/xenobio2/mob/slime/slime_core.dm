/*
Slime core lives here.
*/
/obj/item/xenoproduct/slime/core
	name = "slime core"
	desc = "Gooey."
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime extract"
	source = "Slime"
	product = "core"
	
/obj/item/xenoproduct/slime/core/New()
	..()
	color = traits.get_trait(TRAIT_XENO_COLOR)
	if(traits.get_trait(TRAIT_XENO_BIOLUMESCENT))
		set_light(traits.get_trait(TRAIT_XENO_GLOW_STRENGTH),traits.get_trait(TRAIT_XENO_GLOW_RANGE),traits.get_trait(TRAIT_XENO_BIO_COLOR))
	