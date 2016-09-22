/datum/technomancer/spell/mend_organs
	name = "Mend Organs"
	desc = "Heals the target's internal organs, both organic and robotic.  Instability is split between the target \
	and technomancer, if seperate."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_organs
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/insert/mend_organs
	name = "mend organs"
	desc = "Now nobody will ever need surgery."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_organs

/obj/item/weapon/inserted_spell/mend_organs/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			for(var/i = 0, i<5,i++)
				if(H)
					for(var/obj/item/organ/O in H.internal_organs)
						if(O.damage > 0)
							O.damage = max(O.damage - 1, 0)

					H.adjust_instability(2.5)
					origin.adjust_instability(2.5)
					sleep(1 SECOND)
		on_expire()