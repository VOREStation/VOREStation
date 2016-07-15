/datum/technomancer/spell/mend_metal
	name = "Mend Metal"
	desc = "Restores integrity to external robotic components.  Instability is split between the target and technomancer, if seperate."
	cost = 50
	obj_path = /obj/item/weapon/spell/insert/mend_metal
	ability_icon_state = "tech_mendwounds"

/obj/item/weapon/spell/insert/mend_metal
	name = "mend metal"
	desc = "A roboticist is now obsolete."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_metal

/obj/item/weapon/inserted_spell/mend_metal/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			for(var/i = 0, i<25,i++)
				if(H)
					for(var/obj/item/organ/external/O in H.organs)
						if(O.robotic < ORGAN_ROBOT) // Robot parts only.
							continue
						O.heal_damage(1, 0, internal = 1, robo_repair = 1)

					H.adjust_instability(0.5)
					origin.adjust_instability(0.5)
					sleep(10)
		on_expire()