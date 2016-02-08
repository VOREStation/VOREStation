/datum/technomancer/spell/aspect_bolt
	name = "Aspect Bolt"
	desc = "This bolt function takes on the properties of other functions based on which aspect is introduced to it, with the \
	delivery method being a projectile."
	cost = 150
	obj_path = /mob/living/carbon/human/proc/technomancer_aspect_bolt

/mob/living/carbon/human/proc/technomancer_aspect_bolt()
	place_spell_in_hand(/obj/item/weapon/spell/aspect_bolt)

/obj/item/weapon/spell/aspect_bolt
	name = "aspect bolt"
	desc = "Combine this with another spell to finish the function."
	icon_state = "aspect_bolt"
	cast_methods = CAST_COMBINE
	aspect = ASPECT_CHROMATIC

/obj/item/weapon/spell/aspect_bolt/on_combine_cast(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/spell = W
		if(!spell.aspect || spell.aspect == ASPECT_CHROMATIC)
			user << "<span class='warning'>You cannot combine \the [spell] with \the [src], as the aspects are incompatable.</span>"
			return
		world << spell.aspect
		switch(spell.aspect)
			if(ASPECT_FIRE)
				world << "Ideal."

