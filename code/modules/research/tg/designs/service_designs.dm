/datum/design_techweb/board/atm
	SET_CIRCUIT_DESIGN_NAMEDESC("atm")
	id = "bankmachine"
	build_path = /obj/item/circuitboard/atm
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/fax
	SET_CIRCUIT_DESIGN_NAMEDESC("fax machine")
	id = "fax"
	build_path = /obj/item/circuitboard/fax
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/photocopier
	SET_CIRCUIT_DESIGN_NAMEDESC("photocopier")
	id = "photocopier"
	build_path = /obj/item/circuitboard/photocopier
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/papershredder
	SET_CIRCUIT_DESIGN_NAMEDESC("papershredder")
	id = "papershredder"
	build_path = /obj/item/circuitboard/papershredder
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/guest_pass
	SET_CIRCUIT_DESIGN_NAMEDESC("guestpass console")
	id = "guestpass"
	build_path = /obj/item/circuitboard/guestpass
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ashtray
	name = "ashtray"
	desc = "An ashtray."
	id = "ashtray"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.125))
	build_path = /obj/item/material/ashtray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/glasstray
	name = "glass ashtray"
	desc = "An shinier ashtray."
	id = "glasstray"
	build_type = PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.125))
	build_path = /obj/item/material/ashtray/glass
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE


// glasses
/datum/design_techweb/watercooler_bottle
	name = "water-cooler bottle"
	desc = "A bottle for a water-cooler."
	id = "watercooler_bottle"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = MATERIAL_COST(1.25))
	build_path = /obj/item/reagent_containers/glass/cooler_bottle
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_square
	name = "half-pint glass"
	desc = "Your standard drinking glass."
	id = "barglass_square"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.0375))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/square
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_rocks
	name = "rocks glass"
	desc = "Your standard drinking glass."
	id = "barglass_rocks"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.025))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/rocks
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_milkshake
	name = "milkshake glass"
	desc = "Your standard drinking glass."
	id = "barglass_milkshake"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.02))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/shake
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_cocktail
	name = "cocktail glass"
	desc = "Your standard drinking glass."
	id = "barglass_cocktail"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.02))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/cocktail
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_shot
	name = "shot glass"
	desc = "Your standard drinking glass."
	id = "barglass_shot"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.0075))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/shot
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_pint
	name = "pint glass"
	desc = "Your standard drinking glass."
	id = "barglass_pint"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.075))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/pint
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_mug
	name = "glass mug"
	desc = "Your standard drinking glass."
	id = "barglass_mug"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.05))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/mug
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_wine
	name = "wine glass"
	desc = "Your standard drinking glass."
	id = "barglass_wine"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.03))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/wine
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_metaglass
	name = "metamorphic glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	id = "barglass_metaglass"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.3125))
	build_path = /obj/item/reagent_containers/food/drinks/metaglass
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_metapint
	name = "metamorphic pint glass"
	desc = "This glass changes shape and form depending on the drink inside... fancy!"
	id = "barglass_metapint"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.3125))
	build_path = /obj/item/reagent_containers/food/drinks/metaglass/metapint
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_carafe
	name = "glass carafe"
	desc = "Your standard drinking glass."
	id = "barglass_carafe"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.03))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/carafe
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_pitcher
	name = "plastic pitcher"
	id = "barglass_pitcher"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_PLASTIC = MATERIAL_COST(0.03))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/pitcher
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_coffeemug
	name = "coffee mug"
	id = "barglass_coffeemug"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.025))
	build_path = /obj/item/reagent_containers/food/drinks/glass2/coffeemug
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/barglass_jar
	name = "glass jar"
	desc = "A small empty jar."
	id = "barglass_jar"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_GLASS = MATERIAL_COST(0.125))
	build_path = /obj/item/glass_jar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/idcard
	name = "ID Card"
	id = "idcard"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.05), MAT_GLASS = MATERIAL_COST(0.05), MAT_PLASTIC = MATERIAL_COST(0.15))
	build_path = /obj/item/card/id
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_COMMAND

/datum/design_techweb/cleaver
	name = "butcher's cleaver"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	id = "cleaver"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.4))
	build_path = /obj/item/material/knife/butch
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/rollingpin
	name = "rolling pin"
	desc = "A simple tool for rolling dough flat."
	id = "rollingpin"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_WOOD = MATERIAL_COST(0.5))
	build_path = /obj/item/material/kitchen/rollingpin
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/cargo_scanner
	name = "cargo scanner"
	desc = "A device for scanning items for cargo value."
	id = "cargo_scanner"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = MATERIAL_COST(0.25), MAT_GLASS = MATERIAL_COST(0.1))
	build_path = /obj/item/cargo_scanner
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE
