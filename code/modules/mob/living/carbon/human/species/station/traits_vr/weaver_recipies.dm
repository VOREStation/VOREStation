/datum/weaver_recipe
	var/title = null
	var/result_type
	var/cost = 0
	var/time = 5 SECONDS

/datum/weaver_recipe/structure

/datum/weaver_recipe/structure/floor
	title = "floor"
	result_type = /obj/effect/weaversilk/floor
	cost = 25
	time = 1 SECOND

/datum/weaver_recipe/structure/wall
	title = "wall"
	result_type = /obj/effect/weaversilk/wall
	cost = 100

/datum/weaver_recipe/structure/nest
	title = "nest"
	result_type = /obj/structure/bed/double/weaversilk_nest
	cost = 100

/datum/weaver_recipe/structure/trap
	title = "trap"
	result_type = /obj/effect/weaversilk/trap
	cost = 250
	time = 15 SECONDS

/datum/weaver_recipe/item
	cost = 50

/datum/weaver_recipe/item/bindings
	title = "bindings"
	result_type = /obj/item/clothing/suit/weaversilk_bindings