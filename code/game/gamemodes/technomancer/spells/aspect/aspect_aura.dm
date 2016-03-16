/datum/technomancer/spell/aspect_aura
	name = "Aspect Aura"
	desc = "This aura function takes on the properties of other functions based on which aspect is introduced to it, applying \
	it to everyone nearby."
	cost = 200
	obj_path = /obj/item/weapon/spell/aspect/aura

/obj/item/weapon/spell/aspect/aura
	name = "aspect aura"
	desc = "Combine this with another spell to finish the function."
	fire_result = /obj/item/weapon/spell/aura/fire
	frost_result = /obj/item/weapon/spell/aura/frost
	shock_result = /obj/item/weapon/spell/aura/shock
	air_result = null
	force_result = null
	tele_result = null
	biomed_result = /obj/item/weapon/spell/aura/biomed
	dark_result = null
	light_result = null
	unstable_result = /obj/item/weapon/spell/aura/unstable

/obj/item/weapon/spell/aura
	name = "aura template"
	desc = "If you can read me, the game broke!  Yay!"
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_CHROMATIC
	var/glow_color = "#FFFFFF"

/obj/item/weapon/spell/aura/New()
	..()
	set_light(7, 4, l_color = glow_color)
	processing_objects |= src

/obj/item/weapon/spell/aura/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/spell/aura/process()
	return

/obj/item/weapon/spell/aura/fire
	name = "heat aura"
	desc = "Things are starting to heat up."
	icon_state = "generic"
	aspect = ASPECT_FIRE
	glow_color = "#FF6A00"

/obj/item/weapon/spell/aura/fire/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)
	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(is_ally(H))
			continue

		//We use hotspot_expose() to allow firesuits to protect from this aura.
		var/turf/location = get_turf(H)
		location.hotspot_expose(1000, 50, 1)

	owner.adjust_instability(1)

/obj/item/weapon/spell/aura/frost
	name = "chilling aura"
	desc = "Your enemies will find it hard to chase you if they freeze to death."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_FROST
	glow_color = "#FF6A00"

/obj/item/weapon/spell/aura/frost/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)
	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(is_ally(H))
			continue

		//We use hotspot_expose() to allow firesuits to protect from this aura.
		var/turf/location = get_turf(H)
		location.hotspot_expose(1, 50, 1)

	owner.adjust_instability(1)



/obj/item/weapon/spell/aura/biomed
	name = "restoration aura"
	desc = "Allows everyone, or just your allies, to slowly regenerate."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_BIOMED
	glow_color = "#0000FF"
	var/regen_tick = 0
	var/heal_allies_only = 1

/obj/item/weapon/spell/aura/biomed/process()
	if(!pay_energy(75))
		qdel(src)
	regen_tick++
	if(regen_tick % 5 == 0)
		var/list/nearby_mobs = range(4,owner)
		var/list/mobs_to_heal = list()
		if(heal_allies_only)
			for(var/mob/living/L in nearby_mobs)
				if(is_ally(L))
					mobs_to_heal |= L
		else
			mobs_to_heal = nearby_mobs //Heal everyone!
		for(var/mob/living/L in mobs_to_heal)
			L.adjustBruteLoss(-2)
			L.adjustFireLoss(-2)
		owner.adjust_instability(2)

/obj/item/weapon/spell/aura/biomed/on_use_cast(mob/living/user)
	heal_allies_only = !heal_allies_only
	user << "Your aura will now heal [heal_allies_only ? "your allies" : "everyone"] near you."

/obj/item/weapon/spell/aura/shock
	name = "lightning aura"
	desc = "Now you are a walking electrical storm."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_SHOCK
	glow_color = "#0000FF" //TODO

/obj/item/weapon/spell/aura/shock/process()
	if(!pay_energy(1000))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)
	for(var/obj/machinery/light/light in range(7, owner))
		light.flicker()
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue

		if(L.isSynthetic())
			L << "<span class='danger'>ERROR: Electrical fault detected!</span>"
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(15, src, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(15, src, 1.0, BP_TORSO)


	owner.adjust_instability(4)

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
	var/list/nearby_mobs = range(7,owner)
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue

		var/damage_to_inflict = L.health / L.maxHealth

		if(L.isSynthetic())
			L.adjustBruteLoss(damage_to_inflict)
		else
			L.adjustToxLoss(damage_to_inflict)


	owner.adjust_instability(5)