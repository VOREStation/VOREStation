/datum/design_techweb/board/airlock_electronics
	name = "airlock electronics circuit"
	desc = "The circuit board for a airlock."
	id = "airlock_board"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/airlock_electronics
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/airalarm
	name = "air alarm circuit"
	desc = "The circuit board for a air alarm."
	id = "airalarm_electronics"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/airalarm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/firealarm
	name = "fire alarm circuit"
	desc = "The circuit board for a fire alarm."
	id = "firealarm_electronics"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/firealarm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/power_control
	name = "power control module"
	desc = "The circuit board for an area power controller(APC)."
	id = "power_control"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/module/power_control
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/holopad
	name = "holopad circuit"
	desc = "The circuit board for an AI holopad."
	id = "holopad"
	build_path = /obj/item/circuitboard/holopad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/light_bulb
	name = "light bulb"
	id = "light_bulb"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 125)
	build_path = /obj/item/light/bulb
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/large_light_bulb
	name = "large light bulb"
	id = "large_light_bulb"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 200)
	build_path = /obj/item/light/bulb/large
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/light_tube
	name = "light tube"
	id = "light_tube"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 125)
	build_path = /obj/item/light/tube
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/large_light_tube
	name = "large light tube"
	id = "large_light_tube"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = 200)
	build_path = /obj/item/light/tube/large
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/floor_light
	name = "floor light kit"
	desc = "A backlit floor panel, ready for installation!"
	id = "floor_light"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/floor_light
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
