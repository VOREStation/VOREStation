/mob/living/simple_mob/animal/sif/grafadreka/hatchling
	name = "grafadreka hatchling"
	icon = 'icons/mob/drake_baby.dmi'
	mob_size = MOB_SMALL
	desc = "An immature snow drake, not long out of the shell."

	player_msg = {"<b>You are a very small Sivian pack predator.</b>
The Sivian forest is dark and full of terrors, and you are young and weak. Try to stay alive.
You can eat glowing tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> (on <b><font color = '#009900'>help intent</font></b>)."}

	is_baby = TRUE
	offset_compiled_icon = null

	melee_damage_lower = 3
	melee_damage_upper = 5
	attack_armor_pen = 2
	bite_melee_damage_lower = 5
	bite_melee_damage_upper = 10
	bite_attack_armor_pen = 16

	projectiletype = /obj/item/projectile/drake_spit/weak
	maxHealth = 60
	health = 60
