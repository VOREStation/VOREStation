/datum/technomancer/spell/aspect_weapon
	name = "Aspect Weapon"
	desc = "This bolt function takes on the properties of other functions based on which aspect is introduced to it, making a temporary \
	weapon that has the properties of the aspect introduced to it."
	cost = 200
	obj_path = /obj/item/weapon/spell/aspect/weapon

/obj/item/weapon/spell/aspect/weapon
	name = "aspect weapon"
	desc = "Combine this with another spell to finish the function."
	fire_result = null
	frost_result = null
	shock_result = null
	air_result = null
	force_result = null
	tele_result = null
	biomed_result = null
	dark_result = null
	light_result = null
	unstable_result = /obj/item/weapon/conjured/unstable_blade

/obj/item/weapon/conjured
	anchored = 1
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/mob/living/carbon/human/user = null

/obj/item/weapon/conjured/New(location)
	..()
	if(ishuman(loc))
		user = loc

/obj/item/weapon/conjured/Destroy(location)
	user = null
	..()

/obj/item/weapon/conjured/dropped()
	qdel(src)

/obj/item/weapon/conjured/unstable_blade
	name = "unstable blade"
	desc = "This thing seems to warp before your eyes.  Perhaps this can enable you to land stronger hits, if you feel lucky."
	force = 20
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/conjured/unstable_blade/New(location)
	..()
	processing_objects |= src

/obj/item/weapon/conjured/unstable_blade/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/conjured/unstable_blade/process()
	if(user)
		user.adjust_instability(1)


//The only weapon in SS13 with the ability for 'critical hits', to tie in with the theme for randomness for the Unstable aspect.
/obj/item/weapon/conjured/unstable_blade/afterattack(atom/target, var/mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(prob(20) && proximity_flag)
		visible_message("<span class='danger'>\The [user] lands a devastating blow on \the [target]!</span>")
		force = force * 2
		attack(target, user)
		force = initial(force)
	user.adjust_instability(2)
