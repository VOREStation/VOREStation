/datum/power/technomancer/darkness
	name = "Darkness"
	desc = "Disrupts photons moving in a local area, causing darkness to shroud yourself or a position of your choosing."
	cost = 30
	verbpath = /mob/living/carbon/human/proc/technomancer_darkness

/mob/living/carbon/human/proc/technomancer_darkness()
	place_spell_in_hand(/obj/item/weapon/spell/darkness)

/obj/item/weapon/spell/darkness
	name = "darkness"
	desc = "Not even light can stand in your way now."
	icon_state = "darkness"
	cast_methods = CAST_RANGED
	aspect = ASPECT_DARK
	toggled = 1

/obj/item/weapon/spell/darkness/New()
	..()
	set_light(6, -5, l_color = "#FFFFFF")

/obj/effect/darkness
	name = "darkness"
	desc = "How are you examining what which cannot be seen?"
	invisibility = 101
	var/time_to_die = 2 MINUTES //Despawn after this time, if set.

/obj/effect/darkness/New()
	..()
	set_light(6, -5, l_color = "#FFFFFF")
	if(time_to_die)
		spawn(time_to_die)
			qdel(src)

/obj/item/weapon/spell/darkness/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		new /obj/effect/darkness(T)
		user << "<span class='notice'>You shift the distruption of light onto \the [T].</span>"
		qdel(src)