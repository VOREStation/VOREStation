/mob/living/simple_mob/animal/passive/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	tt_desc = "J Escargot escargot" // a product of Jade, which is a planet that totally exists

	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	icon = 'icons/jungle.dmi'

	organ_names = /decl/mob_organ_names/yithian

	// Same stats as lizards.
	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE

/mob/living/simple_mob/animal/passive/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	tt_desc = "J Locusta bruchus"

	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	icon = 'icons/jungle.dmi'

	organ_names = /decl/mob_organ_names/tindalos

	// Same stats as lizards.
	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE

/decl/mob_organ_names/yithian
	hit_zones = list("head", "abdomen", "left foreleg", "right foreleg", "left hind leg", "right hind leg")

/decl/mob_organ_names/tindalos
	hit_zones = list("head", "thorax", "abdomen", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "left middle leg", "right middle leg")