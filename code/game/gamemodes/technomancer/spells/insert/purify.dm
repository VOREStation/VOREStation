/datum/technomancer/spell/purify
	name = "Purify"
	desc = "Clenses the body of harmful impurities, such as toxins, radiation, viruses, genetic damage, and such."
	spell_power_desc = "Healing amount increased."
	cost = 25
	obj_path = /obj/item/weapon/spell/insert/purify
	ability_icon_state = "tech_purify"
	category = SUPPORT_SPELLS

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
			var/heal_power = host == origin ? 10 : 30
			heal_power = round(heal_power * spell_power_at_creation, 1)
			origin.adjust_instability(10)
			for(var/i = 0, i<5,i++)
				if(H)
					H.adjustToxLoss(-heal_power / 5)
					H.adjustCloneLoss(-heal_power / 5)
					H.radiation = max(host.radiation - ( (heal_power * 2) / 5), 0)

					for(var/obj/item/organ/external/E in H.organs)
						var/obj/item/organ/external/G = E
						if(G.germ_level)
							var/germ_heal = heal_power * 10
							G.germ_level = min(0, G.germ_level - germ_heal)

					for(var/obj/item/organ/internal/I in H.internal_organs)
						var/obj/item/organ/internal/G = I
						if(G.germ_level)
							var/germ_heal = heal_power * 10
							G.germ_level = min(0, G.germ_level - germ_heal)

					sleep(1 SECOND)
		on_expire()
