/datum/technomancer/spell/mend_wounds
	name = "Mend Wounds"
	desc = "Heals minor wounds, such as cuts, bruises, and other non-lifethreatening injuries.  \
	Instability is split between the target and technomancer, if seperate."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_wounds
	ability_icon_state = "tech_mendwounds"

/obj/item/weapon/spell/insert/mend_wounds
	name = "mend wounds"
	desc = "Watch your wounds close up before your eyes."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_wounds

/obj/item/weapon/inserted_spell/mend_wounds/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			for(var/i = 0, i<25,i++)
				if(H)
					H.adjustBruteLoss(-1)
					H.adjust_instability(0.5)
					origin.adjust_instability(0.5)
					sleep(10)
		on_expire()
