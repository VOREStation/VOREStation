/datum/technomancer/spell/purify
	name = "Purify"
	desc = "Clenses the body of harmful impurities, such as toxins, radiation, viruses, and such.  \
	Instability is split between the target and technomancer, if seperate."
	cost = 25
	obj_path = /obj/item/weapon/spell/insert/purify
	ability_icon_state = "tech_purify"

/obj/item/weapon/spell/insert/purify
	name = "purify"
	desc = "Illness and toxins will be no more."
	icon_state = "purify"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#03A728"
	inserting = /obj/item/weapon/inserted_spell/purify

/obj/item/weapon/inserted_spell/purify/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			H.sdisabilities = 0
			H.disabilities = 0
//			for(var/datum/disease/D in H.viruses)
//				D.cure()
			for(var/i = 0, i<25,i++)
				if(H)
					H.adjustToxLoss(-1)
					H.adjustCloneLoss(-1)
					H.radiation = max(host.radiation - 2, 0)
					H.adjust_instability(0.5)
					origin.adjust_instability(0.5)
					sleep(10)
		on_expire()
