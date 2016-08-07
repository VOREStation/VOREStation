/datum/technomancer/spell/mend_burns
	name = "Mend Burns"
	desc = "Heals minor burns, such as from exposure to flame, electric shock, or lasers.  \
	Instability is split between the target and technomancer, if seperate."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_burns
	ability_icon_state = "tech_mendburns"

/obj/item/weapon/spell/insert/mend_burns
	name = "mend burns"
	desc = "Ointment is a thing of the past."
	icon_state = "mend_burns"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_burns

/obj/item/weapon/inserted_spell/mend_burns/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			for(var/i = 0, i<25,i++)
				if(H)
					H.adjustFireLoss(-1)
					H.adjust_instability(0.5)
					origin.adjust_instability(0.5)
					sleep(10)
		on_expire()