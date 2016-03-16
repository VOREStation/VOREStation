/datum/technomancer/spell/unstable_aura
	name = "Degen Aura"
	desc = "Destabalizes your enemies, breaking their elements down to their basic levels, slowly killing them from the inside.  \
	For each person within fourteen meters of you, they suffer 1% of their current health every second.  Your allies are unharmed."
	cost = 150
	obj_path = /obj/item/weapon/spell/aura/unstable
	ability_icon_state = "tech_unstableaura"

/obj/item/weapon/spell/aura/unstable
	name = "degen aura"
	desc = "Breaks down your entities from the inside."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_UNSTABLE
	glow_color = "#0000FF" //TODO

/obj/item/weapon/spell/aura/unstable/process()
	if(!pay_energy(500))
		qdel(src)
	var/list/nearby_mobs = range(14,owner)
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue

		var/damage_to_inflict = max(L.health / L.maxHealth, 0) // Otherwise, those in crit would actually be healed.

		if(L.isSynthetic())
			L.adjustBruteLoss(damage_to_inflict)
		else
			L.adjustToxLoss(damage_to_inflict)


	owner.adjust_instability(2)