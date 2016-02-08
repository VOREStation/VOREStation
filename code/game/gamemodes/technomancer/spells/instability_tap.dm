/datum/technomancer/spell/instability_tap
	name = "Instability Tap"
	desc = "Creates a large sum of energy, at the cost of a very large amount of instability afflicting you."
	cost = 120
	obj_path = /obj/item/weapon/spell/instability_tap

/obj/item/weapon/spell/instability_tap
	name = "instability tap"
	desc = "Short term gain for long term consequences never end bad, right?"
	cast_methods = CAST_USE
	aspect = ASPECT_UNSTABLE

/obj/item/weapon/spell/instability_tap/New()
	..()
	set_light(3, 2, l_color = "#FA58F4")

/obj/item/weapon/spell/instability_tap/on_use_cast(mob/user)
	core.give_energy(5000)
	owner.adjust_instability(50)
	qdel(src)