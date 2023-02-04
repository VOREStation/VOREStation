////////////////////////////
//			Shade
////////////////////////////

/mob/living/simple_mob/construct/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"

	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_armor_pen = 100	//It's a ghost/horror from beyond, I ain't gotta explain 100 AP
	attacktext = list("drained the life from")

	organ_names = /decl/mob_organ_names/shade

	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	universal_speak = 1

	loot_list = list(/obj/item/weapon/ectoplasm = 100)

/mob/living/simple_mob/construct/shade/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = O;
		S.transfer_soul("SHADE", src, user)
		return
	..()

/mob/living/simple_mob/construct/shade/death()
	..()
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.blinded )))
			M.show_message("<font color='red'>[src] lets out a contented sigh as their form unwinds.</font>")

	ghostize()
	qdel(src)
	return

/decl/mob_organ_names/shade
	hit_zones = list("spectral robe", "featureless visage", "haunting glow")
