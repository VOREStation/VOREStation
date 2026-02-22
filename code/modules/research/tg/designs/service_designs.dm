/datum/design_techweb/board/atm
	name = "atm circuit"
	desc = "The circuit board for a ATM."
	id = "bankmachine"
	build_path = /obj/item/circuitboard/atm
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/fax
	name = "fax machine circuit"
	desc = "The circuit board for a fax machine."
	id = "fax"
	build_path = /obj/item/circuitboard/fax
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/photocopier
	name = "photocopier circuit"
	desc = "The circuit board for a photocopier."
	id = "photocopier"
	build_path = /obj/item/circuitboard/photocopier
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/papershredder
	name = "papershredder circuit"
	desc = "The circuit board for a papershredder."
	id = "papershredder"
	build_path = /obj/item/circuitboard/papershredder
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/guest_pass
	name = "guestpass console Board"
	desc = "The circuit board for a guest pass console."
	id = "guestpass"
	build_path = /obj/item/circuitboard/guestpass
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/intercom
	name = "intercom circuit"
	desc = "The circuit board for a radio intercom."
	id = "intercom"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/intercom
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ashtray
	name = "ashtray"
	desc = "An ashtray."
	id = "ashtray"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 250)
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
	materials = list(MAT_GLASS = 250)
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
	materials = list(MAT_PLASTIC = 2500)
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
	materials = list(MAT_GLASS = 75)
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
	materials = list(MAT_GLASS = 50)
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
	materials = list(MAT_GLASS = 40)
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
	materials = list(MAT_GLASS = 40)
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
	materials = list(MAT_GLASS = 15)
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
	materials = list(MAT_GLASS = 150)
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
	materials = list(MAT_GLASS = 100)
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
	materials = list(MAT_GLASS = 60)
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
	materials = list(MAT_GLASS = 625)
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
	materials = list(MAT_GLASS = 625)
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
	materials = list(MAT_GLASS = 60)
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
	materials = list(MAT_PLASTIC = 60)
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
	materials = list(MAT_GLASS = 50)
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
	materials = list(MAT_GLASS = 250)
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
	materials = list(MAT_STEEL = 100, MAT_GLASS = 100, MAT_PLASTIC = 300)
	build_path = /obj/item/card/id
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_COMMAND
