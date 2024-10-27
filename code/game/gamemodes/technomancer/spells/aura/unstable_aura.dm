/datum/technomancer/spell/unstable_aura
	name = "Degen Aura"
	desc = "Destabalizes your enemies, breaking their elements down to their basic levels, slowly killing them from the inside.  \
	For each person within <b>fourteen meters</b> of you, they suffer 1% of their current health every second.  Your allies are \
	unharmed."
	spell_power_desc = "Radius is increased."
	cost = 150
	obj_path = /obj/item/spell/aura/unstable
	ability_icon_state = "tech_unstableaura"
	category = OFFENSIVE_SPELLS

/obj/item/spell/aura/unstable
	name = "degen aura"
	desc = "Breaks down your entities from the inside."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_UNSTABLE
	glow_color = "#CC00CC"

/obj/item/spell/aura/unstable/process()
	if(!pay_energy(200))
		qdel(src)
	var/list/nearby_mobs = range(calculate_spell_power(14),owner)
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue

		var/damage_to_inflict = max(L.health / L.getMaxHealth(), 0) // Otherwise, those in crit would actually be healed.

		var/armor_factor = abs(L.getarmor(null, "energy") - 100)
		armor_factor = armor_factor / 100

		damage_to_inflict = damage_to_inflict * armor_factor

		if(L.isSynthetic())
			L.adjustBruteLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L, span_danger("Your chassis seems to slowly be decaying and breaking down."))
		else
			L.adjustToxLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L, span_danger("You feel almost like you're melting from the inside!"))


	adjust_instability(2)
