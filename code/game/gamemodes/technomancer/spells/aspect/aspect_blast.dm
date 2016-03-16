/datum/technomancer/spell/aspect_blast
	name = "Aspect Blast"
	desc = "This aura function takes on the properties of other functions based on which aspect is introduced to it, applying \
	it in the form of an explosion."
	cost = 200
	obj_path = /obj/item/weapon/spell/aspect/blast

/obj/item/weapon/spell/aspect/blast
	name = "aspect blast"
	desc = "Combine this with another spell to finish the function."
	fire_result = /obj/item/weapon/spell/blast/fire
	frost_result = null
	shock_result = null
	air_result = null
	force_result = null
	tele_result = null
	biomed_result = null
	dark_result = null
	light_result = null
	unstable_result = null

/obj/item/weapon/spell/blast
	name = "blast template"
	desc = "If you can read me, the game broke!  Yay!"
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_CHROMATIC
	var/glow_color = "#FFFFFF"

/obj/item/weapon/spell/blast/New()
	..()
	set_light(7, 4, l_color = glow_color)

/obj/item/weapon/spell/blast/fire
	name = "fire blast"
	desc = "Lead your shots."
	aspect = ASPECT_FIRE
	glow_color = "#FF6A00"

/obj/item/weapon/spell/blast/fire/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T && pay_energy(800) )
		new /obj/effect/pulsar(T)
		user << "<span class='notice'>You cause \the [T] to explode shortly!</span>"
		owner.adjust_instability(6)

