/datum/weaver_recipe
	var/title = null
	var/result_type
	var/cost = 0
	var/time = 50
	var/one_per_turf = FALSE

/datum/weaver_recipe/structure
	one_per_turf = TRUE

/datum/weaver_recipe/structure/floor
	title = "Floor"
	result_type = /obj/effect/weaversilk/floor
	cost = 25

/datum/weaver_recipe/structure/wall
	title = "Wall"
	result_type = /obj/effect/weaversilk/wall
	cost = 100

/datum/weaver_recipe/structure/nest
	title = "Wall"
	result_type = /obj/structure/bed/double/weaversilk_nest
	cost = 100

/datum/weaver_recipe/item
	one_per_turf = FALSE