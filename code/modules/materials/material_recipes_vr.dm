
/material/steel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("light switch frame", /obj/item/frame/lightswitch, 2)

/material/durasteel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("durasteel fishing rod", /obj/item/weapon/material/fishing_rod/modern/strong, 2)