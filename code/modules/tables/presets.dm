//TABLE PRESETS
/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/standard/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	..()

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/steel/New()
	material = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/marble/New()
	material = get_material_by_name("marble")
	..()

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/steel_reinforced/New()
	material = get_material_by_name(MAT_STEEL)
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/wooden_reinforced/New()
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/woodentable/New()
	material = get_material_by_name("wood")
	..()

/obj/structure/table/sifwoodentable
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/sifwoodentable/New()
	material = get_material_by_name("alien wood")
	..()

/obj/structure/table/sifwooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/sifwooden_reinforced/New()
	material = get_material_by_name("alien wood")
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/hardwoodtable
	icon_state = "stone_preview"
	color = "#42291a"

/obj/structure/table/hardwoodtable/Initialize(mapload)
	material = get_material_by_name("hardwood")
	return ..()

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"

/obj/structure/table/gamblingtable/New()
	material = get_material_by_name("wood")
	carpeted = 1
	..()

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/glass/New()
	material = get_material_by_name("glass")
	..()

/obj/structure/table/borosilicate
	icon_state = "plain_preview"
	color = "#4D3EAC"
	alpha = 77

/obj/structure/table/borosilicate/New()
	material = get_material_by_name("borosilicate glass")
	..()

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/holotable/New()
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	..()

/obj/structure/table/woodentable/holotable
	icon_state = "holo_preview"

/obj/structure/table/woodentable/holotable/New()
	material = get_material_by_name("holowood")
	..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/New()
	material = get_material_by_name("alium")
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	..()

/obj/structure/table/alien/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, span_warning("You cannot dismantle \the [src]."))
	return

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/standard/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	..()

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/bench/steel/New()
	material = get_material_by_name(MAT_STEEL)
	..()


/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/bench/marble/New()
	material = get_material_by_name("marble")
	..()
/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = get_material_by_name(MAT_STEEL)
	reinforced = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(MAT_STEEL)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden/New()
	material = get_material_by_name("wood")
	..()

/obj/structure/table/bench/sifwooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/sifwooden/New()
	material = get_material_by_name("alien wood")
	..()

/obj/structure/table/bench/sifwooden/padded
	icon_state = "padded_preview"
	carpeted = 1

/obj/structure/table/bench/padded
	icon_state = "padded_preview"

/obj/structure/table/bench/padded/New()
	material = get_material_by_name(MAT_STEEL)
	carpeted = 1
	..()

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/bench/glass/New()
	material = get_material_by_name("glass")
	..()

/*
/obj/structure/table/bench/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/holotable/New()
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	..()

/obj/structure/table/bench/wooden/holotable
	icon_state = "holo_preview"

/obj/structure/table/bench/wooden/holotable/New()
	material = get_material_by_name("holowood")
	..()
*/
