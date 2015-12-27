/datum/power/technomancer/purify
	name = "Purify"
	desc = "Clenses the body of harmful impurities, such as toxins, radiation, viruses, and such."
	verbpath = /mob/living/carbon/human/proc/technomancer_purify

/mob/living/carbon/human/proc/technomancer_purify()
	place_spell_in_hand(/obj/item/weapon/spell/purify)

/obj/item/weapon/spell/purify
	name = "purify"
	desc = "Illness and toxins will be no more."
	icon_state = "radiance"
	cast_methods = CAST_MELEE
	toggled = 1

/obj/item/weapon/spell/purify/New()
	..()
	set_light(3, 2, l_color = "#03A728")
	processing_objects |= src

/obj/item/weapon/spell/purify/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/spell/purify/process()
	owner.adjustToxLoss(-1)
	owner.adjustCloneLoss(-1)
	owner.radiation = max(owner.radiation - 4, 0)
	owner.sdisabilities = 0
	owner.disabilities = 0
	for(var/datum/disease/D in owner.viruses)
		D.cure()
	owner.adjust_instability(4)

/obj/item/weapon/spell/purify/on_melee_cast(atom/hit_atom, mob/user)
	if(hit_atom == user)
		return 0
	if(istype(hit_atom, /mob/living))
		var/mob/living/L = hit_atom
		visible_message("<span class='info'>\The [user] reaches out towards \the [L] with a glowing hand.</span>")
		L << "<span class='notice'>Your start to feel a tingling sensation.</span>"
		spawn(1)
			L.sdisabilities = 0
			L.disabilities = 0
			for(var/datum/disease/D in L.viruses)
				D.cure()
			for(var/i = 0, i<25,i++)
				if(L)
					L.adjustToxLoss(-4)
					L.adjustCloneLoss(-4)
					L.radiation = max(L.radiation - 8, 0)
					sleep(10)
		qdel(src)